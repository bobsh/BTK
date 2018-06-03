return function()
    local Character = require(script.Parent.Character)

    it("should require ok", function()
        expect(Character).to.be.ok()
    end)

    it("should new ok", function()
        expect(Character:new()).to.be.ok()
    end)
end