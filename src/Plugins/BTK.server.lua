--[[--
	BTK plugin
	@script BTK
--]]
local btkDev = game.ReplicatedStorage:FindFirstChild("BTK", false)
local btk
if btkDev then
	local core = btkDev.Models.Core:Clone()
	btk = require(core.MainModule)
else
	btk = require(1815138614)
end

btk.BTKPlugin:new(plugin)