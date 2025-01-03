--!strict

local Shared = game.ReplicatedStorage.Shared
local Packages = Shared.Packages

local NetworkScanner = require(Packages.Network.Scanner)

local NetworkTree: NetworkScanner.NetworkTree = NetworkScanner:createNetworkTree({
	SharedNetwork = Shared.Network,
	LocalNetwork = script.Parent.Parent.Network,
})

local Network = {}

return Network
