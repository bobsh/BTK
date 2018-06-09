local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local Smashable = EntitySystem.Component:extend("Smashable", {
})

function Smashable:added()
    local _ = self
end

return Smashable