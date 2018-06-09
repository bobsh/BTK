--[[--
	BaseObject is an abstract object that is at the root of the BTK class hierachy.
	@classmod BaseObject
--]]
local class = require(script.Parent.lib.middleclass)
local ClassyModule = require(script.Parent.ClassyModule)
local LoggerModule = require(script.Parent.LoggerModule)
local SchemaModule = require(script.Parent.SchemaModule)
local OutputLogger = require(script.Parent.OutputLogger)

local BaseObject = class(script.Name)
BaseObject:include(ClassyModule)
BaseObject:include(LoggerModule)
BaseObject:AddLogger({
	Class = OutputLogger,
})
BaseObject:include(SchemaModule)

function BaseObject:initialize()
	self:Trace("Initialize")
end

return BaseObject