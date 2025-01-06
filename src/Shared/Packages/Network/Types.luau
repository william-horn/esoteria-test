--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Custom = require(Shared.Types.Custom)
local Table = require(Shared.Types.Table)
local State = require(Shared.Packages.State.index)
local ValidationStatus = require(Shared.Packages.Util.Classes.ValidationStatus)

export type Remote = RemoteEvent | RemoteFunction | UnreliableRemoteEvent | BindableEvent | BindableFunction

export type RemoteInfo = {
	listener: string,
	dispatch: string,
	connectionType: Custom.EnumItem,
}

export type DispatchReport = { ValidationStatus.Log }

export type Headers = {
	channel: Custom.EnumItem,
	request: Custom.EnumItem,
	dependencies: Table.AnyArray?,
	toPlayers: { Player }?,
	sendAll: boolean?,
	[string]: any,
}

export type Request = {
	process: (headers: Headers, payload: Payload) -> (),
	lastSent: { headers: Headers, payload: Payload } | nil,
}

export type Payload = Table.Any
export type RequestHandlers = { [string]: Request }

export type Channel = {
	remote: Remote,
	settings: State.State,
	requestHandlers: RequestHandlers,
}

export type Channels = {
	[string]: Channel,
}

export type Protocol = {
	channels: Channels,
	remoteInfo: RemoteInfo,
}

export type Tree = {
	TCPEvent: Protocol,
	TCPRequest: Protocol,
	UDPEvent: Protocol,
}

export type Group = {
	SharedNetwork: Folder,
	LocalNetwork: Folder,
}

return nil
