local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local Collectable = EntitySystem.Component:extend("Collectable", {
    CollectablePart = "TODO objects",
    CollectableAttachment = "TODO object",
})

function Collectable:added()
        local _ = self
end

return Collectable