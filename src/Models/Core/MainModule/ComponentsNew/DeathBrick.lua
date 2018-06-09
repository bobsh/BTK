local EntitySystem = require(script.Parent.Parent.lib.EntitySystem)

local DeathBrick = EntitySystem.Component:extend("DeathBrick", {
	Foo = "foo",
	Up = true,
})

function DeathBrick:added()
	self.maid.touchConn = self.instance.Touched:Connect(function(part)
		part:BreakJoints()
	end)
end

return DeathBrick