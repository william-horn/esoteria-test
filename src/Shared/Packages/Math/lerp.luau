--!strict

--[[
	@desc:
		Linearly interpolate between values `a` and `b`, given some
		alpha value `p` between 0 and 1
	
	@param a: The starting value
	@param b: The final value
	@param p: The progress from `a` to `b` between 0 and 1

	@returns: The interpolated value between `a` and `b`
]]
local function lerp(a: number, b: number, p: number)
	return a + (b - a) * p
end

return lerp
