--[[--
    widget
    @classmod UI.EntityEditor
--]]

local Roact = require(script.Parent.Parent.Parent.lib.Roact)
local ComponentEditor = require(script.Parent.ComponentEditor)
local Dropdown = require(script.Parent.Dropdown)
local ECS = require(script.Parent.Parent.Parent.ECS)

local EntityEditor = Roact.Component:extend("EntityEditor")

local c = Roact.createElement
local widgetBackground = Color3.fromRGB(255, 255, 255)

function EntityEditor:init(props)
    self.state = {
        Plugin = props.Plugin,
        CurrentSelection = props.CurrentSelection,
    }

    local sel = game:FindFirstChild("Selection")
    if sel then
        self:_handleSelectionChange(sel.SelectionChanged)
    else
        warn("No selection service found")
    end
end

function EntityEditor:render()
    local _ = self

    local children = {}
    if self.state.CurrentSelection then
        local componentEditors = {}

        for _, v in ipairs(self.state.CurrentSelection:GetComponents()) do
            local editor = c(ComponentEditor, {
                Name = v.Name,
            })
            table.insert(componentEditors, editor)
        end

        children = {
            c("UIListLayout", {}),
            unpack(componentEditors),
            c("Frame", {
                Size = UDim2.new(1.0, 0, 0, 64),
                BackgroundColor3 = widgetBackground,
                BackgroundTransparency = 0,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                SizeConstraint = Enum.SizeConstraint.RelativeXY,
            }, {
                c("UIListLayout", {
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                }),
                c(Dropdown, {
                    Items = {"Foo", "Bar"},
                    ChangeFn = function(item)
                        print("TODO: Add component " .. item)
                    end,
                })
            })
        }
    end

    return c("Frame", {
        Size = UDim2.new(1.0, 0, 1.0, 0),
        BackgroundColor3 = widgetBackground,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        SizeConstraint = Enum.SizeConstraint.RelativeXY,
    }, children)
end

function EntityEditor:_handleSelectionChange(signal)
	self._selectionConnection = signal:Connect(function()
		local s = game.Selection:Get()
        if s == nil then
            self:setState({
                CurrentSelection = nil,
            })
			return
		end

		local f = s[1]
        if f == nil then
            self:setState({
                CurrentSelection = nil,
            })

			return
		end

        if not f:IsA("Script") then
            self:setState({
                CurrentSelection = nil,
            })

			return
        end

        if not f.Name:match(ECS.Entity.Pattern) then
            self:setState({
                CurrentSelection = nil,
            })

			return
        end

		local entity = ECS.Entity:new({
            Script = f,
        })
        if not entity then
            self:setState({
                CurrentSelection = nil,
            })

			return
        end

        self:setState({
            CurrentSelection = entity,
        })
	end)
end

return EntityEditor