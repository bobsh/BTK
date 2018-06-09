local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local Character = EntitySystem.Component:extend("Character", {
    AttackDistance = 5.0,
    Humanoid = "TODO objects",
})

function Character:added()
    self.foo = "bar"
end

return Character