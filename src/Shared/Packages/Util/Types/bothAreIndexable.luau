--!strict

local isIndexable = require(script.Parent.isIndexable)

-- Returns true if `a` and `b` are both indexable (i.e, a.foo and b.bar are legal operations)
local function bothAreIndexable(a: any, b: any): boolean
	return isIndexable(a) and isIndexable(b)
end

return bothAreIndexable
