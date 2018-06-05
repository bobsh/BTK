--[[--
    widget
    @classmod UI.EntityEditor
--]]

local Roact = require(script.Parent.Parent.Parent.lib.Roact)
local ComponentEditor = require(script.Parent.ComponentEditor)
local Dropdown = require(script.Parent.Dropdown)
local ECS = require(script.Parent.Parent.Parent.ECS)
local FitChildren = require(script.Parent.Parent.Parent.lib.RoactStudioWidgets.FitChildren)

local EntityEditor = Roact.Component:extend("EntityEditor")

local c = Roact.createElement
local widgetBackground = Color3.fromRGB(255, 255, 255)

--- @TODO make this dynamic, stupid loading issues
local _components = {
	Character = require(script.Parent.Parent.Parent.Components.Character),
	InputEvent = require(script.Parent.Parent.Parent.Components.InputEvent),
	Model = require(script.Parent.Parent.Parent.Components.Model),
}

function EntityEditor:init(props)
    self.state = {
        Plugin = props.Plugin,
        CurrentSelection = props.CurrentSelection,
        Components = {},
    }

    local sel = game:FindFirstChild("Selection")
    if sel then
        self:_handleSelectionChange(sel.SelectionChanged)
    else
        warn("No selection service found")
    end
end

function EntityEditor:render()
    local children = {
        c("UIListLayout"),
    }
    if self.state.CurrentSelection then
        local componentEditors = {}

        print("Number of components in state: " .. tostring(#self.state.Components))
        for _, v in ipairs(self.state.Components) do
            table.insert(children, c(ComponentEditor, {
                Component = v,
            }))
        end

        print("Number of component editors: " .. tostring(#componentEditors))

        table.insert(children,
            c("Frame", {
                Size = UDim2.new(1.0, 0, 0, 64),
                BackgroundColor3 = widgetBackground,
                BackgroundTransparency = 0,
                BorderSizePixel = 0,
                ClipsDescendants = false,
                SizeConstraint = Enum.SizeConstraint.RelativeXY,
            }, {
                c("UIListLayout", {
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                }),
                c(Dropdown, {
                    Items = {"Character", "Model", "InputEvent"},
                    ChangeFn = function(item)
                        self.state.CurrentSelection:AddComponent({
                            Component = _components[item],
                        })
                        self:setState({
                            Components = self.state.CurrentSelection:GetComponents(),
                        })
                        print "Finished updated sate of components list"
                    end,
                })
            })
        )
    end

    return c(FitChildren.ScrollingFrame, {
        Size = UDim2.new(1.0, 0, 1.0, 0),
        BackgroundColor3 = widgetBackground,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        SizeConstraint = Enum.SizeConstraint.RelativeXY,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
    }, children)
end

function EntityEditor:_handleSelectionChange(signal)
	self._selectionConnection = signal:Connect(function()
		local s = game.Selection:Get()
        if s == nil then
            self:setState({
                CurrentSelection = Roact.None,
                Components = {},
            })
			return
		end

		local f = s[1]
        if f == nil then
            self:setState({
                CurrentSelection = Roact.None,
                Components = {},
            })

			return
		end

        if not f:IsA("Script") then
            self:setState({
                CurrentSelection = Roact.None,
                Components = {},
            })

			return
        end

        if not f.Name:match(ECS.Entity.Pattern) then
            self:setState({
                CurrentSelection = Roact.None,
                Components = {},
            })

			return
        end

		local entity = ECS.Entity:new({
            Script = f,
        })
        if not entity then
            self:setState({
                CurrentSelection = Roact.None,
                Components = {},
            })

			return
        end

        self:setState({
            CurrentSelection = entity,
            Components = entity:GetComponents(),
        })
	end)
end

function EntityEditor:willUnmount()
    self._selectionConnection:Disconnect()
end

return EntityEditor