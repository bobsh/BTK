return function()
    local Schema = require(script.Parent.Schema)

    describe("Schema", function()
        it("should require ok", function()
            expect(Schema).to.be.ok()
        end)

        it("should new ok", function()
            expect(Schema:new()).to.be.ok()
        end)
    end)
end