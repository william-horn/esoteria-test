--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Server = game:GetService("ServerScriptService").Server
local Packages = Shared.Packages
local Enums = Shared.Enums

local Network = require(Server.Packages.Network.index)
Network:listen()

local success, dispatchReport = Network:sendTCP({
	channel = Enums.Network.Channel.Channel,
	request = Enums.Network.Request.Generic,
}, {
	body = "Some text",
})

success, dispatchReport = Network:sendTCP({
	channel = Enums.Network.Channel.Channel,
	request = Enums.Network.Request.Generic,
}, {
	body = "Some text",
})

success, dispatchReport = Network:sendTCP({
	channel = Enums.Network.Channel.Channel,
	request = Enums.Network.Request.Generic,
}, {
	body = "Some text",
})

success, dispatchReport = Network:sendTCP({
	channel = Enums.Network.Channel.Channel,
	request = Enums.Network.Request.Generic,
}, {
	body = "Some text",
})

print(Network)
print("Dispatch result: ", success, dispatchReport)

return true
