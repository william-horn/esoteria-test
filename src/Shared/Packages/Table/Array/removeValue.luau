--!strict

local Shared = game:GetService("ReplicatedStorage").Shared

local Table = require(Shared.Types.Table)

local function removeValue(arr: Table.AnyArray, element: any): (boolean, number?)
	for i: number = 1, #arr do
		local v: any = arr[i]

		if v == element then
			return true, i
		end
	end

	return false, nil
end

return removeValue
