local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local Tool = EntitySystem.Component:extend("Tool", {
    Owner = "TODO",
    Equipped = true,
})

function Tool:added()
    local _ = self
end

return Tool