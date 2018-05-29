return function()
    local Model = require(script.Parent.Model)

    describe("Model", function()
        it("should require ok", function()
            expect(Model).to.be.ok()
        end)

        it("should new ok", function()
            local p = Instance.new("Model")
            local s = Instance.new("Script", p)
            expect(Model:new({
                Script = s,
            })).to.be.ok()
        end)
    end)
end