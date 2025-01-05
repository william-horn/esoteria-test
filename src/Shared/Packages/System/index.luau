--!strict

local Enums = game:GetService("ReplicatedStorage").Shared.Enums
local MachineType = Enums.MachineType

local isServer = require(script.Parent.isServer)
local isClient = require(script.Parent.isClient)
local isStudio = require(script.Parent.isStudio)

local System = {}

if isServer() then
	System.MachineType = MachineType.Server
elseif isClient() then
	System.MachineType = MachineType.Client
elseif isStudio() then
	System.MachineType = MachineType.Studio
end

return System
