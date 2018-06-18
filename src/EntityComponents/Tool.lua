local EntitySystem = require(game.ReplicatedStorage.EntitySystem)

local Tool = EntitySystem.Component:extend("Tool", {
    Owner = "TODO",
    Equipped = true,
})

function Tool:added()
    local _ = self
    self:SetOwner(self:_getOwner())

    self.instance.AncestryChanged:Connect(function()
        self:Debug("AncestryChanged: recalculating Owner")
        self.Owner = self:_getOwner()
    end)

    self.instanced.Equipped:Connect(function()
        self:Debug("Equipped: recalculating IsEquipped")
        self.Equipped = true
    end)
    self.instance.Unequipped:Connect(function()
        self:Debug("Unequipped: recalculating IsEquipped")
        self.Equipped = false
    end)
end


--[[
_getOwner returns the character that currently holds the object.
--]]
function Tool:_getOwner()
    local model = self:GetTool().Parent
    if model:IsA("Backpack") then
        local player = model.Parent
        if player:IsA("Player") then
            model = player.Character
        end
    end

    if not model:IsA("Model") then
        self:Debug("The instance is not a model",
            {
                InstanceName = model.Name,
                ClassName = model.ClassName,
            }
        )
        return nil
    end

    local comp = self:GetComponentData({
        Inst = model,
    })
    if comp then
        return comp:GetRoot()
    end

    self:Warn("Owner is not a component",
        {
            InstanceName = model.Name,
        }
    )
    return nil
end

return Tool