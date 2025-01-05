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
local ValidationStatus = require(Packages.Util.Classes.ValidationStatus)
local NetworkScanner = require(Packages.Network.Scanner)

local NetworkTree: NetworkType.Tree = NetworkScanner:createNetworkTree({
	SharedNetwork = Shared.Network,
	LocalNetwork = Server.Network,
})

local Network = {}

function Network:dispatch(headers: NetworkType.Headers, payload: NetworkType.Payload): { ValidationStatus.Log }
	local dependencies: Table.AnyArray? = headers.dependencies
	local protocol: Custom.EnumItem = headers.protocol
	local channel: Custom.EnumItem = headers.channel
	local request: Custom.EnumItem = headers.request

	if not protocol then
		error(INVALID_HEADERS_ERROR:format("protocol"))
	end

	if not channel then
		error(INVALID_HEADERS_ERROR:format("channel"))
	end

	if not request then
		error(INVALID_HEADERS_ERROR:format("request"))
	end

	local requestData = NetworkTree[protocol.Name][channel.Name][request.Name]

	if not requestData then
		error('Invalid request ("' .. request.Name .. '" is not a valid request for channel "' .. channel.Name .. '"')
	end

	local success: boolean, validationReport: { ValidationStatus.Log } = requestData.remoteState:validate()

	return validationReport
end

function Network:sendTCP(headers: NetworkType.Headers, payload: NetworkType.Payload)
	headers.protocol = NetworkEnums.Protocol.TCPEvent
	return self:dispatch(headers, payload)
end

function Network:requestTCP(headers: NetworkType.Headers, payload: NetworkType.Payload)
	headers.protocol = NetworkEnums.Protocol.TCPRequest
	return self:dispatch(headers, payload)
end

function Network:sendUDP(headers: NetworkType.Headers, payload: NetworkType.Payload)
	headers.protocol = NetworkEnums.Protocol.UDPEvent
	return self:dispatch(headers, payload)
end

function Network:listen(): ()
	for _, protocol: NetworkType.Protocol in next, NetworkTree do
		for _, channel: NetworkType.Channel in next, protocol do
		end
	end
end

Network:sendTCP({
	channel = NetworkEnums.Protocol.TCPEvent,
	request = NetworkEnums.Request.Generic,
	dependencies = {},
}, {
	playerName = "Will",
})

return Network
