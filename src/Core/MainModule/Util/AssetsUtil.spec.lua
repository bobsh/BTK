return function()
    local AssetsUtil = require(script.Parent.AssetsUtil)

    describe("AssetsUtil", function()
        it("should require ok", function()
            expect(AssetsUtil).to.be.ok()
        end)
    end)
end