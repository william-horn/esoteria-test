return function(state: any)
	if state.timesFired > 2 then
		return false, "Limit exceeded"
	end
end
