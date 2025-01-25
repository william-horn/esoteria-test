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
local Enums = require(Shared.Enums.index)

-- Packages & Types
local TABLE = require(Shared.Types.Table)

local bothAreIndexable = require(Packages.Util.Types.bothAreIndexable)
local ValidationStatus = require(Packages.Util.Classes.ValidationStatus)
local exists = require(Packages.Util.Types.exists)

-- State class
local State = {}
State.__index = State

-- State types
type self__State = {
	_validators: { StateValidator },
	_internalState: TABLE.Any,
}

export type StateValidator = (TABLE.Any, any) -> (boolean, string?)
export type StateUpdater = (prev: any) -> any
export type State = typeof(setmetatable({} :: self__State, State))
export type Array = { State }

local function new(initialState: any): State
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

function State:get(key: string?): TABLE.Any
	return if key then self._internalState[key] else self._internalState
end

function State:has(key: any): boolean
	return exists(self._internalState[key])
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

function State:validate(_scope: TABLE.StringKeys?): (boolean, ValidationStatus.Array?)
	local scope: TABLE.StringKeys = _scope or {}
	local validationReport: ValidationStatus.Array = {}

	for index: number = 1, #self._validators do
		local success: boolean, _message: string? = self._validators[index](scope, self._internalState)
		local message: string = if _message then _message else "No description"

		if not success then
			local validationLog: ValidationStatus.ValidationStatus =
				ValidationStatus.new(Enums.Validation.Rejected, message)
			validationReport[#validationReport + 1] = validationLog

			return #validationReport == 0, validationReport
		else
			return true
		end
	end
end

return {
	new = new,
}
