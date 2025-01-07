--!strict

--[[
	@author: William J. Horn
	@written: 1/6/2025

	A custom enum category class with serialize/deserialize capabilities. Stores EnumItem
	instances and provides an API for collecting all EnumItems
]]

local Shared = game:GetService("ReplicatedStorage").Shared

local EnumItem = require(Shared.Enums.EnumItem)

-- local TABLE = require(Shared.Types.Table)

local isTable = require(Shared.Packages.Util.Types.isTable)
local getValues = require(Shared.Packages.Table.Dictionary.values)
local getId = require(Shared.Enums.getId)

local EnumCategory = {}
EnumCategory.__index = EnumCategory

EnumCategory._categoryCount = 0
EnumCategory._idMap = {} :: Map

type self__EnumCategory = {
	value: number,
	name: string,
	_items: EnumItem.Map,
	_id: string,

	-- ! bug
	-- ROBLOX does not show intellisense for tables that have this type definition
	-- Fix later
	[string]: EnumCategory | EnumItem.EnumItem,
	-- [string]: EnumCategory,
}

export type EnumCategory = typeof(setmetatable({} :: self__EnumCategory, EnumCategory))
export type Array = { EnumCategory }
export type Map = { [any]: EnumCategory }

function EnumCategory:getItems()
	return getValues(self._items)
end

local function new(name: string, _enumItems: EnumItem.Map?): EnumCategory
	local enumItems: EnumItem.Map = _enumItems or {}
	local categoryId: string = getId("EnumCategory", name, EnumCategory._categoryCount)

	local self = setmetatable({} :: self__EnumCategory, EnumCategory)
	self.value = EnumCategory._categoryCount
	self.name = name
	self._items = enumItems
	self._id = categoryId

	EnumCategory._idMap[categoryId] = self
	EnumCategory._categoryCount += 1
	return self
end

local function is(any: any): boolean
	return isTable(any) and getmetatable(any) == EnumCategory
end

local function serialize(enumCategory: EnumCategory): string
	return enumCategory._id
end

local function deserialize(serialized: string): EnumCategory
	return EnumCategory._idMap[serialized]
end

return {
	new = new,
	is = is,
	serialize = serialize,
	deserialize = deserialize,
}
