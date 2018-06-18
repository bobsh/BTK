local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local Model = EntitySystem.Component:extend("Model", {
    Model = "TODO objects",
})

function Model:added()
    if not self.Model then
        self.Model = self.instance
    end
end

return Model