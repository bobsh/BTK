local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local PlatformMover = EntitySystem.Component:extend("PlatformMover.lua", {
    Part = "TODO",
    StartMarker = "TODO",
    EndMarker = "TODO",
    TimeToMove = 1,
    Increment = 1,
})

function PlatformMover:added()
    local _ = self
end

return PlatformMover.lua