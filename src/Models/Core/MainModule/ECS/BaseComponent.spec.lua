return function()
    local ECS = require(script.Parent)

    it("should require ok", function()
        expect(ECS.BaseComponent).to.be.ok()
    end)

    it("should new ok", function()
        expect(ECS.BaseComponent:new()).to.be.ok()
    end)
end