--!strict

local Shared = game:GetService("ReplicatedStorage").Shared

local TABLE = require(Shared.Types.Table)

local function removeValue(arr: TABLE.AnyArray, element: any): (boolean, number?)
	for i: number = 1, #arr do
		local v: any = arr[i]

		if v == element then
			return true, i
		end
	end

	return false, nil
end

return removeValue
