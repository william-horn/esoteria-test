--!strict

local UNRECOGNIZED_OBJECT_WARNING = 'Found unrecognized object "%s" in "%s"'
local NO_REQUEST_HANDLERS_WARNING = 'No request handlers found for channel "%s"'
local MISSING_FOLDER_WARNING = 'Could not find local folder "%s"'

local MISSING_REMOTE_ERROR = 'Missing Remote for channel "%s"'

local INVALID_CLASSNAME_ERROR = 'Invalid object class for "%s" (expected "%s", got "%s")'
local INVALID_ENUM_ERROR = '"%s" is not a valid enum'

local MUTUALLY_EXLUSIVE_HEADERS_ERROR = 'Cannot pass mutually exlusive headers "%s" and "%s"'
local REQUEST_MISSING_HEADER_ERROR = 'Request "%s" is missing header "%s"'

local Shared = game:GetService("ReplicatedStorage").Shared
local Packages = Shared.Packages
local Enums = require(Shared.Enums.index)
local NetworkEnums = Enums.Network

local NETWORK = require(Shared.Types.Network)
local TABLE = require(Shared.Types.Table)

local isFolder = require(Packages.Util.Types.isFolder)
local isRemote = require(Packages.Util.Types.isRemote)
local isModule = require(Packages.Util.Types.isModule)
local requireModuleIfExists = require(Packages.Util.requireModuleIfExists)
local State = require(Packages.State.index)

local require = require
local Scanner = {}

local function compileRequestsTable(requestsFolder: Folder): NETWORK.Requests
	local requests = {}

	for _, requestFolder in next, requestsFolder:GetChildren() do
		if not isFolder(requestFolder) then
			warn(UNRECOGNIZED_OBJECT_WARNING:format(requestFolder.Name, requestsFolder:GetFullName()))
			continue
		end

		local requestData = {} :: NETWORK.Request
		-- requestData.lastSentPacket = { headers = {}, payload = nil }

		local handlerModule = requestFolder:FindFirstChild("Handler")
		local settingsModule = requestFolder:FindFirstChild("Settings")
		local stateModule = requestFolder:FindFirstChild("State")
		local validatorModule = requestFolder:FindFirstChild("Validator")
		local onDispatchModule = requestFolder:FindFirstChild("OnDispatch")

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

local function findFolderFrom(origin: Instance, enum: Enums.EnumItem, name: string): Instance?
	local folder = origin:FindFirstChild(name)

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

function Scanner:createNetworkTree(networks: NETWORK.Both)
	local networkTree = {} :: NETWORK.Tree

	for _, sharedProtocolFolder in next, networks.SharedNetwork:GetChildren() do
		local localProtocolFolder =
			findFolderFrom(networks.LocalNetwork, NetworkEnums.Protocol, sharedProtocolFolder.Name)

		if not localProtocolFolder then
			continue
		end

		local channels = {} :: NETWORK.Channels

		for _, sharedChannelFolder in next, sharedProtocolFolder:GetChildren() do
			local localChannelFolder =
				findFolderFrom(localProtocolFolder, NetworkEnums.Channel, sharedChannelFolder.Name)

			if not localChannelFolder then
				continue
			end

			local channel = {} :: NETWORK.Channel
			-- channel.lastSentPacket = { headers = {}, payload = nil }

			local remote = sharedChannelFolder:FindFirstChild("Remote")

			-- Find the Remote instance for the channel
			if not (remote and isRemote(remote)) then
				error(MISSING_REMOTE_ERROR:format(sharedChannelFolder:GetFullName()), 2)
			else
				channel.remote = remote :: NETWORK.AnyRemote
			end

			local settingsModule = localChannelFolder:FindFirstChild("Settings")
			local stateModule = localChannelFolder:FindFirstChild("State")
			local validatorModule = localChannelFolder:FindFirstChild("Validator")
			local requestsFolder = localChannelFolder:FindFirstChild("Requests")
			local onDispatchModule = localChannelFolder:FindFirstChild("OnDispatch")

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
			channel.state:addValidator(function(scope: TABLE.Map<string, any>, state: any)
				-- Dependancy check
				local dependencies: TABLE.ArrayOf<any>? = scope.dependencies
				local request: Enums.EnumItem = scope.request
				local lastDependancies: TABLE.ArrayOf<any>? = state.dependencies
				local headers: NETWORK.Headers = scope.headers

				-- Validate headers
				if headers.sendAll and headers.toPlayers then
					return false, MUTUALLY_EXLUSIVE_HEADERS_ERROR:format("sendAll", "toPlayers")
				elseif not headers.sendAll and not headers.toPlayers then
					return false, REQUEST_MISSING_HEADER_ERROR:format(request.name, "toPlayers")
				end

				-- Validate dependancy array
				if not dependencies then
					return true
				elseif lastDependancies and #lastDependancies == #dependencies then
					local sameValues = true
					-- print("both dependency tables exist and are same size")

					-- Shallow-check if both dependency arrays are equal in content
					for index = 1, #lastDependancies do
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
			channels = channels,
		} :: NETWORK.Protocol
	end

	return networkTree
end

return Scanner
