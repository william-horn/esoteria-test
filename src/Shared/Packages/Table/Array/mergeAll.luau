--!strict

local Shared = game.ReplicatedStorage.Shared

local Table = require(Shared.Types.Table)

local function mergeAll(arrays: Table.Array2D): Table.AnyArray
	local all: Table.AnyArray = {}

	for i: number = 1, #arrays do
		local arr: Table.AnyArray = arrays[i]

		for j: number = 1, #arr do
			local value: any = arr[j]
			all[#all + 1] = value
		end
	end

	return all
end

return mergeAll
