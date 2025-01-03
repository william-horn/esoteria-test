--!strict

local isTable = require(script.Parent.isTable)

-- Returns true if `a` and `b` are both table types
local function bothAreTables(a: any, b: any): boolean
	return isTable(a) and isTable(b)
end

return bothAreTables
