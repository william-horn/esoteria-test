--!strict

local Shared = game.ReplicatedStorage.Shared

local Table = require(Shared.Types.Table)

--[[
	@desc: Merges two tables (dictionaries) into one
	@param <table> a
	@param <table> b
	@param <boolean> overwrite - If true, values from a will overwrite values in b
	@returns: <table> c
]]
local function merge(a: Table.Any, b: Table.Any, overwrite: boolean): Table.Any
	local c: Table.Any = table.clone(b)

	for k: any, v: any in next, a do
		if (not c[k]) or overwrite then
			c[k] = v
		end
	end

	return c
end

return merge
