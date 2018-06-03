return function()
    local Model = require(script.Parent.Model)

    it("should require ok", function()
        expect(Model).to.be.ok()
    end)

    it("should new ok", function()
        expect(Model:new()).to.be.ok()
    end)
end