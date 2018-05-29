return function()
    local ComponentHandle = require(script.Parent.ComponentHandle)

    describe("ComponentHandle", function()
        it("should require ok", function()
            expect(ComponentHandle).to.be.ok()
        end)
    end)
end