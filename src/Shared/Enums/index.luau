--!strict

local Shared = game:GetService("ReplicatedStorage").Shared

local TABLE = require(Shared.Types.Table)

local EnumItem = require(Shared.Enums.EnumItem)
local EnumCategory = require(Shared.Enums.EnumCategory)

local Enums = {} :: TABLE.Class

function Enums.serialize(enum: EnumItem.EnumItem | EnumCategory.EnumCategory): string
	return enum._id
end

function Enums.deserialize(serialized: string): EnumItem.EnumItem | EnumCategory.EnumCategory
	local type = serialized:match("[^:]+") :: string

	if type == "EnumCategory" then
		return EnumCategory.deserialize(serialized)
	elseif type == "EnumItem" then
		return EnumItem.deserialize(serialized)
	else
		error("Unable to deserialize Enum")
	end
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
	SignalConnection.Any = EnumItem.new("Callback")
	SignalConnection.Client = EnumItem.new("Event")
	SignalConnection.Server = EnumItem.new("None")

	Enums.SignalConnection = SignalConnection
end

do
	local Validation = EnumCategory.new("Validation")
	Validation.Any = EnumItem.new("Rejected")
	Validation.Client = EnumItem.new("Successful")

	Enums.Validation = Validation
end

return Enums
