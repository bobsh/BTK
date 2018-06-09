local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local Character = EntitySystem.Component:extend("Character", {
    AttackDistance = 5.0,
    Humanoid = "foo",
})

function Character:added()
    self.foo = "bar"
end

return Character