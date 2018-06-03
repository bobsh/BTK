return function()
    local ECS = require(script.Parent)

    it("should require ok", function()
        expect(ECS).to.be.ok()
    end)
end