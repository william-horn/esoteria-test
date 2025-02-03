--!strict

--[[
	@author: William J. Horn
	@written: 12/9/2024

	Lets you create custom escape characters.

	Create an escape ruleset by instantiating the StringEscaper:

		local Escaper = StringEscaper.new("/", {"!", "$"})
		local source = "hello/! world/$"

	To escape:

		local escaped = Escaper:escape(source) --> "hello\11\1 world\12\1"

	To unescape:

		local unescaped = Escaper:unescape(escaped) --> "hello world"

	! bug:
		Escaped strings will be effected by your parser if your parser is looking
		for the following kind of matches:
			- "\1" - anywhere
			- "%d" - specifically by itself, and with any quantifier

		However, this can be worked around by checking for a "\1" match
		in your parser. For example, consider this case:

			local string = StringEscaper:escape("match 10 all/,numbers 20")

		If we want to match all numbers while escaping "," by using "/", then we will
		run into a weird logic error because "/," will be converted to "\11\1" when escaped.

			Ex:

				for match in string:gmatch("%d+") do
					print("found number: ", match)
				end

			--> "found number: 10"
			--> "found number: 1" (from escaped substitution)
			--> "found number: 20"

		TODO: potentially add future options for "freezing" a string once escaped, then
		storing it's unescaped and escaped versions with a unique id to retrieve later.

			Ex:
				"hello /$world test": give this to the parser --> "hello world test"

				save: [id] = "hello /$world test"

				unescape --> "hello $world test"
]]

local Shared = game:GetService("ReplicatedStorage").Shared

local TABLE = require(Shared.Types.Table)

local isNumber = require(Shared.Packages.Util.Types.isNumber)
local isTable = require(Shared.Packages.Util.Types.isTable)
local getVacantIndex = require(Shared.Packages.Table.Dictionary.getVacantIndex)

-- local StringEscaper, _StringEscaper = withDotMethod()
local StringEscaper = {}
StringEscaper.__index = StringEscaper

-- Types
type EscapeData = {
	encoded: string,
	text: string,
	noMagicText: string,
	escapePattern: string,
}

type EscapeDataMap = {
	[number]: EscapeData,
}

type StringIdMap = {
	[string]: number,
}

type StringEscaperFields = {
	_stringToId: { [string]: number },
	_escaped: EscapeDataMap,
	prefix: string,
}

export type StringEscaper = typeof(setmetatable({} :: StringEscaperFields, StringEscaper))

--[[
	StringEscaper:escape(text<string>):
	
	@desc:
		Escapes the text using the escape characters defined
		in the object's instantiation.
	@params:
		text<string>: the text to escape
	@returns:
		<string>: the escaped text
]]
function StringEscaper:escape(text: string)
	for _, stringData: EscapeData in next, self._escaped do
		text = text:gsub(stringData.escapePattern, stringData.encoded)
	end

	return text
end

--[[
	StringEscaper:unescape(text<string>):
	
	@desc:
		Unescapes the text using the escape characters defined
		in the object's instantiation.
	@params:
		text<string>: the text to unescape
	@returns:
		<string>: the unescaped text
]]
function StringEscaper:unescape(text: string)
	for _, stringData: EscapeData in next, self._escaped do
		text = text:gsub(stringData.encoded, stringData.text)
	end

	return text
end

--[[
	StringEscaper:add(text<string>):
	
	@desc:
		Add a new string to the StringEscaper object.
	@params:
		text<string>: the text to add
	@returns:
		<number>: the id of the added text
]]
function StringEscaper:add(text: string): number?
	local stringData: EscapeDataMap = self._escaped
	local stringToId: StringIdMap = self._stringToId

	-- if added text already exists, then return out
	if stringToId[text] then
		return nil
	end

	local id = getVacantIndex(stringData)
	local noMagicText = StringEscaper.escapeMagicChars(text)

	stringData[id] = {
		encoded = "\1" .. id .. "\1",
		text = text,
		noMagicText = noMagicText,
		escapePattern = self.prefix .. "(" .. noMagicText .. ")",
	}

	stringToId[text] = id
	return id
end

--[[
	StringEscaper:remove(text<string|number>):
	
	@desc:
		Removes the string from the StringEscaper object.
	@params:
		text<string|number>: the text or id to remove
	@returns:
		<nil>
]]
function StringEscaper:remove(text: string | number)
	local stringData: EscapeDataMap = self._escaped
	local stringToId: StringIdMap = self._stringToId

	local id: number? = isNumber(text) and text :: number or stringToId[text :: string]

	-- ! error:
	-- If the id does not exist. This can happen if the user manually passes an
	-- invalid id number as the text argument
	if not id then
		error('Invalid id passed to StringEscaper.remove(): Got "' .. tostring(id) .. '"')
	end

	stringData[id] = nil
	stringToId[text :: string] = nil
end

--[[
	StringEscaper.is(v<any>):

	Returns true if a value is a StringEscaper instance
]]
function StringEscaper.is(v: any)
	return isTable(v) and getmetatable(v) == StringEscaper
end

--[[
	StringEscaper.escapeMagicChars(text<string>):
	
	@desc:
		Escapes the magic characters in the text.
	@params:
		text<string>: the text to escape
	@returns:
		<string>: the escaped text
]]
function StringEscaper.escapeMagicChars(text: string)
	text = text:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")
	return text
end

--[[
	StringEscaper.new(prefix<string>, escapedString<table>):
	
	@desc:
		Creates a new StringEscaper object.
	@params:
		prefix<string>: the prefix to use for escaping
		escapedString<table>: the strings to escape
	@returns:
		<StringEscaper>: the StringEscaper object
]]
function StringEscaper.new(prefix: string, _escaped: TABLE.ArrayOf<string>?)
	local escaped: TABLE.ArrayOf<string> = table.clone(_escaped or {}) :: TABLE.ArrayOf<string>

	local self = setmetatable({}, StringEscaper) :: StringEscaper

	--[[
		dict that maps encoded/decoded string segments
		
		escaped: {
			[id] = {
				encoded<string> - the encoded escaped string,
				text<string> - the original string to escape,
				noMagicText<string> - original string but escaping magic characters,
				escapePattern<string> - the pattern to use for finding the escaped string
			},
			...
		}
		
		_stringToId: {
			[text<string>] = id<number>
		}
	]]
	self._stringToId = {}
	self._escaped = {}
	self.prefix = prefix

	for index: number = 1, #escaped do
		self:add(escaped[index])
	end

	-- include the escape prefix in with the strings to escape
	self:add(prefix)
	return self
end

return {
	new = StringEscaper.new,
	escapeMagicChars = StringEscaper.escapeMagicChars,
	is = StringEscaper.is,
}
