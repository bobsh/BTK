local ModelComponent = require(script.Parent.Parent.ModelComponent)
local Schema = require(script.Parent.Parent.Schema)

local Smashable = ModelComponent:subclass(script.Name)

function Smashable:initialize(input)
	ModelComponent.initialize(self, input)

	self:GetInputEvent().Event:Connect(function(input)
		self:AssertSchema(
			input,
			Schema:Message()
		)

		if input.Type == Schema.Enums.InputEventType.Damage then
			self:Dbg("Received damage")
			self:Destroy()
		end
	end)
end

return Smashable