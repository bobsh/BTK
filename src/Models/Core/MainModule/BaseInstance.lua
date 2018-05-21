local BaseObject = require(script.Parent.BaseObject)
local SentryLogger = require(script.Parent.SentryLogger)

--[[
	BaseInstance represents anything abstractly in the game world.
--]]
local BaseInstance = BaseObject:subclass(script.Name)

--[[
	Install the raven logger if there is a DSN configured in our config
]]
if game.ServerStorage.BTKServerConfig:FindFirstChild("Raven") and
	game.ServerStorage.BTKServerConfig.Raven:FindFirstChild("DSN") then
	BaseInstance:AddLogger({
		Class = SentryLogger,
		Config = {
			DSN = game.ServerStorage.BTKServerConfig.Raven.DSN.Value,
		}
	})
end

function BaseInstance:initialize()
	BaseObject.initialize(self)
end

return BaseInstance