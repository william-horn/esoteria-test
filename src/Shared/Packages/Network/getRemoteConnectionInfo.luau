--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Packages = Shared.Packages

local INVALID_ARGS_ERROR = 'Bad argument to getRemoteConnectionInfo() (expected "%s", got "%s")'

local Enums = require(Shared.Enums.index)
local NetworkEnums = Enums.Network
local SignalConnection = Enums.SignalConnection
local SignalDomain = Enums.SignalDomain

-- Dependencies
local NETWORK = require(Shared.Types.Network)
local isClient = require(Packages.System.isClient)

local function getRemoteConnectionInfo(remote: Enums.Enums?): NETWORK.ConnectionInfo
	local connectionInfo = {}

	if not remote then
		connectionInfo.connector = ""
		connectionInfo.dispatcher = ""
		connectionInfo.signalConnection = SignalConnection.None
		connectionInfo.signalDomain = SignalDomain.None
		return connectionInfo
	elseif not Enums.is(remote) then
		error(INVALID_ARGS_ERROR:format("Remote", tostring(remote)))
	end

	if remote == NetworkEnums.Protocol.TCPEvent or remote == NetworkEnums.Protocol.UDPEvent then
		connectionInfo.connector = if isClient() then "OnClientEvent" else "OnServerEvent"
		connectionInfo.dispatcher = if isClient() then "FireServer" else "FireClient"
		connectionInfo.signalConnection = SignalConnection.Event
		connectionInfo.signalDomain = SignalDomain.Global
	elseif remote == NetworkEnums.Protocol.TCPRequest then
		connectionInfo.connector = if isClient() then "OnClientInvoke" else "OnServerInvoke"
		connectionInfo.dispatcher = if isClient() then "InvokeServer" else "InvokeClient"
		connectionInfo.signalConnection = SignalConnection.Callback
		connectionInfo.signalDomain = SignalDomain.Global
	elseif remote == NetworkEnums.Protocol.LocalEvent then
		connectionInfo.connector = "Event"
		connectionInfo.dispatcher = "Fire"
		connectionInfo.signalConnection = SignalConnection.Event
		connectionInfo.signalDomain = SignalDomain.Local
	elseif remote == NetworkEnums.Protocol.LocalRequest then
		connectionInfo.connector = "OnInvoke"
		connectionInfo.dispatcher = "Invoke"
		connectionInfo.signalConnection = SignalConnection.Callback
		connectionInfo.signalDomain = SignalDomain.Local
	end

	return connectionInfo
end

return getRemoteConnectionInfo
