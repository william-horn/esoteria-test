--!strict

--[[
	Returns true if a value is a Remote of any kind. This includes
	signal APIs such as BindableFunctions and BindableEvents
]]
local function isRemote(v: Instance): boolean
	return v:IsA("BaseRemoteEvent") or v:IsA("BindableEvent") or v:IsA("BindableFunction") or v:IsA("RemoteFunction")
end

return isRemote
