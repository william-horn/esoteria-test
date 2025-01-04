--!strict

--[[
	@author: William J. Horn
	@written: 1/4/2025

	A lightweight state manager API for manipulating and keeping track of
	state.
]]

-- Directories
local Shared = game.ReplicatedStorage.Shared
local Packages = Shared.Packages
local Enums = Shared.Enums

-- Packages & Types
local Table = require(Shared.Types.Table)
local bothAreIndexable = require(Packages.Util.Types.bothAreIndexable)
local ValidationStatus = require(script.Parent.ValidationStatus)

-- State class
local State = {}
State.__index = State

-- State types
type self__State = {
	_conditions: Table.FunctionArray,
	_internalState: Table.Any,
}

type StateCondition = (internalState: Table.Any) -> ()

export type State = typeof(setmetatable({} :: self__State, State))

function State.new(initialState: any): State
	local self = setmetatable({} :: self__State, State)
	self._conditions = {}
	self._internalState = initialState or nil

	return self
end

function State:addCondition(condition: StateCondition): ()
	self._conditions[#self._conditions + 1] = condition
end

function State:set(state: any)
	self._internalState = state
end

function State:update(state: any)
	if bothAreIndexable(state, self._internalState) then
		for key: any, value: any in next, state do
			self._internalState[key] = value
		end
	else
		self:set(state)
	end
end

function State:validate(): (boolean, { ValidationStatus.ValidationStatus })
	local report: { ValidationStatus.ValidationStatus } = {}

	for index: number = 1, #self._conditions do
		local conditionResult: ValidationStatus.ValidationStatus? = self._conditions[index](self._internalState)

		if conditionResult and conditionResult.status == Enums.ValidationType.Rejected then
			report[#report + 1] = conditionResult
		end
	end

	return #report == 0, report
end

return State
