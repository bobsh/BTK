local CharacterComponent = require(script.Parent.Parent.CharacterComponent)
local Schema = require(script.Parent.Parent.Schema)

local PC = CharacterComponent:subclass(script.Name)

function PC:initialize(input)
	CharacterComponent.initialize(self, input)
	
	self:_playerSetup()	
	self:_currencySetup()
	self:_collectSetup()
end

--[[
	Player setup
--]]
function PC:_playerSetup()
	self:CreateData({
		Name = "Player",
		Type = "ObjectValue",
		Value = game.Players:GetPlayerFromCharacter(self:GetModel()),
		Schema = Schema:IsA("Player"),
	})
end

--[[
	Currency handling
--]]
function PC:_currencySetup()
	self:Debug("_currencySetup")
	self:CreateData({
		Name = "Currency",
		Type = "NumberValue",
		Value = 0,
		Schema = Schema.Currency,
	})
	self:Debug("_currencySetup complete")
end

--[[
	Collection handling for drawing collectables towards
	the player when within a certain defined distance.
--]]
function PC:_collectSetup()
	self:Debug("_collectSetup")
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
	
	self:CreateData({
		Name = "CollectCollision",
		Type = "ObjectValue",
		Value = cc,
		Schema = Schema:IsA("Part"),
	})
	
	self:CreateData({
		Name = "CollectAttachment",
		Type = "ObjectValue",
		Value = Instance.new("Attachment", self:GetRootPart()),
		Schema = Schema:IsA("Attachment"),
	})
	self:Debug("_completeSetup complete")
end

return PC