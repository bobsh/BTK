local Model = require(script.Parent.Model)
local Schema = require(script.Parent.Parent.Schema)

local Character = Model:subclass(script.Name)
Character:AddProperty({
	Name = "AttackDistance",
    Type = "NumberValue",
    Value = 5.0,
	SchemaFn = Schema.AttackDistance,
	AllowOverride = false,
})
Character:AddProperty({
	Name = "Humanoid",
    Type = "ObjectValue",
    ValueFn = function(self2)
        return self2:GetModel():FindFirstChildOfClass("Humanoid")
    end,
	SchemaFn = Schema:IsA("Humanoid"),
	AllowOverride = true,
})
Character:AddProperty({
	Name = "RootPart",
    Type = "ObjectValue",
    ValueFn = function(self2)
        return self2:GetHumanoid().RootPart
    end,
	SchemaFn = Schema:IsA("BasePart"),
	AllowOverride = true,
})

function Character:initialize(input)
    Model.initialize(self, input)

    local humanoid = self:GetHumanoid()
	local inputEventData = self:GetInputEvent()
	if humanoid then
		inputEventData.Event:Connect(function(input2)
			if input2.Type == Schema.Enums.InputEventType.Damage then
				self:Dbg("Received damage")
				if humanoid.RigType == Enum.HumanoidRigType.R15 then
					humanoid.Health = humanoid.Health - input2.Payload.Damage
				else
					humanoid:TakeDamage(input2.Payload.Damage)
				end
			end
		end)
	end
end

return Character