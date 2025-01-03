--!strict

local Shared = game.ReplicatedStorage.Shared

local Table = require(Shared.Types.Table)
local toBool = require(Shared.Packages.Util.Types.toBool)

local function contains(arr: Table.AnyArray, element: any): boolean
	return toBool(table.find(arr, element))
end

return contains
