return function()
    local AssetItem = require(script.Parent.AssetItem)

    describe("AssetItem", function()
        it("should require ok", function()
            expect(AssetItem).to.be.ok()
        end)

        it("should init", function()
            --- @TODO we currently can't emulate marketplace service
            expect(function()
                AssetItem:init()
            end).to.throw()
        end)

        it("should render", function()
            --- @TODO we need init to work first
            expect(function()
                AssetItem:render()
            end).to.throw()
        end)
    end)
end