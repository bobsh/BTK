--[[--
	Schema checking and helper module
	@module SchemaModule
--]]

local s = require(script.Parent.lib.schema)

local Schema = {
	--- Assert Schema
	AssertSchema = function(self, input, schema)
		local err = s.CheckSchema(input, schema)
		if err then
			self:Error("Schema validation failure: " .. tostring(err))
		end
		return input
	end,

	--- Schema class
	-- @see {Schema}
	Schema = require(script.Parent.Schema),

	static = {}
}

--- Assert schema
Schema.static.AssertSchema = Schema.AssertSchema

return Schema
