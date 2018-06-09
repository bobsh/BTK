--- @classmod scripts.Collectable

local BaseInstance = require(script.Parent.Parent.BaseInstance)
local Component = require(script.Parent.Parent.ECS.Componet)
local Schema = require(script.Parent.Parent.Schema)

local Collectable = BaseInstance:subclass(script.Name)
Collectable:include(Component)
Collectable:Component({
    Properties = {
        {
            Name = "CollectablePart",
            Type = "ObjectValue",
            SchemaFn = Schema.Optional(Schema:IsA("BasePart")),
        },
        {
            Name = "CollectableAttachment",
            Type = "ObjectValue",
            SchemaFn = Schema.Optional(Schema:IsA("Attachment")),
        }
    },
    Dependencies = {
        "Model"
    },
})

function Collectable:initialize(input)
    BaseInstance.initialize(self, input)
    self:SetCollectableAttachment(self:GetPrimaryPart())
    self:SetCollectableAttachment(Instance.new("Attachment", self:GetCollectablePart()))
end

return Collectable