local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local Currency = EntitySystem.Component:extend("Currency", {
    Units = 1,
})

function Currency:added()
    local _ = self
end

return Currency