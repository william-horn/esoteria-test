--!strict

--[[
	@author: William J. Horn
	@written: 1/6/2025

	Custom enums module. New enum categories can be created using the
	EnumCategory class, and enum items are created using the EnumItem class.

	Both EnumCategorys and EnumItems can be serialized/deserialized for
	transmission using Enum.serialize() and Enum.deserialize()
]]

local Shared = game:GetService("ReplicatedStorage").Shared

local EnumItem = require(Shared.Enums.EnumItem)
local EnumCategory = require(Shared.Enums.EnumCategory)

local Enums = {}

export type Enums = EnumItem.EnumItem | EnumCategory.EnumCategory

function Enums.serialize(enum: Enums): string
	return enum._id
end

function Enums.deserialize(serialized: string): Enums
	local type = serialized:match("[^:]+") :: string

	if type == "EnumCategory" then
		return EnumCategory.deserialize(serialized)
	elseif type == "EnumItem" then
		return EnumItem.deserialize(serialized)
	else
		error("Unable to deserialize Enum")
	end
end

function Enums.is(value: any): boolean
	return EnumItem.is(value) or EnumCategory.is(value)
end

do
	local Network = EnumCategory.new("Network")

	local Channel = EnumCategory.new("Channel")
	Channel.Channel = EnumItem.new("Channel")

	local Protocol = EnumCategory.new("Protocol")
	Protocol.LocalEvent = EnumItem.new("LocalEvent")
	Protocol.LocalRequest = EnumItem.new("LocalRequest")
	Protocol.TCPEvent = EnumItem.new("TCPEvent")
	Protocol.TCPRequest = EnumItem.new("TCPRequest")
	Protocol.UDPEvent = EnumItem.new("UDPEvent")

	local Request = EnumCategory.new("Request")
	Request.Generic = EnumItem.new("Generic")

	Network.Channel = Channel
	Network.Protocol = Protocol
	Network.Request = Request

	Enums.Network = Network
end

do
	local Machine = EnumCategory.new("Machine")
	Machine.Any = EnumItem.new("Any")
	Machine.Client = EnumItem.new("Client")
	Machine.Server = EnumItem.new("Server")
	Machine.Studio = EnumItem.new("Studio")

	Enums.Machine = Machine
end

do
	local SignalConnection = EnumCategory.new("SignalConnection")
	SignalConnection.Callback = EnumItem.new("Callback")
	SignalConnection.Event = EnumItem.new("Event")
	SignalConnection.None = EnumItem.new("None")

	Enums.SignalConnection = SignalConnection
end

do
	local SignalDomain = EnumCategory.new("SignalDomain")
	SignalDomain.Global = EnumItem.new("Global") -- Remotes
	SignalDomain.Local = EnumItem.new("Local") -- Bindables
	SignalDomain.None = EnumItem.new("None")

	Enums.SignalDomain = SignalDomain
end

do
	local Validation = EnumCategory.new("Validation")
	Validation.Any = EnumItem.new("Rejected")
	Validation.Client = EnumItem.new("Successful")

	Enums.Validation = Validation
end

return Enums
