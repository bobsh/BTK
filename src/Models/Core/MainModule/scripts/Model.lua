local BaseScript = require(script.Parent.Parent.BaseScript)
local Schema = require(script.Parent.Parent.Schema)

local Model = BaseScript:subclass(script.Name)
Model:AddProperty({
	Name = "Model",
    Type = "ObjectValue",
    ValueFn = function(self2)
        return self2:GetScript().Parent
    end,
	SchemaFn = Schema:IsA("Model"),
	AllowOverride = true,
})
Model:AddProperty({
	Name = "PrimaryPart",
    Type = "ObjectValue",
    ValueFn = function(self2)
        return self2:GetModel().PrimaryPart
    end,
	SchemaFn = Schema:IsA("BasePart"),
	AllowOverride = false,
})

function Model:initialize(input)
    BaseScript.initialize(self, input)
end

return Model