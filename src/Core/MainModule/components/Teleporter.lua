local ModelComponent = require(script.Parent.Parent.ModelComponent)
local TouchUtil = require(script.Parent.Parent.TouchUtil)
local Schema = require(script.Parent.Parent.Schema)

local Teleporter = ModelComponent:subclass(script.Name)

function Teleporter:initialize(input)
	ModelComponent.initialize(self, input)

	self:CreateData({
		Name = "Target",
		Type = "ObjectValue",
		Schema = Schema:IsA("BasePart"),
	})

	self:CreateData({
		Name = "Offset",
		Type = "Vector3Value",
		Schema = Schema:TypeOf("Vector3"),
	})

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
			and input.Component:GetData("RootPart") then
			input.Component:GetData("RootPart").CFrame = target + offset
	    end
	end
end

return Teleporter