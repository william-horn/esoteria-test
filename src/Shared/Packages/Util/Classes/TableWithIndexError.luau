--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local TABLE = require(Shared.Types.Table)

local INDEX_ERROR = 'Index "%s" is not a valid %s of "%s"'

local function new(t, _keyType: string?, _tableName: string?): any
	local tableName: string = _tableName or "Table"
	local keyType: string = _keyType or "Key"

	local mt = {} :: TABLE.StringKeysFunctionValues

	mt.__index = function(_, k: string): ()
		-- if k == "lastSentPacket" then
		-- 	return nil
		-- end
		error(INDEX_ERROR:format(k, keyType, tableName), 2)
	end

	return setmetatable(t, mt)
end

return {
	new = new,
}
