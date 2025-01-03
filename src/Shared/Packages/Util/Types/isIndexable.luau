--!strict

local isTable = require(script.Parent.isTable)
local isUserdata = require(script.Parent.isUserdata)

-- Returns true if a value is indexable (i.e, if you can do Thing.something)
local function isIndexable(v: any): boolean
	return isTable(v) or isUserdata(v)
end

return isIndexable
