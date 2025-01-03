--!strict

local _isClient: boolean = game:GetService("RunService"):IsClient()

local function isClient(): boolean
	return _isClient
end

return isClient
