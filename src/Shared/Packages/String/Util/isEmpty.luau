--!strict

local noSpace = require(script.Parent.noSpace)

--[[
	@desc: Checks if a string is empty or not
	@params: <string> str, <boolean> countSpaceCharAsEmpty (whether to count space chars as empty)
	@returns: <boolean> isEmpty
]]
local function isEmpty(str: string, countSpaceCharAsEmpty: boolean)
	return countSpaceCharAsEmpty and (noSpace(str) == "") or (str == "")
end

return isEmpty
