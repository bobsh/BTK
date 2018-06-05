--- Character component
--
-- @classmod Components.Character

local BaseComponent = require(script.Parent.Parent.ECS.BaseComponent)
local Model = require(script.Parent.Model)
local InputEvent = require(script.Parent.InputEvent)
local Schema = require(script.Parent.Parent.Schema)

local Character = BaseComponent:subclass(script.Name)
Character:RequireComponent(Model)
Character:RequireComponent(InputEvent)
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