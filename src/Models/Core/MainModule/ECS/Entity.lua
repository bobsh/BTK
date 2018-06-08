--- Entity represents an instanced entity that can contain components.
--
-- Parent: @{BaseInstance}
-- @classmod ECS.Entity
local BaseInstance = require(script.Parent.Parent.BaseInstance)
local Entity = BaseInstance:subclass(script.Name)

--- @TODO make this dynamic, stupid loading issues
local _components = {
	Character = require(script.Parent.Parent.Components.Character),
	InputEvent = require(script.Parent.Parent.Components.InputEvent),
	Model = require(script.Parent.Parent.Components.Model),
}

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

--- Get components
-- @treturn {BaseInstance....}
function Entity:GetComponents()
	local comps = {}
	local folders = self:GetComponentsFolder():GetChildren()
	for _, v in ipairs(folders) do
		local c = _components[v.Name]
		table.insert(comps, c)
	end
	self:Debug("GetComponents", {
		Amount = #comps,
	})
	return self:AssertSchema(
		comps,
		self.Schema.Collection(
			self.Schema.IsSubclassOf(BaseInstance)
		)
	)
end

--- Get storage area
function Entity:GetStorageFolder()
	local f = self:GetScript():FindFirstChild("_btk")
	if f ~= nil then
		return f
	end
	f = Instance.new("Folder", self:GetScript())
	f.Name = "_btk"
	return f
end

function Entity:GetComponentsFolder()
	local cf = self:GetStorageFolder():FindFirstChild("Components")
	if cf ~= nil then
		return cf
	end
	cf = Instance.new("Folder", self:GetStorageFolder())
	cf.Name = "Components"
	return cf
end

function Entity:GetComponentFolder(input)
	self:AssertSchema(
		input,
		self.Schema.Record {
			Component = self.Schema.IsSubclassOf(BaseInstance),
		}
	)

	local f = self:GetComponentsFolder():FindFirstChild(input.Component:GetClassName())
	if f ~= nil then
		return f
	end
	f = Instance.new("Folder", self:GetComponentsFolder())
	f.Name = input.Component:GetClassName()
	return f
end

--- Add component
function Entity:AddComponent(input)
	self:AssertSchema(
		input,
		self.Schema.Record {
			Component = self.Schema.IsSubclassOf(BaseInstance),
		}
	)

	local _ = self:GetComponentFolder({
		Component = input.Component
	})
end

return Entity