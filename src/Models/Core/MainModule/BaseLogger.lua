--[[--
	Base logging abstract class
	@classmod BaseLogger
--]]

local class = require(script.Parent.lib.middleclass)

local BaseLogger = class(script.Name)

--- @tparam Schema.LogInit input
function BaseLogger:initialize(input)
	assert(input, 'No input for new(input)')
	assert(input.ClassName, 'ClassName not provided to new()')

	self.Player = input.Player
	self.ClassName = input.ClassName
	self.Config = input.Config or {}
end

--- Log
-- @tparam Schema.LogEntry input
function BaseLogger:Log(input)
	assert(input, 'No input to Log()')
	assert(input.Message, 'Message not provided to Log()')
	assert(input.Level, 'Level not provided to Log()')
	assert(self.ClassName, 'ClassName not defined in class')
end

return BaseLogger