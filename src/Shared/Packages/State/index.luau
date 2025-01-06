--!strict

--[[
	@author: William J. Horn
	@written: 1/4/2025

	A lightweight state manager API for manipulating and keeping track of
	state.
]]

-- Directories
local Shared = game:GetService("ReplicatedStorage").Shared
local Packages = Shared.Packages
local Enums = Shared.Enums

-- Packages & Types
local TABLE = require(Shared.Types.Table)

local bothAreIndexable = require(Packages.Util.Types.bothAreIndexable)
local ValidationStatus = require(Packages.Util.Classes.ValidationStatus)

-- State class
local State = {}
State.__index = State

-- State types
type StateValidator = (any) -> (boolean, string?)
type StateUpdater = (prev: any) -> any

type self__State = {
	_validators: { StateValidator },
	_internalState: TABLE.Any,
}

export type Validator = StateValidator
export type Updater = StateUpdater
export type Self = typeof(setmetatable({} :: self__State, State))
export type Array = { Self }

function State.new(initialState: any): Self
	local self = setmetatable({} :: self__State, State)
	self._validators = {}
	self._internalState = initialState or nil

	return self
end

function State:addValidator(validator: StateValidator): ()
	self._validators[#self._validators + 1] = validator
end

function State:set(state: any): ()
	self._internalState = state
end

function State:get(): TABLE.Any
	return self._internalState
end

function State:update(state: any): ()
	if bothAreIndexable(state, self._internalState) then
		for key: any, stateUpdater: StateUpdater in next, state do
			self._internalState[key] = stateUpdater(self._internalState[key])
		end
	else
		self:set(state)
	end
end

function State:validate(): (boolean, ValidationStatus.Array)
	local validationReport: ValidationStatus.Array = {}

	for index: number = 1, #self._validators do
		local success: boolean, _message: string? = self._validators[index](self._internalState)
		local message: string = if _message then _message else "No description"

		if not success then
			local validationLog: ValidationStatus.Self = ValidationStatus.new(Enums.Validation.Rejected, message)
			validationReport[#validationReport + 1] = validationLog
		end
	end

	return #validationReport == 0, validationReport
end

return State
