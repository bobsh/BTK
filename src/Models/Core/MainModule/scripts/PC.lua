local Character = require(script.Parent.Character)
local Schema = require(script.Parent.Parent.Schema)
local TouchUtil = require(script.Parent.Parent.TouchUtil)

local PC = Character:subclass(script.Name)
PC:AddProperty({
	Name = "Player",
    Type = "ObjectValue",
	SchemaFn = Schema.Optional(Schema:IsA("Player")),
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
	SchemaFn = Schema.Optional(Schema:IsA("Attachment")),
	AllowOverride = true,
})

function PC:initialize(input)
	Character.initialize(self, input)

	self:SetPlayer(game.Players:GetPlayerFromCharacter(self:GetModel()))
	self:SetCollectAttachment(Instance.new("Attachment", self:GetRootPart()))

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
		local comp = TouchUtil:GetComponentData({
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