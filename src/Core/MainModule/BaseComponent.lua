local BaseInstance = require(script.Parent.BaseInstance)
local ComponentHandle = require(script.Parent.ComponentHandle)
local Schema = require(script.Parent.Schema)
local DataModule = require(script.Parent.DataModule)

--[[
	BaseComponent is an abstract class representing BTK's higher level
	component concept.
--]]
BaseComponent = BaseInstance:subclass(script.Name)
BaseComponent:include(DataModule)

function BaseComponent:initialize(input)
	BaseInstance.initialize(self, input)
	
	self:AssertSchema(
		input,
		Schema.Record {
			Root = Schema.Root,
			Component = Schema.ComponentName,
			Script = Schema.ComponentScript,
		}
	)
	
	self:DataSetup(input)
	self:_metaSetup(input)
	self:_eventSetup()
end

--[[
	Destroy the component
--]]
function BaseComponent:Destroy()
	self:Debug("Destroying component")
	self:GetRoot():Destroy()
end

--[[--------------------------------------------
	
	DATA
	
----------------------------------------------]]

--[[
	GetComponentData from an instance
--]]
function BaseComponent:GetComponentData(input)
	self:AssertSchema(
		input,
		Schema.Record {
			Inst = Schema:IsA("Instance"),
		}
	)
	
	local output = {}
	if input.Inst:IsA("Model") or input.Inst:IsA("Tool") then
		output.Root = input.Inst
	else
		output.Root = input.Inst:FindFirstAncestorOfClass("Tool")
		if not output.Root then
			output.Root = input.Inst:FindFirstAncestorOfClass("Model")
		end
	end
	
	-- No root? probably not a component just bail with nil
	if not output.Root then
		self:Debug("Cannot find a compatible root of instance probably not a component",
			{
				InstanceName = input.Inst.Name,
			}
		)
		return nil
	end
	
	-- Create a new component handle and return that
	return ComponentHandle:new(output)
end

--[[--------------------------------------------
	
	META
	
----------------------------------------------]]

function BaseComponent:_metaSetup(input)
	self:CreateData({
		Name = "Root",
		Type = "ObjectValue",
		Value = input.Root,
		Schema = Schema.Root,
	})
		
	self:CreateData({
		Name = "Component",
		Type = "StringValue",
		Value = input.Component,
		Schema = Schema.ComponentName,
	})
	
	self:CreateData({
		Name = "Script",
		Type = "ObjectValue",
		Value = input.Script,
		Schema = Schema.ComponentScript,
	})
end

--[[--------------------------------------------
	
	EVENTS
	
----------------------------------------------]]

--[[
	Create event instances
--]]
function BaseComponent:_eventSetup()
	-- Create input event
	local inputEventData = self:CreateData({
		Name = "InputEvent",
		Type = "ObjectValue",
		Value = Instance.new("BindableEvent", self:GetRoot()),
		Schema = Schema:IsA("BindableEvent"),
	})
	inputEventData.Name = "InputEvent"
end

return BaseComponent