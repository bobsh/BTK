local Model = require(script.Parent.Model)
local Schema = require(script.Parent.Parent.Schema)

local Smashable = Model:subclass(script.Name)

function Smashable:initialize(input)
	Model.initialize(self, input)

	self:GetInputEvent().Event:Connect(function(input2)
		self:AssertSchema(
			input2,
			Schema:Message()
		)

		if input2.Type == Schema.Enums.InputEventType.Damage then
			self:Dbg("Received damage")
			self:Destroy()
		end
	end)
end

return Smashable