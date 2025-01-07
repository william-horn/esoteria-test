--!strict

local Shared = game:GetService("ReplicatedStorage").Shared

local TABLE = require(Shared.Types.Table)

--[[
	@desc: Returns an array of all keys in a table
	@args: <table> dict
	@returns: <array> keys
]]
local function keys(dict: TABLE.Any): TABLE.AnyArray
	local arr: TABLE.AnyArray = {}

	for k: any, _ in next, dict do
		arr[#arr + 1] = k
	end

	return arr
end

return keys
