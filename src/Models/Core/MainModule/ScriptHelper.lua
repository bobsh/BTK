--- @classmod ScriptHelper

local BaseObject = require(script.Parent.BaseObject)
local Schema = require(script.Parent.Schema)
local scriptsFolder = script.Parent.scripts
local scripts = {}
for _, val in ipairs(scriptsFolder:GetChildren()) do
	scripts[val.Name] = require(val)
end

local ScriptHelper = BaseObject:subclass(script.Name)

--- Pattern to match for the script name
ScriptHelper.static.Pattern = "^BTK:(%u[%u%l%d]+)$"

--- Get a script
-- @tparam Schema.Script s
-- @treturn BaseScript
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

	local scriptToCall = scripts[name]
	if scriptToCall == nil then
		self:Error("Script does not exist",
			{
				ScriptName = s.Name,
				Script = name,
			}
		)
	end

	return scriptToCall
end

return ScriptHelper