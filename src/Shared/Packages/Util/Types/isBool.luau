--!strict

-- Returns true if a value is a boolean type
local function isBool(v: any): boolean
	return type(v) == "boolean"
end

return isBool
