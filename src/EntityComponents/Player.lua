local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local Player = EntitySystem.Component:extend("Player", {
})

function Player:added()
    local _ = self
end

return Player