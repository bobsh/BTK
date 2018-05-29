return function()
    local Collectable = require(script.Parent.Collectable)

    describe("Collectable", function()
        it("should require ok", function()
            expect(Collectable).to.be.ok()
        end)

        itSKIP("should new ok", function()
            local p = Instance.new("Model")
            local s = Instance.new("Script", p)
            expect(Collectable:new({
                Script = s,
            })).to.be.ok()
        end)
    end)
end