local Collectable = require(script.Parent.Collectable)
local TouchUtil = require(script.Parent.Parent.TouchUtil)
--local CurrencyManager = require(script.Parent.Parent.Services.CurrencyManager)

local Currency = Collectable:subclass(script.Name)

function Currency:initialize(input)
	Collectable.initialize(self, input)
	self:Debug("Init")

	self.Touched = false

	self:GetCollectablePart().Touched:Connect(
		TouchUtil:Debounce(
			TouchUtil:EnhancedFn(
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
