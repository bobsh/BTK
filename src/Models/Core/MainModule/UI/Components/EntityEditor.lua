--[[--
    widget
    @classmod UI.EntityEditor
--]]

local Roact = require(script.Parent.Parent.Parent.lib.Roact)
local c = Roact.createElement
local ComponentEditor = require(script.Parent.ComponentEditor)

local EntityEditor = Roact.Component:extend("EntityEditor")

local widgetBackground = Color3.fromRGB(255, 255, 255)

function EntityEditor:init(props)
    self.state = {
        Script = props.Script,
    }
end

function EntityEditor:render()
    local _ = self
    return c("Frame", {
        Size = UDim2.new(1.0, 0, 1.0, 0),
        BackgroundColor3 = widgetBackground,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        SizeConstraint = Enum.SizeConstraint.RelativeXY,
    }, {
        c("UIListLayout", {
        }),
        c(ComponentEditor, {
            Name = "Character",
        }),
        c(ComponentEditor, {
            Name = "NPC",
        }),
        c("TextButton", {
            Font = Enum.Font.Arial,
            Text = "Add Component",
            TextSize = 12,
            AutoButtonColor = true,
            BackgroundColor3 = Color3.new(0.8, 0.8, 0.8),
            BackgroundTransparency = 0,
            ClipsDescendants = true,

            [Roact.Event.MouseButton1Click] = function(_)
                print "TODO"
            end,
        }, {
            c("UISizeConstraint", {
                MinSize = Vector2.new(120, 24),
            }),
        })
    })
end

return EntityEditor