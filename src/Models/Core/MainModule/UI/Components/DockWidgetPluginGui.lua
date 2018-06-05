--[[--
    Creates a PluginGui item as a DockWidget
    @classmod UI.DockWidgetPluginGui
    @export
--]]

local Roact = require(script.Parent.Parent.Parent.lib.Roact)
local DockWidgetPluginGui = Roact.Component:extend("DockWidgetPluginGui")
local c = Roact.createElement

function DockWidgetPluginGui:init(props)
    self.state = {
        Name = props.Name,
        Plugin = props.Plugin,
        Children = props[Roact.Children],
        InitialDockState = props.InitialDockState or Enum.InitialDockState.Right,
        InitialEnabled = props.InitialEnabled or true,
        InitialEnabledShouldOverrideRestore = props.InitialEnabledShouldOverrideRestore or true,
        FloatingXSize = props.FloatingXSize or 200,
        FloatingYSize = props.FloatingYSize or 100,
        MinWidth = props.MinWidth or 200,
        MinHeight = props.MinHeight or 100,
    }

    local info = DockWidgetPluginGuiInfo.new(
		self.state.InitialDockState,
		self.state.InitialEnabled,
		self.state.InitialEnabledShouldOverrideRestore,
		self.state.FloatingXSize,
		self.state.FloatingYSize,
		self.state.MinWidth,
		self.state.MinHeight
	)

	local pluginGUI = self.state.Plugin:CreateDockWidgetPluginGui(self.state.Name, info)
	pluginGUI.Title = self.state.Name
    pluginGUI.Name = self.state.Name
    self.state.PluginGui = pluginGUI
end

function DockWidgetPluginGui:render()
    return c(Roact.Portal, {
        target = self.state.PluginGui,
    }, self.state.Children)
end



return DockWidgetPluginGui