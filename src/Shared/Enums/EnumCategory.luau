--!strict

--[[
	@author William J. Horn
	@written 1/6/2025

	A custom enum category class with serialize/deserialize capabilities. Stores EnumItem
	instances and provides an API for collecting all EnumItems
]]

local Shared = game:GetService("ReplicatedStorage").Shared

local EnumItem = require(Shared.Enums.EnumItem)
local TABLE = require(Shared.Types.Table)

local isTable = require(Shared.Packages.Util.Types.isTable)
local getValues = require(Shared.Packages.Table.Dictionary.values)
local getId = require(Shared.Enums.getId)

--[[
Static interface (internal only)

We create an internal interface for the class in order to
ensure that the public method type definitions match up with
the methods that are defined internally. This is why we are
joining `EnumCategoryPublicMethods` with the general map type
]]
type EnumItemStaticInterface = EnumCategoryPublicMethods & TABLE.Map<string, any>

--[[
Public fields (internal & external)

This interface describes what the fields should look like for
an instance of this class
]]
type EnumCategoryPublicFields = {
	value: number,
	name: string,
}

--[[
Public methods (internal & external)

This interface describes what the API should look like
for an instance of this class. It also describes what 
methods should be defined at the class level, and what
their types should be.
]]
type EnumCategoryPublicMethods = {
	getItems: (self: EnumCategory) -> TABLE.ArrayOf<EnumItem.EnumItem>,
	getId: (self: EnumCategory) -> string,
}

--[[
Public interface

This interface describes what the entire interface should
look like for an instance of this class including the public
fields and the public methods.
]]
type EnumCategoryPublicInterface = EnumCategoryPublicFields & EnumCategoryPublicMethods & TABLE.Map<string, any>

--[[
Class

Create the class and assert that it follows the rules of the
static interface type, which describes what types the public
methods should be.
]]
local EnumCategory = {} :: EnumItemStaticInterface

--[[
Private static fields

These fields are defined at the class level and are hidden from
both the public and static interfaces. They are not accessible
in general from the class level unless specified in the class 
export object at the bottom of the module.

These fields are accessible at the instance level, but they
are hidden from the interface and their types are inferred
as `any`. Therefore, whenever accessing these fields, a type
assertion should always be used so that the type system knows
what they are.
]]
EnumCategory.__index = EnumCategory
EnumCategory._categoryCount = 0
EnumCategory._idMap = {}

--[[
Instance type

This type refers to the actual instance object that is created
upon instantiation.
]]
export type EnumCategory = typeof(setmetatable({} :: EnumCategoryPublicInterface, EnumCategory))

--[[
Public methods

These methods are available only to instances of this class.
Internally, they will be visible on the static class interface
of `EnumItemStaticInterface`, but they will not be visible on 
such interface after the class is exported.
]]
function EnumCategory:getItems()
	local enumItems: TABLE.Map<any, EnumItem.EnumItem> = self._items -- private
	return getValues(enumItems)
end

function EnumCategory:getId()
	local id = self._id :: string -- private
	return id
end

--[[
Public Static methods

These methods are constructor or utility functions available only
at the class level.
]]
local function new(name: string, _enumItems: TABLE.Map<any, EnumItem.EnumItem>?)
	local categoryCount = EnumCategory._categoryCount :: number -- private
	local idMap = EnumCategory._idMap :: TABLE.Map<string, EnumCategory> -- private
	local categoryId = getId("EnumCategory", name, categoryCount)

	-- Instance
	local self = setmetatable({} :: EnumCategoryPublicInterface, EnumCategory)

	-- Public
	self.value = categoryCount
	self.name = name

	-- Private
	self._items = _enumItems or {}
	self._id = categoryId

	idMap[categoryId] = self
	EnumCategory._categoryCount += 1
	return self
end

local function is(any: any): boolean
	return isTable(any) and getmetatable(any) == EnumCategory
end

local function serialize(enumCategory: EnumCategory)
	local id = enumCategory._id :: string -- private
	return id
end

local function deserialize(serialized: string): EnumCategory
	local idMap = EnumCategory._idMap :: TABLE.Map<string, EnumCategory> -- private
	return idMap[serialized]
end

return {
	new = new,
	is = is,
	serialize = serialize,
	deserialize = deserialize,
}
