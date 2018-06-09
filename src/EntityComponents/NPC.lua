local EntitySystem = require(game.ReplicatedStorage.EntitySystem)
local Character = require(script.Parent.Character)

local NPC = EntitySystem.Component:extend("NPC", {
    State = "Alive",
    LastAttack = 0,
    DistanceToTarget = 100,
})

function NPC:added()
    local _ = self:getComponent(Character)
    self.foo = "bar"
end

return NPC