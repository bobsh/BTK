local BaseObject = require(script.Parent.Parent.BaseObject)
local AssetsUtil = require(script.Parent.Parent.AssetsUtil)
local UI = require(script.Parent.UI)

local MarketplaceService = game:GetService("MarketplaceService")

--[[

	AssetsWidget

--]]
local AssetsWidget = BaseObject:subclass(script.Name)

AssetsWidget.Assets = {
	NPC = {
		-- Frog
		1667638075
	},
	Tools = {
		-- Hammer
		1637181997,
		-- Nommy Gun
		1673945800
	},
	Utilities = {
		-- Waypoints
		1667667072,
		-- Area
		1667505353,
	}
}

function AssetsWidget:initialize(plg, gui)
	BaseObject.initialize(self)

	self.MainScreenGUI = gui
	self.Plugin = plg

	local info = DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Left,
		true,
		true,
		200,
		100,
		200,
		100
	)

	local pluginGUIName = "BTKAssetsWidget"
	local pluginGUI = self.Plugin:CreateDockWidgetPluginGui(pluginGUIName, info)
	pluginGUI.Title = "BTK Assets"
	pluginGUI.Name = pluginGUIName

	-- small  utility to easily change the position of GUI elements while still having them
	-- relatively positioned.
	local curY = 0
	local function addY(v) curY = curY + v end

	local typeFrame = UI:CreateFrame(
		"TypeFrame",
		UDim2.new(0,0,0,curY),
		UDim2.new(1.0,0,0,32),
		pluginGUI
	)
	addY(32)

	local Frames = {}
	Frames.NPC = self:CreateContentFrame(
		"NPC",
		UDim2.new(0,0,0,curY),
		pluginGUI
	)
	Frames.Tools = self:CreateContentFrame(
		"Tools",
		UDim2.new(0,0,0,curY),
		pluginGUI
	)
	Frames.Tools.Visible = false
	Frames.Utilities = self:CreateContentFrame(
		"Utilities",
		UDim2.new(0,0,0,curY),
		pluginGUI
	)
	Frames.Utilities.Visible = false

	local currentFrame = "NPC"

	UI:CreateStandardDropdown(
		"TypeDropDown",
		UDim2.new(0,0,0,0),
		{"NPC","Tools","Utilities"},
		"NPC",
		function(selected)
			Frames[currentFrame].Visible = false
			currentFrame = selected
			Frames[currentFrame].Visible = true
		end,
		typeFrame
	)
end

function AssetsWidget:CreateContentFrame(
	name,
	position,
	parent
)
	-- small  utility to easily change the position of GUI elements while still having them
	-- relatively positioned.
	local curY = 0
	local function addY(v) curY = curY + v end

	local contentFrame = UI:CreateScrollingFrame(
		name,
		position,
		UDim2.new(1.0,0,1.0,0),
		parent
	)

	-- Reset with new frame
	curY = 0

	local function createFunction(asset)
		return function()
			print "Assets todo"

			self.Plugin:Activate(true)
			local mouse = self.Plugin:GetMouse()
			local oldIcon = mouse.Icon
			mouse.Icon = "rbxassetid://1684734025"

			local touchedConnection
			touchedConnection = mouse.Button1Down:Connect(function(hit)
				self:Trace("Button1Down start")
				AssetsUtil:Install(asset)
				touchedConnection:Disconnect()
				mouse.Icon = oldIcon
				self:Trace("Button1Down finished")
			end)
		end
	end

	for _, assetID in pairs(self.Assets[name]) do
		local productInfo = MarketplaceService:GetProductInfo(assetID, Enum.InfoType.Asset)

		local asset = {
			Name = productInfo.Name,
			Parent = game.Workspace,
			Type = "Model",
			ParentType = "Instance",
			ID = assetID
		}
		if name == "Tools" then
			asset.Type = "Tool"
		end

		-- Thankyou to: https://devforum.roblox.com/t/new-image-endpoints-that-can-be-used-in-game/28182
		-- andd: https://devforum.roblox.com/t/important-info-on-loading-avatar-images-on-xbox/20085
		local iconURL = "https://www.roblox.com/asset-thumbnail/image?assetId=" ..
			tostring(asset.ID) ..
			"&width=420&height=420&format=png&bust=" ..
			math.floor(tick())

		local createButton = UI:CreateImageButton(
			asset.Name .. "AssetButton",
			UDim2.new(0, 0, 0, curY),
			iconURL,
			createFunction(asset),
			contentFrame
		)
		createButton.Style = Enum.ButtonStyle.Custom
		createButton.AutoButtonColor = true

		local createLabel = UI:CreateStandardLabel(
			asset.Name .. "AssetLabel",
			UDim2.new(0, 100, 0, curY),
			UDim2.new(0, 128, 0, 16),
			asset.Name,
			contentFrame
		)
		createLabel.TextColor3 = Color3.new(0,0,0)

		local createDescription = UI:CreateStandardLabel(
			asset.Name .. "AssetDescription",
			UDim2.new(0, 100, 0, curY+16),
			UDim2.new(0, 128, 0, 80),
			productInfo.Description,
			contentFrame
		)
		createDescription.TextYAlignment = Enum.TextYAlignment.Top
		createDescription.TextColor3 = Color3.new(0,0,0)
		createDescription.Font = Enum.Font.Arial

		addY(96)
	end

	-- Set the canvas size based on the last value
	contentFrame.CanvasSize = UDim2.new(1.0,0,0,curY)

	return contentFrame
end

function AssetsWidget:On()
	--self.WidgetFrame.Visible = true
end

function AssetsWidget:Off()
	--self.WidgetFrame.Visible = false
end

function AssetsWidget:Status()
	return true
	--return self.WidgetFrame.Visible
end

function AssetsWidget:Destroy()
	self:Trace("Destroy called")
end

return AssetsWidget