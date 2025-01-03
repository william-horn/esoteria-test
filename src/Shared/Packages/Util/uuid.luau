--!strict

--[[
	Credit to jrus@github.com for UUID generation function
	source: https://gist.github.com/jrus/3197011
]]

local Shared = game.ReplicatedStorage.Shared
local newSeed = require(Shared.Packages.Math.newSeed)

newSeed()

local function uuid(): string
	local random = math.random
	local template: string = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"

	return string.gsub(template, "[xy]", function(c)
		local v = (c == "x") and random(0, 0xf) or random(8, 0xb)
		return string.format("%x", v)
	end)
end

return uuid
