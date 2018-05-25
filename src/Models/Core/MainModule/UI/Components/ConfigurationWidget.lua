--[[--
    widget
    @classmod UI.ConfigurationWidget
--]]

local Roact = require(script.Parent.Parent.Parent.lib.Roact)
local ScriptHelper = require(script.Parent.Parent.Parent.ScriptHelper)
local c = Roact.createElement

local ConfigurationWidget = Roact.Component:extend("ConfigurationWidget")

function ConfigurationWidget:init(_)
    self.state = {
        CurrentSelection = nil,
    }

    self:HandleSelectionChange(game.Selection.SelectionChanged)
end

function ConfigurationWidget:render()
    local _ = self -- lint

    local active
    if self.state.CurrentSelection then
        -- Build up the table and headers
        local props = {
            c("UITableLayout", {
                FillEmptySpaceColumns = true,
                FillEmptySpaceRows = false,
                FillDirection = Enum.FillDirection.Vertical,
            }),
            c("UISizeConstraint", {
                MaxSize = Vector2.new(400, 32),
            }),
            ["1"] = c("Frame", {
                Position = UDim2.new(0,0,0,0),
                Size = UDim2.new(0, 128, 1.0, 16),
                BackgroundTransparency = 1,
            }, {
                A = c("TextLabel", {
                    Position = UDim2.new(0,0,0,0),
                    Size = UDim2.new(0, 128, 1.0, 16),
                    Text = "Name",
                    TextColor3 = Color3.new(0, 0, 0),
                    Font = Enum.Font.SourceSansBold,
                    BackgroundTransparency = 1,
                }),
                B = c("TextLabel", {
                    Position = UDim2.new(0,0,0,0),
                    Size = UDim2.new(0, 64, 1.0, 16),
                    Text = "Type",
                    TextColor3 = Color3.new(0, 0, 0),
                    Font = Enum.Font.SourceSansBold,
                    BackgroundTransparency = 1,
                }),
                C = c("TextLabel", {
                    Position = UDim2.new(0,0,0,0),
                    Size = UDim2.new(0, 64, 1.0, 16),
                    Text = "Overridable",
                    TextColor3 = Color3.new(0, 0, 0),
                    Font = Enum.Font.SourceSansBold,
                    BackgroundTransparency = 1,
                })
            })
        }

        -- Now iterate across the props and add rows
        local idx = 2
        for key, val in pairs(self.state.CurrentSelection:Properties()) do
            props[tostring(idx)] = c("Frame", {
                Position = UDim2.new(0,0,0,0),
                Size = UDim2.new(0, 128, 0, 16),
                BackgroundTransparency = 1,
            }, {
                A = c("TextLabel", {
                    Position = UDim2.new(0,0,0,0),
                    Size = UDim2.new(0, 96, 0, 16),
                    TextColor3 = Color3.new(0, 0, 0),
                    Text = key,
                    BackgroundTransparency = 1,
                }),
                B = c("TextLabel", {
                    Position = UDim2.new(0,0,0,0),
                    Size = UDim2.new(0, 64, 0, 16),
                    TextColor3 = Color3.new(0, 0, 0),
                    Text = val.Type,
                    BackgroundTransparency = 1,
                }),
                C = c("TextLabel", {
                    Position = UDim2.new(0,0,0,0),
                    Size = UDim2.new(0, 64, 0, 16),
                    TextColor3 = Color3.new(0, 0, 0),
                    Text = "TODO",
                    BackgroundTransparency = 1,
                }),
            })

            idx = idx + 1
        end

        -- Now wrap it in a scrolling frame
        active = c("ScrollingFrame", {
            Position = UDim2.new(0,0,0,0),
            Size = UDim2.new(1.0, 0, 1.0, 0),
            BackgroundTransparency = 1,
        }, {
            c("UIListLayout"),
            Selected = c("TextLabel",{
                Position = UDim2.new(0,0,0,0),
                Size = UDim2.new(0, 128, 1.0, 16),
                Text = "Script: " .. self.state.CurrentSelection:GetClassName(),
                TextColor3 = Color3.new(0,0,0,0),
                BackgroundTransparency = 1,
            }),
            Properties = c("Frame", {
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(0.9, 0, 0, 128),
                BackgroundTransparency = 1,
            }, props)
        })
    else
        active = c("TextLabel", {
            Position = UDim2.new(0,0,0,0),
            Size = UDim2.new(0, 128, 0, 16),
            Text = "Select a BTK: script to configure it",
            TextColor3 = Color3.new(0,0,0),
            TextYAlignment = Enum.TextYAlignment.Top,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
        })
    end

    return active
end

function ConfigurationWidget:HandleSelectionChange(signal)
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

		local scriptName = f.Name:match(ScriptHelper.Pattern)
        if not scriptName then
            self:setState({
                CurrentSelection = nil,
            })

			return
		end

		local btkScript = ScriptHelper:Get(f)
        if not btkScript then
            self:setState({
                CurrentSelection = nil,
            })

			return
        end

        self:setState({
            CurrentSelection = btkScript,
        })
	end)
end

return ConfigurationWidget