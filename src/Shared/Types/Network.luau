--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Enums = require(Shared.Enums.index)
local TABLE = require(Shared.Types.Table)
local State = require(Shared.Packages.State.index)
-- local ValidationStatus = require(Shared.Packages.Util.Classes.ValidationStatus)

export type AnyRemote = RemoteEvent | RemoteFunction | UnreliableRemoteEvent | BindableEvent | BindableFunction

export type ConnectionInfo = {
	connector: string,
	dispatcher: string,
	type: Enums.Enums,
	[any]: nil,
}

export type Payload = TABLE.Any
export type Headers = {
	channel: Enums.Enums,
	request: Enums.Enums,
	dependencies: TABLE.AnyArray?,
	toPlayers: { Player }?,
	sendAll: boolean?,
	[string]: any,
}

export type Request = {
	handler: (headers: Headers, payload: Payload) -> (),
	lastSent: { headers: Headers, payload: Payload, [any]: nil },
	state: State.State,
	validator: State.StateValidator?,
	settings: TABLE.Any,
	[any]: nil,
}

export type Requests = { [string]: Request }

export type Channel = {
	remote: AnyRemote,
	lastSent: { headers: Headers, payload: Payload, [any]: nil },
	settings: TABLE.Any,
	state: State.State,
	requests: Requests,
	[any]: nil,
}

export type Channels = {
	[string]: Channel,
}

export type Protocol = {
	channels: Channels,
	connectionInfo: ConnectionInfo,
	[any]: nil,
}

export type Tree = {
	TCPEvent: Protocol,
	TCPRequest: Protocol,
	UDPEvent: Protocol,
	-- [string]: Protocol,
}

export type Both = {
	SharedNetwork: Folder,
	LocalNetwork: Folder,
	[any]: nil,
}

return nil
