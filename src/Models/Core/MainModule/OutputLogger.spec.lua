return function()
    local OutputLogger = require(script.Parent.OutputLogger)

    describe("OutputLogger", function()
        it("should require ok", function()
            expect(OutputLogger).to.be.ok()
        end)

        it("should new ok", function()
            expect(OutputLogger:new({ClassName = "test"})).to.be.ok()
        end)
    end)
end