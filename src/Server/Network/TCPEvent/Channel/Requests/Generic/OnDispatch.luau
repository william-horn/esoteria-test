--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Packages = Shared.Packages

local NETWORK = require(Shared.Types.Network)
local ValidationStatus = require(Packages.Util.Classes.ValidationStatus)

return function(
	requestData: NETWORK.Request,
	success: boolean,
	validationReport: ValidationStatus.Array,
	headers: NETWORK.Headers,
	payload: NETWORK.Payload
): ()
	if not success then
		-- print(" REQUEST Dispatch failed")
		return
	end

	requestData.state:update({
		timesFired = function(prev: number)
			return prev + 1
		end,
	})

	-- print("REQUEST Dispatched successully")
end
