return function()
    local Tool = require(script.Parent.Tool)

    describe("Tool", function()
        it("should require ok", function()
            expect(Tool).to.be.ok()
        end)

        --[[
        --- @TODO this fails now
        it("should new ok", function()
            expect(Tool:new({
                Script = Instance.new("Script"),
            })).to.be.ok()
        end)
        --]]
    end)
end