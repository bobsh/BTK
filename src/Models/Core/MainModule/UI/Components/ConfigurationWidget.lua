local Roact = require(script.Parent.Parent.Parent.lib.Roact)
local Dropdown = require(script.Parent.Dropdown)
local c = Roact.createElement

local ConfigurationWidget = Roact.Component:extend("ConfigurationWidget")

function ConfigurationWidget:init(_)
    self.state = {}
end

function ConfigurationWidget:render()
    return c("Frame", {})
end

return ConfigurationWidget