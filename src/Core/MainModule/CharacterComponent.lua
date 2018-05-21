local ModelComponent = require(script.Parent.ModelComponent)
local Schema = require(script.Parent.Schema)

--[[
	CharacterComponent represents an abstract character
--]]
local CharacterComponent = ModelComponent:subclass(script.Name)

function CharacterComponent:initialize(input)
	ModelComponent.initialize(self, input)

	self:CreateData({
		Name = "AttackDistance",
		Type = "NumberValue",
		Value = 5.0,
		Schema = Schema.AttackDistance,
	})

	-- If there is a humanoid, create a data item for it
	self:CreateData({
		Name = "Humanoid",
		Type = "ObjectValue",
		Value = self:GetModel():FindFirstChildOfClass("Humanoid"),
		Schema = Schema:IsA("Humanoid")
	})

	self:CreateData({
		Name = "RootPart",
		Type = "ObjectValue",
		Value = self:GetHumanoid().RootPart,
		Schema = Schema:IsA("BasePart"),
	})

	-- TODO: remove
	--[[
	local areaValue = self:CreateData({
		Name = "Area",
		Type = "ObjectValue",
		Schema = Schema.Optional(
			Schema.Component
		)
	})



	-- Find the main area we are in by checking all parts
	do
		-- Wait for an area
		wait(2)

		local all = self:GetRoot():GetDescendants()
		for _, v in ipairs(all) do
			if v:IsA("BasePart") then
				local touchingParts = v:GetTouchingParts()
				for _, tp in ipairs(touchingParts) do
					local compTouching = self:GetComponentData({
						Inst = tp,
					})
					if compTouching and compTouching:GetComponent() == "Area" then
						self:SetArea(compTouching:GetRoot())
						break
					end
				end
				if self:GetArea() then
					break
				end
			end
		end
	end
	--]]

	local humanoid = self:GetHumanoid()
	local inputEventData = self:GetInputEvent()
	if humanoid then
		inputEventData.Event:Connect(function(input)
			if input.Type == Schema.Enums.InputEventType.Damage then
				self:Dbg("Received damage")
				if humanoid.RigType == Enum.HumanoidRigType.R15 then
					humanoid.Health = humanoid.Health - input.Payload.Damage
				else
					humanoid:TakeDamage(input.Payload.Damage)
				end
			end
		end)
	end
end

return CharacterComponent