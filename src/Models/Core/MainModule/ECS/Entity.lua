--- Entity class representing an entity in game
--
-- @classmod ECS.Entity

local BaseInstance = require(script.Parent.Parent.BaseInstance)
--local Schema = require(script.Parent.Parent.Schema)

local Entity = BaseInstance:subclass(script.Name)

function Entity:initialize(input)
	BaseInstance.initialize(self, input)
end

return Entity