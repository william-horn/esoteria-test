--!strict

--[[
	@author: William J. Horn
	@written: 12/15/2024

	Used for querying tables or comparing tables
]]

local Shared = game.ReplicatedStorage.Shared

local Table = require(Shared.Types.Table)

export type QueryOptions = {
	strictlyEquals: boolean?,
	usePatterns: boolean?,
	caseSensitive: boolean,
	shallowCheck: boolean?,
}

local bothAreTables = require(Shared.Packages.Util.Types.bothAreTables)
local isMatch = require(Shared.Packages.Util.isMatch)
local size = require(Shared.Packages.Table.size)

--[[
	options:
	strictlyEquals<boolean>: Whether or not "data" and "query" should be exactly equal in content
	default: nil

	usePatterns<boolean>: Whether or not string values will compare using patterns in the query table
	default: nil

	caseSensitive<boolean>: Whether or not string values will ignore case sensitivity
	default: true

	shallowCheck<boolean>: Whether or not the function will deeply check values. If true, only top-level
	entries will be checked.
]]
local function matchesQuery(data: Table.Any, query: Table.Any, _options: QueryOptions?): boolean
	local options = _options or {} :: QueryOptions
	local queue: Table.Array2D = { { data, query } }

	while #queue > 0 do
		local set: Table.AnyArray = queue[#queue]

		local dataDir: Table.Any, queryDir: Table.Any = set[1], set[2]
		queue[#queue] = nil

		-- for strict equals case, keep track of query size:
		local querySize: number = 0

		-- check if all values in queryDir equal the respective values in dataDir
		for queryKey: any, queryVal: any in next, queryDir do
			querySize += 1
			local dataVal: any = dataDir[queryKey]

			if dataVal == nil then
				return false
			end

			if bothAreTables(queryVal, dataVal) and not options.shallowCheck then
				queue[#queue + 1] = { dataVal, queryVal }
			elseif not isMatch(dataVal, queryVal, options) then
				return false
			end
		end

		-- compare to see if both directories are an exact match using table size
		if options.strictlyEquals and querySize ~= size(dataDir) then
			return false
		end
	end

	return true
end

return matchesQuery
