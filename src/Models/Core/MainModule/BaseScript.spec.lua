return function()
    local BaseScript = require(script.Parent.BaseScript)

    describe("BaseScript", function()
        it("should require ok", function()
            expect(BaseScript).to.be.ok()
        end)

        it("should new ok", function()
            expect(BaseScript:new({
                Script = Instance.new("Script"),
            })).to.be.ok()
        end)
    end)
end