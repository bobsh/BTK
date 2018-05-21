local BaseObject = require(script.BaseObject)
local Schema = require(script.Schema)
local PlayerInit = require(script.PlayerInit)
local ServerInit = require(script.ServerInit)

--[[
	BTKMainModule
--]]
local btk = BaseObject:subclass('btk')

btk.static.BTKPlugin = require(script.BTKPlugin)
btk.static.ScriptHelper = require(script.ScriptHelper)

function btk.static:GetComponent(input)
	btk:AssertSchema(
		input,
		Schema.Record {
			Script = Schema.ComponentScript,
		}
	)

	local output = {
		Script = input.Script,
		Component = nil,
		Root = nil,
	}

	local comp
	do
		local scriptConfig = input.Script:FindFirstChild("Configuration")
		btk:Assert(scriptConfig, "No calling Script configuration")

		local scriptComponent = scriptConfig:FindFirstChild("Component")
		btk:Assert(scriptComponent, "No calling Script component configuration")

		output.Component = scriptComponent.Value
		if output.Component == "" then
			btk:Err("Calling script component value is empty")
		end

		local runScript = script.components[output.Component]
		btk:Assert(runScript, "unknown component " .. output.Component)

		comp = require(runScript)
		btk:Assert(comp, "no object returned from component " .. output.Component)
	end

	output.Root = input.Script.Parent
	self:Assert(output.Root, "No parent for Script on input")
	if not (output.Root:IsA("Model") or output.Root:IsA("Tool")) then
		self:Err("Parent of Script on input is not a Model or Tool",
			{
				Name = output.Root.Name,
				ClassName = output.Root.ClassName,
			}
		)
	end

	return comp:new(output)
end

function btk.static:PlayerInit(input)
	self:Trace("PlayerInit")
	return PlayerInit:new(input)
end

function btk.static:ServerInit(input)
	self:Trace("ServerInit")
	return ServerInit:new(input)
end

return btk
