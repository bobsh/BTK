---	Core utility entry point for BTK
--
-- @classmod btk

local btk = {
    --- @{BTKPlugin}
    BTKPlugin = require(script.BTKPlugin),

    --- @{ScriptHelper}
    ScriptHelper = require(script.ScriptHelper),

    --- @{ECS}
    ECS = require(script.ECS),
}

return btk
