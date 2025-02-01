--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Enums = require(Shared.Enums.index)
local TABLE = require(Shared.Types.Table)
-- local FUNCTION = require(Shared.Types.Function)
local State = require(Shared.Packages.State.index)
local ValidationStatus = require(Shared.Packages.Util.Classes.ValidationStatus)

export type AnyRemote = BaseRemoteEvent | RemoteFunction | BindableEvent | BindableFunction

export type ConnectionInfo = {
	connector: string,
	dispatcher: string,
	signalConnection: Enums.Enums,
	signalDomain: Enums.Enums,
	[any]: nil,
}

export type OnDispatch = (
	type: Channel | Request,
	success: boolean,
	validationStatus: ValidationStatus.Array?,
	packet: Packet
) -> ()

export type Response = {
	headers: Headers?,
	payload: Payload?,
	success: boolean,
	validationReport: ValidationStatus.Array?,
}

export type Packet = {
	headers: Headers,
	payload: Payload,
	[any]: nil,
}

export type Payload = any

export type Headers = {
	channel: Enums.Enums,
	request: Enums.Enums,
	dependencies: TABLE.AnyArray?,
	toPlayers: { Player }?,
	sendAll: boolean?,
	[string]: any,
}

export type Request = {
	handler: (packet: Packet) -> (),
	lastSentPacket: Packet?,
	onDispatch: OnDispatch?,
	state: State.State,
	validator: State.StateValidator?,
	settings: TABLE.Any,
	[any]: nil,
}

export type Requests = { [string]: Request }

export type Channel = {
	remote: AnyRemote,
	onDispatch: OnDispatch?,
	lastSentPacket: Packet?,
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
