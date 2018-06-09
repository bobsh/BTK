local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local Server = EntitySystem.Component:extend("Server", {

})

function Server:added()
    local _ = self
end

return Server