--!strict

local Shared = game:GetService("ReplicatedStorage").Shared

local TABLE = require(Shared.Types.Table)

--[[
	@desc: Returns an array of all values in a table
	@args: <table> dict
	@returns: <array> values
]]
local function values(dict: TABLE.Map<any, any>): TABLE.ArrayOf<any>
	local arr = {}

	for _, v: any in next, dict do
		arr[#arr + 1] = v
	end

	return arr
end

return values
