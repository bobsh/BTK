local BaseObject = require(script.Parent.Parent.BaseObject)
local RbxGui = LoadLibrary("RbxGui")

--[[
	UI Functions
--]]
local UI = BaseObject:subclass(script.Name)

function UI.static:CreateFrame(
	name,
	pos,
	size,
	parent)
	self:Trace("create")

	local frame = Instance.new("Frame", parent)
	frame.Name = name
	frame.Position = pos
	frame.Size = size

	return frame
end

function UI.static:CreateScrollingFrame(
	name,
	pos,
	size,
	parent)
	self:Trace("create")

	local frame = Instance.new("ScrollingFrame", parent)
	frame.Name = name
	frame.Position = pos
	frame.Size = size

	return frame
end

-- Create a standard text label.  Use this for all lables in the popup so it is easy to standardize.
-- labelName - What to set the text label name as.
-- pos    	 - Where to position the label.  Should be of type UDim2.
-- size   	 - How large to make the label.	 Should be of type UDim2.
-- text   	 - Text to display.
-- parent 	 - What to set the text parent as.
-- Return:
-- Value is the created label.
function UI.static:CreateStandardLabel(
	labelName,
	pos,
	size,
	text,
	parent)
	self:Trace("create")

	local label = Instance.new("TextLabel", parent)
	label.Name = labelName
	label.Position = pos
	label.Size = size
	label.Text = text
	label.TextColor3 = Color3.new(0.95, 0.95, 0.95)
	label.Font = Enum.Font.SourceSans
	label.FontSize = Enum.FontSize.Size14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.BackgroundTransparency = 1
	label.Parent = parent

	return label
end

-- Create a standard text label.  Use this for all lables in the popup so it is easy to standardize.
-- labelName - What to set the text label name as.
-- pos    	 - Where to position the label.  Should be of type UDim2.
-- size   	 - How large to make the label.	 Should be of type UDim2.
-- text   	 - Text to display.
-- parent 	 - What to set the text parent as.
-- Return:
-- Value is the created label.
function UI.static:CreateStandardTextBox(labelName,
                             pos,
							 size,
							 text,
							 parent)
	self:Trace("create")

	local label = Instance.new("TextBox", parent)
	label.Name = labelName
	label.Position = pos
	label.Size = size
	label.Text = text
	label.TextColor3 = Color3.new(0.95, 0.95, 0.95)
	label.Font = Enum.Font.ArialBold
	label.FontSize = Enum.FontSize.Size14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.BackgroundTransparency = 1
	label.BorderSizePixel = 1
	label.BorderColor3 = Color3.new(0.95, 0.95, 0.95)
	label.Parent = parent

	return label
end

-- Create a standardized slider.
-- name  - Name to use for the slider.
-- pos   - Position to display the slider at.
-- steps - How many steps there are in the slider.
-- funcOnChange - Function to call when the slider changes.
-- initValue    - Initial value to set the slider to.  If nil the slider stays at the default.
-- parent       - What to set as the parent.
-- Return:
-- sliderGui      - Slider gui object.
-- sliderPosition - Object that can set the slider value.
function UI.static:CreateStandardSlider(name,
                              pos,
							  lengthBarPos,
							  steps,
							  funcOnChange,
							  initValue,
							  parent)

	self:Trace("create")

	local sliderGui, sliderPosition = RbxGui.CreateSlider(steps, 0, UDim2.new(0,0,0,0))

	sliderGui.Name = name
	sliderGui.Parent = parent
	sliderGui.Position = pos
	sliderGui.Size = UDim2.new(1,0,0,20)
	local lengthBar = sliderGui:FindFirstChild("Bar")
	lengthBar.Size = UDim2.new(1, -21, 0, 5)
	lengthBar.Position = lengthBarPos

	if nil ~= funcOnChange then
		sliderPosition.Changed:connect(function() funcOnChange(sliderPosition) end)
	end

	if nil ~= initValue then
		sliderPosition.Value = initValue
	end

	return sliderGui, sliderPosition
end

-- Create a standard dropdown.  Use this for all dropdowns in the popup so it is easy to standardize.
-- name - What to set the text label name as.
-- pos    	 	 - Where to position the label.  Should be of type UDim2.
-- values    	 - A table of the values that will be in the dropbox, in the order they are to be shown.
-- initValue	 - Initial value the dropdown should be set to.
-- funcOnChange  - Function to run when a dropdown selection is made.
-- parent 	 	 - What to set the parent as.
-- Return:
-- dropdown 	   - The dropdown gui.
-- updateSelection - Object to use to change the current dropdown.
function UI.static:CreateStandardDropdown(name,
						        pos,
								values,
								initValue,
								funcOnChange,
								parent)

	self:Trace("create")

	-- Create a dropdown selection for the modes to fill in a river
	local dropdown, updateSelection=RbxGui.CreateDropDownMenu(values, funcOnChange);
	dropdown.Name = name
	dropdown.Position = pos
	dropdown.Active = true
	dropdown.Size = UDim2.new(0,150,0,32)
	dropdown.Parent = parent

	updateSelection(initValue)

	return dropdown, updateSelection
