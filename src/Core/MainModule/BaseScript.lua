local BaseInstance = require(script.Parent.BaseObject)

BaseScript = BaseInstance:subclass(script.name)

function BaseScript:initialize(input)
	BaseInstance.initalize(self, input)
end

return BaseScript
