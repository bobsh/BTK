local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local Teleporter = EntitySystem.Component:extend("Teleporter", {
    Target = "TODO objects",
    Offset = Vector3.new(0, 0, 0),
})

function Teleporter:added()
    local _ = self
end

return Teleporter