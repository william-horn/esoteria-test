--!strict

-- Returns true if a value is a BaseRemoteEvent
local function isRemoteEvent(v: Instance): boolean
	return v:IsA("BaseRemoteEvent")
end

return isRemoteEvent
