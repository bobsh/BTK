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
local TextLabel = require(script.Parent.TextLabel)
local AssetItem = require(script.Parent.AssetItem)

function Demo:init(_)
    self.state = {
        CurrentItem = "None",
    }
end

function Demo:render()
    local demoButtons = {
        c("UIListLayout"),
    }
    for k, _ in pairs(Demo._demos) do
        demoButtons[k] = c("TextButton", {
            Text = k,
            Size = UDim2.new(1, 0, 0, 20),

            [Roact.Event.MouseButton1Click] = function(_)
                self:setState({
                    CurrentItem = k,
                })
            end,
        })
    end

    return c("Frame", {
        Size = UDim2.new(0.9, 0, 0.9, 0),
    }, {
        Buttons = c("Frame", {
            Size = UDim2.new(0.3, 0, 1, 0),
        }, demoButtons),

        Example = c("Frame", {
            Size = UDim2.new(0.7, 0, 1, 0),
            Position = UDim2.new(0.3, 0, 0, 0),
        }, {
            DemoContent = Demo._demos[self.state.CurrentItem]
        })
    })
end

Demo._demos = {
    None = c("TextLabel", {
        Text = "No demo chosen",
        Size = UDim2.new(1, 0, 0, 20),
        BorderSizePixel = 0,
    }),
    Dropdown = c(Dropdown, {
        Items = {"First", "Second"},
        ChangeFn = function(i)
            print("Item selected: " .. i)
        end,
    }),
    TextLabel = c(TextLabel, {
        Text = "This is an example of our standard text label",
    }),
    AssetItem = c(AssetItem, {
        Type = "Tools",
        ID = 1637181997,
    }),
}

return Demo