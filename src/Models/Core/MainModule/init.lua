---	Core utility entry point for BTK
--
-- @classmod btk

local btk = {
    --- @{BTKPlugin}
    BTKPlugin = require(script.BTKPlugin),

    --- @{ECS}
    ECS = require(script.ECS),

    --- @{UI}
    UI = require(script.UI),

    --- @{EntitySystem}
    EntitySystem = require(script.lib.EntitySystem)
}

return btk
