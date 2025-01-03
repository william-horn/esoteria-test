--!strict

local isNumber = require(script.Parent.isNumber)

-- Returns true if `a` and `b` are both number types
local function bothAreNumbers(a: any, b: any): boolean
	return isNumber(a) and isNumber(b)
end

return bothAreNumbers
