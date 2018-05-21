local BaseComponent = require(script.Parent.BaseComponent)
local Schema = require(script.Parent.Schema)

--[[
	ToolComponent represents a component that uses a Tool at its root.
--]]
local ToolComponent = BaseComponent:subclass(script.Name)

function ToolComponent:initialize(input)
	BaseComponent.initialize(self, input)
	
	self:AssertSchema(input.Root, Schema:IsA("Tool"))
	
	self:CreateData({
		Name = "Owner",
		Type = "ObjectValue",
		Value = self:_getOwner(),
		Schema = Schema.Optional(
			Schema.CharacterModel
		),
	})
	self:GetTool().AncestryChanged:Connect(function()
		self:Debug("AncestryChanged: recalculating Owner")
		self:SetData("Owner", self:_getOwner())
	end)
	
	self:CreateData({
		Name = "Equipped",
		Type = "BoolValue",
		Value = false,
		Schema = Schema.Boolean,
	})
	self:GetTool().Equipped:Connect(function()
		self:Debug("Equipped: recalculating IsEquipped")
		self:SetData("IsEquipped", true)
	end)
	self:GetTool().Unequipped:Connect(function()
		self:Debug("Unequipped: recalculating IsEquipped")
		self:SetData("IsEquipped", false)
	end)
end

--[[
	Get the tool at the root of this component.
--]]
function ToolComponent:GetTool()
	return self:AssertSchema(
		self:GetRoot(),
		Schema:IsA("Tool")
	)
end

--[[
	_getOwner returns the character that currently holds the object.
--]]
function ToolComponent:_getOwner()
	local model = self:GetTool().Parent
	if model:IsA("Backpack") then
		local player = model.Parent
		if player:IsA("Player") then
			model = player.Character
		end
	end
	
	if not model:IsA("Model") then
		self:Debug("The instance is not a model",
			{
				InstanceName = model.Name,
				ClassName = model.ClassName,
			}
		)
		return nil
	end

	local comp = self:GetComponentData({
		Inst = model,
	})
	if comp then
		return comp:GetRoot()
	end

	self:Warn("Owner is not a component",
		{
			InstanceName = model.Name,
		}
	)
	return nil
end

return ToolComponent