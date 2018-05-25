--- @classmod scripts.Collectable

local Model = require(script.Parent.Model)
local Schema = require(script.Parent.Parent.Schema)

local Collectable = Model:subclass(script.Name)

Collectable:AddProperty({
    Name = "CollectablePart",
    Type = "ObjectValue",
    ValueFn = function(self2)
        return self2:GetPrimaryPart()
    end,
    SchemaFn = Schema:IsA("BasePart"),
})

Collectable:AddProperty({
    Name = "CollectableAttachment",
    Type = "ObjectValue",
    ValueFn = function(self2)
        return Instance.new("Attachment", self2:GetCollectablePart())
    end,
    SchemaFn = Schema:IsA("Attachment"),
})

function Collectable:initialize(input)
    Model.initialize(self, input)
end

return Collectable