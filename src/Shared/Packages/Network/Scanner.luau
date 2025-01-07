--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Packages = Shared.Packages
local Enums = require(Shared.Enums.index)
local NetworkEnums = Enums.Network

local UNRECOGNIZED_OBJECT_WARNING = 'Found unrecognized object "%s" in "%s"'
local NO_REQUEST_HANDLERS_WARNING = 'No request handlers found for channel "%s"'
local MISSING_REMOTE_ERROR = 'Missing Remote for channel "%s"'

-- local TABLE = require(Shared.Types.Table)
local NETWORK = require(Shared.Types.Network)

local isFolder = require(Packages.Util.Types.isFolder)
local isRemote = require(Packages.Util.Types.isRemote)
local isModule = require(Packages.Util.Types.isModule)
local getRemoteInfo = require(Packages.Network.getRemoteInfo)
local State = require(Packages.State.index)
-- local ValidationStatus = require(Packages.Util.Classes.ValidationStatus)

local require = require

local Scanner = {}

local function requireModuleIfExists(module: Instance?, default: any): any
	if not (module and isModule(module)) then
		return default
	end

	return require(module)
end

local function compileRequestsTable(requestsFolder: Folder): NETWORK.Requests
	local requests: NETWORK.Requests = {}

	for _, requestFolder: Instance in next, requestsFolder:GetChildren() do
		if not isFolder(requestFolder) then
			warn(UNRECOGNIZED_OBJECT_WARNING:format(requestFolder.Name, requestsFolder:GetFullName()))
			continue
		end

		local requestData = {} :: NETWORK.Request
	end

	return requests
end

local function findFolderFrom(origin: Instance, enum: Enums.Enums, name: string): Instance?
	local folder: Instance? = origin:FindFirstChild(name)

	if not folder then
		warn('Could not find local folder "' .. name .. '"')
		return nil
	elseif not isFolder(folder) then
		warn('Local folder is not a Folder (got "' .. folder.ClassName .. '")')
		return nil
	elseif not enum:FindFirstChild(name) then
		error("Not a valid Enum")
	end

	return folder
end

function Scanner:createNetworkTree(networks: NETWORK.Both): NETWORK.Tree
	local networkTree = {} :: NETWORK.Tree

	for _, sharedProtocolFolder: Instance in next, networks.SharedNetwork:GetChildren() do
		local localProtocolFolder: Instance? =
			findFolderFrom(networks.LocalNetwork, NetworkEnums.Protocol, sharedProtocolFolder.Name)

		if not localProtocolFolder then
			continue
		end

		local channels: NETWORK.Channels = {}

		for _, sharedChannelFolder: Instance in next, sharedProtocolFolder:GetChildren() do
			local localChannelFolder: Instance? =
				findFolderFrom(localProtocolFolder, NetworkEnums.Channel, sharedChannelFolder.Name)

			if not localChannelFolder then
				continue
			end

			local channel = {} :: NETWORK.Channel

			local remote: Instance? = sharedChannelFolder:FindFirstChild("Remote")
			local settingsModule: Instance? = localChannelFolder:FindFirstChild("Settings")
			local stateModule: Instance? = localChannelFolder:FindFirstChild("State")
			local validatorModule: Instance? = localChannelFolder:FindFirstChild("Validator")
			local requestsFolder: Instance? = localChannelFolder:FindFirstChild("Requests")

			-- Find the Remote instance for the channel
			if not (remote and isRemote(remote)) then
				error(MISSING_REMOTE_ERROR:format(sharedChannelFolder:GetFullName()))
			else
				channel.remote = remote
			end

			-- Get the settings for the channel
			channel.settings = requireModuleIfExists(settingsModule, {})

			-- Get the state for the channel
			channel.state = State.new(requireModuleIfExists(stateModule, {}))

			-- Get the validator function for the channel
			if validatorModule and isModule(validatorModule) then
				channel.state:addValidator(require(validatorModule))
			end

			-- Get the requests table for the channel
			if not (requestsFolder and isFolder(requestsFolder)) then
				warn(NO_REQUEST_HANDLERS_WARNING:format(sharedChannelFolder:GetFullName()))
				channel.requests = {}
			else
				channel.requests = compileRequestsTable(requestsFolder)
			end

			channels[sharedChannelFolder.Name] = channel
		end

		networkTree[sharedProtocolFolder.Name] = {
			remoteInfo = getRemoteInfo(NetworkEnums.Protocol[sharedProtocolFolder.Name]),
			channels = channels,
		}
	end

	return networkTree
end

return Scanner
