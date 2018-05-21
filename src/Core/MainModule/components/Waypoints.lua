local ModelComponent = require(script.Parent.ModelComponent)

local Waypoints = ModelComponent:subclass(script.Name)

function Waypoints:initialize(input)
	ModelComponent.initialize(self, input)	
	
	self.WaypointFolder = self:GetConfiguration("WaypointFolder")
	self.Waypoints = self.WaypointFolder:GetChildren()
end

return Waypoints
