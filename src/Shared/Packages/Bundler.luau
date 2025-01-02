--!strict
--[[
	@author: William J. Horn
	@written: 1/2/2025

	ScriptGuider@ROBLOX.com
	
	A super light-weight package bundler for handling global dependency imports. This
	module mimmicks a weak version of CommonJS modules.

	# Micro-optimizations if needed:
		- Remove error checking if statements
		- Replace type-checking functions with relational operations like "=="
		- Replace generic for loops with numeric for loops
	
	TODO: Fix issue with cache not working for different path variations, i.e "../A" and "A"
	TODO: Add warning if multiple instance names exist in a directory
	TODO: When Commands module is finished, create import commands such as "$nocache" or "$benchmark"
	TODO: When commands are added, create a "$ignore _" command to ignore certain file name imports such as starting with an underscore

	# New version changes:
		? cannot path through modules
		? ./ will imply directory script is in

	import("@/Util/math") -- start from currently set directory

	import("./Child/Child2") -- imply script directory

	import("@/Util") -- will look for a module called "index"

	import("@/Util/func1") -- will look for "Util.func1"

	import("@/Util", "func1")

	import("../Util/Math") -- implied current directory, but up one level

	import("@/../") -- start at currently set directory then up a level

	import("ModuleScript") -- implies "script.ModuleScript"

	import("@/Util", "func1", "func2")

	import("@/Util/*") -- bundles all requireable children of Util into a table. will require directories with 'index'

	import("@/$nocache/Util)

	import("@", "$nocache", "Util")
]]

-- Instances
local Packages = game.ReplicatedStorage.Shared.Packages

-- Localize require (hide inherit type error with global require)
local require: (ModuleScript) -> any = require

-- Util
local type__splitWith = require(Packages.String.Util.splitWith)
local splitWith = type__splitWith()

-- Bundler package
local Bundler = {}
Bundler.__index = Bundler

local cachedModules: { [ModuleScript]: any } = {}
Bundler._cachedModules = cachedModules

-- Types
type self = {
	anchor: Instance?,
	default: Instance?,
	types: any,
}

export type Bundle = typeof(setmetatable({} :: self, Bundler))

function Bundler.new(module: Instance): Bundle
	if not module:IsA("ModuleScript") then
		error("Bundle must be given a valid ModuleScript Instance")
	end

	local self = setmetatable({} :: self, Bundler)
	self.anchor = Packages
	self.default = module
	self.types = require(module)

	return self
end

function Bundler.is(obj: any): boolean
	return type(obj) == "table" and getmetatable(obj) == Bundler
end

--[[
	@desc:
		Require a module as a bundler package, meaning the required module can
		return a function with the bundler default params like "import"

	@param module: The ModuleScript to require

	@return package: The result of the required ModuleScript
]]
function Bundler:require(module: Instance?): any
	if not module then
		error("Could not require ModuleScript (a nil value)")
	elseif not module:IsA("ModuleScript") then
		error("Required module is not a ModuleScript")
	end

	if cachedModules[module] ~= nil then
		return cachedModules[module]
	end

	local package: any = require(module)

	if typeof(package) == "function" then
		local Bundle: Bundle = Bundler.new(module)
		package = package(Bundle)
	end

	cachedModules[module] = package
	return package
end

--[[
	@desc:
		Require a directory as a bundler package. The directory must be a
		Folder instance that contains a ModuleScript named "index", which
		will then be required and returned.

	@param directory: The Folder to require

	@return package: The result of the required "index" ModuleScript
]]
function Bundler:requireDirectory(directory: Instance?): any
	if not directory then
		error("Could not require directory (a nil value)")
	elseif not directory:IsA("Folder") then
		warn("Cannot require directory of a non-Folder instance")
		return nil
	end

	local package: Instance? = directory:FindFirstChild("index")
	return self:require(package)
end

function Bundler:requirePath(path: string, _default: Instance?): any
	local default: Instance = _default or self.default

	local pathNodes = 0

	return nil
end

function Bundler:import(path: string, ...: string): any
	local pathBranches: { string } = { ... }
	local requiredPath: any = self:requirePath(path)

	if #pathBranches == 0 then
		return requiredPath
	end

	if typeof(requiredPath) ~= "Instance" then
		error("When using multiple arguments with import, first argument path must return an Instance")
	end

	local defaultRoot: Instance = requiredPath
	local export: { any } = {}

	for _, pathBranch: string in next, pathBranches do
		export[#export + 1] = self:requirePath(pathBranch, defaultRoot)
	end

	return table.unpack(export)
end

return {
	new = Bundler.new,
	is = Bundler.is,
}
