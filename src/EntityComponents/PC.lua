local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local PC = EntitySystem.Component:extend("PC", {
    Player = "TODO objects",
    Currency = 0,
    CollectCollision = "TODO objects",
    CollectAttachment = "TODO objects",
})

function PC:added()
    local _ = self
end

return PC