return function()
    local ClassyModule = require(script.Parent.ClassyModule)

    describe("ClassyModule", function()
        it("should require ok", function()
            expect(ClassyModule).to.be.ok()
        end)

        it("should be a table", function()
            expect(ClassyModule).to.be.a("table")
        end)
    end)
end