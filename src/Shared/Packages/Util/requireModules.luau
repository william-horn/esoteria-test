--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local isModule = require(Shared.Packages.Util.Types.isModule)

local require = require

type RequiredModules = { [string]: any }

local function requireModules(modules: { Instance }): RequiredModules
	local package: RequiredModules = {}

	for _, module: Instance in next, modules do
		if isModule(module) then
			package[module.Name] = require(module)
		else
			warn(
				'Could not require module "'
					.. module.Name
					.. '" using requireModules() (Instance is not a ModuleScript)'
			)
		end
	end

	return package
end

return requireModules
