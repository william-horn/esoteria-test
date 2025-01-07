--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Server = game:GetService("ServerScriptService").Server
local Packages = Shared.Packages

-- Enums
local Enums = require(Shared.Enums.index)
local EnumCategory = require(Shared.Enums.EnumCategory)
local EnumItem = require(Shared.Enums.EnumItem)

local Proto: Enums.Enums = Enums.Network.Protocol

return nil
