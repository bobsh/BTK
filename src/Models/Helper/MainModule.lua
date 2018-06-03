--[[--
    EntityHelper bootstraps the Entity handling code
	@module Helper
	@export
--]]

local function EntityHelper(s)
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
		Return the instantiated entity
	--]]
	return btk.ECS.Entity:new({
		Script = s,
	})
end

return EntityHelper