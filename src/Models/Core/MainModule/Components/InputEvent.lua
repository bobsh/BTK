--- InputEvent component
--
-- @classmod Components.InputEvent
local BaseComponent = require(script.Parent.Parent.ECS.BaseComponent)
local Schema = require(script.Parent.Parent.Schema)

local InputEvent = BaseComponent:subclass(script.Name)
InputEvent:AddProperty({
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
})

return InputEvent