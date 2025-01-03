--!strict

local Shared = game.ReplicatedStorage.Shared

local bothAreStrings = require(Shared.Packages.Util.Types.bothAreStrings)

export type MatchOptions = {
	caseSensitive: boolean?,
	usePatterns: boolean?,
}

--[[
	@desc: Determine if a and b match, according to the options table.
	@param a <string>
	@param b <string>
	@param options <Table>
		caseSensitive - (default: true) whether case sensitivity is used in the comparison (true = yes)
		usePatterns - (default: false) whether pattern matching is enabled (true = yes)
		
	@returns: validMatch <boolean>
]]
local function isMatch(a: any, b: any, _options: MatchOptions?): boolean
	local options: MatchOptions = _options or {} :: MatchOptions

	if options.caseSensitive == nil then
		options.caseSensitive = true
	end

	if options.usePatterns == nil then
		options.usePatterns = false
	end

	if not bothAreStrings(a, b) then
		return a == b
	end

	if options.caseSensitive then
		a = a:lower()
		b = b:lower()
	end

	if not options.usePatterns then
		return a == b
	end

	return a:match(b) ~= nil
end

return isMatch
