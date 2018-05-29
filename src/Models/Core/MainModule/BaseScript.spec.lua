return function()
    local BaseScript = require(script.Parent.BaseScript)

    describe("BaseScript", function()
        it("should require ok", function()
            expect(BaseScript).to.be.ok()
        end)

        it("should new ok", function()
            expect(BaseScript:new({
                Script = Instance.new("Script"),
            })).to.be.ok()
        end)

        it("should have properties", function()
            local props = BaseScript:Properties()
            expect(props).to.be.a("table")
            expect(props.Script).to.be.a("table")
        end)

        it("GetScript should work", function()
            local s = Instance.new("Script")
            local a = BaseScript:new({
                Script = s,
            })
            expect(a:GetScript()).to.equal(s)
        end)

        it("GetConfigurationFolder should work", function()
            local s = Instance.new("Script")
            local f = Instance.new("Folder", s)
            f.Name = "Configuration"
            local a = BaseScript:new({
                Script = s,
            })
            expect(a:GetConfigurationFolder()).to.equal(f)
        end)

        it("GetInputEvent should work", function()
            local s = Instance.new("Script")
            local a = BaseScript:new({
                Script = s,
            })
            local e = a:GetInputEvent()
            expect(e).to.be.a("userdata")
            expect(e.Name).to.equal("InputEvent")
        end)
    end)
end