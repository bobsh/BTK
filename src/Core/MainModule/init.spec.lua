return function()
    local btk = require(script.Parent)

    describe("btk", function()
        it("should require ok", function()
            expect(btk).to.be.ok()
        end)

        it("should link to ecs", function()
            expect(btk.ECS).to.be.ok()
        end)
    end)
end