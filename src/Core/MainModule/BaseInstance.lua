local BaseObject = require(script.Parent.BaseObject)
local SentryLogger = require(script.Parent.SentryLogger)

--[[
	BaseInstance represents anything abstractly in the game world.
--]]
BaseInstance = BaseObject:subclass(script.Name)
BaseInstance:AddLogger({
	Class = SentryLogger,
	Config = {
		DSN = game.ServerStorage.BTKServerConfig.Raven.DSN.Value,
	}
})

function BaseInstance:initialize()
	BaseObject.initialize(self)
end

return BaseInstance