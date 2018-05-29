return function()
    local Currency = require(script.Parent.Currency)

    describe("Currency", function()
        it("should require ok", function()
            expect(Currency).to.be.ok()
        end)

        itSKIP("should new ok", function()
            local p = Instance.new("Model")
            local s = Instance.new("Script", p)
            expect(Currency:new({
                Script = s,
            })).to.be.ok()
        end)
    end)
end