return function()
    local Weapon = require(script.Parent.Weapon)

    describe("Weapon", function()
        it("should require ok", function()
            expect(Weapon).to.be.ok()
        end)

        --[[
        --- @TODO this fails now
        it("should new ok", function()
            expect(Weapon:new({
                Script = Instance.new("Script"),
            })).to.be.ok()
        end)
        --]]
    end)
end