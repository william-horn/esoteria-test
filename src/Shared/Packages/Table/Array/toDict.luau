--!strict

local Shared = game:GetService("ReplicatedStorage").Shared

local Table = require(Shared.Types.Table)

--[[
	@desc: Converts an array into a dictionary with the structure:
		array: {'a', 'b', 'c', ...}
		dict: {['a'] = 'a', ['b'] = 'b', ['c'] = 'c', ...}
	@args: <array> arr
	@returns: <dictionary> dict
]]
local function toDict(arr: Table.AnyArray): Table.Any
	local dict: Table.Any = {}

	for i: number = 1, #arr do
		local v: any = arr[i]
		dict[v] = v
	end

	return dict
end

return toDict
