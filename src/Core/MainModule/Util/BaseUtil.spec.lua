return function()
    local BaseUtil = require(script.Parent.BaseUtil)

    describe("BaseUtil", function()
        it("should require ok", function()
            expect(BaseUtil).to.be.ok()
        end)

        it("should new ok", function()
            expect(BaseUtil:new()).to.be.ok()
        end)
    end)
end