--!strict

--[[
	Server-side Network API
]]

local INVALID_DISPATCH_ARGS_ERROR = 'Failed to dispatch remote due to missing "headers" or "payload" fields'
local INVALID_HEADERS_ERROR = "Failed to dispatch remote due to missing or invalid '%s' header"
local BAD_REQUEST_ERROR = 'Received bad request "%s" from player: %s'
local REQUEST_MISSING_HEADER_ERROR = 'Request "%s" is missing header "%s"'
local DISPATCH_ERROR = "Dispatch failed due to: %s"

local Shared = game:GetService("ReplicatedStorage").Shared
local Server = game:GetService("ServerScriptService").Server
local Packages = Shared.Packages
local Enums = require(Shared.Enums.index)
local NetworkEnums = Enums.Network
local SignalConnection = Enums.SignalConnection
-- local SignalDomain: Enums.Enums = Enums.SignalDomain
-- local SignalType: Enums.Enums = Enums.SignalType

local TABLE = require(Shared.Types.Table)
local NETWORK = require(Shared.Types.Network)

local NetworkScanner = require(Packages.Network.Scanner)
local ValidationStatus = require(Packages.Util.Classes.ValidationStatus)
-- local State = require(Packages.State.index)

local Network = {}

local function handleRequest(requests: NETWORK.Requests)
	return function(fromPlayer: Player, packet: NETWORK.Packet): ()
		local request = packet.headers.request
		local requestData = requests[request.name]

		if not requestData then
			error(BAD_REQUEST_ERROR:format(request.name, fromPlayer.Name), 2)
		else
			print('Received request "' .. request.name .. '" from player: ' .. fromPlayer.Name)
		end

		-- Add final headers before calling the server-side remote handlers
		packet.headers.fromPlayer = fromPlayer
		requestData.handler(packet)
	end
end

function Network:getTCPEventChannel(channel: Enums.EnumItem)
	return self._tree.TCPEvent.channels[channel.name]
end

function Network:getTCPRequestChannel(channel: Enums.EnumItem)
	return self._tree.TCPRequest.channels[channel.name]
end

function Network:getUDPEventChannel(channel: Enums.EnumItem)
	return self._tree.UDPEvent.channels[channel.name]
end

function Network:dispatch(packet: NETWORK.Packet): NETWORK.Response
	local headers = packet.headers
	local payload = packet.payload

	if not headers or not payload then
		error(INVALID_DISPATCH_ARGS_ERROR, 2)
	end

	--! do timestamps here --

	local dependencies: TABLE.ArrayOf<any>? = headers.dependencies
	headers.dependencies = nil

	local protocol: Enums.EnumItem = headers.protocol
	local channel = headers.channel
	local request = headers.request

	local response = {}

	-- Validate required headers
	if not request then
		error(INVALID_HEADERS_ERROR:format("request"), 2)
	end

	if not protocol then
		error(REQUEST_MISSING_HEADER_ERROR:format(request.name, "protocol"), 2)
	end

	if not channel then
		error(REQUEST_MISSING_HEADER_ERROR:format(request.name, "channel"), 2)
	end

	-- Retrieve the network location to fire from
	local protocolData = self._tree[protocol.name]
	local channelData = protocolData.channels[channel.name]
	local requestData = channelData.requests[request.name]
	local connectionInfo = protocolData.connectionInfo

	headers.originTime = DateTime.now()

	-- Validate the remote dispatch
	local success, validationReport = channelData.state:validate({
		dependencies = dependencies,
		headers = headers,
		request = request,
	})

	local function invokeOnDispatch(
		_success: boolean,
		_validationReport: TABLE.ArrayOf<ValidationStatus.ValidationStatus>?
	)
		if channelData.onDispatch then
			channelData.onDispatch(channelData, _success, _validationReport, packet)
		end

		if requestData.onDispatch then
			requestData.onDispatch(requestData, _success, _validationReport, packet)
		end
	end

	-- Check remote channel validator
	if not success then
		response.success = success
		response.validationReport = validationReport

		invokeOnDispatch(success, validationReport)
		return response
	else
		-- Check remote request validator
		success, validationReport = requestData.state:validate()

		if not success then
			response.success = success
			response.validationReport = validationReport

			invokeOnDispatch(success, validationReport)
			return response
		end
	end

	-- Run OnDispatch callbacks
	response.success = success
	response.validationReport = validationReport

	invokeOnDispatch(success, validationReport)

	-- Remote dispatch state is valid beyond this point --
	channelData.lastSentPacket = packet
	requestData.lastSentPacket = packet

	-- Update last dependency list
	channelData.state:update({
		dependencies = function()
			return dependencies
		end,
	})

	-- Dispatch signal --

	-- If the signal is a Remote and an Event
	if connectionInfo.signalConnection == SignalConnection.Event then
		if headers.sendAll then
			channelData.remote:FireAllClients(packet)
			return response
		elseif headers.toPlayers then
			for _, player: Player in next, headers.toPlayers do
				channelData.remote[protocolData.connectionInfo.dispatcher](player, packet)
			end
		else
			error(DISPATCH_ERROR:format("Invalid headers"), 2)
		end
	end

	-- Return the dispatch results
	return response
end

function Network:sendTCP(packet: NETWORK.Packet): NETWORK.Response
	packet.headers.protocol = NetworkEnums.Protocol.TCPEvent
	return self:dispatch(packet)
end

function Network:requestTCP(packet: NETWORK.Packet): NETWORK.Response
	packet.headers.protocol = NetworkEnums.Protocol.TCPRequest
	return self:dispatch(packet)
end

function Network:sendUDP(packet: NETWORK.Packet): NETWORK.Response
	packet.headers.protocol = NetworkEnums.Protocol.UDPEvent
	return self:dispatch(packet)
end

function Network:init(): any
	-- Build the network tree responsible for storing channels, remote, requests, etc
	local NetworkTree: NETWORK.Tree = NetworkScanner:createNetworkTree({
		SharedNetwork = Shared.Network,
		LocalNetwork = Server.Network,
	})

	self._tree = NetworkTree

	-- Connect remote listeners to their handler functions
	for protocolName: string, protocolData: NETWORK.Protocol in next, NetworkTree do
		-- If there are no channels for this protocol, then skip
		if not next(protocolData.channels) then
			continue
		end

		print("Preparing [" .. protocolName .. "] listeners...")
		local connectionInfo = protocolData.connectionInfo

		for channelName, channelData in next, protocolData.channels do
			-- If there are no request handlers for this channel, then don't create any listeners
			if not next(channelData.requests) then
				continue
			end

			-- Ignore these type errors. `remoteInfo.listener` is a valid key of `channelData.remote`
			if connectionInfo.signalConnection == Enums.SignalConnection.Event then
				channelData.remote[connectionInfo.connector]:Connect(handleRequest(channelData.requests))
			elseif connectionInfo.connectionType == Enums.SignalConnection.Callback then
				channelData.remote[connectionInfo.connector] = handleRequest(channelData.requests)
			end

			print('Created listeners for channel "' .. channelName .. '"')
		end
	end

	return self
end

return Network
