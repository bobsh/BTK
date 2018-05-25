--[[--
    Assets widget item
    @classmod UI.AssetItem
    @export
--]]

local Roact = require(script.Parent.Parent.Parent.lib.Roact)
local AssetsUtil = require(script.Parent.Parent.Parent.AssetsUtil)
local AssetItem = Roact.Component:extend("AssetItem")
local c = Roact.createElement

local MarketplaceService = game:GetService("MarketplaceService")

function AssetItem:init(props)
    local productInfo = MarketplaceService:GetProductInfo(props.ID, Enum.InfoType.Asset)

    local asset = {
        Name = productInfo.Name,
        Parent = game.Workspace,
        Type = props.Type,
        ParentType = "Instance",
        ID = props.ID
    }

    self.state = {
        Asset = asset,
        Plugin = props.Plugin,
    }
end

function AssetItem:render()
    local iconURL = "https://www.roblox.com/asset-thumbnail/image?assetId=" ..
        tostring(self.state.Asset.ID) ..
        "&width=420&height=420&format=png&bust=" ..
        math.floor(tick())

    return c("Frame", {
        Size = UDim2.new(1.0, 0, 0, 96),
    }, {
        Button = c("ImageButton", {
            Size = UDim2.new(0, 96, 0, 96),
            Style = Enum.ButtonStyle.Custom,
            AutoButtonColor = true,
            ImageColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 1,
            Image = iconURL,

            [Roact.Event.MouseButton1Click] = self._createFunction,
        }),
        Name = c("TextLabel", {
            Position = UDim2.new(0, 100, 0, 0),
            Size = UDim2.new(0, 128, 0, 16),
            Text = self.state.Asset.Name,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = Color3.new(0,0,0),
            TextSize = 14,
            Font = Enum.Font.SourceSansBold,
            BackgroundTransparency = 1.0,
            Visible = true,
        }),
        Description = c("TextLabel", {
            Position = UDim2.new(0, 100, 0, 16),
            Size = UDim2.new(0, 128, 0, 80),
            Text = self.state.Asset.Description,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = Color3.new(0,0,0),
            TextSize = 14,
            Font = Enum.Font.SourceSans,
            BackgroundTransparency = 1.0,
            Visible = true,
        })
    })
end

function AssetItem:_createFunction()
    return function()
        self.state.Plugin:Activate(true)
        local mouse = self.state.Plugin:GetMouse()
        local oldIcon = mouse.Icon
        mouse.Icon = "rbxassetid://1684734025"

        local touchedConnection
        touchedConnection = mouse.Button1Down:Connect(function(_)
            AssetsUtil:Install(self.state.Asset)
            touchedConnection:Disconnect()
            mouse.Icon = oldIcon
        end)
    end
end

return AssetItem