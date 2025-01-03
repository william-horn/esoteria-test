--!strict

-- Returns true if a value is a RemoteFunction
local function isRemoteFunction(v: Instance): boolean
	return v:IsA("RemoteFunction")
end

return isRemoteFunction
