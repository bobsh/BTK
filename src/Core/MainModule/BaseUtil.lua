local BaseObject = require(script.Parent.BaseObject)

--[[
	BaseUtil docs
--]]
local BaseUtil = BaseObject:subclass(script.Name)

function BaseUtil:initialize()
	BaseObject.initialize(self)
end

return BaseUtil
