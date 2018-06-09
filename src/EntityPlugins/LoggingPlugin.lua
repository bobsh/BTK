local inspect = require(game.ReplicatedStorage.Modules.inspect)

local function _logWrap(level)
	return function(self, ...)
	    assert(type(self) == 'table', "Make sure that you are using 'Class:method' instead of 'Class.method'")

		local args = {...}

		assert(#args >= 1 and #args <= 2, 'Must provider 1 or 2 arguments')

		if #args == 1 and type(args[1]) == 'table' then
			local input = args[1]
			input.Level = level
			input.ClassName = input.ClassName or self.className
			return self:Log(input)
		end

		local input = {
			Message = args[1],
			Level = level,
			Data = args[2],
			ClassName = self.className
		}
		return self:Log(input)
	end
end

--- Logging level
local LogLevel = {
	None = 1,
	Fatal = 2,
	Error = 3,
	Warn = 4,
	Info = 5,
	Debug = 6,
	Trace = 7,
}

local LogLevelName = {
	"None",
	"Fatal",
	"Error",
	"Warn",
	"Info",
	"Debug",
	"Trace",
}


local LoggingPlugin = {
	ComponentMixins = {
		Log = function(_, input)
			print(inspect(input))
			local outMsg = string.upper(LogLevelName[input.Level]) ..
				" [" .. input.ClassName .. "] " ..
				input.Message
			if input.Data then
				outMsg = outMsg .. "\n" .. inspect(input.Data)
			end

			if input.Level == LogLevel.Trace or
				input.Level == LogLevel.Debug or
				input.Level == LogLevel.Info then
				print(outMsg)
			elseif input.Level == LogLevel.Warn then
				warn(outMsg)
			elseif input.Level == LogLevel.Error or
				input.Level == LogLevel.Fatal then
				error(outMsg)
			end
		end,

		Trace = _logWrap(LogLevel.Trace),
		Debug = _logWrap(LogLevel.Debug),
		Info = _logWrap(LogLevel.Info),
		Warn = _logWrap(LogLevel.Warn),
		Error = _logWrap(LogLevel.Efrror),
		Fatal = _logWrap(LogLevel.Fatal),
	}
}

return LoggingPlugin
