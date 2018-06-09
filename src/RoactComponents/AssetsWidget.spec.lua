local Roact = require(script.Parent.Parent.Parent.lib.Roact)

return function()
    local AssetsWidget = require(script.Parent.AssetsWidget)

    describe("AssetsWidget", function()
        it("should require ok", function()
            expect(AssetsWidget).to.be.ok()
        end)

        it("should mount and unmount", function()
            local d = Roact.createElement(AssetsWidget, {
                Plugin = "foo",
            })
            local h = Roact.mount(d)
            Roact.unmount(h)
        end)
    end)
end