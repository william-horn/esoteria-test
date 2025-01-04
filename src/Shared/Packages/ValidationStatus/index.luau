--!strict

-- Directories
local Shared = game.ReplicatedStorage.Shared

local Custom = require(Shared.Types.Custom)

-- ValidationStatus class
local ValidationStatus = {}
ValidationStatus.__index = ValidationStatus

-- ValidationStatus types
type self__ValidationStatus = {
	status: Custom.EnumItem,
	reason: Custom.EnumItem,
	message: string,
}

export type ValidationStatus = typeof(setmetatable({} :: self__ValidationStatus, ValidationStatus))

function ValidationStatus.new(status: Custom.EnumItem, reason: Custom.EnumItem, message: string): ValidationStatus
	local self: self__ValidationStatus = {
		status = status,
		reason = reason,
		message = message,
	}

	return setmetatable(self, ValidationStatus)
end

return ValidationStatus
