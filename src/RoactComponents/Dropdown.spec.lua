local Roact = require(script.Parent.Parent.Parent.lib.Roact)

return function()
    local Dropdown = require(script.Parent.Dropdown)

    describe("Dropdown", function()
        it("should require ok", function()
            expect(Dropdown).to.be.ok()
        end)

        it("should mount and unmount", function()
            local d = Roact.createElement(Dropdown, {
                Items = {"foo"},
            })
            local h = Roact.mount(d)
            Roact.unmount(h)
        end)
    end)
end