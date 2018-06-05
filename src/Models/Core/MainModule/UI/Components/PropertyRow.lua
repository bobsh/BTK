--[[--
    PropertyRow widget item
    @classmod UI.PropertyRow
    @export
--]]

local Roact = require(script.Parent.Parent.Parent.lib.Roact)
local RoactStudioWidgets = require(script.Parent.Parent.Parent.lib.RoactStudioWidgets)
local PropertyRow = Roact.Component:extend("PropertyRow")
local c = Roact.createElement

local fontSize = 12
local tableBorderColor = Color3.fromRGB(214, 214, 214)
local textColor = Color3.fromRGB(0, 0, 0)
local hoverColor = Color3.fromRGB(209,233,247)

local function TextBox(props)
    return c("TextBox", {
        ClearTextOnFocus = false,
        Font = Enum.Font.Arial,
        MultiLine = false,
        ShowNativeInput = true,
        TextColor3 = textColor,
        TextSize = fontSize,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = props.Text,
        Size = UDim2.new(1, 0, 1, 0),
    }, {
        c("UISizeConstraint", {
            MinSize = Vector2.new(128, 24),
        }),
    })
end

function PropertyRow:init(props)
    self.state = {
        Name = props.Name,
        Type = props.Type,
        Value = props.Value,
        AllowOverride = props.AllowOverride or false,

        BackgroundColor = props.BackgroundColor,
        CurrentColor = props.CurrentColor or props.BackgroundColor,
    }
end

function PropertyRow:render()
    local fieldEditor
    if self.state.Type == "StringValue" then
        fieldEditor = c(TextBox, {
            Text = self.state.Value,
        })
    elseif self.state.Type == "NumerValue" then
        fieldEditor = c(TextBox, {
            Text = self.state.Value,
        })
    elseif self.state.Type == "IntValue" then
        fieldEditor = c(TextBox, {
            Text = self.state.Value,
        })
    elseif self.state.Type == "ObjectValue" then
        fieldEditor = c(TextBox, {
            Text = self.state.Value,
        })
    elseif self.state.Type == "Vector3Value" then
        fieldEditor = c(TextBox, {
            Text = self.state.Value,
        })
    elseif self.state.Type == "BoolValue" then
        fieldEditor = c(RoactStudioWidgets.Checkbox, {})
    end

    return c("Frame", {
        Size = UDim2.new(0, 128, 0, 24),
        BackgroundTransparency = 0,
        BackgroundColor3 = self.state.CurrentColor,
        BorderSizePixel = 1,
        BorderColor3 = tableBorderColor,
        ClipsDescendants = true,
        SizeConstraint = Enum.SizeConstraint.RelativeXX,
        Selectable = true,

        [Roact.Event.InputBegan] = function(_, input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                self:setState({
                    CurrentColor = hoverColor,
                })
            end
        end,

        [Roact.Event.InputEnded] = function(_, input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                self:setState({
                    CurrentColor = self.state.BackgroundColor,
                })
            end
        end,

    }, {
        c("TextLabel", {
            Font = Enum.Font.ArialBold,
            TextColor3 = textColor,
            TextSize = fontSize,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
        }, {
            c("UISizeConstraint", {
                MaxSize = Vector2.new(24, 24),
                MinSize = Vector2.new(24, 24),
            }),
        }),
        c("TextLabel", {
            Font = Enum.Font.Arial,
            TextColor3 = textColor,
            TextSize = fontSize,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = self.state.Name,
        }, {
            c("UISizeConstraint", {
                MaxSize = Vector2.new(128, 24),
                MinSize = Vector2.new(128, 24),
            }),
        }),
        c("Frame", {
            BackgroundTransparency = 0,
            BackgroundColor3 = self.state.CurrentColor,
            BorderSizePixel = 1,
            BorderColor3 = tableBorderColor,
            ClipsDescendants = true,
            SizeConstraint = Enum.SizeConstraint.RelativeXX,
        }, {
            c("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
            }),
            c("UIPadding", {
                PaddingLeft = UDim.new(0,5),
            }),
            fieldEditor,
        }),
    })
end

return PropertyRow