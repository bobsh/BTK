return function()
    local ECS = require(script.Parent)

    it("should require ok", function()
        expect(ECS.Entity).to.be.ok()
    end)

    it("should new ok", function()
        expect(ECS.Entity:new()).to.be.ok()
    end)
end