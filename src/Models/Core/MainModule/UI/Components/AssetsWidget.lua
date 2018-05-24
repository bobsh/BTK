local Roact = require(script.Parent.Parent.Parent.lib.Roact)
local Dropdown = require(script.Parent.Dropdown)
local c = Roact.createElement

local AssetsWidget = Roact.Component:extend("AssetsWidget")

function AssetsWidget:init(props)
    self.state = {}
end

function AssetsWidget:render()
    return c("Frame", {
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 0, 0, 0),
    }, {
        TypeFrame = c("Frame", {
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1.0, 0, 0, 32),
        },{
            TypeChosen = c(Dropdown, {
                Items = {
                    "NPC",
                    "Utilities",
                    "Tools",
                },
                CurrentItem = "NPC",
            })
        })
    })
end

return AssetsWidget