--!strict

local Shared = game:GetService("ReplicatedStorage").Shared

local TABLE = require(Shared.Types.Table)

--[[
	local dict1 = { x = 1, y = 2 }
	local dict2 = { y = 3, z = 5 }
	local dict3 = { x = 8, z = 3, a = 1 }
	
	mergeDicts({dict1, dict2, dict3}) -> { x = 1, y = 2, z = 5, a = 1}
	mergeDicts({dict1, dict2, dict3}, true) -> { x = 8, y = 3, z = 3, a = 1}
]]
local function mergeAll(dicts: TABLE.ObjectArray, overwrite: boolean): TABLE.Any
	local dic: TABLE.Any = {}

	for i: number = 1, #dicts do
		local obj: TABLE.Any = dicts[i]

		for k: any, v: any in next, obj do
			-- lol
			if (not dic[k]) or overwrite then
				dic[k] = v
			end
		end
	end

	return dic
end

return mergeAll
