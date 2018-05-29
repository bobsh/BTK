return function()
    local SchemaModule = require(script.Parent.SchemaModule)

    describe("SchemaModule", function()
        it("should require ok", function()
            expect(SchemaModule).to.be.ok()
        end)

        it("should be a table", function()
            expect(SchemaModule).to.be.a("table")
        end)
    end)
end