--!strict

--[[
	@author: William
	@written: 12/15/2024
]]

local Shared = game.ReplicatedStorage.Shared

-- Types
local Table = require(Shared.Types.Table)
local Function = require(Shared.Types.Function)

export type EntrySettings = {
	key: any,
	value: any,
	count: number,
	treatAsValue: boolean,
	terminate: boolean,
	ignore: boolean,
	depth: number,
	currentTable: Table.Any,
}

-- Packages
local isFunction: Function.BooleanResult = require(Shared.Packages.Util.Types.isFunction)
local isTable: Function.BooleanResult = require(Shared.Packages.Util.Types.isTable)

--[[
	Create a tree-like hierarchy table of another nested table with a
	callback function of options. 
		
	Your callback argument does not need to return anything, instead, it 
	is passed a table of options that have been defined internally. You can
	modify these options to determine what should happen during the iteration.

	For example, this will ignore any value of "a" in the tree:

	```lua
		deepScan(t, function(got)
			if (got.value == "a") then
				got.ignore = true
			end
		end)
	```

	If you have not re-assigned the key or value, they will remain as they were.

	### Possible options:
	
	* got.terminate:
	If true, process the other options and break the loop

	* got.ignore:
	If true, don't include the current entry in the returned tree

	* got.treatAsValue:
	If true, value is implied to be a table, and the table reference will be added to the tree but not iterated over.

	* got.value:
	The value at the current iteration

	* got.key:
	The key at the current iteration

	### These are included as options but are intended as read-only:
	* got.depth:
	The depth of the cycle

	* got.currentTable:
	The current table in the cycle

	* got.count:
	The iteration cycle as a numeric counter value in the current table

	### Example of stopping table coping once past a certain depth:

	```lua
		deepScan(t, function(got)
			if (got.depth == 3) then
				got.terminate = true
				return 
			end
		end)
	```

	### Example of changing keys/values in table copy:

	```lua
		deepScan(t, function(got)
			got.key = tostring(got.key) .. " - modified"
			got.value = tostring(got.value) .. " - modified"
		end)
	```
]]
local function deepScan(t: Table.Any, callback: (got: EntrySettings) -> ()): Table.Any
	if callback and not isFunction(callback) then
		error("Callback passed to deepScan() must be nil or a function")
	end

	local tree: Table.Any = {}
	local queue: Table.Array2D = { { t, tree, 1 } }

	while #queue > 0 do
		local set: Table.AnyArray = queue[#queue]
		local dir: Table.Any, treeDir: Table.Any, depth: number = set[1], set[2], set[3]
		local count = 0

		queue[#queue] = nil

		for key: any, value: any in next, dir do
			local got: EntrySettings = {
				key = key,
				value = value,
				count = count,
				treatAsValue = false,
				terminate = false,
				ignore = false,
				depth = depth,
				currentTable = dir,
			}

			if callback then
				callback(got)
			end

			if got.ignore then
				continue
			end

			if isTable(got.value) and not got.treatAsValue then
				local newDir: Table.Any = {}
				treeDir[got.key] = newDir
				queue[#queue + 1] = { got.value, newDir, depth + 1 }
			else
				treeDir[got.key] = got.value
			end

			if got.terminate then
				break
			end

			count += 1
		end
	end

	return tree
end

return deepScan
