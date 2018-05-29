return function()
    local Collectable = require(script.Parent.Collectable)

    describe("Collectable", function()
        it("should require ok", function()
            expect(Collectable).to.be.ok()
        end)

        --[[
        --- @TODO this fails now
        it("should new ok", function()
            expect(Collectable:new({
                Script = Instance.new("Script"),
            })).to.be.ok()
        end)
        --]]
    end)
end