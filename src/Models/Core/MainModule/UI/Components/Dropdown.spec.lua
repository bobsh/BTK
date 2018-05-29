return function()
    local Dropdown = require(script.Parent.Dropdown)

    describe("Dropdown", function()
        it("should require ok", function()
            expect(Dropdown).to.be.ok()
        end)

        it("should new ok", function()
            expect(Dropdown:init({})).never.to.be.ok()
        end)

        it("should render", function()
            expect(Dropdown:render()).to.be.ok()
        end)
    end)
end