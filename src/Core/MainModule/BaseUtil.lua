local BaseObject = require(script.Parent.BaseObject)

--[[
	BaseUtil docs
--]]
BaseUtil = BaseObject:subclass(script.Name)

function BaseUtil:initialize()
	BaseObject.initialize(self)
end

return BaseUtil
