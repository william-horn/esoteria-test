--!strict

-- Directories
local Shared = game:GetService("ReplicatedStorage").Shared
local Enums = require(Shared.Enums.index)

-- ValidationStatus class
local ValidationStatus = {}
ValidationStatus.__index = ValidationStatus

-- ValidationStatus types
type self__ValidationStatus = {
	status: Enums.Enums,
	-- reason: Enums.Enums,
	message: string,
}

export type ValidationStatus = typeof(setmetatable({} :: self__ValidationStatus, ValidationStatus))
export type Array = { ValidationStatus }
export type Map = { [any]: ValidationStatus }

function ValidationStatus.new(status: Enums.Enums, message: string): ValidationStatus
	local self: self__ValidationStatus = {
		status = status,
		-- reason = reason,
		message = message,
	}

	return setmetatable(self, ValidationStatus)
end

return ValidationStatus
