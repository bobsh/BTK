local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local Weapon = EntitySystem.Component:extend("Weapon", {
    Type = "TODO objects",
})

function Weapon:added()
    local _ = self
end

return Weapon