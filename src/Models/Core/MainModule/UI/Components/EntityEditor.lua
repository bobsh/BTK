--[[--
    widget
    @classmod UI.EntityEditor
--]]

local Roact = require(script.Parent.Parent.Parent.lib.Roact)
local ComponentEditor = require(script.Parent.ComponentEditor)
local ECS = require(script.Parent.Parent.Parent.ECS)

local EntityEditor = Roact.Component:extend("EntityEditor")

local c = Roact.createElement
local widgetBackground = Color3.fromRGB(255, 255, 255)

function EntityEditor:init(props)
    self.state = {
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

    local componentEditors = {}
    if self.state.CurrentSelection then
        for _, v in ipairs(self.state.CurrentSelection:GetComponents()) do
            local editor = c(ComponentEditor, {
                Name = v.Name,
            })
            table.insert(componentEditors, editor)
        end
    end

    return c("Frame", {
        Size = UDim2.new(1.0, 0, 1.0, 0),
        BackgroundColor3 = widgetBackground,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        SizeConstraint = Enum.SizeConstraint.RelativeXY,
    }, {
        c("UIListLayout", {
        }),
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
            c("TextButton", {
                Font = Enum.Font.Arial,
                Text = "Add Component",
                TextSize = 12,
                AutoButtonColor = true,
                BackgroundColor3 = Color3.new(0.8, 0.8, 0.8),
                BackgroundTransparency = 0,
                ClipsDescendants = true,

                [Roact.Event.MouseButton1Click] = function(_)
                    print "TODO"
                end,
            }, {
                c("UISizeConstraint", {
                    MinSize = Vector2.new(120, 24),
                }),
            }),
        }),
    })
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