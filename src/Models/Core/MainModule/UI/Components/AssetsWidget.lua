--[[--
    Assets widget
    @classmod UI.AssetsWidget
--]]

local Roact = require(script.Parent.Parent.Parent.lib.Roact)
local Dropdown = require(script.Parent.Dropdown)
local c = Roact.createElement

local AssetsWidget = Roact.Component:extend("AssetsWidget")

local function AssetItem(props)
    return c("Frame", {
        Size = UDim2.new(1.0, 0, 0, 96),
    }, {
        Button = c("ImageButton", {
            Size = UDim2.new(0, 96, 0, 96),
            Style = Enum.ButtonStyle.Custom,
            AutoButtonColor = true,
            ImageColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 1,
        }),
        Name = c("TextLabel", {
            Position = UDim2.new(0, 100, 0, 0),
            Size = UDim2.new(0, 128, 0, 16),
            Text = props.Name,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextColor3 = Color3.new(0,0,0),
            TextSize = 14,
            Font = Enum.Font.SourceSansBold,
            BackgroundTransparency = 1.0,
            Visible = true,
        }),
        Description = c("TextLabel", {
            Position = UDim2.new(0, 100, 0, 16),
            Size = UDim2.new(0, 128, 0, 80),
            Text = props.Description,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextColor3 = Color3.new(0,0,0),
            TextSize = 14,
            Font = Enum.Font.SourceSans,
            BackgroundTransparency = 1.0,
            Visible = true,
        })
    })
end

function AssetsWidget:init(_)
    self.state = {}
end

function AssetsWidget:render()
    local _ = self -- lint
    return c("Frame", {
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1.0, 0, 1.0, 0),
        BackgroundTransparency = 1,
    }, {
        TypeFrame = c("Frame", {
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1.0, 0, 0, 32),
            BackgroundTransparency = 1,
        },{
            TypeChosen = c(Dropdown, {
                Items = {
                    "NPC",
                    "Utilities",
                    "Tools",
                },
                CurrentItem = "NPC",
            })
        }),
        AssetList = c("ScrollingFrame", {
            Position = UDim2.new(0, 0, 0, 32),
            Size = UDim2.new(1.0, 0, 1.0, 0),
            BackgroundTransparency = 1,
        }, {
            First = c(AssetItem, {
                Name = "Foo",
                Description = "Bar",
            })
        })
    })
end

return AssetsWidget