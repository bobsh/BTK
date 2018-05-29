return function()
    local TextLabel = require(script.Parent.TextLabel)

    describe("TextLabel", function()
        it("should require ok", function()
            expect(TextLabel).to.be.ok()
        end)

        it("should new ok", function()
            expect(TextLabel:init({})).never.to.be.ok()
        end)

        it("should render", function()
            expect(TextLabel:render()).to.be.ok()
        end)

    end)
end