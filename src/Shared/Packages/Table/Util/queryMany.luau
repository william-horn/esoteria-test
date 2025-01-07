--!strict

local Shared = game:GetService("ReplicatedStorage").Shared

local TABLE = require(Shared.Types.Table)
local matchesQuery = require(Shared.Packages.Table.Util.matchesQuery)

local function queryMany(array: TABLE.ObjectArray, query: TABLE.Any, options: TABLE.StringKey): TABLE.ObjectArray
	local matches: TABLE.ObjectArray = {}

	for _, item: TABLE.Any in ipairs(array) do
		if matchesQuery(item, query, options) then
			table.insert(matches, item)
		end
	end

	return matches
end

return queryMany
