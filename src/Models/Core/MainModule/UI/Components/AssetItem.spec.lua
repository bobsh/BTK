local Roact = require(script.Parent.Parent.Parent.lib.Roact)

return function()
    local AssetItem = require(script.Parent.AssetItem)

    describe("AssetItem", function()
        it("should require ok", function()
            expect(AssetItem).to.be.ok()
        end)

        --- @TODO breaks trying to get MarketplaceService
        itSKIP("should mount and unmount", function()
            local d = Roact.createElement(AssetItem)
            local h = Roact.mount(d)
            Roact.unmount(h)
        end)
    end)
end