local BaseInstance = require(script.Parent.BaseObject)
local PropertiesModule = require(script.Parent.PropertiesModule)
local Schema = require(script.Parent.Schema)

local BaseScript = BaseInstance:subclass(script.name)
BaseScript:include(PropertiesModule)
BaseScript:AddProperty({
	Name = "Script",
	Type = "ObjectValue",
	SchemaFn = Schema.Optional(Schema.OneOf(
		Schema:IsA("Script"),
		Schema:IsA("LocalScript")
	)),
	AllowOverride = false,
})
BaseScript:AddProperty({
	Name = "ConfigurationFolder",
	Type = "ObjectValue",
	SchemaFn = Schema.Optional(
		Schema:IsA("Folder")
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

	self:SetScript(input.Script)
	self:SetConfigurationFolder(self:GetScript():FindFirstChild("Configuration", false))
end

return BaseScript
