--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Server = game:GetService("ServerScriptService").Server
-- local Packages = Shared.Packages
local Network = require(Server.Packages.Network.index):init()

-- local TABLE = require(Shared.Types.Table)
-- local NETWORK = require(Shared.Types.Network)

-- Enums
local Enums = require(Shared.Enums.index)
-- local NetworkEnums = Enums.Network
-- local EnumCategory = require(Shared.Enums.EnumCategory)
-- local EnumItem = require(Shared.Enums.EnumItem)

while true do
	local t = os.clock()

	local response = Network:sendTCP({
		headers = {
			channel = Enums.Network.Channel.Channel,
			request = Enums.Network.Request.Generic,
			sendAll = true,
		},
		payload = {
			data = "testing",
		},
	})

	local f = os.clock() - t

	print("time: ", f)
	print("response: ", response)

	task.wait(2)
end

-- class builder
-- local ClassBuilder = require(Shared.Packages.Util.Classes.ClassBuilder)

-- -- Public class fields
-- type EnumInstanceInterface = {
-- 	name: string?,
-- 	poop: string,
-- 	[string]: any,
-- }

-- local Enum = ClassBuilder.new({} :: {
-- 	new: () -> EnumInstanceInterface,
-- 	[string]: any,
-- })

-- -- Private static class fields
-- -- Enum.private = "hidden"
-- Enum._instanceCount = 540
-- --

-- function Enum.new()
-- 	local instance = Enum._CONSTRUCTOR()

-- 	-- Public local fields (exists in interface)
-- 	instance.hidden = "lol"

-- 	-- Private hidden fields (does not exist in interface)
-- 	instance.poop = "a dump"
-- 	instance.name = "Willy bob jean"

-- 	return instance
-- end

-- local e1 = Enum.new()
-- local e2 = Enum.new()
-- print(e1._instanceCount)
-- print(e1.name)
-- print(e1.poop)
-- print(Enum.is(e1))
-- print(Enum.is(e2))

-- local Enum2 = ClassBuilder.new({} :: {
-- 	new: () -> EnumInstanceInterface,
-- })

-- function Enum2.new()
-- 	return Enum2._CONSTRUCTOR()
-- end

-- local r1 = Enum2.new()
-- print(Enum.is(Enum2))

-- local EnumCategory = require(Shared.Enums.EnumCategory)
-- local EnumItem = require(Shared.Enums.EnumItem)
-- local Enums = require(Shared.Enums.index)

-- print(Enums.Machine:getItems())
-- print(Enums.Machine.Any:getId())

-- print(EnumCategory.is(Enums.Machine.Any))
-- print(EnumItem.is(Enums.Machine.Any))

-- print(Enums.is(Enums.Machine))
-- print(Enums.is(Enums.Machine.Any))

-- print(Enums.serialize(Enums.Network.Protocol.LocalRequest))

-- print(Enums.Machine.Any == Enums.Machine.Any)

return nil
