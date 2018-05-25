--[[--
    widget
    @classmod UI.ConfigurationWidget
--]]

local Roact = require(script.Parent.Parent.Parent.lib.Roact)
local c = Roact.createElement

local ConfigurationWidget = Roact.Component:extend("ConfigurationWidget")

function ConfigurationWidget:init(_)
    self.state = {}
end

function ConfigurationWidget:render()
    local _ = self -- lint
    return c("Frame", {})
end

return ConfigurationWidget