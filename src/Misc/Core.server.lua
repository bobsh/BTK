local EntitySystem = require(script.Parent.EntitySystem)

-- The array we pass here is a list of arguments. This is where we'll
-- pass plugins and other data.
local core = EntitySystem.Core.new({})

-- The folder from earlier.
local componentsFolder = script.Parent.ComponentsNew
-- We put them all together so that we don't have to manually list them here.
for _,module in pairs(componentsFolder:GetChildren()) do
	-- registerComponent() takes a component description, which is what we created earlier in that snippet.
	core:registerComponent(require(module))
end