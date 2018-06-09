--[[--
	RunDemo
	@classmod UI.RunDemo
--]]

local BaseUtil = require(script.Parent.Parent.BaseUtil)
local Roact = require(script.Parent.Parent.lib.Roact)
local c = Roact.createElement
local Demo = require(script.Parent.Components.Demo)

local RunDemo = BaseUtil:subclass(script.Name)

--- Init
-- @function new
function RunDemo:initialize(input)
    self:AssertSchema(
        input,
        self.Schema.Record {
            Script = self.Schema.Script,
        }
    )

    local app = c("ScreenGui", {
        Name = "Demo",
    }, {
        Demo = c(Demo)
    })

    Roact.mount(app, input.Script.Parent.Parent.PlayerGui)
end

return RunDemo