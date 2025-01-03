--!strict

export type EnumItem = {
	[number]: string | EnumCategory,
}

export type EnumCategory = {
	Category: string,
	Items: EnumItem,
}

local Enums = {} :: {
	[number]: EnumCategory,
}

--[[
	local Enums = {
		{
			Category = "Foo",
			Items = {
				"Foo1",
				"Foo2",
				"Foo3"
			}
		},

		{
			Category = "Bar",
			Items = {
				"Bar1",
				"Bar2",
				"Bar3",
				{
					Category = "Foobar",
					Items = {
						"Foobar1",
						"Foobar2",
						"Foobar3"
					}
				}
			}
		},
	}
]]

table.insert(Enums, {
	Category = "MachineType",
	Items = {
		"Client",
		"Server",
		"Studio",
		"All",
	},
})

table.insert(Enums, {
	Category = "Player",
	Items = {
		{
			Category = "Classification",
			Items = {
				"Class1",
				"Class2",
				"Class3",
				"Class4",
				"Class5",
			},
		},
	},
})

return Enums
