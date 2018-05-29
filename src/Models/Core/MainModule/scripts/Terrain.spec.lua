return function()
    local Terrain = require(script.Parent.Terrain)

    describe("Terrain", function()
        it("should require ok", function()
            expect(Terrain).to.be.ok()
        end)

        --[[
        --- @TODO this fails now
        it("should new ok", function()
            expect(Terrain:new({
                Script = Instance.new("Script"),
            })).to.be.ok()
        end)
        --]]
    end)
end