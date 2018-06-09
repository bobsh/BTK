--[[--
	UI
	@classmod UI
--]]

local BaseUtil = require(script.Parent.BaseUtil)

local UI = BaseUtil:subclass(script.Name)

for _, component in ipairs(script:WaitForChild("Components"):GetChildren()) do
	UI.static[component.Name] = require(component)
end

--- @{RunDemo}
UI.static.RunDemo = require(script.RunDemo)

return UI