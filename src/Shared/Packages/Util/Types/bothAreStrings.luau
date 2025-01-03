--!strict

local isString = require(script.Parent.isString)

-- Returns true if `a` and `b` are both string types
local function bothAreStrings(a: any, b: any): boolean
	return isString(a) and isString(b)
end

return bothAreStrings
