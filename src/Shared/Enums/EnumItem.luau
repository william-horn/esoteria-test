--!strict

--[[
	@author William J. Horn
	@written 1/6/2025

	A custom enum item class with serialize/deserialize capabilities
]]

local Shared = game:GetService("ReplicatedStorage").Shared

local isTable = require(Shared.Packages.Util.Types.isTable)
local getId = require(Shared.Enums.getId)

type EnumItemStaticInterface = {
	[string]: any,
}

type EnumItemPublicInterface = {
	value: number,
	name: string,
	[string]: any,
}

local EnumItem = {} :: EnumItemStaticInterface
EnumItem.__index = EnumItem

-- Static fields
EnumItem._itemCount = 0
EnumItem._idMap = {}

export type EnumItem = typeof(setmetatable({} :: EnumItemPublicInterface, EnumItem))
-- export type Array = { EnumItem }
-- export type Map = { [any]: EnumItem }

local function new(name: string, _value: number?)
	local itemCount: number = EnumItem._itemCount
	local value: number = _value or itemCount
	local itemId = getId("EnumItem", name, itemCount)

	local self = setmetatable({}, EnumItem) :: EnumItem
	self.value = value
	self.name = name
	self._id = itemId

	EnumItem._idMap[itemId] = self
	EnumItem._itemCount += 1
	return self
end

local function is(any: any)
	return isTable(any) and getmetatable(any) == EnumItem
end

local function serialize(enumItem: EnumItem)
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
