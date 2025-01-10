--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Server = game:GetService("ServerScriptService").Server
local Packages = Shared.Packages
local Network = require(Server.Packages.Network.index):init()

local TABLE = require(Shared.Types.Table)

-- Enums
local Enums = require(Shared.Enums.index)
local EnumCategory = require(Shared.Enums.EnumCategory)
local EnumItem = require(Shared.Enums.EnumItem)

Network:sendTCP({
	channel = Enums.Network.Channel.Channel,
	request = Enums.Network.Request.Generic,
	sendAll = true,
	dependencies = { "something" },
}, {
	data = "test data",
})

Network:sendTCP({
	channel = Enums.Network.Channel.Channel,
	request = Enums.Network.Request.Generic,
	sendAll = true,
	dependencies = { "something" },
}, {
	data = "test data",
})

Network:sendTCP({
	channel = Enums.Network.Channel.Channel,
	request = Enums.Network.Request.Generic,
	sendAll = true,
	dependencies = { "something1" },
}, {
	data = "test data",
})

return nil
