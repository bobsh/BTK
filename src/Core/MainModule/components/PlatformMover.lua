local ModelComponent = require(script.Parent.Parent.ModelComponent)
local Schema = require(script.Parent.Parent.Schema)

local PlatformMover = ModelComponent:subclass(script.Name)

function PlatformMover:initialize(input)
	ModelComponent.initialize(self, input)	
	
	-- Platform
	local platformPart = self:CreateData({
		Name = "PlatformPart",
		Type = "ObjectValue",
		Value = self:GetPrimaryPart(),
		Schema = Schema:IsA("BasePart"),
	})
	platformPart.Anchored = true
	
	local startPosition = self:CreateData({
		Name = "StartPositionMarker",
		Type = "ObjectValue",
		Schema = Schema:IsA("BasePart"),
	})
	startPosition.Transparency = 1

	local endPosition = self:CreateData({
		Name = "EndPositionMarker",
		Type = "ObjectValue",
		Schema = Schema:IsA("BasePart"),
	})
	endPosition.Transparency = 1
	
	self:CreateData({
		Name = "TimeToMove",
		Type = "NumberValue",
		Schema = Schema.NumberFrom(1.0, 1000.0),
	})
	
	self:CreateData({
		Name = "Increment",
		Type = "NumberValue",
		Schema = Schema.NumberFrom(0.1, 10.0),
	})

	--- Begin moving, an infinite loop
	self:Debug("Beginning cycle")
	while true do
		self:MovePart(endPosition.Position)
		self:MovePart(startPosition.Position)
	end
end

function PlatformMover:MovePart(newPos)
	self:AssertSchema(
		newPos,
		Schema:TypeOf("Vector3")
	)	
		
	local platform = self:GetPlatformPart()
	local timeToMove = self:GetTimeToMove()
	local increment = self:GetIncrement()
		
	local Diff = newPos - platform.Position -- the difference between the two positions
	local Mag = Diff.magnitude -- the distance between the two parts
	local Direction = CFrame.new(platform.Position, newPos).lookVector

	for n = 0, Mag, increment do
		platform.CFrame = platform.CFrame + (Direction * increment)
		wait( (timeToMove/Mag) * increment )
	end
end

return PlatformMover
