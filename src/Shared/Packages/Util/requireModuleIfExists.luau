local Shared = game:GetService("ReplicatedStorage").Shared
local isModule = require(Shared.Packages.Util.Types.isModule)

local require = require

local function requireModuleIfExists(module: Instance?, default: any)
	if not (module and isModule(module)) then
		return default
	end

	return require(module)
end

return requireModuleIfExists
