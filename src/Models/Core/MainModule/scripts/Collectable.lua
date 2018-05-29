--- @classmod scripts.Collectable

local Model = require(script.Parent.Model)
local Schema = require(script.Parent.Parent.Schema)

local Collectable = Model:subclass(script.Name)

Collectable:AddProperty({
    Name = "CollectablePart",
    Type = "ObjectValue",
    SchemaFn = Schema.Optional(Schema:IsA("BasePart")),
})

Collectable:AddProperty({
    Name = "CollectableAttachment",
    Type = "ObjectValue",
    SchemaFn = Schema.Optional(Schema:IsA("Attachment")),
})

function Collectable:initialize(input)
    Model.initialize(self, input)
    self:SetCollectableAttachment(self:GetPrimaryPart())
    self:SetCollectableAttachment(Instance.new("Attachment", self:GetCollectablePart()))
end

return Collectable