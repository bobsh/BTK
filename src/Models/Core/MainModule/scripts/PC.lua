local Character = require(script.Parent.Character)
local Schema = require(script.Parent.Parent.Schema)

local PC = Character:subclass(script.Name)
PC:AddProperty({
	Name = "Player",
    Type = "ObjectValue",
    ValueFn = function(self2)
        return game.Players:GetPlayerFromCharacter(self2:GetModel())
    end,
	SchemaFn = Schema:IsA("Player"),
	AllowOverride = false,
})
PC:AddProperty({
	Name = "Currency",
    Type = "NumberValue",
    Value = 0,
	SchemaFn = Schema.Currency,
	AllowOverride = true,
})
PC:AddProperty({
	Name = "CollectCollision",
    Type = "ObjectValue",
	SchemaFn = Schema.Optional(Schema:IsA("Part")),
	AllowOverride = true,
})
PC:AddProperty({
	Name = "CollectAttachment",
    Type = "ObjectValue",
    ValueFn = function(self2)
        return Instance.new("Attachment", self2:GetRootPart())
    end,
	SchemaFn = Schema:IsA("Attachment"),
	AllowOverride = true,
})

function PC:initialize(input)
    Character.initialize(self, input)

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
		local comp = self:GetComponentData({
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
		cf.Attachment1 = self:GetCollectAttachment()

		delay(4, function()
			cf:Destroy()
		end)
	end)

	local weld = Instance.new("Weld", self:GetRootPart())
	weld.Name = "CollectCollisionWeld"
	weld.Part0 = self:GetRootPart()
    weld.Part1 = cc

    self:SetCollectCollision(cc)
end

return PC