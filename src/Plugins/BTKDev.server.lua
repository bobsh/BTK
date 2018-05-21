assert(plugin, "BTKPlugin: Code not running as plugin, stopping")

local insertService = game:GetService("InsertService")

--[[
	Assets
--]]
local Assets = {}

function Assets:GetAsset(asset)
	local _ = self
	print("Assets: Finding child " .. asset.Name .. " of parent " .. asset.Parent.Name)
	return asset.Parent:FindFirstChild(asset.Name, false)
end

function Assets:GetAssets(assets)
	local _ = self
	local list = {}
	for _, value in pairs(assets) do
		table.insert(list, value)
	end
	return list
end

function Assets:InstallAsset(asset)
	local _ = self
	print(("Assets: Installing %s with id %d into %s"):format(asset.Name, asset.ID, asset.Parent.Name))

	local currentAsset = Assets:GetAsset(asset)
	if currentAsset ~= nil then
		warn(("Assets: %s already exists in %s"):format(asset.Name, asset.Parent.Name))
		return
	end

	local versionID = insertService:GetLatestAssetVersionAsync(asset.ID)
	print(("Assets: Found version %d for asset ID %d"):format(versionID, asset.ID))

	local assetRef = insertService:LoadAssetVersion(versionID)
	if not assetRef then
		error "Assets: Unable to load asset"
	end
	local assetChildren = assetRef:GetChildren()
	if #assetChildren ~= 1 then
		error "Assets: Asset should only have 1 child"
	end
	local btkScript = assetChildren[1]
	if not (btkScript:IsA(asset.Type)) then
		error(("Assets: Asset child should be %s"):format(asset.Type))
	end
	btkScript.Parent = asset.Parent
	btkScript.Name = asset.Name

	print(("Assets: Done installing %s with id %d version %d into %s"):format(
		asset.Name, asset.ID, versionID, asset.Parent.Name))
end

function Assets:InstallAssets(assets)
	local _ = self
	for _, value in pairs(assets) do
		Assets:InstallAsset(value)
	end
end

function Assets:UninstallAsset(asset)
	local _ = self
	print(("Assets: Uninstalling %s from %s"):format(asset.Name, asset.Parent.Name))

	local currentAsset = Assets:GetAsset(asset)
	if currentAsset == nil then
		warn(("Assets: %s does not exist in %s"):format(asset.Name, asset.Parent.Name))
		return
	end

	currentAsset:Destroy()
	print(("Assets: Uninstalled %s from %s"):format(asset.Name, asset.Parent.Name))
end

function Assets:UninstallAssets(assets)
	local _ = self
	for _, value in pairs(assets) do
		Assets:UninstallAsset(value)
	end
end

function Assets:AttachOnClick(asset)
	local _ = self
	return function()
		local selectRef = game.Selection:Get()[1]
		if not selectRef then
			error("Assets: Nothing selected")
			return
		end
		if not selectRef:IsA(asset.ParentType) then
			error("Assets: Selection is not a base part")
		end

		asset.Parent = selectRef

		Assets:InstallAsset(asset)
	end
end

--[[
	DevToolBar - support for me
--]]
local DevToolBar = {}

function DevToolBar:Init()
	local _ = self
	local installToolbar = plugin:CreateToolbar("BTK Development")

	local installButton = installToolbar:CreateButton(
		"Install",
		"Install BTK development environment",
		"rbxassetid://1675181449"
	)

	local uninstallButton = installToolbar:CreateButton(
		"Uninstall",
		"Uninstall BTK development environment",
		"rbxassetid://1675202319"
	)

	local publishButton = installToolbar:CreateButton(
		"Publish MainModule",
		"Publish BTK development environment",
		"rbxassetid://133293265"
	)

	local publishContentButton = installToolbar:CreateButton(
		"Publish BTKContent",
		"Publish BTKContent",
		"rbxassetid://133293265"
	)

	-- Setup button
	local componentButton = installToolbar:CreateButton(
		"Attach Component",
		"Will attach a generic component to the selected instance.",
		"rbxassetid://133293265"
		---"rbxassetid://1606339973"
	)

	componentButton.Click:connect(Assets:AttachOnClick({
		Name = "BTKComponent",
		ID = 1608226814,
		Type = "Script",
		ParentType = "Instance"
	}))

	-- Setup button
	local diagsButton = installToolbar:CreateButton(
		"Diags",
		"Diags",
		"rbxassetid://133293265"
		---"rbxassetid://1606339973"
	)
	diagsButton.Click:connect(function()
		local coreGUIChildren = game.CoreGui:GetChildren()
		print "BTKDev: Printing list of coregui children"
		for _, value in pairs(coreGUIChildren) do
			print("BTKDEV: - " .. value.Name)
		end
		print "BTKDev: End of coregui children"
	end)



	local btkMod = {
		Parent = game.Workspace,
		Name = "MainModule",
		ID = 1637466041,
		Type = "ModuleScript"
	}

	local btkContent = {
		Parent = game.ReplicatedStorage,
		Name = "BTKContent",
		ID = 1815201505,
		Type = "Folder"
	}

	installButton.Click:connect(function()
		Assets:InstallAsset(btkMod)
	end)

	uninstallButton.Click:connect(function()
		Assets:InstallAsset(btkMod)
	end)

	publishButton.Click:connect(function()
		local mod = Assets:GetAsset(btkMod)
		game.Selection:Set({mod})
		plugin:SaveSelectedToRoblox()
	end)

	publishContentButton.Click:connect(function()
		local mod = Assets:GetAsset(btkContent)
		game.Selection:Set({mod})
		plugin:SaveSelectedToRoblox()
	end)

	local function updateButtons()
		local mod = Assets:GetAsset(btkMod)
		if (mod == nil) then
			installButton.Enabled = true
			uninstallButton.Enabled = false
			publishButton.Enabled = false

			publishContentButton.Enabled = false
			componentButton.Enabled = false
		else
			installButton.Enabled = false
			uninstallButton.Enabled = true
			publishContentButton.Enabled = true
			componentButton.Enabled = true
		end
	end

	updateButtons()
	btkMod.Parent.ChildAdded:connect(function(_)
		updateButtons()
	end)
	btkMod.Parent.ChildRemoved:connect(function(_)
		updateButtons()
	end)
	btkContent.Parent.ChildAdded:connect(function(_)
		updateButtons()
	end)
	btkContent.Parent.ChildRemoved:connect(function(_)
		updateButtons()
	end)

end

do
	DevToolBar:Init()
end