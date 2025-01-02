--!strict

local SKY_HEIGHT: number = 100
local GROUND_OFFSET: number = 20

local COLLISION_CHECK_INTERVAL: number = 0.1

local INTENSITY: number = 0.5

local MIN_SPEED: number = 35
local MAX_SPEED: number = 75

local RunService: RunService = game:GetService("RunService")
local Players: Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer :: Player
local PlayerCamera: Camera = workspace.CurrentCamera
local PlayerCharacter: Model = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local cloud: Model = workspace:WaitForChild("Cloud2")

local function lerp(a: number, b: number, d: number): number
	return a + (b - a) * d
end

local SPEED: number = lerp(MIN_SPEED, MAX_SPEED, INTENSITY)

type RenderElapsed = {
	[string]: number,
}

type RaindropProperties = {
	[string]: any,
}

local normal = {
	Transparency = NumberSequence.new(0.8),
	Speed = NumberRange.new(45, 55),
	Lifetime = NumberRange.new((SKY_HEIGHT + GROUND_OFFSET) / SPEED),
}

local collided = {
	Transparency = NumberSequence.new(1),
}

local function updateRainPosition(_, _): ()
	local PlayerHead: Part? = PlayerCharacter:FindFirstChild("Head") :: Part

	if not PlayerHead then
		return
	end

	-- cloud:PivotTo(CFrame.new(PlayerHead.Position + Vector3.new(0, 50, 0)) * cloud:GetPivot().Rotation)
	cloud:PivotTo(CFrame.new(PlayerCamera.CFrame.Position + Vector3.new(0, SKY_HEIGHT, 0)) * cloud:GetPivot().Rotation)
end

local function rainStep(elapsed: RenderElapsed, _): ()
	if elapsed.rainStep < COLLISION_CHECK_INTERVAL then
		return
	end

	elapsed.rainStep = 0

	local RainParts: Folder? = cloud:FindFirstChild("RainParts") :: Folder
	local PlayerHead: Part? = PlayerCharacter:FindFirstChild("Head") :: Part

	if not (RainParts and PlayerHead) then
		return
	end

	for _, rainPart: Instance in next, RainParts:GetChildren() do
		if not rainPart:IsA("Part") then
			continue
		end

		local raycastResult: RaycastResult = workspace:Raycast(rainPart.Position, Vector3.new(0, -SKY_HEIGHT, 0))
		local pm: ParticleEmitter? = rainPart:FindFirstChild("ParticleEmitter") :: ParticleEmitter

		if not pm or not pm:IsA("ParticleEmitter") then
			continue
		end

		-- if raycastResult and raycastResult.Position.Y > PlayerHead.Position.Y then
		if raycastResult and raycastResult.Position.Y > PlayerCamera.CFrame.Position.Y then
			rainPart.BrickColor = BrickColor.new("Bright blue")

			-- pm.Enabled = false
			pm.Transparency = collided.Transparency
		else
			rainPart.BrickColor = BrickColor.new("Medium stone grey")

			-- pm.Enabled = true
			pm.Transparency = normal.Transparency
			pm.Lifetime = normal.Lifetime
		end
	end
end

do
	local elasped: RenderElapsed = {
		rainStep = 0,
		updateRainPosition = 0,
	}

	RunService:BindToRenderStep("Rain", Enum.RenderPriority.Character.Value, function(step: number)
		updateRainPosition(elasped, step)
		rainStep(elasped, step)

		for key: string in next, elasped do
			elasped[key] += step
		end
	end)
end
