--!strict

local splitPattern: string = "[^,]+"
local lastSplitDelim: string = ","

export type SplitOptions = {
	usePatterns: boolean,
}

return function(import)
	local StringEscaper = import("@String/@Classes/StringEscaper")
	local trimAround: (string) -> string = require(script.Parent.trimAround)()

	--[[
		String:splitWith(str<string>, delim<string>, options<table>):

		@desc:
			Splits a string by a delimiter and returns a table of the split values
		@params:
			str<string>: The string to split
			delim<string>: The delimiter to split by
			options<table>: (optional) A table of options
		@returns: <table> splitStr
	]]
	local function splitWith(str: string, delim: string, _options: SplitOptions?): { string }
		local options: SplitOptions = _options or {} :: SplitOptions
		-- options.usePatterns<boolean>: default - nil

		if not options.usePatterns then
			delim = StringEscaper.escapeMagicChars(delim)
		end

		if delim ~= lastSplitDelim then
			splitPattern = "[^" .. delim .. "]+"
		end

		local t: { string } = {}

		for element: string in str:gmatch(splitPattern) do
			t[#t + 1] = trimAround(element)
		end

		return t
	end

	return splitWith
end
