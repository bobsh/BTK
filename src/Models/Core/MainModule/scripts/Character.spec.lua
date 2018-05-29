return function()
    local Character = require(script.Parent.Character)

    describe("Character", function()
        it("should require ok", function()
            expect(Character).to.be.ok()
        end)

        --[[
        --- @TODO this fails now
        it("should new ok", function()
            expect(Character:new({
                Script = Instance.new("Script"),
            })).to.be.ok()
        end)
        --]]
    end)
end