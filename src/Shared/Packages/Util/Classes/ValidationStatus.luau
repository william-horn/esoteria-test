--!strict

-- Directories
local Shared = game:GetService("ReplicatedStorage").Shared

local ENUM = require(Shared.Types.Enum)

-- ValidationStatus class
local ValidationStatus = {}
ValidationStatus.__index = ValidationStatus

-- ValidationStatus types
type self__ValidationStatus = {
	status: ENUM.Item,
	-- reason: ENUM.Item,
	message: string,
}

export type Self = typeof(setmetatable({} :: self__ValidationStatus, ValidationStatus))
export type Array = { Self }
export type Map = { [any]: Self }

function ValidationStatus.new(status: ENUM.Item, message: string): Self
	local self: self__ValidationStatus = {
		status = status,
		-- reason = reason,
		message = message,
	}

	return setmetatable(self, ValidationStatus)
end

return ValidationStatus
