return function()
    local Teleporter = require(script.Parent.Teleporter)

    describe("Teleporter", function()
        it("should require ok", function()
            expect(Teleporter).to.be.ok()
        end)

        --[[
        --- @TODO this fails now
        it("should new ok", function()
            expect(Teleporter:new({
                Script = Instance.new("Script"),
            })).to.be.ok()
        end)
        --]]
    end)
end