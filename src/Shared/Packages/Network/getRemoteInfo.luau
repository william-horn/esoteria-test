--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Packages = Shared.Packages

local NetworkEnums = Shared.Enums.Network
local connectionType = Shared.Enums.SignalConnection

-- Dependencies
local NetworkType = require(Packages.Network.Types)
local Custom = require(Shared.Types.Custom)

local isClient = require(Packages.System.isClient)
local isBindableEvent = require(Packages.Util.Types.isBindableEvent)
local isBindableFunction = require(Packages.Util.Types.isBindableFunction)
local isRemoteEvent = require(Packages.Util.Types.isRemoteEvent)
local isRemoteFunction = require(Packages.Util.Types.isRemoteFunction)

local function getRemoteInfo(remote: Custom.EnumItem? | NetworkType.Remote?): NetworkType.RemoteInfo
	local remoteInfo = {} :: NetworkType.RemoteInfo

	if not remote then
		remoteInfo.listener = ""
		remoteInfo.dispatch = ""
		remoteInfo.connectionType = connectionType.None
		return remoteInfo
	end

	if
		isRemoteEvent(remote)
		or remote == NetworkEnums.Protocol.TCPEvent
		or remote == NetworkEnums.Protocol.UDPEvent
	then
		remoteInfo.listener = if isClient() then "OnClientEvent" else "OnServerEvent"
		remoteInfo.dispatch = if isClient() then "FireServer" else "FireClient"
		remoteInfo.connectionType = connectionType.Event
	elseif isRemoteFunction(remote) or remote == NetworkEnums.Protocol.TCPRequest then
		remoteInfo.listener = if isClient() then "OnClientInvoke" else "OnServerInvoke"
		remoteInfo.dispatch = if isClient() then "InvokeServer" else "InvokeClient"
		remoteInfo.connectionType = connectionType.Callback
	elseif isBindableEvent(remote) or remote == NetworkEnums.Protocol.LocalEvent then
		remoteInfo.listener = "Event"
		remoteInfo.dispatch = "Fire"
		remoteInfo.connectionType = connectionType.Event
	elseif isBindableFunction(remote) or remote == NetworkEnums.Protocol.LocalRequest then
		remoteInfo.listener = "OnInvoke"
		remoteInfo.dispatch = "Invoke"
		remoteInfo.connectionType = connectionType.Callback
	end

	return remoteInfo
end

return getRemoteInfo
