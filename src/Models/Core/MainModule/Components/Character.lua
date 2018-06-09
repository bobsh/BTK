--- Character component
--
-- @classmod Components.Character

local BaseInstance = require(script.Parent.Parent.xBaseInstance)
local Component = require(script.Parent.Parent.ECS.Component)
local Schema = require(script.Parent.Parent.Schema)

local Character = BaseInstance:subclass(script.Name)
Character:include(Component)
Character:Component({
    Properties = {
        {
            Name = "AttackDistance",
            Type = "NumberValue",
            Value = 5.0,
            SchemaFn = Schema.AttackDistance,
            AllowOverride = false,
        },
        {
            Name = "Humanoid",
            Type = "ObjectValue",
            ValueFn = function(self)
                return self.Model.GetModel():FindFirstChildOfClass("Humanoid")
            end,
            SchemaFn = Schema.Optional(Schema:IsA("Humanoid")),
            AllowOverride = true,
        }
    },
    Dependencies = {
        "Model",
        "InputEvent",
    },
})

return Character