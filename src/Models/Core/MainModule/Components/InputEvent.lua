--- InputEvent component
--
-- @classmod Components.InputEvent

local ECS = require(script.Parent.Parent.ECS)
local Schema = require(script.Parent.Schema)

local InputEvent = ECS.BaseComponent:subclass(script.Name)
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