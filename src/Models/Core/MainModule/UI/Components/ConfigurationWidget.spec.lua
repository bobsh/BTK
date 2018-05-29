local Roact = require(script.Parent.Parent.Parent.lib.Roact)

return function()
    local ConfigurationWidget = require(script.Parent.ConfigurationWidget)

    describe("ConfigurationWidget", function()
        it("should require ok", function()
            expect(ConfigurationWidget).to.be.ok()
        end)

        it("should mount and unmount", function()
            local d = Roact.createElement(ConfigurationWidget)
            local h = Roact.mount(d)
            Roact.unmount(h)
        end)
    end)
end