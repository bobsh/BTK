local ModelComponent = require(script.Parent.Parent.ModelComponent)
local TouchUtil = require(script.Parent.Parent.TouchUtil)
local Schema = require(script.Parent.Parent.Schema)

local TeleportService = game:GetService("TeleportService")

local PlaceTeleporter = ModelComponent:subclass(script.Name)

function PlaceTeleporter:initialize(input)
	ModelComponent.initialize(self, input)
	
	self:CreateData({
		Name = "TeleportPlaceId",
		Type = "NumberValue",
		Schema = Schema.PlaceId,
	})
	
	self:CreateData({
		Name = "ReserveInstance",
		Type = "BoolValue",
		Value = false,
		Schema = Schema.Boolean,
	})
	
	self:GetPrimaryPart().Touched:Connect(
		TouchUtil:Debounce(
			TouchUtil:EnhancedFn(
				self:CreateOnTouched()
			)
		)
	)
end

function PlaceTeleporter:CreateOnTouched()
	return function(input)
	    if input.Player then
			if self:IsReserveInstance() then
				local reserveId = TeleportService:ReserveServer(
					self:GetTeleportPlaceId()
				)
				TeleportService:TeleportToPrivateServer(
					self:GetTeleportPlaceId(),
					reserveId,
					{input.Player}
				)
			else
				TeleportService:Teleport(
					self:GetTeleportPlaceId(),
					input.Player
				)
			end
	    end
	end
end

return PlaceTeleporter