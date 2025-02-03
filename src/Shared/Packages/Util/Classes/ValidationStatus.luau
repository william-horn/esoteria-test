--!strict

-- Directories
local Shared = game:GetService("ReplicatedStorage").Shared
local Enums = require(Shared.Enums.index)

-- ValidationStatus class
local ValidationStatus = {}
ValidationStatus.__index = ValidationStatus

-- ValidationStatus types
type ValidationStatusFields = {
	status: Enums.EnumItem,
	-- reason: Enums.Enums,
	message: string,
}

export type ValidationStatus = typeof(setmetatable({} :: ValidationStatusFields, ValidationStatus))

function ValidationStatus.new(status: Enums.EnumItem, message: string): ValidationStatus
	local self: ValidationStatusFields = {
		status = status,
		-- reason = reason,
		message = message,
	}

	return setmetatable(self, ValidationStatus)
end

return ValidationStatus
