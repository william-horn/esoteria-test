--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Enums = require(Shared.Enums.index)
local TABLE = require(Shared.Types.Table)
local State = require(Shared.Packages.State.index)
local ValidationStatus = require(Shared.Packages.Util.Classes.ValidationStatus)

export type AnyRemote = BaseRemoteEvent | RemoteFunction | BindableEvent | BindableFunction

export type OnDispatch = (
	type: Channel | Request,
	success: boolean,
	validationStatus: TABLE.ArrayOf<ValidationStatus.ValidationStatus>?,
	packet: Packet
) -> ()

export type Response = {
	headers: Headers?,
	payload: any?,
	success: boolean,
	validationReport: TABLE.ArrayOf<ValidationStatus.ValidationStatus>?,
}

export type Packet = {
	headers: Headers,
	payload: any,
	[any]: nil,
}

export type Headers = {
	channel: Enums.EnumItem,
	request: Enums.EnumItem,
	dependencies: TABLE.ArrayOf<any>?,
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
	settings: TABLE.Map<string, any>,
	[any]: nil,
}

export type Requests = TABLE.Map<string, Request>

export type Channel = {
	remote: AnyRemote,
	onDispatch: OnDispatch?,
	lastSentPacket: Packet?,
	settings: TABLE.Map<string, any>,
	state: State.State,
	requests: Requests,
	[any]: nil,
}

export type Channels = {
	[string]: Channel,
}

export type Protocol = {
	channels: Channels,
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
