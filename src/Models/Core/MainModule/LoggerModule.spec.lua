return function()
    local LoggerModule = require(script.Parent.LoggerModule)

    describe("LoggerModule", function()
        it("should require ok", function()
            expect(LoggerModule).to.be.ok()
        end)

        it("should be a table", function()
            expect(LoggerModule).to.be.a("table")
        end)
    end)
end