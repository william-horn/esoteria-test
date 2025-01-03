--!strict

-- Returns true if an Instance is a BindableEvent
local function isBindableEvent(v: Instance): boolean
	return v:IsA("BindableEvent")
end

return isBindableEvent
