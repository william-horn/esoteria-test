--!strict

-- Returns true if a value is a ModuleScript
local function isModule(v: Instance): boolean
	return v:IsA("ModuleScript")
end

return isModule
