--!strict

local Shared = game:GetService("ReplicatedStorage").Shared

local Table = require(Shared.Types.Table)
local matchesQuery = require(Shared.Packages.Table.Util.matchesQuery)

local function queryOne(array: Table.ObjectArray, query: Table.Any, options: Table.StringKey): Table.Any?
	for _, item: Table.Any in ipairs(array) do
		if matchesQuery(item, query, options) then
			return item
		end
	end

	return nil
end

return queryOne
