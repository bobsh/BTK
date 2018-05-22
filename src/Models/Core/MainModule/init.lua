local BaseObject = require(script.BaseObject)

--[[
	BTKMainModule
--]]
local btk = BaseObject:subclass('btk')

btk.static.BTKPlugin = require(script.BTKPlugin)
btk.static.ScriptHelper = require(script.ScriptHelper)

return btk
