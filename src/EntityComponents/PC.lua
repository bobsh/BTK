local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local Model = require(script.Parent.Model)

local PC = EntitySystem.Component:extend("PC", {
    Player = "TODO objects",
    Currency = 0,
    CollectCollision = "TODO objects",
    CollectAttachment = "TODO objects",
})

function PC:added()
    local model = self:getComponent(Model)
	self.Player = game.Players:GetPlayerFromCharacter(model.Model)
	self.CollectAttachment = Instance.new("Attachment", self:GetRootPart())

    local zeroMaterial = PhysicalProperties.new(0,0,0)

	local cc = Instance.new("Part", self:GetModel())
	cc.Name = "CollectCollision"
	cc.Shape = Enum.PartType.Ball
	cc.Anchored = false
	cc.CanCollide = false
	cc.Size = Vector3.new(18, 18, 18)
	cc.Transparency = 1.0
	cc.CustomPhysicalProperties = zeroMaterial
	cc.Touched:Connect(function(hit)
		local comp = self.TouchUtil:GetComponentData({
			Inst = hit,
		})
		if not comp then
			return
		end

		local colAttachment = comp:GetData("CollectableAttachment")
		if not colAttachment then
			return
		end

		self:Debug("Hit someting with CollectableAttachment",
			{
				HitName = hit.Name,
			}
		)

		local cf = Instance.new("AlignPosition", colAttachment)
		cf.Name = "CollectableForce"
		cf.Attachment0 = colAttachment
		cf.Attachment1 = self.CollectAttachment

		delay(4, function()
			cf:Destroy()
		end)
	end)

	local weld = Instance.new("Weld", self:GetRootPart())
	weld.Name = "CollectCollisionWeld"
	weld.Part0 = self:GetRootPart()
    weld.Part1 = cc

	self.CollectCollision = cc
end
return PC