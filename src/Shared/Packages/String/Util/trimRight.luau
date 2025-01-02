--!strict

return function()
	--[[
		@desc: Removes whitespace from the right of a string
		@params: <string> str
		@returns: <string> trimmedStr
	]]
	local function trimRight(str: string): string
		str = str:gsub("%s+$", "")
		return str
	end

	return trimRight
end
