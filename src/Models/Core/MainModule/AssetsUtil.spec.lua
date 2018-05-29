return function()
    local AssetsUtil = require(script.Parent.AssetsUtil)

    describe("AssetsUtil", function()
        it("should require ok", function()
            expect(AssetsUtil).to.be.ok()
        end)

        it("should new ok", function()
            expect(AssetsUtil:new()).to.be.ok()
        end)
    end)
end