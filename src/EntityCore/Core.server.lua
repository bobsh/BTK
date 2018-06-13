local EntitySystem = require(game.ReplicatedStorage.EntitySystem)
local LoggingPlugin = require(game.ReplicatedStorage.BTK.EntityPlugins.LoggingPlugin)
local AssertSchemaPlugin = require(game.ReplicatedStorage.BTK.EntityPlugins.AssertSchemaPlugin)
local TouchPlugin = require(game.ReplicatedStorage.BTK.EntityPlugins.TouchPlugin)

-- The array we pass here is a list of arguments. This is where we'll
-- pass plugins and other data.
local core = EntitySystem.Core.new({
	plugins = {
		LoggingPlugin,
		AssertSchemaPlugin,
		TouchPlugin,
	}
})

-- The folder from earlier.
local componentsFolder = game.ReplicatedStorage.BTK.EntityComponents
-- We put them all together so that we don't have to manually list them here.
for _,module in pairs(componentsFolder:GetChildren()) do
	print("EntityCore: Registering component " .. module.name)
	-- registerComponent() takes a component description, which is what we created earlier in that snippet.
	core:registerComponent(require(module))
end
