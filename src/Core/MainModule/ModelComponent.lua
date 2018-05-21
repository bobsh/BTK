local BaseComponent = require(script.Parent.BaseComponent)
local Schema = require(script.Parent.Schema)

--[[
	ModelComponent
--]]
ModelComponent = BaseComponent:subclass(script.Name)

function ModelComponent:initialize(input)
	BaseComponent.initialize(self, input)
	self:AssertSchema(input.Root, Schema:IsA("Model"))
	
	self:CreateData({
		Name = "Model",
		Type = "ObjectValue",
		Value = self:GetRoot(),
		Schema = Schema:IsA("Model"),
	})	
	
	self:CreateData({
		Name = "PrimaryPart",
		Type = "ObjectValue",
		Value = self:GetModel().PrimaryPart,
		Schema = Schema:IsA("BasePart"),
	})
end

return ModelComponent
