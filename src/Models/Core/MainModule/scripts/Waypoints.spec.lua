return function()
    local Waypoints = require(script.Parent.Waypoints)

    describe("Waypoints", function()
        it("should require ok", function()
            expect(Waypoints).to.be.ok()
        end)

        --[[
        --- @TODO this fails now
        it("should new ok", function()
            expect(Waypoints:new({
                Script = Instance.new("Script"),
            })).to.be.ok()
        end)
        --]]
    end)
end