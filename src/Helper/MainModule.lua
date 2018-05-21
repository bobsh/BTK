--[[
    BTKScriptHelper bootstraps the BTK script handling
	code
--]]
local function BTKScriptHelper(s)
	--[[
		Here we lookup a development version of the code
		or fallback to the hosted version.
	--]]
	local mainModule = game.Workspace:FindFirstChild("MainModule", false)
	local btk = require(mainModule or 1637466041)
	--[[
		Call out to whatever ScriptHelper we found to continue
		bootstrap in the central code area.
	--]]
	local scriptModule = btk.ScriptHelper:Get(s)
	scriptModule:new({
		Script = s,
	})
end

return BTKScriptHelper