--!strict

--[[
	@author: William J. Horn
	@written: 1/6/2025

	Custom enums module. New enum categories can be created using the
	EnumCategory class, and enum items are created using the EnumItem class.

	Both EnumCategorys and EnumItems can be serialized/deserialized for
	transmission using Enum.serialize() and Enum.deserialize()
]]

local INVALID_ENUM_ARG_ERROR = "Unable to call %s with incorrect arg type. Expected '%s', got '%s'"

local Shared = game:GetService("ReplicatedStorage").Shared

local EnumItem = require(Shared.Enums.EnumItem)
local EnumCategory = require(Shared.Enums.EnumCategory)

export type EnumItem = EnumItem.EnumItem
export type EnumCategory = EnumCategory.EnumCategory

-- NETWORK
local Network: EnumCategory & {
	Channel: EnumCategory & {
		Channel: EnumItem,
	},

	Protocol: EnumCategory & {
		LocalEvent: EnumItem,
		LocalRequest: EnumItem,
		TCPEvent: EnumItem,
		TCPRequest: EnumItem,
		UDPEvent: EnumItem,
	},

	Request: EnumCategory & {
		Generic: EnumItem,
	},
} =
	EnumCategory.new("Network", {
		Channel = EnumCategory.new("Channel", {
			Channel = EnumItem.new("Channel"),
		}),

		Protocol = EnumCategory.new("Protocol", {
			LocalEvent = EnumItem.new("LocalEvent"),
			LocalRequest = EnumItem.new("LocalRequest"),
			TCPEvent = EnumItem.new("TCPEvent"),
			TCPRequest = EnumItem.new("TCPRequest"),
			UDPEvent = EnumItem.new("UDPEvent"),
		}),

		Request = EnumCategory.new("Request", {
			Generic = EnumItem.new("Generic"),
		}),
	})
--

-- MACHINE
local Machine: EnumCategory & {
	Any: EnumItem,
	Client: EnumItem,
	Server: EnumItem,
	Studio: EnumItem,
} =
	EnumCategory.new("Machine", {
		Any = EnumItem.new("Any"),
		Client = EnumItem.new("Client"),
		Server = EnumItem.new("Server"),
		Studio = EnumItem.new("Studio"),
	})
--

-- SIGNAL CONNECTION
local SignalConnection: EnumCategory & {
	Callback: EnumItem,
	Event: EnumItem,
	None: EnumItem,
} =
	EnumCategory.new("SignalConnection", {
		Callback = EnumItem.new("Callback"),
		Event = EnumItem.new("Event"),
		None = EnumItem.new("None"),
	})
--

-- SIGNAL DOMAIN
local SignalDomain: EnumCategory & {
	Global: EnumItem,
	Local: EnumItem,
	None: EnumItem,
} =
	EnumCategory.new("SignalDomain", {
		Global = EnumItem.new("Global"),
		Local = EnumItem.new("Local"),
		None = EnumItem.new("None"),
	})
--

-- VALIDATION
local Validation: EnumCategory & {
	Rejected: EnumItem,
	Successful: EnumItem,
} = EnumCategory.new("Validation", {
	Rejected = EnumItem.new("Rejected"),
	Successful = EnumItem.new("Successful"),
})
--

local function serialize(enum: EnumCategory | EnumItem.EnumItem): string
	if EnumItem.is(enum) then
		return EnumItem.serialize(enum)
	elseif EnumCategory.is(enum) then
		return EnumCategory.serialize(enum)
	else
		error(INVALID_ENUM_ARG_ERROR:format("serialize()", "Enums", typeof(enum)), 2)
	end
end

local function deserialize(serialized: string): EnumCategory | EnumItem.EnumItem
	local token = serialized:match("[^:]+")

	if token == "EnumCategory" then
		return EnumCategory.deserialize(serialized)
	elseif token == "EnumItem" then
		return EnumItem.deserialize(serialized)
	else
		error(INVALID_ENUM_ARG_ERROR:format("deserialize()", "Enums._id<string>", typeof(serialized)))
	end
end

local function is(value: any): boolean
	return EnumItem.is(value) or EnumCategory.is(value)
end

return {
	serialize = serialize,
	deserialize = deserialize,
	is = is,
	Network = Network,
	Machine = Machine,
	SignalConnection = SignalConnection,
	SignalDomain = SignalDomain,
	Validation = Validation,
}
