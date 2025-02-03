--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Packages = Shared.Packages

local Enums = require(Shared.Enums.index)
local NetworkEnums = Enums.Network

-- Dependencies
local NETWORK = require(Shared.Types.Network)
local isClient = require(Packages.System.isClient)

local function connectRemote(remote, callback) end

return connectRemote
