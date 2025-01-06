--!strict

--[[
	Server-side Network API
]]

local Shared = game:GetService("ReplicatedStorage").Shared
local Server = game:GetService("ServerScriptService").Server
local Packages = Shared.Packages
local Enums = Shared.Enums
local NetworkEnums = Enums.Network

local INVALID_HEADERS_ERROR: string = "Failed to dispatch remote due to missing or invalid '%s' header"

local Custom = require(Shared.Types.Custom)
local Table = require(Shared.Types.Table)
local NetworkType = require(Packages.Network.Types)
local NetworkScanner = require(Packages.Network.Scanner)

local NetworkTree: NetworkType.Tree = NetworkScanner:createNetworkTree({
	SharedNetwork = Shared.Network,
	LocalNetwork = Server.Network,
})

local Network: Table.StringKey = {}
Network._tree = NetworkTree

local function handleRequest(
	requestHandlers: NetworkType.RequestHandlers
): (fromPlayer: Player, headers: NetworkType.Headers, payload: NetworkType.Payload) -> ()
	--
	return function(fromPlayer: Player, headers: NetworkType.Headers, payload: NetworkType.Payload)
		local request: Custom.EnumItem = headers.request
		local requestData: NetworkType.Request = requestHandlers[request.Name]

		if not requestData then
			error('Received a bad request "' .. request.Name .. '" from player: "' .. fromPlayer.Name)
		else
			print('Received request "' .. request.Name .. '" from player: ' .. fromPlayer.Name)
		end

		requestData.process(headers, payload)
	end
end

function Network:dispatch(
	headers: NetworkType.Headers,
	payload: NetworkType.Payload
): (boolean, NetworkType.DispatchReport)
	local dependencies: Table.AnyArray? = headers.dependencies
	local protocol: Custom.EnumItem = headers.protocol
	local channel: Custom.EnumItem = headers.channel
	local request: Custom.EnumItem = headers.request

	-- Validate required headers
	if not protocol then
		error(INVALID_HEADERS_ERROR:format("protocol"))
	end

	if not channel then
		error(INVALID_HEADERS_ERROR:format("channel"))
	end

	if not request then
		error(INVALID_HEADERS_ERROR:format("request"))
	end

	-- Retrieve the network location to fire from
	local protocolData: NetworkType.Protocol = NetworkTree[protocol.Name]
	local channelData: NetworkType.Channel = protocolData.channels[channel.Name]
	local requestData: NetworkType.Request = channelData[request.Name]

	if not requestData then
		error('Invalid request ("' .. request.Name .. '" is not a valid request for channel "' .. channel.Name .. '"')
	end

	-- Validate the remote dispatch locally
	local success: boolean, validationReport: NetworkType.DispatchReport = channelData.settings:validate()

	if success then
		if headers.sendAll then
			channelData.remote:FireAllClients(headers, payload)
		elseif headers.toPlayers then
			for _, player in next, headers.toPlayers do
				channelData.remote[protocolData.remoteInfo.dispatch](channelData.remote, player, headers, payload)
			end
		end
	end

	return success, validationReport
end

function Network:sendTCP(headers: NetworkType.Headers, payload: NetworkType.Payload): NetworkType.DispatchReport
	headers.protocol = NetworkEnums.Protocol.TCPEvent
	return self:dispatch(headers, payload)
end

function Network:requestTCP(headers: NetworkType.Headers, payload: NetworkType.Payload): NetworkType.DispatchReport
	headers.protocol = NetworkEnums.Protocol.TCPRequest
	return self:dispatch(headers, payload)
end

function Network:sendUDP(headers: NetworkType.Headers, payload: NetworkType.Payload): NetworkType.DispatchReport
	headers.protocol = NetworkEnums.Protocol.UDPEvent
	return self:dispatch(headers, payload)
end

function Network:listen(): ()
	for protocolName: string, protocol: NetworkType.Protocol in next, NetworkTree do
		-- If there are no channels for this protocol, then skip
		if not next(protocol.channels) then
			continue
		end

		print("Preparing [" .. protocolName .. "] listeners...")
		local remoteInfo: NetworkType.RemoteInfo = protocol.remoteInfo

		for channelName: string, channel: NetworkType.Channel in next, protocol.channels do
			-- If there are no request handlers for this channel, then don't create any listeners
			if not next(channel.requestHandlers) then
				continue
			end

			--[[
				This is a technical type error but this will not cause any issues. `channel.remote`
				can be any kind of remote, so the linter does not like the ambiguity of indexing
				that union with `remoteInfo.listener` even though that won't cause an issue.
			]]
			if remoteInfo.connectionType == Enums.SignalConnection.Event then
				channel.remote[remoteInfo.listener]:Connect(handleRequest(channel.requestHandlers))
			elseif remoteInfo.connectionType == Enums.SignalConnection.Callback then
				channel.remote[remoteInfo.listener] = handleRequest(channel.requestHandlers)
			end

			print('Created listeners for channel "' .. channelName .. '"')
		end
	end
end

return Network
