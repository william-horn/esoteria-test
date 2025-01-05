--!strict

--[[
	@desc: Returns the quantity of entries in a table
	@args: <table> dict
	@returns: <number> size
]]
local function size(dict): number
	local count: number = 0

	for _, _ in next, dict do
		count = count + 1
	end

	return count
end

return size
