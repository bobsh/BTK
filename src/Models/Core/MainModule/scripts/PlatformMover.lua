--- @classmod scripts.PlatformMover

local Model = require(script.Parent.Model)
local Schema = require(script.Parent.Parent.Schema)

local PlatformMover = Model:subclass(script.Name)
PlatformMover:AddProperty({
	Name = "PlatformPart",
	Type = "ObjectValue",
	ValueFn = function(self)
		local a = self:GetPrimaryPart()
		a.Anchored = true
		return a
	end,
	SchemaFn = Schema:IsA("BasePart"),
})
PlatformMover:AddProperty({
	Name = "StartPositionMarker",
	Type = "ObjectValue",
	SchemaFn = Schema:IsA("BasePart"),
})
PlatformMover:AddProperty({
	Name = "EndPositionMarker",
	Type = "ObjectValue",
	SchemaFn = Schema:IsA("BasePart"),
})
PlatformMover:AddProperty({
	Name = "TimeToMove",
	Type = "NumberValue",
	SchemaFn = Schema.NumberFrom(1.0, 1000.0),
})
PlatformMover:AddProperty({
	Name = "Increment",
	Type = "NumberValue",
	SchemaFn = Schema.NumberFrom(0.1, 10.0),
})

function PlatformMover:initialize(input)
	Model.initialize(self, input)

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
		Schema:TypeOf("Vector3")
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
