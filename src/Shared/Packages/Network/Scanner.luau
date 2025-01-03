--!strict

local NetworkScanner = {}

type Networks = {
	SharedNetwork: Folder,
	LocalNetwork: Folder,
}

type Channel = {}

type Protocol = {}

export type NetworkTree = {
	TCPEvent: {},
}

function NetworkScanner:createNetworkTree(networks: Networks): NetworkTree
	local networkTree = {} :: NetworkTree

	return networkTree
end

return NetworkScanner
