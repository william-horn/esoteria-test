--!strict

return function()
	local function getVacantIndex(t: {})
		for i: number = 1, #t do
			if t[i] == nil then
				return i
			end
		end

		return #t + 1
	end

	return getVacantIndex
end
