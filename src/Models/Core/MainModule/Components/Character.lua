--- Character component
--
-- @classmod Components.Character

local ECS = require(script.Parent.Parent.ECS)
local Components = require(script.Parent)
local Schema = require(script.Parent.Schema)

local Character = ECS.BaseComponent:subclass(script.Name)
Character:RequireComponent(Components.Model)
Character:RequireComponent(Components.InputEvent)
Character:AddProperty({
	Name = "AttackDistance",
    Type = "NumberValue",
    Value = 5.0,
	SchemaFn = Schema.AttackDistance,
	AllowOverride = false,
})
Character:AddProperty({
	Name = "Humanoid",
    Type = "ObjectValue",
    ValueFn = function(self)
        return self.Model.GetModel():FindFirstChildOfClass("Humanoid")
    end,
	SchemaFn = Schema.Optional(Schema:IsA("Humanoid")),
	AllowOverride = true,
})

return Character