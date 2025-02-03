--!strict

local function getId(type: string, name: string, count: number): string
	return ("%s:%s_%s"):format(type, name, tostring(count))
end

return getId
