local Shared = game:GetService("ReplicatedStorage").Shared
local NETWORK = require(Shared.Types.Network)

return function(headers: NETWORK.Headers, payload: NETWORK.Payload): ()
	print("Got request from player: ", headers.fromPlayer)
	print(payload)
end
