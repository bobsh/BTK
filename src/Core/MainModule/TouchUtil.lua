local BaseUtil = require(script.Parent.BaseUtil)
local Schema = require(script.Parent.Schema)
local ComponentHandle = require(script.Parent.ComponentHandle)

local TouchUtil = BaseUtil:subclass(script.Name)

function TouchUtil.static:Debounce(func)
    local isRunning = false    -- Create a local debounce variable
    return function(...)       -- Return a new function
        if not isRunning then
            isRunning = true

            func(...)          -- Call it with the original arguments

            isRunning = false
        end
    end
end

function TouchUtil.static:EnhancedFn(func)
	return function(hit)
		local input = {
			Hit = hit,
			Player = game.Players:GetPlayerFromCharacter(hit.Parent),
			Component = TouchUtil:GetComponentData({
				Inst = hit,
			}),
		}
		func(input)
	end
end

--[[
	GetComponentData from an instance
--]]
function TouchUtil.static:GetComponentData(input)
	self:AssertSchema(
		input,
		Schema.Record {
			Inst = Schema:IsA("Instance"),
		}
	)

	local output = {}
	if input.Inst:IsA("Model") or input.Inst:IsA("Tool") then
		output.Root = input.Inst
	else
		output.Root = input.Inst:FindFirstAncestorOfClass("Tool")
		if not output.Root then
			output.Root = input.Inst:FindFirstAncestorOfClass("Model")
		end
	end

	-- No root? probably not a component just bail with nil
	if not output.Root then
		self:Debug("Cannot find a compatible root of instance probably not a component",
			{
				InstanceName = input.Inst.Name,
			}
		)
		return nil
	end

	-- Create a new component handle and return that
	return ComponentHandle:new(output)
end

return TouchUtil
