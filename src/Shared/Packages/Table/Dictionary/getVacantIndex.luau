--!strict

local function getVacantIndex(t): number
	for i: number = 1, #t do
		if t[i] == nil then
			return i
		end
	end

	return #t + 1
end

return getVacantIndex
