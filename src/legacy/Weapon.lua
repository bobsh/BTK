--- @classmod scripts.Weapon

local Tool = require(script.Parent.Tool)
local Schema = require(script.Parent.Parent.Schema)
local TouchUtil = require(script.Parent.Parent.TouchUtil)

local Weapon = Tool:subclass(script.Name)
Weapon:AddProperty({
	Name = "Type",
	Type = "StringValue",
	SchemaFn = Schema.WeaponType,
})

--[[
	void Weapon:Init()
--]]
function Weapon:initialize(input)
	Tool.initialize(self, input)

	if self:GetType() == Schema.Enums.WeaponType.Melee then
		self:GetTool().Activated:Connect(self:MeleeActivate())
	elseif self:GetType() == Schema.Enums.WeaponType.Ranged then
		self:GetTool().Activated:Connect(self:RangedActivate())
		self:GetTool().Equipped:Connect(function(_)
			print "Weapon: Equipped"
			local vCharacter = self.GetRoot().Parent
			local myHumanoid = vCharacter:FindFirstChild("Humanoid")
			local rootPart = myHumanoid.RootPart

			self.Aimer = Instance.new("Part", rootPart)
			self.Aimer.Name = "Aimer"
			self.Aimer.CanCollide = false
			self.Aimer.Shape = Enum.PartType.Cylinder
			self.Aimer.Size = Vector3.new(0.2, 2.5, 2.5)
			self.Aimer.Color = BrickColor.Red().Color
			self.Aimer.Transparency = 0.2
			self.Aimer.CollisionGroupId = 1

			local weld = Instance.new("Weld", self.Aimer)
			weld.Part0 = rootPart
			weld.Part1 = self.Aimer
			weld.C0 = CFrame.new( Vector3.new( 0 , 0 , -10 ) )
			weld.C1 = CFrame.new(0,0,0)*CFrame.fromEulerAnglesXYZ(0, math.pi/2, 0)
		end)
		self:GetTool().Unequipped:Connect(function()
			print "Weapon: Unequipped"

			self.Aimer:Destroy()
		end)
	end
end

--[[
	function(hit) Weapon:Blow()
--]]
function Weapon:Blow()
	return function(hit)
		local humanoid, myHumanoid

		local myCharacterComponent = self:GetOwner()
		if myCharacterComponent then
			myHumanoid = myCharacterComponent:GetData("Humanoid")
		else
			self:Err("Weapon has no owner")
		end

		if not myHumanoid then
			self:Err("Weapon has no humanoid")
		end

		local hitComponent = self:GetComponentData({
			Inst = hit,
		})
		if hitComponent then
			humanoid = hitComponent:GetData("Humanoid")
		else
			self:Dbg("Hit has no component",
				{
					HitName = hit.Name,
				}
			)
			return
		end

		if humanoid ~= myHumanoid then
			hitComponent:SendDamage({
				Damage = self:GetConfiguration("Damage")
			})
			wait(0.7)
		end
	end
end

--[[
	function(hit) Weapon:Hit(
		BasePart projectile
	)
--]]
function Weapon:Hit(projectile)
	return function(hit)
		local hitLocation = projectile.Position
		projectile:Destroy()

		local humanoid, myHumanoid

		local hitComponent = self:GetComponentData({
			Inst = hit,
		})
		if hitComponent then
			humanoid = hitComponent:GetData("Humanoid")
		end

		local vCharacter = self:GetTool().Parent
		local myCharacterComponent = self:GetComponentData({
			Inst = vCharacter,
		})
		if myCharacterComponent then
			myHumanoid = myCharacterComponent:GetData("Humanoid")
		end
		if hit.Parent then
			humanoid = hit.Parent:FindFirstChild("Humanoid")
		end

		if humanoid ~= nil and myHumanoid ~= nil and humanoid ~= myHumanoid then
			hitComponent:SendDamage({
				Damage = self:GetConfiguration("Damage"),
			})

			wait(0.7)
		else
			local bulletHole = Instance.new("Part",game.Workspace)
			bulletHole.CanCollide = false
			bulletHole.Name = "BulletHole"
			bulletHole.Color = BrickColor.Black().Color
			bulletHole.Shape = Enum.PartType.Ball
			bulletHole.Size = Vector3.new(0.5, 0.5, 0.5)
			bulletHole.Anchored = true
			bulletHole.Position = hitLocation
			delay(15, function()
				print "Weapon: Removing old bullet hole"
				bulletHole:Destroy()
			end)
		end
	end
end

--[[
	void Weapon:SetToolAnim(
		string name -- Name to set toolanim too
	)

	Creates a new StringValue alled 'toolanim' and sets it to a value.
	This interacts with the baked in Animate script for characters to
	enable a particular animation name for tool usage.
--]]
function Weapon:SetToolAnim(name)
	local anim = Instance.new("StringValue", self:GetTool())
	anim.Name = "toolanim"
	anim.Value = name
end

--[[
	function() Weapon:MeleeActivate()
--]]
function Weapon:MeleeActivate()
	return function()
		if self:GetTool().Enabled == false then
			return
		end

		print "Weapon: Activating"

		local handleConnect = self:GetTool().Handle.Touched:Connect(
			TouchUtil:Debounce(
				self:Blow()
			)
		)

		self:GetTool().Enabled = false
		self:SetToolAnim("Slash")
		wait(0.7)
		handleConnect:Disconnect()
		self:GetTool().Enabled = true

		print "Weapon: Done activating"
	end
end

--[[
	function() Weapon:RangedActivate()
--]]
function Weapon:RangedActivate()
	return function()
		if self:GetTool().Enabled == false then
			return
		end

		print "Ranged: Activating"

		self:GetTool().Enabled = false
		self:SetToolAnim("Lunge")
		wait(0.2)

		local vCharacter = self:GetTool().Parent
		local myHumanoid = vCharacter:FindFirstChild("Humanoid")
		local rootPart = myHumanoid.RootPart

		local projectile = Instance.new("Part", game.Workspace)
		projectile.Name = "Projectile"
		projectile.Size = Vector3.new(0.3, 0.3, 0.3)
		projectile.Shape = Enum.PartType.Ball
		projectile.Position = self.Handle.Muzzle.WorldPosition
		local po = rootPart.Orientation
		--projectile.Orientation = CFrame.new(projectile.Position, rootPart.Aimer.Position).lookVector
		projectile.Orientation = Vector3.new(po.X, po.Y+90, po.Z)
		--projectile.Orientation = self.Handle.Muzzle.WorldOrientation
		projectile.Touched:Connect(self:Hit(projectile))

		local force = Instance.new("BodyThrust", projectile)
		force.Force = Vector3.new(90.0, 0.0, 0.0)

		wait(0.5)

		self:GetTool().Enabled = true

		print "Ranged: Done activating"
	end
end

return Weapon