end

-- Keep common button properties here to make it easer to change them all at once.
-- These are the default properties to use for a button.
local buttonTextColor = Color3.new(1, 1, 1);
local buttonFont = Enum.Font.ArialBold;
local buttonFontSize = Enum.FontSize.Size18;

-- Create a standard dropdown.  Use this for all dropdowns in the popup so it is easy to standardize.
-- name - What to use.
-- pos    	 	- Where to position the button.  Should be of type UDim2.
-- text         - Text to show in the button.
-- funcOnPress  - Function to run when the button is pressed.
-- parent 	 	- What to set the parent as.
-- Return:
-- button 	   - The button gui.
function UI.static:CreateStandardButton(name,
								pos,
							  text,
							  funcOnPress,
							  parent,
							  size)

	self:Trace("create")

	local button = Instance.new("TextButton", parent)
	button.Name = name
	button.Position = pos

	button.Size = UDim2.new(0,120,0,40)
	button.Text = text

	if size then
		button.Size = size
	end

	button.Style = Enum.ButtonStyle.RobloxButton

	button.TextColor3 = buttonTextColor
	button.Font = buttonFont
	button.FontSize = buttonFontSize

	button.MouseButton1Click:connect(funcOnPress)

	return button
end

function UI.static:CreateImageButton(
	name,
	pos,
	image,
	funcOnPress,
	parent,
	size)

	self:Trace("create")


	local button = Instance.new("ImageButton", parent)
	button.Name = name
	button.Position = pos

	button.Size = UDim2.new(0,96,0,96)
	button.Image = image

	if size then
		button.Size = size
	end

	button.Style = Enum.ButtonStyle.RobloxButton

	button.MouseButton1Click:connect(funcOnPress)

	return button
end


-- Create a standard accordion, which contains many child areas that can be
-- swiched between
-- name
-- pos           - Where to put it
-- childList     - List of children to add, format: [{Name = ..., Gui = ..., Height = ...}]
--
function UI.static:CreateStandardAccordion(name,
	                             pos,
	                             size,
	                             childList,
								 parent)

	self:Trace("create")

	local frame = Instance.new('Frame', parent)
	frame.Position = pos
	frame.Size = size
	frame.Name = name
	frame.ClipsDescendants = true
	frame.BackgroundTransparency = 1
	--
	local childContainerList = {}
	--
	local function doLayout(pressedItem)
		local atY = 0
		for _, child in pairs(childContainerList) do
			child.Gui.Position = UDim2.new(0, 0, 0, atY)
			if child == pressedItem then
				child.Gui.Size = UDim2.new(1, 0, 0, child.DesiredHeight)
				child.Gui.HeadingButton.TextColor3 = Color3.new(1, 0.7, 0.7)
				child.ChildGui.Visible = true
				atY = atY + child.DesiredHeight
			else
				child.Gui.Size = UDim2.new(1, 0, 0, 40)
				child.Gui.HeadingButton.TextColor3 = buttonTextColor
				child.ChildGui.Visible = false
				atY = atY + 25
			end
		end
	end
	--
	for _, childData in pairs(childList) do
		local childContainer = Instance.new('Frame', frame)
		childContainer.BackgroundTransparency = 1
		childContainer.ClipsDescendants = true
		--
		local childHeader = Instance.new('TextButton', childContainer)
		childHeader.Name = 'HeadingButton'
		childHeader.Style = Enum.ButtonStyle.RobloxButton
		childHeader.Size = UDim2.new(1, 0, 0, 30)
		childHeader.TextColor3 = buttonTextColor
		childHeader.Font = buttonFont
		childHeader.FontSize = buttonFontSize
		childHeader.Text = " v "..childData.Name.." v "
		--
		childData.Gui.BackgroundTransparency = 1
		childData.Gui.Position = UDim2.new(0, 0, 0, 30)
		childData.Gui.Size = UDim2.new(1, 0, 1, -30)
		childData.Gui.Parent = childContainer
		--
		local data = {
			Gui = childContainer;
			ChildGui = childData.Gui;
			DesiredHeight = childData.Height + 30;
		}
		childContainerList[#childContainerList+1] = data
		--
		childHeader.MouseButton1Click:connect(function() doLayout(data) end)
	end
	--do an initial layout
	doLayout(childContainerList[1])
	--
	return frame
end

return UI