return function()
    local NPC = require(script.Parent.NPC)

    describe("NPC", function()
        it("should require ok", function()
            expect(NPC).to.be.ok()
        end)

        --[[
        --- @TODO this fails now
        it("should new ok", function()
            expect(NPC:new({
                Script = Instance.new("Script"),
            })).to.be.ok()
        end)
        --]]
    end)
end