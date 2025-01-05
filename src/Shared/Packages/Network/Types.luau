--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Custom = require(Shared.Types.Custom)
local Table = require(Shared.Types.Table)
local State = require(Shared.Packages.State.index)

export type Remote = RemoteEvent | RemoteFunction | UnreliableRemoteEvent | BindableEvent | BindableFunction

export type RemoteInfo = {
	listener: string?,
	dispatch: string?,
	connectionType: Custom.EnumItem,
}

export type Headers = {
	channel: Custom.EnumItem,
	request: Custom.EnumItem,
	dependencies: Table.AnyArray?,
	[string]: any,
}

export type Payload = Table.Any

export type Request = {
	process: (headers: Headers, payload: Payload) -> (),
	lastSent: { headers: Headers, payload: Payload },
}

export type Channel = {
	remote: Remote,
	settings: Table.Any,
	requestHandlers: { [string]: Request },
	remoteInfo: RemoteInfo,
	remoteState: State.State,
}

export type Protocol = {
	[string]: Channel,
}

export type Tree = {
	TCPEvent: Protocol,
	TCPFunctions: Protocol,
	UDPEvent: Protocol,
}

export type Group = {
	SharedNetwork: Folder,
	LocalNetwork: Folder,
}

return nil
