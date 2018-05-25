--[[--
    BTKScriptHelper bootstraps the BTK script handling code
	@module Helper
	@export
--]]

local function BTKScriptHelper(s)
	--[[
		Here we lookup a development version of the code
		or fallback to the hosted version.
	--]]
	local btkDev = game.ReplicatedStorage:FindFirstChild("BTK", false)
	local btk
	if btkDev then
		btk = require(btkDev.Models.Core.MainModule)
	else
		btk = require(1815138614)
	end
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