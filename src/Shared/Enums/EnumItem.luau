--!strict

local Shared = game:GetService("ReplicatedStorage").Shared

local TABLE = require(Shared.Types.Table)

local EnumItem = {} :: TABLE.Class
EnumItem.__index = EnumItem

type self__EnumItem = {
	value: number,
	name: string,
	[any]: nil,
}

export type Self = typeof(setmetatable({} :: self__EnumItem, EnumItem))
export type Array = { Self }
export type Map = { [any]: Self }

local function new(value: number, name: string): Self
	local self = setmetatable({} :: self__EnumItem, EnumItem)
	self.value = value
	self.name = name

	return self
end

return {
	new = new,
}
