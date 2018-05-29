local Roact = require(script.Parent.Parent.Parent.lib.Roact)

return function()
    local TextLabel = require(script.Parent.TextLabel)

    describe("TextLabel", function()
        it("should require ok", function()
            expect(TextLabel).to.be.ok()
        end)

        it("should mount and unmount", function()
            local d = Roact.createElement(TextLabel, {
                Size = UDim2.new(0,0,0,0),
                Text = "foo",
            })
            local h = Roact.mount(d)
            Roact.unmount(h)
        end)
    end)
end