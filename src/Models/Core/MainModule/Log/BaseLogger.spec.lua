return function()
    local BaseLogger = require(script.Parent.BaseLogger)

    describe("BaseLogger", function()
        it("should require ok", function()
            expect(BaseLogger).to.be.ok()
        end)

        it("should new ok", function()
            expect(BaseLogger:new({ClassName = "test"})).to.be.ok()
        end)
    end)
end