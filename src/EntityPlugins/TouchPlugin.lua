--[[---
	Touch plugin

	TouchUtil class which contains a series of static functions
	that you can utilise.

	@classmod TouchPlugin
--]]

local TouchPlugin = {
	ComponentMixins = {}
}

--[[---
	A debounce implementation.

	@tparam func func
	@treturn func
--]]
function TouchPlugin.ComponentMixins.Debounce(func)
    local isRunning = false    -- Create a local debounce variable
    return function(...)       -- Return a new function
        if not isRunning then
            isRunning = true

            func(...)          -- Call it with the original arguments

            isRunning = false
        end
    end
end

function TouchPlugin.ComponentMixins:GetComponentInAncestorInst(instance, component)
	local cur = instance
	while cur do
		local object = self._core:getComponentFromInstance(component, cur)
		if object then
			return object
		end
		cur = cur.Parent
	end
	return nil
end

--[[---
	An enhanced hit wrapper

	@tparam func func
	@treturn func
--]]
function TouchPlugin.ComponentMixins.EnhancedFn(func)
	return function(hit)
		local input = {
			Instance = hit,
			Player = game.Players:GetPlayerFromCharacter(hit.Parent),
		}
		func(input)
	end
end

return TouchPlugin
