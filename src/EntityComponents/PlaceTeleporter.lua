local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local PlaceTeleporter = EntitySystem.Component:extend("PlaceTeleporter", {
    TeleportPlaceId = 0,
    ReserveInstance = true,
    OnPlayerAdded = false,
    OnTouched = true,
})

function PlaceTeleporter:added()
    if game.JobId == "" then
        self:Warn("PlaceTeleporter cannot be used in offline mode")
        return
    end

    if self.OnPlayerAdded then
        game.Players.PlayerAdded:Connect(function(player)
            self:_teleport(player)
        end)
    end

    if self.OnTouched then
        self.instance.Touched:Connect(
            self.TouchUtil:Debounce(
                self.TouchUtil:EnhancedFn(
                    function(input)
                        if input.Player then
                            self:_teleport(input.Player)
                        end
                    end
                )
            )
        )
    end
end

function PlaceTeleporter:_teleport(player)
    local TeleportService = game:GetService("TeleportService")

    if self.ReserveInstance then
        local reserveId = TeleportService:ReserveServer(
            self.TeleportPlaceId
        )
        TeleportService:TeleportToPrivateServer(
            self.TeleportPlaceId,
            reserveId,
            {player}
        )
    else
        TeleportService:Teleport(
            self.TeleportPlaceId,
            player
        )
    end

end

return PlaceTeleporter