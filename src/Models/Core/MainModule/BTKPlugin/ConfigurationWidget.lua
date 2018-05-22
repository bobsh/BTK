local BaseObject = require(script.Parent.Parent.BaseObject)
local UI = require(script.Parent.UI)
local ScriptHelper = require(script.Parent.Parent.ScriptHelper)
local Schema = require(script.Parent.Parent.Schema)

local ConfigurationWidget = BaseObject:subclass(script.Name)

function ConfigurationWidget:initialize(plg)
	BaseObject.initialize(self)

	self.Plugin = plg

	local info = DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Right,
		true,
		true,
		200,
		100,
		200,
		100
	)

	local pluginGUIName = "BTKConfigurationWidget"
	self.pluginGUI = self.Plugin:CreateDockWidgetPluginGui(pluginGUIName, info)
	self.pluginGUI.Title = "BTK Configuration"
	self.pluginGUI.Name = pluginGUIName

	self:NothingSelected()

	self:HandleSelectionChange(game.Selection.SelectionChanged)
end

function ConfigurationWidget:NothingSelected()
	self.pluginGUI:ClearAllChildren()

	-- small  utility to easily change the position of GUI elements while still having them
	-- relatively positioned.
	local curY = 0
	local function addY(v) curY = curY + v end

	local createLabel = UI:CreateStandardLabel(
		"NothingSelected",
		UDim2.new(0, 0, 0, curY),
		UDim2.new(0, 128, 0, 16),
		"Select a BTK: script to configure it",
		self.pluginGUI
	)
	createLabel.TextColor3 = Color3.new(0,0,0)
	addY(16)
end

function ConfigurationWidget:PopulateConfiguration(f, btkScript)
	self.pluginGUI:ClearAllChildren()

	-- small  utility to easily change the position of GUI elements while still having them
	-- relatively positioned.
	local curY = 0
	local function addY(v) curY = curY + v end

	local createLabel = UI:CreateStandardLabel(
		"Selection",
		UDim2.new(0, 0, 0, curY),
		UDim2.new(0, 128, 0, 16),
		"Selected script: " .. f.Name,
		self.pluginGUI
	)
	createLabel.TextColor3 = Color3.new(0,0,0)
	addY(16)

	local propsFrame = UI:CreateFrame(
		"PropertiesFrame",
		UDim2.new(0,0,0,curY),
		UDim2.new(0.9,0,0,128),
		self.pluginGUI
	)

	local uiLayout = Instance.new("UITableLayout", propsFrame)
	uiLayout.FillEmptySpaceColumns = true
	uiLayout.FillEmptySpaceRows = false
	uiLayout.FillDirection = Enum.FillDirection.Vertical

	local uiSize = Instance.new("UISizeConstraint", propsFrame)
	uiSize.MaxSize = Vector2.new(200, 32)

	local idx = 1
	for key, val in pairs(btkScript:Properties()) do
		self:AssertSchema(val, Schema.PropertyDefinition)
		local columnFrame = UI:CreateFrame(
			tostring(idx),
			UDim2.new(0,0,0,0),
			UDim2.new(0,100,0,16),
			propsFrame
		)
		local keyLabel = UI:CreateStandardLabel(
			"1",
			UDim2.new(0, 0, 0, 0),
			UDim2.new(0, 64, 0, 16),
			key,
			columnFrame
		)
		keyLabel.TextColor3 = Color3.new(0,0,0)

		local typeLabel = UI:CreateStandardLabel(
			"2",
			UDim2.new(0, 0, 0, 0),
			UDim2.new(0, 64, 0, 16),
			val.Type,
			columnFrame
		)
		typeLabel.TextColor3 = Color3.new(0,0,0)

		idx = idx + 1
	end

	uiLayout:ApplyLayout()
end

function ConfigurationWidget:HandleSelectionChange(signal)
	self._selectionConnection = signal:Connect(function()
		local s = game.Selection:Get()
		if s == nil then
			self:NothingSelected()
			return
		end

		local f = s[1]
		if f == nil then
			self:NothingSelected()
			return
		end

		if not f:IsA("Script") then
			self:NothingSelected()
			return
		end

		local scriptName = f.Name:match(ScriptHelper.Pattern)
		if not scriptName then
			self:NothingSelected()
			return
		end

		self:Debug("Script name is " .. scriptName)

		local btkScript = ScriptHelper:Get(f)
		if not btkScript then
			self:NothingSelected()
			self:Warn("btkScript not set")
			return
		end

		self:PopulateConfiguration(f, btkScript)
		self:Debug("Selected: " .. f.Name)
		self:Debug("Properties", btkScript:Properties())
	end)
end

function ConfigurationWidget:Destroy()
	self:Debug("Destroy called")
	self._selectionConnection:Disconnect()
	self:Debug("Destroy complete")
end

return ConfigurationWidget