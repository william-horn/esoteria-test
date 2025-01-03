--!strict

local isInstance = require(script.Parent.isInstance)

-- Returns true if `a` and `b` are both Instances
local function bothAreInstances(a: any, b: any): boolean
	return isInstance(a) and isInstance(b)
end

return bothAreInstances
