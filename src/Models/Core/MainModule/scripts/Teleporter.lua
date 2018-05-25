--- @classmod scripts.Teleporter

local Model = require(script.Parent.Model)
local TouchUtil = require(script.Parent.Parent.TouchUtil)
local Schema = require(script.Parent.Parent.Schema)

local Teleporter = Model:subclass(script.Name)
Teleporter:AddProperty({
	Name = "Target",
	Type = "ObjectValue",
	SchemaFn = Schema:IsA("BasePart"),
})

Teleporter:AddProperty({
	Name = "Offset",
	Type = "Vector3Value",
	SchemaFn = Schema:TypeOf("Vector3"),
})

function Teleporter:initialize(input)
	Model.initialize(self, input)

	self:GetPrimaryPart().Touched:Connect(
		TouchUtil:Debounce(
			TouchUtil:EnhancedFn(
				self:CreateOnTouched()
			)
		)
	)
end

function Teleporter:CreateOnTouched()
	return function(input)
		local target = self:GetTarget().CFrame
		local offset = self:GetOffset()

	    if input.Player
			and input.Component:GetRootPart() then
			input.Component:GetRootPart().CFrame = target + offset
	    end
	end
end

return Teleporter