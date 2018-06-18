local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local InputEvent = EntitySystem.Component:extend("InputEvent", {
    InputEventPart = "TODO objects",
})

function InputEvent:added()
	if not self.InputEventPart then
		local event = Instance.new("BindableEvent", self.Entity)
		event.Name = "InputEvent"
		self.InputEventPart = event
	end
end

return InputEvent