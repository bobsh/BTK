local class = require(script.Parent.lib.middleclass)
local Schema = require(script.Parent.Schema)
local ClassyModule = require(script.Parent.ClassyModule)
local LoggerModule = require(script.Parent.LoggerModule)
local SchemaModule = require(script.Parent.SchemaModule)
local OutputLogger = require(script.Parent.OutputLogger)

--[[
	BaseObject is an abstract object that is at the root of the BTK
	class hierachy.
--]]
BaseObject = class(script.Name)
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