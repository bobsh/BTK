--- Model component
--
-- @classmod Components.Model

local ECS = require(script.Parent.Parent.ECS)
local Schema = require(script.Parent.Parent.Schema)

local Model = ECS.BaseComponent:subclass(script.Name)
Model:AddProperty({
	Name = "Model",
	Type = "ObjectValue",
	ValueFn = function(self)
		return self.Entity.Parent
	end,
	SchemaFn = Schema.Optional(Schema:IsA("Model")),
	AllowOverride = true,
})

return Model