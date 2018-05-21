local ModelComponent = require(script.Parent.ModelComponent)
local Schema = require(script.Parent.Schema)

--[[
	CollectableComponent represents an abstract collectable
--]]
local CollectableComponent = ModelComponent:subclass(script.Name)

function CollectableComponent:initialize(input)
	ModelComponent.initialize(self, input)
	self:_collectSetup()
end

--[[
	Collect setup
--]]
function CollectableComponent:_collectSetup()
	self:CreateData({
		Name = "CollectablePart",
		Type = "ObjectValue",
		Value = self:GetPrimaryPart(),
		Schema = Schema:IsA("BasePart"),
	})

	self:CreateData({
		Name = "CollectableAttachment",
		Type = "ObjectValue",
		Value = Instance.new("Attachment", self:GetCollectablePart()),
		Schema = Schema:IsA("Attachment"),
	})
end

return CollectableComponent