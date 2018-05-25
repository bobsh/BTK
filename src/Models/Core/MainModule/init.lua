--[[--
	Core utility entry point for BTK

	@classmod btk
--]]
local BaseObject = require(script.BaseObject)

local btk = BaseObject:subclass('btk')

--- A link to @{BTKPlugin}
btk.static.BTKPlugin = require(script.BTKPlugin)

--- A link to @{ScriptHelper}
btk.static.ScriptHelper = require(script.ScriptHelper)

return btk
