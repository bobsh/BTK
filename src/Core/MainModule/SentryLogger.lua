local BaseLogger = require(script.Parent.BaseLogger)
local Schema = require(script.Parent.Schema)
local Raven = require(script.Parent.lib.Raven)

local RunService = game:GetService("RunService")

--[[
	SentryLogger outputs to sentry
--]]
SentryLogger = BaseLogger:subclass(script.Name)

function SentryLogger:initialize(input)
	BaseLogger.initialize(self, input)
	
	-- Don't set a client if we're in the studio
	if RunService:IsStudio() then
		return
	end
	
	if not self.Config.DSN then
		warn("No DSN configured")
		return
	end
	
	local rconf = {
		environment = "development",
		tags = {
			ClassName = self.ClassName,
		},
	}
	
	if game.JobId ~= "" then
		rconf["server_name"] = game.JobId
		rconf["environment"] = "production"
		rconf["tags"] = {
			ClassName = self.ClassName,
			CreatorId = game.CreatorId,
			GameId = game.GameId,
			PlaceId = game.PlaceId,
		}
	end
	
	if game.PlaceVersion ~= 0 then
		rconf["release"] = tostring(game.PlaceVersion)
	end
	
	if input.Player then
		rconf.user = {
			id = input.Player.UserId,
			username = input.Player.Name,
		}
	end
	
	self._ravenClient = Raven:Client(
		self.Config.DSN,
		rconf
	)
end

local _levelToRaven = {
	[Schema.Enums.LogLevel.Trace] = Raven.EventLevel.Debug,
	[Schema.Enums.LogLevel.Debug] = Raven.EventLevel.Debug,
	[Schema.Enums.LogLevel.Info] = Raven.EventLevel.Info,
	[Schema.Enums.LogLevel.Warn] = Raven.EventLevel.Warn,
	[Schema.Enums.LogLevel.Error] = Raven.EventLevel.Error,
	[Schema.Enums.LogLevel.Fatal] = Raven.EventLevel.Fatal,
}

function SentryLogger:Log(input)
	if not self._raventClient then
		return
	end
	
	-- Skip anything above Info
	if input.Level.Value > Schema.Enums.LogLevel.Info.Value then
		return
	end

	local sentryData = {
		level = _levelToRaven[input.Level],
		message = input.Message,
		extra = input.Data,
	}

	if input.Player then
		sentryData.user = {
			id = input.Player.UserId,
			username = input.Player.Name,
		}
	end

	self._ravenClient:SendException(
		input.Level.String,
		input.Message,
		debug.traceback(),
		sentryData
	)
end

return SentryLogger