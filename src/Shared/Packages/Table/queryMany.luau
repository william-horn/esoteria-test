--!strict

local Shared = game.ReplicatedStorage.Shared

local Table = require(Shared.Types.Table)
local matchesQuery = require(Shared.Packages.Table.matchesQuery)

local function queryMany(array: Table.ObjectArray, query: Table.Any, options: Table.StringKey): Table.ObjectArray
	local matches: Table.ObjectArray = {}

	for _, item: Table.Any in ipairs(array) do
		if matchesQuery(item, query, options) then
			table.insert(matches, item)
		end
	end

	return matches
end

return queryMany
