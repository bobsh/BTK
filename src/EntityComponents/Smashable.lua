local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local Smashable = EntitySystem.Component:extend("Smashable", {
})

function Smashable:added()
    local _ = self

    self:GetInputEvent().Event:Connect(function(input2)
		self:AssertSchema(
			input2,
			self.Schema:Message()
		)

		if input2.Type == self.Schema.Enums.InputEventType.Damage then
			self:Dbg("Received damage")
			self:Destroy()
		end
	end)
end

return Smashable