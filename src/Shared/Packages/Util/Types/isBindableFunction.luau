--!strict

-- Returns true if an Instance is a BindableFunction
local function isBindableFunction(v: Instance): boolean
	return v:IsA("BindableFunction")
end

return isBindableFunction
