return function()
    local Character = require(script.Parent.Character)

    describe("Character", function()
        it("should require ok", function()
            expect(Character).to.be.ok()
        end)

        itSKIP("should new ok", function()
            local p = Instance.new("Model")
            local s = Instance.new("Script", p)
            expect(Character:new({
                Script = s,
            })).to.be.ok()
        end)
    end)
end