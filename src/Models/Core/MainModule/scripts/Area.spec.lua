return function()
    local Area = require(script.Parent.Area)

    describe("Area", function()
        it("should require ok", function()
            expect(Area).to.be.ok()
        end)

        itSKIP("should new ok", function()
            local p = Instance.new("Model")
            local s = Instance.new("Script", p)
            expect(Area:new({
                Script = s,
            })).to.be.ok()
        end)
    end)
end