local storage = game.ReplicatedStorage
local BTKContent = storage:WaitForChild("BTKContent", 2)

do
	if not BTKContent then
		print "BTKPluginDev: Unable to find BTKContent"
		return
	end

	local Plugins = BTKContent:WaitForChild("Plugins")

	local LoadPlugins = require(script.LoadPlugins)
	local pluginsToolBar = plugin:CreateToolbar("BTK Plugin Dev")

	--[[
		Reload plugins
	--]]

	local reloadPluginsButton = pluginsToolBar:CreateButton(
		"Reload Plugins",
		"Reload all BTK plugins",
		"rbxassetid://1688365262"
	)

	local function reloadPlugins()
		print "BTKPluginDev: Reloading all plugins"
		LoadPlugins(Plugins)
		print "BTKPluginDev: Finished reloading"
	end
	reloadPluginsButton.Click:connect(reloadPlugins)
end