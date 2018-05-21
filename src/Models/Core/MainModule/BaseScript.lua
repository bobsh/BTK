local BaseInstance = require(script.Parent.BaseObject)

local BaseScript = BaseInstance:subclass(script.name)

function BaseScript:initialize(input)
	BaseInstance.initialize(self, input)
end

return BaseScript
