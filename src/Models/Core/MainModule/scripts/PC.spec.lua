return function()
    local PC = require(script.Parent.PC)

    describe("PC", function()
        it("should require ok", function()
            expect(PC).to.be.ok()
        end)

        --[[
        --- @TODO this fails now
        it("should new ok", function()
            expect(PC:new({
                Script = Instance.new("Script"),
            })).to.be.ok()
        end)
        --]]
    end)
end