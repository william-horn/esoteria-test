--!strict

local isBool = require(script.Parent.isBool)

-- Returns true if a value is a valid boolean, and it's value is false
local function isFalse(v: any): boolean
	return isBool(v) and v == false
end

return isFalse
