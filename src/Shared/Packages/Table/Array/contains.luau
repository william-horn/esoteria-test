--!strict

local Shared = game:GetService("ReplicatedStorage").Shared

local Table = require(Shared.Types.Table)
local toBool = require(Shared.Packages.Util.Types.toBool)
local isFunction = require(Shared.Packages.Util.Types.isFunction)

local function contains(arr: Table.AnyArray, element: any): boolean
	if isFunction(element) then
		for index: number = 1, #arr do
			local value: any = arr[index]
			if element(index, value) then
				return true
			end
		end

		return false
	else
		return toBool(table.find(arr, element))
	end
end

return contains
