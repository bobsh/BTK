local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local Collectable = EntitySystem.Component:extend("Collectable", {
    CollectablePart = nil,
    CollectableAttachment = nil,
})

function Collectable:added()
        local _ = self
        if not self.CollectablePart then
            self.CollectablePart = self.instance:GetPrimaryPart()
        end

        if not self.CollectableAttachment then
            local at = Instance.new("Attachment", self.CollectablePart)
            at.Name = "CollectableAttachment"
        end
end

return Collectable