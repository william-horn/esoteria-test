--!strict

local Shared = game:GetService("ReplicatedStorage").Shared

local EnumItem = require(Shared.Enums.EnumItem)
local TABLE = require(Shared.Types.Table)
local getValues = require(Shared.Packages.Table.Dictionary.values)

local EnumCategory = {} :: TABLE.Class
EnumCategory.__index = EnumCategory

EnumCategory._categoryCount = 0

type self__EnumCategory = {
	value: number,
	name: string,
	_items: EnumItem.Map,
	[any]: nil,
}

export type Self = typeof(setmetatable({} :: self__EnumCategory, EnumCategory))
export type Array = { Self }
export type Map = { [any]: Self }

function EnumCategory:getItems()
	return getValues(self._items)
end

local function new(name: string, _enumItems: EnumItem.Map): Self
	local enumItems: EnumItem.Map = _enumItems or {}

	local self = setmetatable({} :: self__EnumCategory, EnumCategory)
	self.value = EnumCategory._categoryCount
	self.name = name
	self._items = enumItems

	EnumCategory._categoryCount += 1
	return self
end

return {
	new = new,
}
