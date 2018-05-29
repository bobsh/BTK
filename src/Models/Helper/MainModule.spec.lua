return function()
    local Helper = require(script.Parent.MainModule)

    describe("Helper", function()
        it("should require ok", function()
            expect(Helper).to.be.ok()
        end)

        it("should return a func", function()
            expect(Helper).to.be.a("function")
        end)

        --- @TODO there is a bug with all script instances
        it("should work", function()
            local newscript = Instance.new("Script")
            newscript.Name = "BTK:Terrain"
            local s = Helper(newscript)
            expect(s).to.be.a("table")
        end)
    end)
end