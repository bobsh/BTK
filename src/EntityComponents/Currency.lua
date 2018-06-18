local EntitySystem = require(game.ReplicatedStorage.EntitySystem)
local Collectable = require(script.Parent.Collectable)

local Currency = EntitySystem.Component:extend("Currency", {
    Units = 1,
})

function Currency:added()
    local coll = self:getComponent(Collectable)
    self.Touched = false

    coll.CollectablePart.Touched:Connect(
		self.TouchUtil:Debounce(
			self.TouchUtil:EnhancedFn(
				self:OnTouch()
			)
		)
	)
end

function Currency:OnTouch()
	return function(input)
		if self.Touched then
			self:Debug("Already touching, do nothing")
			return
		end

		if input.Player then
			self:Debug(("Player touched %s"):format(input.Player.Name))
			self.Touched = true
			self:Destroy()
		end

		self.Touched = false
	end
end

return Currency