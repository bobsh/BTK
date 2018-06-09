return function()
    local SentryLogger = require(script.Parent.SentryLogger)

    describe("SentryLogger", function()
        it("should require ok", function()
            expect(SentryLogger).to.be.ok()
        end)

        it("should new ok", function()
            expect(SentryLogger:new({
                ClassName = "test",
            })).to.be.ok()
        end)
    end)
end