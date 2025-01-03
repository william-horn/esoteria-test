--!strict

local Shared = game.ReplicatedStorage.Shared

local Table = require(Shared.Types.Table)

--[[
	@desc: Returns an array of all keys in a table
	@args: <table> dict
	@returns: <array> keys
]]
local function keys(dict: Table.Any): Table.AnyArray
	local arr: Table.AnyArray = {}

	for k: any, _ in next, dict do
		arr[#arr + 1] = k
	end

	return arr
end

return keys
