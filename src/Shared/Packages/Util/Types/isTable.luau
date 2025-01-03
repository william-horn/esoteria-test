--!strict

-- Returns true is a value is a table type
local function isTable(v: any): boolean
	return type(v) == "table"
end

return isTable
