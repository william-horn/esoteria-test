--!strict

local createPart = require(script.Parent.createPart)

--[[
	Create a ball with the following default properties:

	```lua
	part.Shape = Enum.PartType.Ball
	part.BrickColor = BrickColor.Blue()
	part.Size = Vector3.new(1, 1, 1)
	part.Transparency = 0.5
	part.Parent = parent
	```
]]
local function createBall(parent: Instance?): Part
	local part = createPart()
	part.Shape = Enum.PartType.Ball
	part.BrickColor = BrickColor.Blue()
	part.Size = Vector3.new(1, 1, 1)
	part.Transparency = 0.5
	part.Parent = parent

	return part
end

return createBall
