return function()
    local Smashable = require(script.Parent.Smashable)

    describe("Smashable", function()
        it("should require ok", function()
            expect(Smashable).to.be.ok()
        end)

        it("should new ok", function()
            local p = Instance.new("Model")
            local s = Instance.new("Script", p)
            expect(Smashable:new({
                Script = s,
            })).to.be.ok()
        end)
    end)
end