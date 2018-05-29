return function()
    local Model = require(script.Parent.Model)

    describe("Model", function()
        it("should require ok", function()
            expect(Model).to.be.ok()
        end)

        --[[
        --- @TODO this fails now
        it("should new ok", function()
            expect(Model:new({
                Script = Instance.new("Script"),
            })).to.be.ok()
        end)
        --]]
    end)
end