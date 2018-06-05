--[[--
    ComponentEditor widget item
    @classmod UI.ComponentEditor
    @export
--]]

local Roact = require(script.Parent.Parent.Parent.lib.Roact)
local ComponentEditor = Roact.Component:extend("ComponentEditor")
local PropertyRow = require(script.Parent.PropertyRow)
local c = Roact.createElement

function ComponentEditor:init(props)
    self.state = {
        Component = props.Component,
        Expanded = props.Expanded or true,
    }
end

local fontSize = 12
local headerBackground = Color3.fromRGB(228, 228, 228)
local propertyBackground1 = Color3.fromRGB(247, 247, 247)
local propertyBackground2 = Color3.fromRGB(255, 255, 255)
local widgetBackground = Color3.fromRGB(255, 255, 255)
local tableBorderColor = Color3.fromRGB(214, 214, 214)
local textColor = Color3.new(0, 0, 0)

function ComponentEditor:render()
    local properties = {}
    for _, v in pairs(self.state.Component:GetProperties()) do
        local background = propertyBackground1
        if #properties % 2 then
            background = propertyBackground2
        end
        table.insert(properties, c(PropertyRow, {
            BackgroundColor = background,
            Name = v.Name,
            Value = v.Value,
            Type = v.Type,
        }))
    end

    local compHeight = ((#properties + 1) * 24) + 2
    if not self.state.Expanded then
        compHeight = 26
    end

    return c("Frame", {
        Size = UDim2.new(1.0, 0, 0, compHeight),
        BackgroundColor3 = widgetBackground,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        SizeConstraint = Enum.SizeConstraint.RelativeXY,
    }, {
        HeaderAndPropsLayout = c("UIListLayout"),
        ["1_Header"] = c("Frame", {
            Size = UDim2.new(1.0, 0, 0, 24),
            BackgroundTransparency = 0,
            BorderSizePixel = 1,
            BorderColor3 = tableBorderColor,
            BackgroundColor3 = headerBackground,
            ClipsDescendants = true,
            SizeConstraint = Enum.SizeConstraint.RelativeXY,
        }, {
            HeaderLayout = c("UITableLayout", {
                FillEmptySpaceColumns = true,
                FillEmptySpaceRows = false,
                Padding = UDim2.new(0, 0, 0, 0),
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                VerticalAlignment = Enum.VerticalAlignment.Top,
            }),
            HeaderSizeConstraint = c("UISizeConstraint", {
                MaxSize = Vector2.new(1024, 24),
            }),
            ["1_Header"] = c("Frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                SizeConstraint = Enum.SizeConstraint.RelativeXX,
            }, {
                c("TextButton", {
                    Font = Enum.Font.Arial,
                    TextColor3 = textColor,
                    TextSize = fontSize,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Text = "V",

                    [Roact.Event.MouseButton1Click] = function()
                        self:setState(function(old)
                            if old.Expanded then
                                old.Expanded = false
                            else
                                old.Expanded = true
                            end
                            return old
                        end)
                    end
                }, {
                    c("UISizeConstraint", {
                        MaxSize = Vector2.new(24, 24),
                        MinSize = Vector2.new(24, 24),
                    })
                }),
                c("TextLabel", {
                    Font = Enum.Font.ArialBold,
                    TextColor3 = textColor,
                    TextSize = fontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Text = self.state.Component:GetClassName(),
                }, {
                    c("UISizeConstraint", {
                        MaxSize = Vector2.new(128, 24),
                        MinSize = Vector2.new(24, 24),
                    }),
                }),
                c("TextLabel", {
                    Font = Enum.Font.ArialBold,
                    TextColor3 = textColor,
                    TextSize = fontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Text = "",
                }, {
                    c("UISizeConstraint", {
                        MaxSize = Vector2.new(1024, 24),
                        MinSize = Vector2.new(24, 24),
                    }),
                }),
            }),
        }),
        ["2_Properties"] = c("Frame", {
            Size = UDim2.new(1.0, 0, 1.0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            SizeConstraint = Enum.SizeConstraint.RelativeXY,
        }, {
            PropertiesLayout = c("UITableLayout", {
                FillEmptySpaceColumns = true,
                FillEmptySpaceRows = false,
                Padding = UDim2.new(0, 0, 0, 0),
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                VerticalAlignment = Enum.VerticalAlignment.Top,
            }),
            unpack(properties),
        }),
    })
end



return ComponentEditor