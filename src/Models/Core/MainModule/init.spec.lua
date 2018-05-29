return function()
    local btk = require(script.Parent)

    describe("btk", function()
        it("should require ok", function()
            expect(btk).to.be.ok()
        end)

        it("should new ok", function()
            expect(btk:new()).to.be.ok()
        end)
    end)
end