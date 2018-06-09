--- Model component
--
-- @classmod Components.Model


local BaseInstance = require(script.Parent.Parent.BaseInstance)
local Schema = require(script.Parent.Parent.Schema)
local Component = require(script.Parent.Parent.ECS.Component)

local Model = BaseInstance:subclass(script.Name)
Model:include(Component)
Model:Component({
	Properties = {
		{
			Name = "Model",
			Type = "ObjectValue",
			ValueFn = function(self)
				return self.Entity.Parent
			end,
			SchemaFn = Schema.Optional(Schema:IsA("Model")),
			AllowOverride = true,
		},
	},
})

return Model