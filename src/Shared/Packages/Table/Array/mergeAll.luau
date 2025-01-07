--!strict

local Shared = game:GetService("ReplicatedStorage").Shared

local TABLE = require(Shared.Types.Table)

local function mergeAll(arrays: TABLE.Array2D): TABLE.AnyArray
	local all: TABLE.AnyArray = {}

	for i: number = 1, #arrays do
		local arr: TABLE.AnyArray = arrays[i]

		for j: number = 1, #arr do
			local value: any = arr[j]
			all[#all + 1] = value
		end
	end

	return all
end

return mergeAll
