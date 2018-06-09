local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local InputEvent = EntitySystem.Component:extend("InputEvent", {
    InputEventPart = "TODO objects",
})

function InputEvent:added()
    local _ = self
end

return InputEvent