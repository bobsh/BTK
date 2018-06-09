return function()
    local BaseObject = require(script.Parent.BaseObject)

    describe("BaseObject", function()
        it("should require ok", function()
            expect(BaseObject).to.be.ok()
        end)

        it("should new ok", function()
            expect(BaseObject:new()).to.be.ok()
        end)
    end)
end