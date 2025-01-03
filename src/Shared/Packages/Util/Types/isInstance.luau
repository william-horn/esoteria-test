--!strict

-- Returns true if a value is an Instance
local function isInstance(v: any): boolean
	return typeof(v) == "Instance"
end

return isInstance
