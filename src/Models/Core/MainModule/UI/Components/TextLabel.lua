--[[--
    widget
    @classmod UI.TextLabel
--]]

local Roact = require(script.Parent.Parent.Parent.lib.Roact)
local c = Roact.createElement

local TextLabel = Roact.Component:extend("BTKTextLabel")

function TextLabel:init(props)
    self.state = {
        Size = props.Size,
        Text = props.Text,
    }
end

function TextLabel:render()
    return c("TextLabel", {
        Size = self.state.Size,
        Text = self.state.Text,

        Font = Enum.Font.Legacy,
        Position = UDim2.new(0,0,0,0),
        TextSize = 8,
        TextColor3 = Color3.new(0,0,0),
        TextYAlignment = Enum.TextYAlignment.Top,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
    })
end

return TextLabel