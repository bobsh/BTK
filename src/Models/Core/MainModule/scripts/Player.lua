local BaseScript = require(script.Parent.Parent.BaseScript)
local AssetsUtil = require(script.Parent.Parent.AssetsUtil)

local Player = BaseScript:subclass(script.Name)

function Player:initialize(input)
	local parent = input.Script.Parent

	if not parent:IsA("PlayerScripts") then
		self:Error("Script is not placed in PlayerScripts")
	end

	-- Disable player list
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)

	-- Install player jump script
	AssetsUtil:Install({
		Parent = parent,
		Name = "BTKDoubleJump",
		ID = 1606680345,
		Type = "LocalScript"
	})
end

return Player