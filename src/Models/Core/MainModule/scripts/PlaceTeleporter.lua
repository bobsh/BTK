local Model = require(script.Parent.Model)
local TouchUtil = require(script.Parent.Parent.TouchUtil)
local Schema = require(script.Parent.Parent.Schema)

local TeleportService = game:GetService("TeleportService")

local PlaceTeleporter = Model:subclass(script.Name)
PlaceTeleporter:AddProperty({
	Name = "TeleportPlaceId",
	Type = "NumberValue",
	SchemaFn = Schema.PlaceId,
})

PlaceTeleporter:AddProperty({
	Name = "ReserveInstance",
	Type = "BoolValue",
	Value = false,
	SchemaFn = Schema.Boolean,
})

function PlaceTeleporter:initialize(input)
	Model.initialize(self, input)

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