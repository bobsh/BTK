return function()
    local PlaceTeleporter = require(script.Parent.PlaceTeleporter)

    describe("PlaceTeleporter", function()
        it("should require ok", function()
            expect(PlaceTeleporter).to.be.ok()
        end)

        itSKIP("should new ok", function()
            local p = Instance.new("Model")
            local s = Instance.new("Script", p)
            expect(PlaceTeleporter:new({
                Script = s,
            })).to.be.ok()
        end)
    end)
end