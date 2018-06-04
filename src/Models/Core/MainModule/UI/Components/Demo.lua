--[[--
    Demo widget item
    @classmod UI.Demo
    @export
--]]

local Roact = require(script.Parent.Parent.Parent.lib.Roact)
local Demo = Roact.Component:extend("Demo")
local c = Roact.createElement

-- Get our demo components
local Dropdown = require(script.Parent.Dropdown)
local AssetItem = require(script.Parent.AssetItem)
local EntityEditor = require(script.Parent.EntityEditor)
local ComponentEditor = require(script.Parent.ComponentEditor)
local PropertyRow = require(script.Parent.PropertyRow)
local AddComponent = require(script.Parent.AddComponent)

function Demo:init(_)
    self.state = {
        CurrentItem = "None",
    }
end

function Demo:render()
    local padding = UDim.new(0.05)
    local frameColor = Color3.fromRGB(232, 214, 243)

    local demoButtons = {
        ButtonsLayout = c("UIListLayout", {
            Padding = UDim.new(0, 10),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Top,
        }),
        c("TextLabel", {
            Font = Enum.Font.ArialBold,
            Text = "Components",
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            BackgroundColor3 = Color3.new(0.8, 0.8, 0.8),
            BackgroundTransparency = 0,
            BorderSizePixel = 1,
            ClipsDescendants = true,
            Size = UDim2.new(1, 0, 0, 24),
        }),
    }

    for k, _ in pairs(Demo._demos) do
        demoButtons[k] = c("TextButton", {
            Font = Enum.Font.Arial,
            Text = k,
            TextSize = 12,
            AutoButtonColor = true,
            BackgroundColor3 = Color3.new(0.8, 0.8, 0.8),
            BackgroundTransparency = 0,
            ClipsDescendants = true,

            [Roact.Event.MouseButton1Click] = function(_)
                self:setState({
                    CurrentItem = k,
                })
            end,
        }, {
            c("UISizeConstraint", {
                MaxSize = Vector2.new(140, 24),
                MinSize = Vector2.new(120, 24),
            }),
        })
    end

    return c("Frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Size = UDim2.new(1, 0, 1, 0),
    }, {
        c("UIPadding", {
            PaddingBottom = padding,
            PaddingLeft = padding,
            PaddingRight = padding,
            PaddingTop = padding,
        }),
        c("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 2),
        }),
        Buttons = c("Frame", {
            BackgroundColor3 = frameColor,
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Size = UDim2.new(0.2, 0, 1, 0),
        }, demoButtons),
        Example = c("Frame", {
            BackgroundColor3 = frameColor,
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Size = UDim2.new(0.8, 0, 1, 0),
        }, {
            c("UIListLayout", {
                Padding = UDim.new(0, 10),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Top,
            }),
            c("TextLabel", {
                Font = Enum.Font.ArialBold,
                Text = "Demo Area",
                TextSize = 18,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                BackgroundColor3 = Color3.new(0.8, 0.8, 0.8),
                BackgroundTransparency = 0,
                BorderSizePixel = 1,
                Size = UDim2.new(1, 0, 0, 24),
            }),
            c("Frame", {
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 0,
                BorderSizePixel = 1,
                ClipsDescendants = true,
                Size = UDim2.new(0.9, 0, 0.9, 0),
            }, {
                c("UIListLayout"),
                DemoContent = Demo._demos[self.state.CurrentItem]
            }),
        })
    })
end

Demo._demos = {
    None = c("TextLabel", {
        Font = Enum.Font.Arial,
        Text = "No demo chosen",
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
    }),
    Dropdown = c(Dropdown, {
        Items = {"First", "Second"},
        ChangeFn = function(i)
            print("Item selected: " .. i)
        end,
    }),
    TextLabel = c("TextLabel", {
        Font = Enum.Font.Arial,
        Text = "This is an example of our standard text label",
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
    }),
    AssetItem = c(AssetItem, {
        Type = "Tools",
        ID = 1637181997,
    }),
    AssetsWidget = c("TextLabel", {
        Font = Enum.Font.Arial,
        Text = "TODO",
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
    }),
    ComponentEditor = c(ComponentEditor),
    PropertyRow = c(PropertyRow, {
        Name = "Mine",
        Value = "",
        Type = "StringValue",
        BackgroundColor = Color3.new(255,255,255),
    }),
    EntityEditor = c(EntityEditor, {
    }),
    AddComponent = c(AddComponent, {
    })
}

return Demo