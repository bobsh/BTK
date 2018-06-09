--- @classmod BaseUtil
local BaseObject = require(script.Parent.BaseObject)

local BaseUtil = BaseObject:subclass(script.Name)

function BaseUtil:initialize()
	BaseObject.initialize(self)
end

return BaseUtil
