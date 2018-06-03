return function()
    local InputEvent = require(script.Parent.InputEvent)

    it("should require ok", function()
        expect(InputEvent).to.be.ok()
    end)

    it("should new ok", function()
        expect(InputEvent:new()).to.be.ok()
    end)
end