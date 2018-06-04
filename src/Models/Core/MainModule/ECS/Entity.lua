--- Entity represents an instanced entity that can contain components.
--
-- Parent: @{BaseInstance}
-- @classmod ECS.Entity
local BaseInstance = require(script.Parent.Parent.BaseInstance)
local Entity = BaseInstance:subclass(script.Name)

--- Input schema
-- @table initializeInput
-- @tfield Schema.Script Script
Entity.static.initializeInput = Entity.Schema.Record {
	Script = Entity.Schema.Script,
}

--- Pattern to match for the script name
Entity.static.Pattern = "^BTK:(%u[%u%l%d]+)$"

--- Initialize entity
-- @function ECS.Entity:new
-- @tparam initializeInput input
-- @usage
--   -- Placed in a roblox script, this turns it into an entity
--   local entity = ECS.Entity:new({
--     Script = script,
--   })
function Entity:initialize(input)
	BaseInstance.initialize(self, input)

	self:AssertSchema(
		input,
		Entity.initializeInput
	)

	local name = input.Script.Name:match(Entity.Pattern)
	if name == nil then
		self:Error("BTK script name not valid",
			{
				ScriptName = input.Script.Name,
				Pattern = Entity.Pattern,
			}
		)
	end

	self._init_input = input
end

--- Get script instance this entity points at
-- @treturn Schema.Script
function Entity:GetScript()
	return self:AssertSchema(
		self._init_input.Script,
		Entity.Schema.Script
	)
end

Entity._components = {}

--- Get components
-- @treturn {BaseComponent....}
function Entity:GetComponents()
	return self:AssertSchema(
		self._components,
		self.Schema.Collection(self.Schema.Boolean)
	)
end

return Entity