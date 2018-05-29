return function()
    local UI = require(script.Parent)

    describe("UI", function()
        it("should require ok", function()
            expect(UI).to.be.ok()
        end)

        it("should new ok", function()
            expect(UI:new()).to.be.ok()
        end)
    end)
end