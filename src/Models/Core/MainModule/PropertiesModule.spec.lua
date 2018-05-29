return function()
    local PropertiesModule = require(script.Parent.PropertiesModule)

    describe("PropertiesModule", function()
        it("should require ok", function()
            expect(PropertiesModule).to.be.ok()
        end)

        it("should be a table", function()
            expect(PropertiesModule).to.be.a("table")
        end)
    end)
end