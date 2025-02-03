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
type StateFields = {
	_validators: { StateValidator },
	_internalState: TABLE.Map<any, any>,
}

export type StateValidator = (TABLE.Map<any, any>, any) -> (boolean, string?)
export type StateUpdater = (prev: any) -> any
export type State = typeof(setmetatable({} :: StateFields, State))

local function new(initialState: any)
	local self = setmetatable({}, State) :: State
	self._validators = {}
	self._internalState = initialState or nil

	return self
end

function State:addValidator(validator: StateValidator)
	self._validators[#self._validators + 1] = validator
end

function State:set(state: any)
	self._internalState = state
end

function State:get(key: string?): TABLE.Map<any, any>
	return if key then self._internalState[key] else self._internalState
end

function State:has(key: any)
	return exists(self._internalState[key])
end

function State:update(state: any)
	if bothAreIndexable(state, self._internalState) then
		for key: any, stateUpdater: StateUpdater in next, state do
			self._internalState[key] = stateUpdater(self._internalState[key])
		end
	else
		self:set(state)
	end
end

function State:validate(_scope: TABLE.Map<string, any>?): (boolean, TABLE.ArrayOf<ValidationStatus.ValidationStatus>?)
	local scope: TABLE.Map<string, any> = _scope or {}
	local validationReport: TABLE.ArrayOf<ValidationStatus.ValidationStatus> = {}

	for index = 1, #self._validators do
		local success: boolean, _message: string? = self._validators[index](scope, self._internalState)
		local message: string = if _message then _message else "No description"

		if not success then
			local validationLog = ValidationStatus.new(Enums.Validation.Rejected, message)
			validationReport[#validationReport + 1] = validationLog

			return #validationReport == 0, validationReport
		else
			return true
		end
	end

	return true
end

return {
	new = new,
}
