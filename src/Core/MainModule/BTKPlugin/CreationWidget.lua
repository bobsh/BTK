local BaseObject = require(script.Parent.Parent.BaseObject)
local UI = require(script.Parent.UI)
local ConfirmationPopup = require(script.Parent.ConfirmationPopup)
local AssetsUtil = require(script.Parent.Parent.AssetsUtil)
local RbxGui = LoadLibrary("RbxGui")

--[[
	CreationWidget
--]]
CreationWidget = BaseObject:subclass(script.Name)

CreationWidget.ComponentTypes = {
	Teleporter = {
		Name = "BTKTeleporter",
		Type = "Script",
		ParentType = "BasePart",
		Local = {
			Folder = "Components",
			Name = "BTKTeleport"
		}
	},
	Platform = {
		Name = "BTKPlatformMover",
		Type = "Script",
		ParentType = "BasePart",
		Local = {
			Folder = "Components",
			Name = "BTKPlatformMover"
		}
	},
	Currency = {
		Name = "BTKCurrency",
		Type = "Script",
		ParentType = "BasePart",
		Local = {
			Folder = "Components",
			Name = "BTKCurrency"
		}
	},
	Area = {
		Name = "BTKArea",
		Type = "Script",
		ParentType = "BasePart",
		Local = {
			Folder = "Components",
			Name = "BTKArea"
		}
	},
	Weapon = {
		Name = "BTKWeapon",
		Type = "Script",
		ParentType = "Tool",
		Local = {
			Folder = "Components",
			Name = "BTKWeapon"
		}
	},
	NPC = {
		Name = "BTKNPC",
		Type = "Script",
		ParentType = "Humanoid",
		Local = {
			Folder = "Components",
			Name = "BTKNPC"
		}
	}
}
CreationWidget.ComponentSelected = "NPC"

function CreationWidget:initialize(gui)	
	BaseObject.initialize(self)	
	
	self.MainScreenGUI = gui

	local entire, container, info, event = RbxGui.CreatePluginFrame(
		"Create Object",
		UDim2.new(0,320,0,200),
		UDim2.new(0,0,0,0),
		false,
		self.MainScreenGUI
	)
	self.WidgetFrame = entire
	event.Event:connect(function()
		self:Trace("Plugin frame closed event raised")
		self.WidgetFrame.Visible = false
	end)
	self.WidgetFrame.Visible = false
	
	self:Trace("Drawing GUI Widgets")
	
	-- small  utility to easily change the position of GUI elements while still having them
	-- relatively positioned.
	local curY = 10
	local function setY(v) curY = v end
	local function addY(v) curY = curY + v end

	--[[
		Component type selection
	--]]	
	local widthLabel = UI:CreateStandardLabel("ComponentTypeLabel", UDim2.new(0, 8, 0, curY), UDim2.new(0, 67, 0, 14), "First choose a component type", container)
	addY(24)
	
	local function onComponentTypeDropDown	(value)
		self:Debug("Drop down changed, value is now " .. tostring(value))
		self.ComponentSelected = value
	end
	
	local componentTypeDropDown, componentTypeSet = UI:CreateStandardDropdown("ComponentTypeDropdown",
						        UDim2.new(0,0,0,curY),
								{"NPC", "Weapon", "Platform", "Teleporter", "Area", "Currency"},
								self.ComponentSelected,
								onComponentTypeDropDown, 
								container)
	
	addY(48)
	
	
	
	--[[
		Parent selection
	--]]
	local focusLabel = UI:CreateStandardLabel("FocusLabel", UDim2.new(0, 8, 0, curY), UDim2.new(0, 67, 0, 14), "Then select a suitable item in the explorer", container)
	addY(24)
	
	UI:CreateStandardLabel("FocusedOnLabel", UDim2.new(0, 8, 0, curY), UDim2.new(0, 67, 0, 14), "Currently selected:", container)
	local focusValueLabel = UI:CreateStandardTextBox("FocusValueLabel", UDim2.new(0, 140, 0, curY), UDim2.new(0, 67, 0, 14), "Nothing", container)
	addY(32)
	
	--[[
		Create button
	--]]
	local function createFunction()
		self:Trace("Create button pushed")
		
		ConfirmationPopupObject = ConfirmationPopup.Create(
			self.MainScreenGUI,
			"Ready to create?",
			"Create",
			"Cancel",
			function()
				print("New component type " .. self.ComponentSelected .. " with target of " .. self.ComponentTarget.Name)
				local assetToInstall = self.ComponentTypes[self.ComponentSelected]
				assetToInstall.Parent = self.ComponentTarget
				AssetsUtil:Install(assetToInstall)
				print("Finished adding asset to object")
				self:Off()

				ConfirmationPopupObject:Clear()
			end,
			function()
				print("Popup destroyed")
				ConfirmationPopupObject:Clear()
			end
		)
	end
	
	local createButton = UI:CreateStandardButton("CreateButton",
											UDim2.new(0, 0, 0, curY),
										    "Create",
										    createFunction,
	    container)
	createButton.Active = false
	
	local selectionFn = function()
		local selections = game.Selection:Get()
		local selection = selections[1]
		self.ComponentTarget = selection
		if selection == nil then
			createButton.Active = false
			focusValueLabel.Text = "Nothing"
		else
			createButton.Active = true
			focusValueLabel.Text = ("%s/%s"):format(selection.Parent.Name, selection.Name)
		end
	end
	selectionFn()

	game.Selection.SelectionChanged:connect(selectionFn)	
	
	self:Trace("Initilisation complete")
end

function CreationWidget:On()
	self:Trace("Turning on")
	self.WidgetFrame.Visible = true
end

function CreationWidget:Off()
	self:Trace("Turning off")
	self.WidgetFrame.Visible = false
end

function CreationWidget:Status()
	return self.WidgetFrame.Visible
end

function CreationWidget:Destroy()
	self:Trace("Destroy called")
end

return CreationWidget