--- InputEvent component
--
-- @classmod Components.InputEvent
local BaseInstance = require(script.Parent.Parent.BaseInstance)
local Schema = require(script.Parent.Parent.Schema)
local Component = require(script.Parent.Parent.ECS.Component)

local InputEvent = BaseInstance:subclass(script.Name)
InputEvent:include(Component)
InputEvent:Component({
	Properties = {
		{
			Name = "InputEvent",
			Type = "ObjectValue",
			ValueFn = function(self)
				local event = Instance.new("BindableEvent", self.Entity)
				event.Name = "InputEvent"
				return event
			end,
			SchemaFn = Schema.Optional(
				Schema:IsA("BindableEvent")
			),
			AllowOverride = false,
		},
	},
})

return InputEvent