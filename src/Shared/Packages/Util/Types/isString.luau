--!strict

-- Returns true if a value is a string type
local function isString(v: any): boolean
	return type(v) == "string"
end

return isString
