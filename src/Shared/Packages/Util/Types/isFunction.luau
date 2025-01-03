--!strict

-- Returns true if a value is a function
local function isFunction(v: any): boolean
	return type(v) == "function"
end

return isFunction
