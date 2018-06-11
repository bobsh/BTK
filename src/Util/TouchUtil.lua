--[[---
	Touch utilities

	TouchUtil class which contains a series of static functions
	that you can utilise.

	@classmod TouchUtil
--]]

local TouchUtil = {}

--[[---
	A debounce implementation.

	@tparam func func
	@treturn func
--]]
function TouchUtil.Debounce(func)
    local isRunning = false    -- Create a local debounce variable
    return function(...)       -- Return a new function
        if not isRunning then
            isRunning = true

            func(...)          -- Call it with the original arguments

            isRunning = false
        end
    end
end

--[[---
	An enhanced hit wrapper

	@tparam func func
	@treturn func
--]]
function TouchUtil.EnhancedFn(func)
	return function(hit)
		local input = {
			Instance = hit,
			Player = game.Players:GetPlayerFromCharacter(hit.Parent),
		}
		func(input)
	end
end

return TouchUtil
