return function()
    local ConfigurationWidget = require(script.Parent.ConfigurationWidget)

    describe("ConfigurationWidget", function()
        it("should require ok", function()
            expect(ConfigurationWidget).to.be.ok()
        end)

        it("should init", function()
            expect(ConfigurationWidget:init({})).never.to.be.ok()
        end)

        it("should render", function()
            expect(ConfigurationWidget:render()).to.be.ok()
        end)
    end)
end