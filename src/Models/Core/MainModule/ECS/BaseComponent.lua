--- Base for all components
--
-- @classmod ECS.BaseComponent

local BaseInstance = require(script.Parent.Parent.BaseInstance)
--local Schema = require(script.Parent.Parent.Schema)

local BaseComponent = BaseInstance:subclass(script.Name)

function BaseComponent:initialize(input)
	BaseInstance.initialize(self, input)
end

--- OnAwake is called when the component is awoken
-- A subclass should override it if you need something
-- to run at this time.
function BaseComponent:OnAwake()
	local _ = self
end

return BaseComponent