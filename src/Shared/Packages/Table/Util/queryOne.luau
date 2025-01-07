--!strict

local Shared = game:GetService("ReplicatedStorage").Shared

local TABLE = require(Shared.Types.Table)
local matchesQuery = require(Shared.Packages.Table.Util.matchesQuery)

local function queryOne(array: TABLE.ObjectArray, query: TABLE.Any, options: TABLE.StringKey): TABLE.Any?
	for _, item: TABLE.Any in ipairs(array) do
		if matchesQuery(item, query, options) then
			return item
		end
	end

	return nil
end

return queryOne
