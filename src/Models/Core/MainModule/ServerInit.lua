local BaseObject = require(script.Parent.BaseObject)
local AssetsUtil = require(script.Parent.AssetsUtil)

local ServerInit = BaseObject:subclass(script.Name)

function ServerInit:initialize(input)
	BaseObject.initialize(self, input)

	self.ServerConfig = game.ServerStorage.BTKServerConfig
	self:Assert(self.ServerConfig, "No BTKServerConfig in ServerStorage")

	--[[
		Output initialisation messages to logs and discordapp
	--]]
	local serverData = {
		CreatorId = game.CreatorId,
		GameId = game.GameId,
		JobId = game.JobId,
		PlaceId = game.PlaceId,
		PlaceVersion = game.PlaceVersion,
		SecondsSinceStart = time(),
	}

	self:Info("Initialising server", serverData)

	--[[
		Setup game close logging
	--]]
	game.Close:Connect(function()
		serverData.SecondsSinceStart = time()
		self:Info("Server close", serverData)
	end)

	-- CHange default anims
	game.Players.PlayerAdded:connect(function(player)
		self:Info({
			Message = "Player has joined server",
			Player = player,
		})

		while not player.Character do wait() end
	end)

	self:Debug("Disabling character autoload")
	game.Players.CharacterAutoLoads = false

	self:Debug("Disabling custom characters")
	game.StarterPlayer.LoadCharacterAppearance = false

	local loadCharacters = self.ServerConfig:FindFirstChild("LoadCharacters")
	if loadCharacters == nil or loadCharacters.Value == true then
		self:Debug("Configuring StarterHumanoid")
		local starterHumanoid = Instance.new("Humanoid", game.StarterPlayer)
		starterHumanoid.Name = "StarterHumanoid"
		starterHumanoid.Health = 4
		starterHumanoid.MaxHealth = 4
		starterHumanoid.RigType = Enum.HumanoidRigType.R15
		starterHumanoid.HipHeight = 1.35
		starterHumanoid.MaxSlopeAngle = 89
		starterHumanoid.WalkSpeed = 16

		self:Debug("Configuring initial tools")
		local initialTools = self.ServerConfig:FindFirstChild("InitialTools")
		if initialTools then
			for _, value in pairs(initialTools:GetChildren()) do
				self:Debug("Configuring tool: " .. value.Name)
				AssetsUtil:Install({
					Parent = game.StarterPack,
					Name = value.Name,
					ID = value.Value,
					Type = "Tool"
				})
			end
		end

		self:Debug("Loading characters")
		for _, value in pairs(game.Players:GetPlayers()) do
			self:Debug("Loading character: " .. value.Name)
			value:LoadCharacter()
		end
		game.Players.CharacterAutoLoads = true
	else
		self:Debug("Not loading characters")
	end

	self:Debug("Init complete")
end

return ServerInit
