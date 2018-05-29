return function()
    local PlatformMover = require(script.Parent.PlatformMover)

    describe("PlatformMover", function()
        it("should require ok", function()
            expect(PlatformMover).to.be.ok()
        end)

        --[[
        --- @TODO this fails now
        it("should new ok", function()
            expect(PlatformMover:new({
                Script = Instance.new("Script"),
            })).to.be.ok()
        end)
        --]]
    end)
end