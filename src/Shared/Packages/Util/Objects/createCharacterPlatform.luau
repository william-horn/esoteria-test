--!strict

local createPart = require(script.Parent.createPart)

--[[
	Create a 10x10 platform part with the following default properties:

	```lua
	platform.Transparency = 0.5
	platform.BrickColor = BrickColor.Red()
	platform.Size = Vector3.new(10, 1, 10)
	platform.Parent = parent
	```
]]
local function createPlatform(parent: Instance?): Part
	local platform = createPart()
	platform.Transparency = 0.5
	platform.BrickColor = BrickColor.Red()
	platform.Size = Vector3.new(10, 1, 10)
	platform.Parent = parent

	return platform
end

return createPlatform
