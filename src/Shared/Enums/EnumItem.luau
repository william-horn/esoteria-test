--!strict

--[[
	@author: William J. Horn
	@written: 1/6/2025

	A custom enum item class with serialize/deserialize capabilities
]]

local Shared = game:GetService("ReplicatedStorage").Shared

-- local TABLE = require(Shared.Types.Table)

local isTable = require(Shared.Packages.Util.Types.isTable)
local getId = require(Shared.Enums.getId)

local EnumItem = {}
EnumItem.__index = EnumItem

EnumItem._itemCount = 0
EnumItem._idMap = {}

type self__EnumItem = {
	value: number,
	name: string,
	_id: string,
	[any]: nil,
}

export type EnumItem = typeof(setmetatable({} :: self__EnumItem, EnumItem))
export type Array = { EnumItem }
export type Map = { [any]: EnumItem }

local function new(name: string, _value: number?): EnumItem
	local value: number = _value or EnumItem._itemCount
	local itemId: string = getId("EnumItem", name, EnumItem._itemCount)

	local self = setmetatable({} :: self__EnumItem, EnumItem)
	self.value = value
	self.name = name
	self._id = itemId

	EnumItem._idMap[itemId] = self
	EnumItem._itemCount += 1
	return self
end

local function is(any: any): boolean
	return isTable(any) and getmetatable(any) == EnumItem
end

local function serialize(enumItem: EnumItem): string
	return enumItem._id
end

local function deserialize(serialized: string): EnumItem
	return EnumItem._idMap[serialized]
end

return {
	new = new,
	is = is,
	serialize = serialize,
	deserialize = deserialize,
}
