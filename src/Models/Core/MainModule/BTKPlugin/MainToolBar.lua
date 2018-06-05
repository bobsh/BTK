--- @module BTKPlugin.MainToolBar
local BaseObject = require(script.Parent.Parent.BaseObject)
local AssetsUtil = require(script.Parent.Parent.AssetsUtil)

--[[

	MainToolBar

--]]
local MainToolBar = BaseObject:subclass(script.Name)

local starterPlayer = game:FindFirstChild("StarterPlayer")

MainToolBar.AssetsToInstall = {
	{
		Parent = game.ReplicatedStorage,
		Name = "BTKContent",
		ID = 1815201505,
		Type = "Folder",
		NoDelete = true
	},
	{
		-- @TODO this is a lookup, not absolute because lemr doesn't
		-- handle it yet
		Parent = game:FindFirstChild("ServerScriptService"),
		Name = "BTK:Server",
		Type = "Script",
		Local = {
			Folder = "Init",
			Name = "BTK:Script"
		}
	},
	{
		-- @TODO
		Parent = starterPlayer and starterPlayer:FindFirstChild("StarterCharacterScripts"),
		Name = "Animate",
		Type = "LocalScript",
		Local = {
			Folder = "CharacterScripts",
			Name = "Animate"
		}
	},
	{
		Parent = starterPlayer and starterPlayer:FindFirstChild("StarterCharacterScripts"),
		Name = "BTK:PC",
		Type = "Script",
		Local = {
			Folder = "Init",
			Name = "BTK:Script"
		}
	},
	{
		Parent = starterPlayer and starterPlayer:FindFirstChild("StarterPlayerScripts"),
		Name = "BTK:Player",
		Type = "LocalScript",
		Local = {
			Folder = "Init",
			Name = "BTK:LocalScript"
		}
	}
}

function MainToolBar:initialize(plg, gui)
	BaseObject.initialize(self)

	self.MainScreenGUI = gui
	self.Plugin = plg

	local installToolbar = self.Plugin:CreateToolbar("Bob's Toolkit")

	self.Buttons = {
		InstallButton = installToolbar:CreateButton(
			"Install",
			"Install BTK runtime services into this place",
			"rbxassetid://1675181449"
		),
		UninstallButton = installToolbar:CreateButton(
			"Uninstall",
			"Uninstall BTK runtime services from this place",
			"rbxassetid://1675202319"
		)
	}

	local function updateButtons()
		local assets = AssetsUtil:GetMany(self.AssetsToInstall)
		self:Debug("Assets installed: " .. #assets .. " Number of assets to install: " .. #self.AssetsToInstall)
		if #assets < #self.AssetsToInstall then
			self.Buttons.InstallButton.Enabled = true
			self.Buttons.UninstallButton.Enabled = false
		else
			self.Buttons.InstallButton.Enabled = false
			self.Buttons.UninstallButton.Enabled = true
		end
	end


	self.Buttons.InstallButton.Click:connect(function()
		AssetsUtil:InstallMany(self.AssetsToInstall)
		updateButtons()
	end)

	self.Buttons.UninstallButton.Click:connect(function()
		AssetsUtil:UninstallMany(self.AssetsToInstall)
		updateButtons()
	end)

	updateButtons()
	for _, value in pairs(self.AssetsToInstall) do
		local function updateFn(_)
			updateButtons()
		end
		value.Parent.ChildAdded:connect(updateFn)
		value.Parent.ChildRemoved:connect(updateFn)
	end

end

function MainToolBar:Destroy()
	self:Trace("Destroy called")
end

return MainToolBar