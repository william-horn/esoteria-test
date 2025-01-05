--!strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Table = require(Shared.Types.Table)

local function findInstanceWithNameAndClass(
	parent: Instance,
	name: string,
	className: string,
	recursive: boolean?
): Instance?
	local children: Table.InstanceArray = if recursive then parent:GetDescendants() else parent:GetChildren()

	for _, child: Instance in children do
		if child.Name == name and child.ClassName == className then
			return child
		end
	end

	return nil
end

return findInstanceWithNameAndClass
