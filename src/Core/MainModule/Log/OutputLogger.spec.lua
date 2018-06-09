local Schema = require(script.Parent.Schema)

return function()
    local OutputLogger = require(script.Parent.OutputLogger)

    describe("OutputLogger", function()
        it("should require ok", function()
            expect(OutputLogger).to.be.ok()
        end)

        it("should new ok", function()
            local a = OutputLogger:new({ClassName = "test"})
            expect(a).to.be.ok()
        end)

        it("should log", function()
            local a = OutputLogger:new({ClassName = "test"})
            a:Log({
                Message = "foo",
                Level = Schema.Enums.LogLevel.Trace,
                ClassName = "foo",
            })
            a:Log({
                Message = "foo",
                Level = Schema.Enums.LogLevel.Debug,
                ClassName = "foo",
            })
            a:Log({
                Message = "foo",
                Level = Schema.Enums.LogLevel.Warn,
                ClassName = "foo",
            })
            a:Log({
                Message = "foo",
                Level = Schema.Enums.LogLevel.Info,
                ClassName = "foo",
            })

            expect(function()
                a:Log({
                    Message = "foo",
                    Level = Schema.Enums.LogLevel.Error,
                    ClassName = "foo",
                })
            end).to.throw()
            expect(function()
                a:Log({
                    Message = "foo",
                    Level = Schema.Enums.LogLevel.Fatal,
                    ClassName = "foo",
                })
            end).to.throw()
        end)
    end)
end