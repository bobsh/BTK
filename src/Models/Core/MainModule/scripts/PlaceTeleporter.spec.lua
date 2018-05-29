return function()
    local PlaceTeleporter = require(script.Parent.PlaceTeleporter)

    describe("PlaceTeleporter", function()
        it("should require ok", function()
            expect(PlaceTeleporter).to.be.ok()
        end)

        --[[
        --- @TODO this fails now
        it("should new ok", function()
            expect(PlaceTeleporter:new({
                Script = Instance.new("Script"),
            })).to.be.ok()
        end)
        --]]
    end)
end