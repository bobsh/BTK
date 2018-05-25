--- @classmod BTKPlugin

local BaseObject = require(script.Parent.BaseObject)
local MainToolBar = require(script.MainToolBar)
local ConfigurationWidget = require(script.ConfigurationWidget)
local UI = require(script.Parent.UI)
local Roact = require(script.Parent.lib.Roact)

local BTKPlugin = BaseObject:subclass(script.Name)

BTKPlugin.static._mainScreenGUI = nil
BTKPlugin.static._mainToolBar = nil

function BTKPlugin:initialize(plug)
	BaseObject.initialize(self)

	plug:Activate(false)

	self._plugin = plug
	self._mainScreenGUI = Instance.new("ScreenGui", game.CoreGui)
	self._mainScreenGUI.Name = "BTKMainScreenGUI"

	self._mainToolBar = MainToolBar:new(plug, self._mainScreenGUI)
	self._configurationWidget = ConfigurationWidget:new(plug)

	self:AssetsWidget()
	self:ConfigurationWidget()

	plug.Deactivation:Connect(self:Deactivate())
end

function BTKPlugin:AssetsWidget()
	local dockWidget = UI.DockWidget({
		Name = "Assets",
		Plugin = self._plugin,
	})
	local assetsWidget = Roact.createElement(UI.AssetsWidget)
	Roact.mount(assetsWidget, dockWidget)
end

function BTKPlugin:ConfigurationWidget()
	local dockWidget = UI.DockWidget({
		Name = "Configuration",
		Plugin = self._plugin,
	})
	local widget = Roact.createElement(UI.ConfigurationWidget)
	Roact.mount(widget, dockWidget)
end

function BTKPlugin:Deactivate()
	return function()
		self:Trace("Plugin deactivating")
		self._mainScreenGUI:Destroy()
		self._mainToolBar:Destroy()
		self._configurationWidget:Destroy()
		self:Trace("Plugin deactivation complete")
	end
end

return BTKPlugin
