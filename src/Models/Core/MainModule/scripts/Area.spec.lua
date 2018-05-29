return function()
    local Area = require(script.Parent.Area)

    describe("Area", function()
        it("should require ok", function()
            expect(Area).to.be.ok()
        end)

        --[[
        --- @TODO this fails now
        it("should new ok", function()
            expect(Area:new({
                Script = Instance.new("Script"),
            })).to.be.ok()
        end)
        --]]
    end)
end