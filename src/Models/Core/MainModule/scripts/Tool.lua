--- @classmod scripts.Tool

local BaseScript = require(script.Parent.Parent.BaseScript)
local Schema = require(script.Parent.Parent.Schema)

--[[
	ToolComponent represents a component that uses a Tool at its root.
--]]
local Tool = BaseScript:subclass(script.Name)
Tool:AddProperty({
	Name = "Owner",
	Type = "ObjectValue",
	SchemaFn = Schema.Optional(
		Schema.CharacterModel
	),
})
Tool:AddProperty({
	Name = "Equipped",
	Type = "BoolValue",
	Value = false,
	SchemaFn = Schema.Boolean,
})


function Tool:initialize(input)
	BaseScript.initialize(self, input)
	self:SetOwner(self:_getOwner())

	self:AssertSchema(input.Root, Schema:IsA("Tool"))

	self:GetTool().AncestryChanged:Connect(function()
		self:Debug("AncestryChanged: recalculating Owner")
		self:SetData("Owner", self:_getOwner())
	end)

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
function Tool:GetTool()
	return self:AssertSchema(
		self:GetRoot(),
		Schema:IsA("Tool")
	)
end

--[[
	_getOwner returns the character that currently holds the object.
--]]
function Tool:_getOwner()
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

return Tool