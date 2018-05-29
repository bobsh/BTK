return function()
    local Server = require(script.Parent.Server)

    describe("Server", function()
        it("should require ok", function()
            expect(Server).to.be.ok()
        end)

        --[[
        --- @TODO this fails now
        it("should new ok", function()
            expect(Server:new({
                Script = Instance.new("Script"),
            })).to.be.ok()
        end)
        --]]
    end)
end