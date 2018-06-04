return function()
    local ECS = require(script.Parent)

    it("should require ok", function()
        expect(ECS.Entity).to.be.ok()
    end)

    it("should new ok", function()
        local s = Instance.new("Script")
        s.Name = "BTK:SomeValidName"
        expect(ECS.Entity:new({
            Script = s,
        })).to.be.ok()
    end)
end