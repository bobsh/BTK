--[[--
    Mount a Roact app to the Components ScreenGui instance.
    @module RoactMount
--]]

local EntitySystem = require(game.ReplicatedStorage.EntitySystem)
local Roact = require(game.ReplicatedStorage.Modules.roact.lib)

local RoactMount = EntitySystem.Component:extend("RoactMount", {
    App = "Demo",
})

function RoactMount:added()
    local app = require(game.ReplicatedStorage.BTK.RoactComponents[self.App])
    Roact.mount(app, self.instance)
end

return RoactMount