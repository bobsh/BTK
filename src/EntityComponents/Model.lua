local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local Model = EntitySystem.Component:extend("Model", {
    Model = "TODO objects",
})

function Model:added()
    local _ = self
end

return Model