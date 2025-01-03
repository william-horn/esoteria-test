--!strict

local _isServer: boolean = game:GetService("RunService"):IsServer()

local function isServer(): boolean
	return _isServer
end

return isServer
