--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Packages = Shared.Packages

local NETWORK = require(Shared.Types.Network)
local ValidationStatus = require(Packages.Util.Classes.ValidationStatus)

return function(
	channelData: NETWORK.Channel,
	success: boolean,
	validationReport: ValidationStatus.Array,
	headers: NETWORK.Headers,
	payload: NETWORK.Payload
): ()
	if not success then
		-- print("CHANNEL Dispatch failed")
		return
	end

	channelData.state:update({
		timesFired = function(prev: number)
			return prev + 1
		end,
	})

	-- print("CHANNEL Dispatched successully")
end
