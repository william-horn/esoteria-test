--!strict

--[[
	@author William J. Horn
	@written 1/6/2025

	A custom enum item class with serialize/deserialize capabilities
]]

local Shared = game:GetService("ReplicatedStorage").Shared

local TABLE = require(Shared.Types.Table)
local isTable = require(Shared.Packages.Util.Types.isTable)
local getId = require(Shared.Enums.getId)

type EnumItemStaticInterface = EnumItemPublicMethods & TABLE.Map<string, any>

type EnumItemPublicFields = {
	value: number,
	name: string,
}

type EnumItemPublicMethods = {
	getId: (self: EnumItem) -> string,
}

type EnumItemPublicInterface = EnumItemPublicFields & EnumItemPublicMethods & TABLE.Map<string, any>

local EnumItem = {} :: EnumItemStaticInterface
EnumItem.__index = EnumItem

-- Static fields
EnumItem._itemCount = 0
EnumItem._idMap = {}

export type EnumItem = typeof(setmetatable({} :: EnumItemPublicInterface, EnumItem))

function EnumItem:getId()
	local id = self._id :: string -- private
	return id
end

local function new(name: string, _value: number?)
	local itemCount = EnumItem._itemCount :: number -- private
	local idMap = EnumItem._idMap :: TABLE.Map<string, EnumItem> -- private

	local value: number = _value or itemCount
	local itemId = getId("EnumItem", name, itemCount)

	local self = setmetatable({} :: EnumItemPublicInterface, EnumItem)
	self.value = value
	self.name = name
	self._id = itemId

	idMap[itemId] = self
	EnumItem._itemCount += 1
	return self
end

local function is(any: any)
	return isTable(any) and getmetatable(any) == EnumItem
end

local function serialize(enumItem: EnumItem)
	return enumItem:getId()
end

local function deserialize(serialized: string)
	local idMap = EnumItem._idMap :: TABLE.Map<string, EnumItem> -- private
	return idMap[serialized]
end

return {
	new = new,
	is = is,
	serialize = serialize,
	deserialize = deserialize,
}
