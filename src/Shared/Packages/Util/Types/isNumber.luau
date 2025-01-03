--!strict

-- Returns true if a value is a number type
local function isNumber(v: any): boolean
	return type(v) == "number"
end

return isNumber
