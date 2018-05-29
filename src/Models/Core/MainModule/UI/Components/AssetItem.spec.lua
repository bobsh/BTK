return function()
    local AssetItem = require(script.Parent.AssetItem)

    describe("AssetItem", function()
        it("should require ok", function()
            expect(AssetItem).to.be.ok()
        end)

        --[[
        --- @TODO cannot emulate marketplaceservice yet
        it("should new ok", function()
            expect(AssetItem:init()).to.be.ok()
        end)
        --]]
    end)
end