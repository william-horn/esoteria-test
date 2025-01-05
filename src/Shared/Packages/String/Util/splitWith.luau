--!strict

local splitPattern: string = "[^,]+"
local lastSplitDelim: string = ","

export type SplitOptions = {
	usePatterns: boolean,
}

local Shared = game:GetService("ReplicatedStorage").Shared

local Table = require(Shared.Types.Table)
local StringEscaper = require(Shared.Packages.String.Classes.StringEscaper)
local trimAround = require(script.Parent.trimAround)

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
local function splitWith(str: string, delim: string, _options: SplitOptions?): Table.StringArray
	local options: SplitOptions = _options or {} :: SplitOptions
	-- options.usePatterns<boolean>: default - nil

	if not options.usePatterns then
		delim = StringEscaper.escapeMagicChars(delim)
	end

	if delim ~= lastSplitDelim then
		splitPattern = "[^" .. delim .. "]+"
	end

	local t: Table.StringArray = {}

	for element: string in str:gmatch(splitPattern) do
		t[#t + 1] = trimAround(element)
	end

	return t
end

return splitWith
