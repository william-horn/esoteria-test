--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Server = game:GetService("ServerScriptService").Server
local Packages = Shared.Packages
local Network = require(Server.Packages.Network.index):init()

local TABLE = require(Shared.Types.Table)

-- Enums
local Enums = require(Shared.Enums.index)
local NetworkEnums = Enums.Network
local EnumCategory = require(Shared.Enums.EnumCategory)
local EnumItem = require(Shared.Enums.EnumItem)

while true do
	local t = os.clock()

	Network:sendTCP({
		channel = Enums.Network.Channel.Channel,
		request = Enums.Network.Request.Generic,
		sendAll = true,
		-- dependencies = { os.clock() },
	}, {
		data = "test data",
	})

	local f = os.clock() - t

	print("time: ", f)
	print("Channel Data: ", Network:getTCPEventChannel(NetworkEnums.Channel.Channel))

	task.wait(0.5)
end

return nil
