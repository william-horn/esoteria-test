local Shared = game:GetService("ReplicatedStorage").Shared
local EnumItem = require(Shared.Enums.EnumItem)
local EnumCategory = require(Shared.Enums.EnumCategory)

local Enums = {}

do
	local Network = EnumCategory.new("Network")

	Network.Channel = EnumCategory.new("Channel", {
		Channel = EnumItem.new("Channel", 0),
	})

	Network.Protocol = EnumCategory.new("Protocol", {
		LocalEvent = EnumItem.new("LocalEvent", 0),
		LocalRequest = EnumItem.new("LocalRequest", 1),
		TCPEvent = EnumItem.new("TCPEvent", 2),
		TCPRequest = EnumItem.new("TCPRequest", 3),
		UDPEvent = EnumItem.new("UDPEvent", 4),
	})

	Network.Request = EnumCategory.new("Request", {
		Generic = EnumItem.new("Generic", 0),
	})

	Enums.Network = Network
end

do
	local Machine = EnumCategory.new("Machine", {
		Any = EnumItem.new("Any", 0),
		Client = EnumItem.new("Client", 1),
		Server = EnumItem.new("Server", 2),
		Studio = EnumItem.new("Studio", 3),
	})

	Enums.Machine = Machine
end

do
	local SignalConnection = EnumCategory.new("SignalConnection", {
		Callback = EnumItem.new("Callback", 0),
		Event = EnumItem.new("Event", 1),
		None = EnumItem.new("None", 2),
	})

	Enums.SignalConnection = SignalConnection
end

do
	local Validation = EnumCategory.new("Validation", {
		Rejected = EnumItem.new("Rejected", 0),
		Successful = EnumItem.new("Successful", 1),
	})

	Enums.Validation = Validation
end

return Enums
