local s = require(game.ReplicatedStorage.Modules.schema)

local AssertSchemaPlugin = {
	ComponentMixins = {
		--- Assert Schema
		AssertSchema = function(self, input, schema)
			local err = s.CheckSchema(input, schema)
			if err then
				self:Error("Schema validation failure: " .. tostring(err))
			end
			return input
		end,
	},
}

return AssertSchemaPlugin
