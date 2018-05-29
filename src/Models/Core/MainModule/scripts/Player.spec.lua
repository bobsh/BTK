return function()
    local Player = require(script.Parent.Player)

    describe("Player", function()
        it("should require ok", function()
            expect(Player).to.be.ok()
        end)

        --[[
        --- @TODO this fails now
        it("should new ok", function()
            expect(Player:new({
                Script = Instance.new("Script"),
            })).to.be.ok()
        end)
        --]]
    end)
end