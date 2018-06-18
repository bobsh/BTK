local EntitySystem = require(game.ReplicatedStorage.EntitySystem)
local Character = require(script.Parent.Character)

local Teleporter = EntitySystem.Component:extend("Teleporter", {
	Target = {"Target"},
    Offset = Vector3.new(0, 0, 0),
})

function Teleporter:added()
	self.TargetInstance = self.instance
	for _, v in pairs(self.Target) do
		self.TargetInstance = self.TargetInstance:FindFirstChild(v)
	end

    self.instance.Touched:Connect(
		self.Debounce(
			self.EnhancedFn(
				self:CreateOnTouched()
			)
		)
	)
end

function Teleporter:CreateOnTouched()
	return function(input)
		local target = self.TargetInstance.CFrame
		local offset = self.Offset

		local humanoid = self:GetComponentInAncestorInst(input.Hit, Character)

		if input.Player
			and humanoid
			and humanoid:GetRootPart() then
			humanoid:GetRootPart().CFrame = target + offset
	    end
	end
end


return Teleporter