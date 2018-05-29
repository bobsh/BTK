return function()
    local TouchUtil = require(script.Parent.TouchUtil)

    describe("TouchUtil", function()
        it("should require ok", function()
            expect(TouchUtil).to.be.ok()
        end)

        it("should new ok", function()
            expect(TouchUtil:new()).to.be.ok()
        end)
    end)
end