--- Base for all components
--
-- @classmod ECS.BaseComponent

local BaseInstance = require(script.Parent.Parent.BaseInstance)
local Schema = require(script.Parent.Parent.Schema)

local BaseComponent = BaseInstance:subclass(script.Name)

function BaseComponent:initialize(input)
	BaseInstance.initialize(self, input)
end

--- Awake is called when the component is awoken
-- A subclass should override it if you need something
-- to run at this time.
function BaseComponent:Awake()
	local _ = self
end

function BaseComponent:OnDestroy()
	local _ = self
end

--[[---
	Properties

	@section properties
--]]---

BaseComponent.static._properties = {}

--- Add property using a definition
-- @tparam Schema.PropertyDefinition input
function BaseComponent.static:AddProperty(input)
	self:AssertSchema(
		input,
		Schema.PropertyDefinition
	)
	if self._properties[input.Name] then
		self:Error("Duplicate property", {
			Property = input.Name,
		})
	end
	self._properties[input.Name] = input
end

function BaseComponent.static:GetProperties()
	return self._properties
end

BaseComponent.static._required_components = {}

--- Require a component to operate
-- @tparam BaseComponent input
function BaseComponent.static:RequireComponent(input)
	self:AssertSchema(
		input,
		Schema.IsSubclassOf(BaseComponent)
	)
	if self._required_components[input:GetClassName()] then
		self:Error("Duplicate component", {
			Component = input:GetClassName(),
		})
	end
	self._required_components[input:GetClassName()] = input
end

return BaseComponent