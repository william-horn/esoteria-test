--!strict

return function()
	local trimLeft: (string) -> string = require(script.Parent.trimLeft)()
	local trimRight: (string) -> string = require(script.Parent.trimRight)()

	--[[
		@desc: Removes whitespace from the left and right of a string
		@params: <string> str
		@returns: <string> trimmedStr
	]]
	local function trimAround(str: string): string
		return trimLeft(trimRight(str))
	end

	return trimAround
end
