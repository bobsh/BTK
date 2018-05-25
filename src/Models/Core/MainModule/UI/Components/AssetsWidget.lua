--[[--
    Assets widget
    @classmod UI.AssetsWidget
--]]

local Roact = require(script.Parent.Parent.Parent.lib.Roact)
local Dropdown = require(script.Parent.Dropdown)
local AssetItem = require(script.Parent.AssetItem)
local c = Roact.createElement

local AssetsWidget = Roact.Component:extend("AssetsWidget")

function AssetsWidget:init(props)
    self.state = {
        Plugin = props.Plugin,
        CurrentCategory = nil,
        Assets = {
            NPC = {
                -- Frog
                1667638075
            },
            Tools = {
                -- Hammer
                1637181997,
                -- Nommy Gun
                1673945800
            },
            Utilities = {
                -- Waypoints
                1667667072,
                -- Area
                1667505353,
            }
        }
    }
end

function AssetsWidget:render()
    local items = {}

    local propsType = "Model"
    if self.state.CurrentCategory == "Tools" then
        propsType = "Tool"
    end

    -- Only add try to add asset items if a category is chosen
    if self.state.CurrentCategory then
        for _, v in pairs(self.state.Assets[self.state.CurrentCategory]) do
            table.insert(items, c(AssetItem, {
                ID = v,
                Plugin = self.Plugin,
                Type = propsType,
            }))
        end
    end

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
                ChangeFn = function(item)
                    self:setState({
                        CurrentCategory = item,
                    })
                end
            })
        }),
        AssetList = c("ScrollingFrame", {
            Position = UDim2.new(0, 0, 0, 32),
            Size = UDim2.new(1.0, 0, 1.0, -32),
            BackgroundTransparency = 1,
        }, {
            c("UIListLayout"),
            unpack(items),
        })
    })
end

return AssetsWidget