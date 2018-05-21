local BaseObject = require(script.Parent.BaseObject)
local AssetsUtil = require(script.Parent.AssetsUtil)

PlayerInit = BaseObject:subclass(script.Name)

function PlayerInit:initialize(input)
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

return PlayerInit