return function()
    local ConfigurationWidget = require(script.Parent.ConfigurationWidget)

    describe("ConfigurationWidget", function()
        it("should require ok", function()
            expect(ConfigurationWidget).to.be.ok()
        end)

        --[[ @TODO no support for selection
        it("should new ok", function()
            expect(ConfigurationWidget:init({})).never.to.be.ok()
        end)
        --]]
    end)
end