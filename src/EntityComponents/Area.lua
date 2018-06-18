local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local Area = EntitySystem.Component:extend("Area")

function Area:added()
    local _ = self

    self.instance.Anchored = true
	self.instance.CanCollide = false
	self.instance.Transparency = 1.0
	self.instance.Touched:Connect(self:TouchedConnect())
	self.instance.TouchEnded:Connect(self:TouchEndedConnect())
end

function Area:_touchedConnect()
	return function(otherPart)
		local comp = self:GetComponentData({
			Inst = otherPart,
		})
		if not comp then
			return
		end

		local humanoid = comp:GetData("Humanoid")
		if not humanoid then
			return
		end

		local rootPart = humanoid.RootPart
		if (not rootPart) or otherPart ~= rootPart then
			return
		end

		local player = comp:GetData("Player")
		if player ~= nil then
			self:Dbg(("Player touched with %s"):format(tostring(player)))
			local playerEvent = self:GetConfiguration("PlayerTouchedBindableEvent")
			playerEvent:Fire(player)
		end
	end
end

function Area:_touchEndedConnect()
	return function(otherPart)
		local comp = self:GetComponentData({
			Inst = otherPart,
		})
		if not comp then
			return
		end

		local humanoid = comp:GetData("Humanoid")
		if not humanoid then
			return
		end

		local rootPart = humanoid.RootPart
		if (not rootPart) or otherPart ~= rootPart then
			return
		end

		local player = comp:GetData("Player")
		if player ~= nil then
			self:Dbg("Player touch ended")
			local playerEvent = self:GetConfiguration("PlayerTouchEndedBindableEvent")
			playerEvent:Fire(player)
		end
	end
end

return Area