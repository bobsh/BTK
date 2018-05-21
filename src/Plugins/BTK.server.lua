local btkDev = game.ReplicatedStorage:FindFirstChild("BTK", false)
local btk
if btkDev then
	btk = require(btkDev.Models.Core.MainModule:Clone())
else
	btk = require(1815138614)
end

btk.BTKPlugin:new(plugin)