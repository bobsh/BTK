local BaseLogger = require(script.Parent.BaseLogger)
local Schema = require(script.Parent.Schema)
local inspect = require(script.Parent.lib.inspect)

--[[
	OutputLogger outputs to the standard text output
--]]
OutputLogger = BaseLogger:subclass(script.Name)

function OutputLogger:Log(input)
	BaseLogger.Log(self, input)

	local outMsg = string.upper(input.Level.Name) ..
		" [" .. input.ClassName .. "] " ..
		input.Message
	if input.Data then
		outMsg = outMsg .. "\n" .. inspect(input.Data)
	end
	
	if input.Level == Schema.Enums.LogLevel.Trace or
		input.Level == Schema.Enums.LogLevel.Debug or
		input.Level == Schema.Enums.LogLevel.Info then
		print(outMsg)
	elseif input.Level == Schema.Enums.LogLevel.Warn then
		warn(outMsg)
	elseif input.Level == Schema.Enums.LogLevel.Error or
		input.Level == Schema.Enums.LogLevel.Fatal then
		error(outMsg)
	end
end

return OutputLogger