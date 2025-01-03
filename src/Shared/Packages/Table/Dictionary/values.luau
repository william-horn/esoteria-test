--!strict

local Shared = game.ReplicatedStorage.Shared

local Table = require(Shared.Types.Table)

--[[
	@desc: Returns an array of all values in a table
	@args: <table> dict
	@returns: <array> values
]]
local function values(dict: Table.Any): Table.AnyArray
	local arr: Table.AnyArray = {}

	for _, v: any in next, dict do
		arr[#arr + 1] = v
	end

	return arr
end

return values
