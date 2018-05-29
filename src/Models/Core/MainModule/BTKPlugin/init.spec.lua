return function()
    local BTKPlugin = require(script.Parent)

    describe("BTKPlugin", function()
        it("should require ok", function()
            expect(BTKPlugin).to.be.ok()
        end)

        --[[
        --- @TODO no support for emulating plugins yet
        it("should new ok", function()
            expect(BTKPlugin:new()).to.be.ok()
        end)
        --]]
    end)
end