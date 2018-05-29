return function()
    local Terrain = require(script.Parent.Terrain)

    describe("Terrain", function()
        it("should require ok", function()
            expect(Terrain).to.be.ok()
        end)

        it("should new ok", function()
            local p = Instance.new("Model")
            local s = Instance.new("Script", p)
            expect(Terrain:new({
                Script = s,
            })).to.be.ok()
        end)
    end)
end