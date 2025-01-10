--!strict

--[[
	Server-side Network API
]]

local Shared = game:GetService("ReplicatedStorage").Shared
local Server = game:GetService("ServerScriptService").Server
local Packages = Shared.Packages
local Enums = require(Shared.Enums.index)
local NetworkEnums = Enums.Network

local INVALID_HEADERS_ERROR: string = "Failed to dispatch remote due to missing or invalid '%s' header"
local BAD_REQUEST_ERROR: string = 'Received bad request "%s" from player: %s'
local REQUEST_MISSING_HEADER_ERROR: string = 'Request "%s" is missing header "%s"'

local TABLE = require(Shared.Types.Table)
local NETWORK = require(Shared.Types.Network)
local NetworkScanner = require(Packages.Network.Scanner)
local ValidationStatus = require(Packages.Util.Classes.ValidationStatus)
-- local State = require(Packages.State.index)

local Network = {}

local function handleRequest(
	requests: NETWORK.Requests
): (fromPlayer: Player, headers: NETWORK.Headers, payload: NETWORK.Payload) -> ()
	--
	return function(fromPlayer: Player, headers: NETWORK.Headers, payload: NETWORK.Payload)
		local request: Enums.Enums = headers.request
		local requestData: NETWORK.Request = requests[request.name]

		if not requestData then
			error(BAD_REQUEST_ERROR:format(request.name, fromPlayer.Name), 2)
		else
			print('Received request "' .. request.name .. '" from player: ' .. fromPlayer.Name)
		end

		-- Add final headers before calling the server-side remote handlers
		headers.fromPlayer = fromPlayer

		requestData.handler(headers, payload)
	end
end

function Network:dispatch(headers: NETWORK.Headers, payload: NETWORK.Payload): (boolean, ValidationStatus.Array)
	local dependencies: TABLE.AnyArray? = headers.dependencies
	headers.dependencies = nil

	local protocol: Enums.Enums = headers.protocol
	local channel: Enums.Enums = headers.channel
	local request: Enums.Enums = headers.request

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
	local protocolData: NETWORK.Protocol = self._tree[protocol.name]
	local channelData: NETWORK.Channel = protocolData.channels[channel.name]
	local requestData: NETWORK.Request = channelData.requests[request.name]

	-- Validate the remote dispatch
	local success: boolean, validationReport: ValidationStatus.Array = channelData.state:validate({
		dependencies = dependencies,
	})

	-- Check remote channel validator
	if not success then
		return success, validationReport
	else
		-- Check remote request validator
		success, validationReport = requestData.state:validate()

		if not success then
			return success, validationReport
		end
	end

	-- Remote dispatch state is valid beyond this point --

	-- Update last dependency list
	if channelData.lastSent then
		channelData.lastSent.headers = headers
		channelData.lastSent.payload = payload

		requestData.lastSent.headers = headers
		requestData.lastSent.payload = payload
	else
		local lastSent: NETWORK.LastRequest = {
			headers = headers,
			payload = nil,
		}

		channelData.lastSent = lastSent
		requestData.lastSent = lastSent
	end

	channelData.state:update({
		dependencies = function(): TABLE.AnyArray?
			return dependencies
		end,
	})

	-- Dispatch remote
	if headers.sendAll then
		channelData.remote:FireAllClients(headers, payload)
	elseif not headers.toPlayers then
		error(REQUEST_MISSING_HEADER_ERROR:format(request.name, "toPlayers"), 2)
	else
		for _, player: Player in next, headers.toPlayers do
			channelData.remote[protocolData.connectionInfo.dispatcher](player, headers, payload)
		end
	end

	-- Return the dispatch results
	return success, validationReport
end

function Network:sendTCP(headers: NETWORK.Headers, payload: NETWORK.Payload): (boolean, ValidationStatus.Array)
	headers.protocol = NetworkEnums.Protocol.TCPEvent
	return self:dispatch(headers, payload)
end

function Network:requestTCP(headers: NETWORK.Headers, payload: NETWORK.Payload): (boolean, ValidationStatus.Array)
	headers.protocol = NetworkEnums.Protocol.TCPRequest
	return self:dispatch(headers, payload)
end

function Network:sendUDP(headers: NETWORK.Headers, payload: NETWORK.Payload): (boolean, ValidationStatus.Array)
	headers.protocol = NetworkEnums.Protocol.UDPEvent
	return self:dispatch(headers, payload)
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
		local connectionInfo: NETWORK.ConnectionInfo = protocolData.connectionInfo

		for channelName: string, channelData: NETWORK.Channel in next, protocolData.channels do
			-- If there are no request handlers for this channel, then don't create any listeners
			if not next(channelData.requests) then
				continue
			end

			-- Ignore these type errors. `remoteInfo.listener` is a valid key of `channelData.remote`
			if connectionInfo.type == Enums.SignalConnection.Event then
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
