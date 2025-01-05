--!strict

-- Returns true if an Instance is a Folder
local function isFolder(v: Instance): boolean
	return v:IsA("Folder")
end

return isFolder
