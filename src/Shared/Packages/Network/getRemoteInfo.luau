--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Packages = Shared.Packages

local connectionType = Shared.Enums.SignalConnection

-- Dependencies
local NetworkType = require(Packages.Network.Types)

local isClient = require(Packages.System.isClient)
local isBindableEvent = require(Packages.Util.Types.isBindableEvent)
local isBindableFunction = require(Packages.Util.Types.isBindableFunction)
local isRemoteEvent = require(Packages.Util.Types.isRemoteEvent)
local isRemoteFunction = require(Packages.Util.Types.isRemoteFunction)

local function getRemoteInfo(remote: NetworkType.Remote): NetworkType.RemoteInfo
	local remoteInfo = {} :: NetworkType.RemoteInfo

	if not remote then
		remoteInfo.connectionType = connectionType.None
		return remoteInfo
	end

	if isRemoteEvent(remote) then
		remoteInfo.listener = isClient() and "OnClientEvent" or "OnServerEvent"
		remoteInfo.dispatch = isClient() and "FireServer" or "FireClient"
		remoteInfo.connectionType = connectionType.Event
	elseif isRemoteFunction(remote) then
		remoteInfo.listener = isClient() and "OnClientInvoke" or "OnServerInvoke"
		remoteInfo.dispatch = isClient() and "InvokeServer" or "InvokeClient"
		remoteInfo.connectionType = connectionType.Callback
	elseif isBindableEvent(remote) then
		remoteInfo.listener = "Event"
		remoteInfo.dispatch = "Fire"
		remoteInfo.connectionType = connectionType.Event
	elseif isBindableFunction(remote) then
		remoteInfo.listener = "OnInvoke"
		remoteInfo.dispatch = "Invoke"
		remoteInfo.connectionType = connectionType.Callback
	end

	return remoteInfo
end

return getRemoteInfo
