local s = require(script.Parent.lib.schema)

Schema = {
	--[[
		Variant self:AssertSchema(Variant input, ? schema)
		
		Throws error if validation fails, otherwise returns
		the input so you can do things like:
		
			return self:AssertSchema(
				output,
				s.String
			)
			
		At the end of a function.
	--]]
	AssertSchema = function(self, input, schema)
		local err = s.CheckSchema(input, schema)
		if err then
			self:Error("Schema validation failure: " .. tostring(err))
		end
		return input
	end,
	
	static = {}
}

Schema.static.AssertSchema = Schema.AssertSchema

return Schema
