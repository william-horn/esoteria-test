--!strict

--[[
	@desc:
		Create a new random seed using `os.clock()`
]]
local function newSeed()
	math.randomseed(os.clock())
end

return newSeed
