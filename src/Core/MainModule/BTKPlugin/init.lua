local BaseObject = require(script.Parent.BaseObject)
local MainToolBar = require(script.MainToolBar)

BTKPlugin = BaseObject:subclass(script.Name)

BTKPlugin.static._mainScreenGUI = nil
BTKPlugin.static._mainToolBar = nil

function BTKPlugin:initialize(plug)
	BaseObject.initialize(self)
	
	plug:Activate(false)

	self._mainScreenGUI = Instance.new("ScreenGui", game.CoreGui)
	self._mainScreenGUI.Name = "BTKMainScreenGUI"
	
	self._mainToolBar = MainToolBar:new(plug, self._mainScreenGUI)
	
	plug.Deactivation:Connect(self:Deactivate())
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
