--- @classmod LoggerModule

local BaseLogger = require(script.Parent.BaseLogger)
local Schema = require(script.Parent.Schema)

local LoggerModule = {
	static = {
		_logger = {
			_registered = {},
		},

		--- Add logger
		AddLogger = function(self, input)
			assert(input, 'No input for AddLoger()')
			assert(input.Class:isSubclassOf(BaseLogger),
				'Class is not subclass of BaseLogger')

			local cls = input.Class
			local logger = cls:new({
				ClassName = self:GetClassName(),
				Player = input.Player,
				Config = input.Config,
			})
			print("Logger: " .. self:GetClassName() .. " Added logger: " .. input.Class.name)
			table.insert(self._logger._registered, logger)
		end,
	},
}

local function _logWrap(level)
	return function(self, ...)
	    assert(type(self) == 'table', "Make sure that you are using 'Class:method' instead of 'Class.method'")

		local args = {...}

		assert(#args >= 1 and #args <= 2, 'Must provider 1 or 2 arguments')

		if #args == 1 and type(args[1]) == 'table' then
			local input = args[1]
			input.Level = level
			input.ClassName = input.ClassName or self:GetClassName()
			return self:Log(input)
		end

		local input = {
			Message = args[1],
			Level = level,
			Data = args[2],
			ClassName = self:GetClassName()
		}
		return self:Log(input)
	end
end

local contextHelpers = {
	Log = function(self, input)
		local registered
		if self.class ~= nil then
			registered = self.class._logger._registered
		else
			registered = self._logger._registered
		end
		for _, logger in ipairs(registered) do
			logger:Log(input)
		end
	end,

	Trace = _logWrap(Schema.Enums.LogLevel.Trace),
	Debug = _logWrap(Schema.Enums.LogLevel.Debug),
	Info = _logWrap(Schema.Enums.LogLevel.Info),
	Warn = _logWrap(Schema.Enums.LogLevel.Warn),
	Error = _logWrap(Schema.Enums.LogLevel.Error),
	Fatal = _logWrap(Schema.Enums.LogLevel.Fatal),

	Assert = function(self, v, message)
		if not v then
			message = message or "Assertion failed"
			self:Error(message)
		end
	end,

	AssertWarn = function(self, v, message)
		if v then
			return true
		end
		message = message or "Assertion failed"
		self:Warn(message)
		return false
	end,
}

for key, val in pairs(contextHelpers) do
	LoggerModule.static[key] = val
	LoggerModule[key] = val
end

return LoggerModule
