--- @classmod BaseScript

local BaseInstance = require(script.Parent.BaseObject)
local PropertiesModule = require(script.Parent.PropertiesModule)
local Schema = require(script.Parent.Schema)

local BaseScript = BaseInstance:subclass(script.Name)
BaseScript:include(PropertiesModule)
BaseScript:AddProperty({
	Name = "InputEvent",
	Type = "ObjectValue",
	SchemaFn = Schema.Optional(
		Schema:IsA("BindableEvent")
	),
	AllowOverride = false,
})

function BaseScript:initialize(input)
	BaseInstance.initialize(self, input)

	self:AssertSchema(
		input,
		Schema.Record {
			Script = Schema.Script,
		}
	)

	-- Initialize all the runtime instances for our properties
	self:InitProperties(input)

	local event = Instance.new("BindableEvent", self:GetScript())
	event.Name = "InputEvent"
	self:SetInputEvent(event)
end

return BaseScript
