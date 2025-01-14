--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Packages = Shared.Packages

local INVALID_ARGS_ERROR = 'Bad argument to getRemoteConnectionInfo() (expected "%s", got "%s")'

local Enums = require(Shared.Enums.index)
local NetworkEnums: Enums.Enums = Enums.Network
local SignalConnection: Enums.Enums = Enums.SignalConnection

-- Dependencies
local NETWORK = require(Shared.Types.Network)

local isClient = require(Packages.System.isClient)
-- local isBindableEvent = require(Packages.Util.Types.isBindableEvent)
-- local isBindableFunction = require(Packages.Util.Types.isBindableFunction)
-- local isRemoteEvent = require(Packages.Util.Types.isRemoteEvent)
-- local isRemoteFunction = require(Packages.Util.Types.isRemoteFunction)

local function getRemoteConnectionInfo(remote: Enums.Enums?): NETWORK.ConnectionInfo
	local connectionInfo = {} :: NETWORK.ConnectionInfo

	if not remote then
		connectionInfo.connector = ""
		connectionInfo.dispatcher = ""
		connectionInfo.type = SignalConnection.None
		return connectionInfo
	elseif not Enums.is(remote) then
		error(INVALID_ARGS_ERROR:format("Remote", tostring(remote)))
	end

	if remote == NetworkEnums.Protocol.TCPEvent or remote == NetworkEnums.Protocol.UDPEvent then
		connectionInfo.connector = if isClient() then "OnClientEvent" else "OnServerEvent"
		connectionInfo.dispatcher = if isClient() then "FireServer" else "FireClient"
		connectionInfo.type = SignalConnection.Event
	elseif remote == NetworkEnums.Protocol.TCPRequest then
		connectionInfo.connector = if isClient() then "OnClientInvoke" else "OnServerInvoke"
		connectionInfo.dispatcher = if isClient() then "InvokeServer" else "InvokeClient"
		connectionInfo.type = SignalConnection.Callback
	elseif remote == NetworkEnums.Protocol.LocalEvent then
		connectionInfo.connector = "Event"
		connectionInfo.dispatcher = "Fire"
		connectionInfo.type = SignalConnection.Event
	elseif remote == NetworkEnums.Protocol.LocalRequest then
		connectionInfo.connector = "OnInvoke"
		connectionInfo.dispatcher = "Invoke"
		connectionInfo.type = SignalConnection.Callback
	end

	return connectionInfo
end

return getRemoteConnectionInfo
