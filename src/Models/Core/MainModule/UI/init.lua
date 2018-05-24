local BaseUtil = require(script.Parent.BaseUtil)
local Roact = require(script.Parent.lib.Roact)

local UI = BaseUtil:subclass(script.Name)

for _, component in ipairs(script:WaitForChild("Components"):GetChildren()) do
	UI.static[component.Name] = require(component)
end

function UI.static.DockWidget(props)
	local info = DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Left,
		true,
		true,
		200,
		100,
		200,
		100
	)

	local pluginGUI = props.Plugin:CreateDockWidgetPluginGui(props.Name, info)
	pluginGUI.Title = "Testies"
	pluginGUI.Name = props.Name

	return pluginGUI
end

return UI