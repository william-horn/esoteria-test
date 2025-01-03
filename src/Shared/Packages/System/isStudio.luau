--!strict

local _isStudio: boolean = game:GetService("RunService"):IsStudio()

local function isStudio(): boolean
	return _isStudio
end

return isStudio
