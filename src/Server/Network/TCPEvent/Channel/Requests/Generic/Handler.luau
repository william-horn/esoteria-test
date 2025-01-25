local Shared = game:GetService("ReplicatedStorage").Shared
local NETWORK = require(Shared.Types.Network)

return function(packet: NETWORK.Packet): ()
	print("Got request from player: ", packet.headers.fromPlayer)
	print(packet.payload)
end
