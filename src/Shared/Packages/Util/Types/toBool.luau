--!strict

-- Convert a value to a boolean type
local function toBool(v: any): boolean
	return not not v
end

return toBool
