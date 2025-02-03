--[[
	@desc: 
		Returns a value's percentage from min to max
		
		Example: getPercentFrom(1, 10, 7) -> 0.7
]]
local function getPercentFrom(min: number, max: number, value: number)
	return (value - min) / (max - min)
end

return getPercentFrom
