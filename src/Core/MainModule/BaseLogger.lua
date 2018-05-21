local class = require(script.Parent.lib.middleclass)

--[[
	BaseLogger for creating logging extensions.
--]]
local BaseLogger = class(script.Name)

function BaseLogger:initialize(input)
	assert(input, 'No input for new(input)')
	assert(input.ClassName, 'ClassName not provided to new()')

	self.Player = input.Player
	self.ClassName = input.ClassName
	self.Config = input.Config or {}
end

function BaseLogger:Log(input)
	assert(input, 'No input to Log()')
	assert(input.Message, 'Message not provided to Log()')
	assert(input.Level, 'Level not provided to Log()')
	assert(self.ClassName, 'ClassName not defined in class')
end

return BaseLogger