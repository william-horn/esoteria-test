--!strict

local Shared = game:GetService("ReplicatedStorage").Shared

local Table = require(Shared.Types.Table)

--[[
	@desc:
		Remove duplicate entries in an array

		Example:
			reduce({1,1,1,2,3}) -> {1,2,3}
]]
local function reduce(t: Table.AnyArray): Table.AnyArray
	local unique: Table.AnyArray = {}
	local seen: Table.Any = {}

	for _, v: any in next, t do
		if not seen[v] then
			unique[#unique + 1] = v
			seen[v] = true
		end
	end

	return unique
end

return reduce
