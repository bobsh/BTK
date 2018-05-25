--- @classmod scripts.Model

local BaseScript = require(script.Parent.Parent.BaseScript)
local Schema = require(script.Parent.Parent.Schema)

local Model = BaseScript:subclass(script.Name)
Model:AddProperty({
	Name = "Model",
    Type = "ObjectValue",
	SchemaFn = Schema.Optional(Schema:IsA("Model")),
	AllowOverride = true,
})
Model:AddProperty({
	Name = "PrimaryPart",
    Type = "ObjectValue",
	SchemaFn = Schema.Optional(Schema:IsA("BasePart")),
	AllowOverride = false,
})

function Model:initialize(input)
    BaseScript.initialize(self, input)

    self:SetModel(self:GetScript().Parent)
    self:SetPrimaryPart(self:GetModel().PrimaryPart)
end

return Model