return function()
    local ECS = require(script.Parent)

    it("should require ok", function()
        expect(ECS.Entity).to.be.ok()
    end)

    it("should new ok", function()
        expect(ECS.Entity:new({
            Script = Instance.new("Script"),
        })).to.be.ok()
    end)
end