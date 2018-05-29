return function()
    local ScriptHelper = require(script.Parent.ScriptHelper)

    describe("ScriptHelper", function()
        it("should require ok", function()
            expect(ScriptHelper).to.be.ok()
        end)

        it("should new ok", function()
            expect(ScriptHelper:new()).to.be.ok()
        end)
    end)
end