--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Server = game:GetService("ServerScriptService").Server
local Packages = Shared.Packages

local TABLE = require(Shared.Types.Table)

-- Enums
local Enums = require(Shared.Enums.index)
local EnumCategory = require(Shared.Enums.EnumCategory)
local EnumItem = require(Shared.Enums.EnumItem)

local TableWithIndexError = require(Packages.Util.Classes.TableWithIndexError)

local t: TABLE.Any = TableWithIndexError.new("Some Table")

print(t.something)

return nil
