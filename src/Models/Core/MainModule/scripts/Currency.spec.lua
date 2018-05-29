return function()
    local Currency = require(script.Parent.Currency)

    describe("Currency", function()
        it("should require ok", function()
            expect(Currency).to.be.ok()
        end)

        --[[
        --- @TODO this fails now
        it("should new ok", function()
            expect(Currency:new({
                Script = Instance.new("Script"),
            })).to.be.ok()
        end)
        --]]
    end)
end