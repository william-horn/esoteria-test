--!strict

local Shared = game.ReplicatedStorage.Shared

local _Enums = require(script.Parent.Enums)
local deepScan = require(Shared.Packages.Table.deepScan)

export type EnumObject = {
	[NumberValue]: NumberValue,
}

export type EnumCategory = {
	[NumberValue]: EnumObject | EnumCategory,
}

local Enums: Enums = deepScan(_Enums, function(got: deepScan.EntrySettings)
	local enumObject = Instance.new("NumberValue")
	enumObject.Value = got.count
	enumObject.Name = got.key

	got.key = enumObject
end)

return Enums
