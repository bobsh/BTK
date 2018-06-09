local EntitySystem = require(game.ReplicatedStorage.EntitySystem)
local Character = require(script.Parent.Character)


local NPCState = {
	Dead = "Dead",
	Idle = "Idle",
	MoveToTarget = "MoveToTarget",
	AttackTarget = "AttackTarget",
}

local NPC = EntitySystem.Component:extend("NPC", {
    State = NPCState.Idle,
    LastAttack = 0,
    DistanceToTarget = 0,
    EnemyTarget = "TODO objects",
})

function NPC:added()
    self:Warn("Foo!")
    local _ = self:getComponent(Character)
    self.foo = "bar"
end

return NPC