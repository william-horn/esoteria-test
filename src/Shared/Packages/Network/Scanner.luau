--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Packages = Shared.Packages
local Enums = require(Shared.Enums.index)
local NetworkEnums = Enums.Network

local UNRECOGNIZED_OBJECT_WARNING: string = 'Found unrecognized object "%s" in "%s"'
local NO_REQUEST_HANDLERS_WARNING: string = 'No request handlers found for channel "%s"'
local MISSING_FOLDER_WARNING: string = 'Could not find local folder "%s"'

local MISSING_REMOTE_ERROR: string = 'Missing Remote for channel "%s"'

local INVALID_CLASSNAME_ERROR = 'Invalid object class for "%s" (expected "%s", got "%s")'
local INVALID_ENUM_ERROR = '"%s" is not a valid enum'

local NETWORK = require(Shared.Types.Network)
local TABLE = require(Shared.Types.Table)

local isFolder = require(Packages.Util.Types.isFolder)
local isRemote = require(Packages.Util.Types.isRemote)
-- local isRemoteEvent = require(Packages.Util.Types.isRemoteEvent)
local isModule = require(Packages.Util.Types.isModule)
local getRemoteConnectionInfo = require(Packages.Network.getRemoteConnectionInfo)
local State = require(Packages.State.index)
local TableWithIndexError = require(Packages.Util.Classes.TableWithIndexError)
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
	local requests = {} :: NETWORK.Requests

	for _, requestFolder: Instance in next, requestsFolder:GetChildren() do
		if not isFolder(requestFolder) then
			warn(UNRECOGNIZED_OBJECT_WARNING:format(requestFolder.Name, requestsFolder:GetFullName()))
			continue
		end

		local requestData = TableWithIndexError.new({}, "Field", "RequestData") :: NETWORK.Request
		-- requestData.lastSent = { headers = {}, payload = nil }

		local handlerModule: Instance? = requestFolder:FindFirstChild("Handler")
		local settingsModule: Instance? = requestFolder:FindFirstChild("Settings")
		local stateModule: Instance? = requestFolder:FindFirstChild("State")
		local validatorModule: Instance? = requestFolder:FindFirstChild("Validator")
		local onDispatchModule: Instance? = requestFolder:FindFirstChild("OnDispatch")

		requestData.handler = requireModuleIfExists(handlerModule, nil)
		requestData.onDispatch = requireModuleIfExists(onDispatchModule, nil)
		requestData.settingsModule = requireModuleIfExists(settingsModule, {})
		requestData.state = State.new(requireModuleIfExists(stateModule, {}))

		if validatorModule and isModule(validatorModule) then
			requestData.state:addValidator(require(validatorModule))
		end

		requests[requestFolder.Name] = requestData
	end

	return requests
end

local function findFolderFrom(origin: Instance, enum: Enums.Enums, name: string): Instance?
	local folder: Instance? = origin:FindFirstChild(name)

	if not folder then
		warn(MISSING_FOLDER_WARNING:format(name))
		return nil
	elseif not isFolder(folder) then
		error(INVALID_CLASSNAME_ERROR:format(folder.Name, "Folder", folder.ClassName), 2)
		return nil
	elseif not Enums.is(enum[name]) then
		error(INVALID_ENUM_ERROR:format(name), 2)
	end

	return folder
end

function Scanner:createNetworkTree(networks: NETWORK.Both): NETWORK.Tree
	local networkTree = TableWithIndexError.new({}, "Protocol", "NetworkTree") :: NETWORK.Tree

	for _, sharedProtocolFolder: Instance in next, networks.SharedNetwork:GetChildren() do
		local localProtocolFolder: Instance? =
			findFolderFrom(networks.LocalNetwork, NetworkEnums.Protocol, sharedProtocolFolder.Name)

		if not localProtocolFolder then
			continue
		end

		local channels = TableWithIndexError.new({}, "Channel", "Protocol") :: NETWORK.Channels

		for _, sharedChannelFolder: Instance in next, sharedProtocolFolder:GetChildren() do
			local localChannelFolder: Instance? =
				findFolderFrom(localProtocolFolder, NetworkEnums.Channel, sharedChannelFolder.Name)

			if not localChannelFolder then
				continue
			end

			local channel = {} :: NETWORK.Channel
			-- channel.lastSent = { headers = {}, payload = nil }

			local remote: Instance? = sharedChannelFolder:FindFirstChild("Remote")

			-- Find the Remote instance for the channel
			if not (remote and isRemote(remote)) then
				error(MISSING_REMOTE_ERROR:format(sharedChannelFolder:GetFullName()), 2)
			else
				channel.remote = remote
			end

			local settingsModule: Instance? = localChannelFolder:FindFirstChild("Settings")
			local stateModule: Instance? = localChannelFolder:FindFirstChild("State")
			local validatorModule: Instance? = localChannelFolder:FindFirstChild("Validator")
			local requestsFolder: Instance? = localChannelFolder:FindFirstChild("Requests")
			local onDispatchModule: Instance? = localChannelFolder:FindFirstChild("OnDispatch")

			-- Get the settings for the channel
			channel.settings = requireModuleIfExists(settingsModule, {})

			-- Get OnDispatch callback if one exists
			channel.onDispatch = requireModuleIfExists(onDispatchModule, nil)

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
				channel.requests = compileRequestsTable(requestsFolder :: Folder)
			end

			-- Default channel validator
			channel.state:addValidator(function(scope: TABLE.StringKeys, state: any)
				-- Dependancy check
				local dependencies: TABLE.AnyArray? = scope.dependencies
				-- local request: Enums.Enums = scope.request
				local lastDependancies: TABLE.AnyArray? = state.dependencies

				if not dependencies then
					return true
				elseif lastDependancies and #lastDependancies == #dependencies then
					local sameValues: boolean = true
					-- print("both dependency tables exist and are same size")

					-- Shallow-check if both dependency arrays are equal in content
					for index: number = 1, #lastDependancies do
						if lastDependancies[index] ~= dependencies[index] then
							sameValues = false
							break
						end
					end

					-- if all dependencies are the same, then return out
					if sameValues then
						-- print(
						-- 	'Dependencies are the same for request "'
						-- 		.. tostring(request.name)
						-- 		.. '", aborting dispatch...'
						-- )
						return false, "Aborted dispatch due to unchanged dependancy array"
					end
				end

				return true
			end)

			channels[sharedChannelFolder.Name] = channel
		end

		networkTree[sharedProtocolFolder.Name] = {
			connectionInfo = getRemoteConnectionInfo(NetworkEnums.Protocol[sharedProtocolFolder.Name]),
			channels = channels,
		} :: NETWORK.Protocol
	end

	return networkTree
end

return Scanner
