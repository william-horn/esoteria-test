--!strict

--[[
	@desc:
		Generate a unique number given two other numbers using
		the Szudzik's pairing function.

	@param a: The first number
	@param b: The second number

	@returns: A unique number from the two parameters
]]
local function uniquePair(a: number, b: number)
	return a > b and a * a + a + b or b * b + a
end

return uniquePair
