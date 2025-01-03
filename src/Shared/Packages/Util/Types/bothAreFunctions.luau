--!strict

local isFunction = require(script.Parent.isFunction)

-- Returns true if `a` and `b` are both function types
local function bothAreFunctions(a: any, b: any): boolean
	return isFunction(a) and isFunction(b)
end

return bothAreFunctions
