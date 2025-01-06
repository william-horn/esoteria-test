--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Packages = Shared.Packages
local Enums = Shared.Enums
local NetworkEnums = Enums.Network

local Table = require(Shared.Types.Table)
local Custom = require(Shared.Types.Custom)
local NetworkType = require(Packages.Network.Types)

local isFolder = require(Packages.Util.Types.isFolder)
local isRemote = require(Packages.Util.Types.isRemote)
local isModule = require(Packages.Util.Types.isModule)
local requireModules = require(Packages.Util.requireModules)
local getRemoteInfo = require(Packages.Network.getRemoteInfo)
local State = require(Packages.State.index)

local require = require

local Scanner = {}

local function findFolderFrom(origin: Instance, enum: Custom.EnumItem, name: string): Instance?
	if not isFolder(origin) then
		error('Network tree failed: "' .. origin:GetFullName() .. '" is not a Folder')
	elseif not enum:FindFirstChild(name) then
		error('Network tree failed: "' .. name .. '" is not a valid ' .. enum.Name .. " enum")
	end

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

function Scanner:createNetworkTree(networks: NetworkType.Group): NetworkType.Tree
	local networkTree = {} :: NetworkType.Tree

	for _, sharedProtocolFolder: Instance in next, networks.SharedNetwork:GetChildren() do
		local localProtocolFolder: Instance? =
			findFolderFrom(networks.LocalNetwork, NetworkEnums.Protocol, sharedProtocolFolder.Name)

		if not localProtocolFolder then
			continue
		end

		local channels: NetworkType.Channels = {}

		for _, sharedChannelFolder: Instance in next, sharedProtocolFolder:GetChildren() do
			local localChannelFolder: Instance? =
				findFolderFrom(localProtocolFolder, NetworkEnums.Channel, sharedChannelFolder.Name)

			if not localChannelFolder then
				continue
			end

			local remote: Instance? = sharedChannelFolder:FindFirstChild("Remote")
			local settingsModule: Instance? = localChannelFolder:FindFirstChild("Settings")
			local requestHandlersFolder: Instance? = localChannelFolder:FindFirstChild("RequestHandlers")

			local settings: Table.Any
			local requestHandlers: NetworkType.RequestHandlers

			if not (remote and isRemote(remote)) then
				error('Channel "' .. sharedChannelFolder:GetFullName() .. '" is missing a Remote')
			end

			if not (settingsModule and isModule(settingsModule)) then
				settings = {}
			else
				settings = require(settingsModule)
			end

			if not (requestHandlersFolder and isFolder(requestHandlersFolder)) then
				warn('Channel "' .. sharedChannelFolder:GetFullName() .. '" has no RequestHandlers')
				requestHandlers = {}
			else
				requestHandlers = requireModules(
					requestHandlersFolder:GetChildren(),
					function(got: { key: any, value: any })
						local requestData: NetworkType.Request = {
							process = require(got.value),
							lastSent = nil,
						}

						got.value = requestData
					end
				)
			end

			local channel = {} :: NetworkType.Channel
			channel.remote = remote :: NetworkType.Remote
			channel.settings = State.new(settings)
			channel.requestHandlers = requestHandlers

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
