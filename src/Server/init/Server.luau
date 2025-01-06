--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Server = game:GetService("ServerScriptService").Server
local Packages = Shared.Packages
local Enums = Shared.Enums

local Network = require(Server.Packages.Network.index)
local NetworkType = require(Packages.Network.Types)
Network:listen()

print(Network._tree)

Network:sendTCP({
	channel = Enums.Network.Channel,
	request = Enums.Network.Request,
}, {})

return true
