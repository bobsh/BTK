return function()
    local Player = require(script.Parent.Player)

    describe("Player", function()
        it("should require ok", function()
            expect(Player).to.be.ok()
        end)

        itSKIP("should new ok", function()
            local p = Instance.new("Folder")
            p.Name = "PlayerScripts"
            local s = Instance.new("Script", p)
            expect(Player:new({
                Script = s,
            })).to.be.ok()
        end)
    end)
end