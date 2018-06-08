--- Component module
-- @module ECS.Component

local Component = {
	_component = {}
}

local Schema = require(script.Parent.Parent.Schema)

function Component:included(klass)
	local _ = self
    print(klass.name .. ' included')
end

Component.ComponentDefinition = Schema.Record {
	Properties = Schema.Collection(Schema.PropertyDefinition),
	Dependencies = Schema.Optional(
		Schema.Collection(Schema.DataKey)
	)
}

function Component:Component(input)
	self:AssertSchema(
		input,
		Component.ComponentDefinition
	)
end

return Component