--!strict

local Shared = game:GetService("ReplicatedStorage").Shared

local TABLE = require(Shared.Types.Table)

--[[
	@desc: Merges dictionary table `a` into dictionary table `b`
	@param <table> a
	@param <table> b
	@param <boolean> overwrite - If true, values from a will overwrite values in b
	@returns: <table> c
]]
local function merge(a: TABLE.Any, b: TABLE.Any, overwrite: boolean?): TABLE.Any
	local c: TABLE.Any = table.clone(b)

	for k: any, v: any in next, a do
		if (not c[k]) or overwrite then
			c[k] = v
		end
	end

	return c
end

return merge
