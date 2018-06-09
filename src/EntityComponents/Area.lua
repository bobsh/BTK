local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local Area = EntitySystem.Component:extend("Area", {
    AreaPart = "TODO objects",
})

function Area:added()
    local _ = self
end

return Area