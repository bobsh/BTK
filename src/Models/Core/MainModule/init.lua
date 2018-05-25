--[[--
	Core utility entry point for BTK

	@module btk
	@author Bob.sh Ltd
	@copyright Bob.sh Ltd 2018
	@license TBA
	@usage
	This is usage?
--]]
local BaseObject = require(script.BaseObject)

--[[--
	Base class for the entry point

	@type btk
--]]
local btk = BaseObject:subclass('btk')

--- A link to the BTKPlugin helper
btk.static.BTKPlugin = require(script.BTKPlugin)

--- A link to the script helper
btk.static.ScriptHelper = require(script.ScriptHelper)

return btk
