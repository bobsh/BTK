return function()
    local AssetsWidget = require(script.Parent.AssetsWidget)

    describe("AssetsWidget", function()
        it("should require ok", function()
            expect(AssetsWidget).to.be.ok()
        end)

        it("should new ok", function()
            expect(AssetsWidget:init({
                Plugin = "foo",
            })).never.to.be.ok()
        end)

        it("should render", function()
            expect(AssetsWidget:render()).to.be.ok()
        end)
    end)
end