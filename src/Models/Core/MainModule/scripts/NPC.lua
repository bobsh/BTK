--- @classmod scripts.NPC

local Character = require(script.Parent.Character)
local Schema = require(script.Parent.Parent.Schema)

local NPCState = {
	Dead = "Dead",
	Idle = "Idle",
	MoveToTarget = "MoveToTarget",
	AttackTarget = "AttackTarget",
}

local NPC = Character:subclass(script.Name)
NPC:AddProperty({
	Name = "State",
	Type = "StringValue",
	Value = NPCState.Idle,
	SchemaFn = Schema.OneOf(
		NPCState.Dead,
		NPCState.Idle,
		NPCState.MoveToTarget,
		NPCState.AttackTarget
	),
	WatchFn = function(self, value)
		self:Debug("State is now " .. value)
		if     value == NPCState.Idle then
			self.Waypoints = {}
			self.GetHumanoid().PlatformStand = true
		elseif value == NPCState.MoveToTarget then
			self.GetHumanoid().PlatformStand = false
			self:WalkToTarget()
		elseif value == NPCState.AttackTarget then
			self.Waypoints = {}
			self.GetHumanoid().PlatformStand = true
		elseif value == NPCState.Dead then
			self.Waypoints = {}
			self.GetHumanoid().PlatformStand = true
		else
			self:Error("Unknown state: " .. value)
		end
	end
})
NPC:AddProperty({
	Name = "LastAttack",
	Type = "NumberValue",
	Value = 0,
	SchemaFn = Schema.NonNegativeNumber,
})
NPC:AddProperty({
	Name = "DistanceToTarget",
	Type = "NumberValue",
	Value = 0.0,
	SchemaFn = Schema.NumberFrom(0.0, 9999.0),
	WatchFn = function(self, value)
		if self:GetEnemyTarget() ~= nil then
			if value < self:GetAttackDistance() then
				self:SetState(NPCState.AttackTarget)
			else
				self:SetState(NPCState.MoveToTarget)
			end
		else
			self:SetState(NPCState.Idle)
		end
	end
})
NPC:AddProperty({
	Name = "EnemyTarget",
	Type = "ObjectValue",
	SchemaFn = Schema.Optional(
		Schema.CharacterModel
	),
	WatchFn = function(self, value)
		if value ~= nil then
			self:SetState(NPCState.MoveToTarget)
		else
			self:SetState(NPCState.Idle)
		end
	end
})

function NPC:initialize(input)
	Character.initialize(self, input)

	self.Waypoints = {}

	self.Humanoid = self:GetHumanoid()
	local moveToFinishedConnect = self.Humanoid.MoveToFinished:Connect(function(reached)
		self:Debug("Reached target: " .. tostring(reached))
		self:WalkToTarget()
	end)

	self.Humanoid.Died:Connect(function()
		self:Debug("Dead")
		self:SetState(NPCState.Dead)

		moveToFinishedConnect:Disconnect()

		delay(4, function()
			self:Destroy()
		end)
	end)

	self.Area = self:GetArea()
	if self.Area ~= nil then
		self.Area.Events.PlayerTouched.Event:Connect(function(player)
			self:SetEnemyTarget(player.Character)
		end)
		self.Area.Events.PlayerTouchEnded.Event:Connect(function(_)
			self:SetEnemyTarget(nil)
		end)
	else
		self:Warn("No area found")
	end

	self:Heartbeat()
end

--[[
	DistanceToTarget
--]]
function NPC:_setDistanceToTarget()
	local start = self.Humanoid.RootPart.Position
	local finish = self:GetEnemyTarget().PrimaryPart.Position

	self:SetData("DistanceToTarget",(finish - start).Magnitude)
end

function NPC:RefreshPathToEnemy()
	if  self.EnemyTarget and
		self.Humanoid.PlatformStand == false then
		self:Debug("Path calc")
		local start = self.Humanoid.RootPart
		local finish = self:GetEnemyTarget().PrimaryPart

		local PathfindingService = game:GetService("PathfindingService")
		local path = PathfindingService:FindPathAsync(start.Position, finish.Position)
		self.Waypoints = path:GetWaypoints()
		self.LastWaypointCalc = time()
	end
end

function NPC:WalkToTarget()
	if #self.Waypoints == 0 then
		self:RefreshPathToEnemy()
	end

	if  self.EnemyTarget and
		self.Humanoid.PlatformStand == false then


		local enemyPosition = self:GetEnemyTarget().PrimaryPart.Position
		local lastWaypointPosition = self.Waypoints[#self.Waypoints].Position
		local distanceBetween = (lastWaypointPosition-enemyPosition).Magnitude

		self:Debug("Distance between last waypoint and enemy: " ..
			tostring(distanceBetween))

		if distanceBetween > self:GetAttackDistance() then
			local timeSinceLast = time()-self.LastWaypointCalc
			if timeSinceLast > 2 then
				self:RefreshPathToEnemy()
			else
				self:Debug("Throttling path calc")
			end
		end

		self:Debug("Number of waypoints: " .. tostring(#self.Waypoints))

		self.Humanoid:MoveTo(
			table.remove(self.Waypoints,1).Position
		)
	end
end

function NPC:Heartbeat()
	while self:GetState() ~= NPCState.Dead do
		if self:GetEnemyTarget() ~= nil then
			self:_setDistanceToTarget()
		end

		if self:GetState() == NPCState.AttackTarget then
			local sinceLastAttack = time() - self:GetLastAttack()
			if sinceLastAttack > 2 then
				local enemyComp = self:GetComponentData({
					Inst = self:GetEnemyTarget(),
				})
				enemyComp:SendDamage({
					Damage = 1.0,
				})
				self:SetData("LastAttack", time())
			end
		end
		wait()
	end
end

return NPC
