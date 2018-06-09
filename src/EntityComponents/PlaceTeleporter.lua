local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local PlaceTeleporter = EntitySystem.Component:extend("PlaceTeleporter", {
    TeleportPlaceId = 0,
    ReserveInstand = true,
})

function PlaceTeleporter:added()
    local _ = self
end

return PlaceTeleporter