local EntitySystem = require(script.Parent.EntitySystem)

local DeathBrick = EntitySystem.Component:extend("DeathBrick")

function DeathBrick:added()
	self.maid.touchConn = self.instance.Touched:Connect(function(part)
		part:BreakJoints()
	end)
end

return DeathBrick