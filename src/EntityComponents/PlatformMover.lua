local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local PlatformMover = EntitySystem.Component:extend("PlatformMover", {
    Part = "TODO",
    StartMarker = "TODO",
    EndMarker = "TODO",
    TimeToMove = 1,
    Increment = 1,
})

function PlatformMover:added()
    local _ = self
    local a = self:GetPrimaryPart()
	a.Anchored = true
	self:SetPlatformPart(a)

	self:GetStartPositionMarker().Transparency = 1
	self:EndStartPositionMarker().Transparency = 1

	-- Begin moving, an infinite loop
	self:Debug("Beginning cycle")
	while true do
		self:MovePart(self:EndStartPositionMarker().Position)
		self:MovePart(self:GetStartPositionMarker().Position)
	end
end

function PlatformMover:MovePart(newPos)
	self:AssertSchema(
		newPos,
		self.Schema:TypeOf("Vector3")
	)

	local platform = self:GetPlatformPart()
	local timeToMove = self:GetTimeToMove()
	local increment = self:GetIncrement()

	local Diff = newPos - platform.Position -- the difference between the two positions
	local Mag = Diff.magnitude -- the distance between the two parts
	local Direction = CFrame.new(platform.Position, newPos).lookVector

	for _ = 0, Mag, increment do
		platform.CFrame = platform.CFrame + (Direction * increment)
		wait( (timeToMove/Mag) * increment )
	end
end

return PlatformMover