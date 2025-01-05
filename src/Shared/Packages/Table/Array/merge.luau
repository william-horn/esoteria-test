--!strict

local Shared = game:GetService("ReplicatedStorage").Shared

local Table = require(Shared.Types.Table)

--[[
	@desc: Merges two tables (arrays) into one
	@param <table> a
	@param <table> b
	@returns: <table> c
]]
local function merge(a: Table.AnyArray, b: Table.AnyArray): Table.AnyArray
	local c: Table.AnyArray = table.clone(b)

	for i = 1, #a do
		local v: any = a[i]
		c[#c + 1] = v
	end

	return c
end

return merge
