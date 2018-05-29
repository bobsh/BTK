return function()
    local Smashable = require(script.Parent.Smashable)

    describe("Smashable", function()
        it("should require ok", function()
            expect(Smashable).to.be.ok()
        end)

        --[[
        --- @TODO this fails now
        it("should new ok", function()
            expect(Smashable:new({
                Script = Instance.new("Script"),
            })).to.be.ok()
        end)
        --]]
    end)
end