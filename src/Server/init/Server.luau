--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Server = game:GetService("ServerScriptService").Server
local Packages = Shared.Packages
local Network = require(Server.Packages.Network.index):init()

local TABLE = require(Shared.Types.Table)
local NETWORK = require(Shared.Types.Network)

-- Enums
local Enums = require(Shared.Enums.index)
local NetworkEnums = Enums.Network
local EnumCategory = require(Shared.Enums.EnumCategory)
local EnumItem = require(Shared.Enums.EnumItem)

while true do
	local t = os.clock()

	local response: NETWORK.Response = Network:sendTCP({
		headers = {
			channel = Enums.Network.Channel.Channel,
			request = Enums.Network.Request.Generic,
			sendAll = true,
			-- dependencies = { os.clock() },
		},
		payload = {
			data = "test data",
		},
	})

	local f = os.clock() - t

	print("time: ", f)
	print("response: ", response)

	task.wait(0.5)
end

return nil
