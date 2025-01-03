--!strict

-- Checks if a value is a userdata type
local function isUserdata(v: any): boolean
	return type(v) == "userdata"
end

return isUserdata
