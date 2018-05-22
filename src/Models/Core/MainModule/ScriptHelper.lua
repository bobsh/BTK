local BaseObject = require(script.Parent.BaseObject)
local Schema = require(script.Parent.Schema)

local ScriptHelper = BaseObject:subclass(script.Name)

ScriptHelper.static.Pattern = "^BTK:(%u[%u%l%d]+)$"

function ScriptHelper.static:Get(s)
	self:AssertSchema(
		s,
		Schema.Script
	)

	local name = s.Name:match(ScriptHelper.Pattern)
	if name == nil then
		self:Error("BTK script name not valid",
			{
				ScriptName = s.Name,
				Pattern = self.Pattern,
			}
		)
	end

	local scriptToCall = script.Parent.scripts:FindFirstChild(name, false)
	if scriptToCall == nil then
		self:Error("Script does not exist",
			{
				ScriptName = s.Name,
				Script = name,
			}
		)
	end
	self:AssertSchema(
		scriptToCall,
		Schema:IsA("ModuleScript")
	)

	local scriptModule = require(scriptToCall)
	if scriptModule == nil then
		self:Error("Script require returned nil",
			{
				ScriptName = s.Name,
				Script = name,
			}
		)
	end
	return scriptModule
end

return ScriptHelper