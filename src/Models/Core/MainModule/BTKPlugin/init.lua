--- @classmod BTKPlugin

local BaseObject = require(script.Parent.BaseObject)
local MainToolBar = require(script.MainToolBar)
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

	self:_assetsWidget()
	self:_entityEditor()

	plug.Deactivation:Connect(self:Deactivate())
end

function BTKPlugin:_assetsWidget()
	local gui = Roact.createElement(UI.DockWidgetPluginGui, {
		Name = "Assets",
		Plugin = self._plugin,
		InitialDockState = Enum.InitialDockState.Right,
	}, {
		Roact.createElement(UI.AssetsWidget)
	})
	Roact.mount(gui)
end

function BTKPlugin:_entityEditor()
	local gui = Roact.createElement(UI.DockWidgetPluginGui, {
		Name = "Entity Editor",
		Plugin = self._plugin,
		InitialDockState = Enum.InitialDockState.Left,
		MinWidth = 128,
		MinHeight = 200,
	}, {
		Roact.createElement(UI.EntityEditor, {
			Plugin = self._plugin,
		})
	})
	Roact.mount(gui)
end

function BTKPlugin:Deactivate()
	return function()
		self:Trace("Plugin deactivating")
		self._mainScreenGUI:Destroy()
		self._mainToolBar:Destroy()
		self:Trace("Plugin deactivation complete")
	end
end

return BTKPlugin
