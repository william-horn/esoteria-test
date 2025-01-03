--!strict

-- Returns true if a value is nil
local function isNil(v: any): boolean
	return type(v) == "nil"
end

return isNil
