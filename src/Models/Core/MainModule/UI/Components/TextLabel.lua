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
        Bold = props.Bold,
    }
end

function TextLabel:render()
    local f = Enum.Font.Arial
    if self.state.Bold then
        f = Enum.Font.ArialBold
    end
    return c("TextLabel", {
        Size = self.state.Size,
        Text = self.state.Text,

        Font = f,
        Position = UDim2.new(0,0,0,0),
        TextSize = 12,
        TextColor3 = Color3.new(0,0,0),
        TextYAlignment = Enum.TextYAlignment.Center,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
    }, self.state[Roact.Children])
end

return TextLabel