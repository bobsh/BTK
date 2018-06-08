--- @classmod scripts.Waypoints

local Model = require(script.Parent.Model)

local Waypoints = Model:subclass(script.Name)

function Waypoints:initialize(input)
	Model.initialize(self, input)
end

return Waypoints
