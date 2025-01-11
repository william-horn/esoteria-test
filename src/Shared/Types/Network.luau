--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Enums = require(Shared.Enums.index)
local TABLE = require(Shared.Types.Table)
-- local FUNCTION = require(Shared.Types.Function)
local State = require(Shared.Packages.State.index)
local ValidationStatus = require(Shared.Packages.Util.Classes.ValidationStatus)

export type AnyRemote = RemoteEvent | RemoteFunction | UnreliableRemoteEvent | BindableEvent | BindableFunction

export type ConnectionInfo = {
	connector: string,
	dispatcher: string,
	type: Enums.Enums,
	[any]: nil,
}

export type LastRequest = {
	headers: Headers,
	payload: Payload,
	[any]: nil,
}

export type OnDispatch = (
	channelOrRequest: Channel | Request,
	success: boolean,
	validationStatus: ValidationStatus.Array,
	headers: Headers,
	payload: Payload
) -> ()

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
	handler: (headers: Headers, payload: Payload) -> (),
	lastSent: LastRequest?,
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
	lastSent: LastRequest?,
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
