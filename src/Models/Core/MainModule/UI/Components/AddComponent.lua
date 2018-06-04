--[[--
    widget
    @classmod UI.AddComponent
--]]

local Roact = require(script.Parent.Parent.Parent.lib.Roact)
local Dropdown = require(script.Parent.Dropdown)

local AddComponent = Roact.Component:extend("AddComponent")

local c = Roact.createElement
local widgetBackground = Color3.fromRGB(255, 255, 255)

function AddComponent:init(props)
    self.state = {
        CurrentSelection = props.CurrentSelection,
    }
end

function AddComponent:render()
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
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Top,
        }),
        c("TextLabel", {
            Font = Enum.Font.ArialBold,
            Text = "Add Component",
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            BackgroundColor3 = Color3.new(0.8, 0.8, 0.8),
            BackgroundTransparency = 0,
            BorderSizePixel = 1,
            ClipsDescendants = true,
            Size = UDim2.new(1, 0, 0, 24),
        }),
        c("Frame", {
            Size = UDim2.new(1.0, 0, 0, 64),
            BackgroundColor3 = widgetBackground,
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            SizeConstraint = Enum.SizeConstraint.RelativeXY,

        }, {
            c("UIListLayout", {
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
            }),
            Dropdown = c(Dropdown, {
                Items = {"Model", "Character"},
                ChangeFn = function(i)
                    print("Item selected: " .. i)
                end,
            }),
        }),
        c("Frame", {
            Size = UDim2.new(1.0, 0, 0, 64),
            BackgroundColor3 = widgetBackground,
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            SizeConstraint = Enum.SizeConstraint.RelativeXY,
        }, {
            c("UIListLayout", {
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
            }),
            c("TextButton", {
                Font = Enum.Font.Arial,
                Text = "Add",
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
            }),
        }),
    })
end

return AddComponent