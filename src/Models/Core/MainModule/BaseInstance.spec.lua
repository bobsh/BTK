return function()
    local BaseInstance = require(script.Parent.BaseInstance)

    describe("BaseInstance", function()
        it("should require ok", function()
            expect(BaseInstance).to.be.ok()
        end)

        it("should new ok", function()
            expect(BaseInstance:new()).to.be.ok()
        end)
    end)
end