--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local isModule = require(Shared.Packages.Util.Types.isModule)

local require = require

local function requireModules(modules: { Instance }, callback: (got: { key: any, value: any }) -> ()?)
	local package = {}

	for _, module: Instance in next, modules do
		local _isModule: boolean = isModule(module)

		if _isModule and callback then
			local got: { key: any, value: any } = {
				key = module.Name,
				value = module,
			}

			callback(got)
			package[got.key] = got.value
		elseif _isModule then
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
