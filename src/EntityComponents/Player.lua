local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local Player = EntitySystem.Component:extend("Player", {
})

function Player:added()
    local _ = self
end

local UserInputService = game:GetService("UserInputService")

local localPlayer = game.Players.LocalPlayer
local character
local humanoid

local canDoubleJump = false
local hasDoubleJumped = false
local oldPower
local TIME_BETWEEN_JUMPS = 0.2
local DOUBLE_JUMP_POWER_MULTIPLIER = 2

local function onJumpRequest()
	if not character or not humanoid or not character:IsDescendantOf(game.Workspace) or
	 humanoid:GetState() == Enum.HumanoidStateType.Dead then
		return
	end

	if canDoubleJump and not hasDoubleJumped then
		hasDoubleJumped = true
		humanoid.JumpPower = oldPower * DOUBLE_JUMP_POWER_MULTIPLIER
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end

local function characterAdded(newCharacter)
	character = newCharacter
	humanoid = newCharacter:WaitForChild("Humanoid")
	hasDoubleJumped = false
	canDoubleJump = false
	oldPower = humanoid.JumpPower

	humanoid.StateChanged:connect(function(_, new)
		if new == Enum.HumanoidStateType.Landed then
			canDoubleJump = false
			hasDoubleJumped = false
			humanoid.JumpPower = oldPower
		elseif new == Enum.HumanoidStateType.Freefall then
			wait(TIME_BETWEEN_JUMPS)
			canDoubleJump = true
		end
	end)
end

function Player:initialize(input)
	local parent = input.Script.Parent

	if not parent:IsA("PlayerScripts") then
		self:Error("Script is not placed in PlayerScripts")
	end

	-- Disable player list
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)

	if localPlayer.Character then
		characterAdded(localPlayer.Character)
	end

	localPlayer.CharacterAdded:connect(characterAdded)
	UserInputService.JumpRequest:connect(onJumpRequest)
end

return Player