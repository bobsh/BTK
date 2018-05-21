local mainModule = game.Workspace:FindFirstChild("MainModule", false)
local btk
if mainModule then
	-- Always clone for plugins to always reload during development
	btk = require(mainModule:Clone())
else
	btk = require(1637466041)
end

btk.BTKPlugin:new(plugin)