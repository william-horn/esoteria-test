--!strict

local isBool = require(script.Parent.isBool)

-- Returns true only if value is a boolean and it's value is true
local function isTrue(v: any): boolean
	return isBool(v) and v == true
end

return isTrue
