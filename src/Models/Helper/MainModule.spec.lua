return function()
    local Helper = require(script.Parent.MainModule)

    describe("Helper", function()
        it("should require ok", function()
            expect(Helper).to.be.ok()
        end)

        it("should return a func", function()
            expect(Helper).to.be.a("function")
        end)
    end)
end