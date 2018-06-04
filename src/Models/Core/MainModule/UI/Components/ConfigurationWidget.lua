--[[--
    widget
    @classmod UI.ConfigurationWidget
--]]

local Roact = require(script.Parent.Parent.Parent.lib.Roact)
local ECS = require(script.Parent.Parent.Parent.ECS)
local TextLabel = require(script.Parent.TextLabel)
local c = Roact.createElement

local ConfigurationWidget = Roact.Component:extend("ConfigurationWidget")

function ConfigurationWidget:init(_)
    self.state = {
        CurrentSelection = nil,
    }

    local sel = game:FindFirstChild("Selection")
    if sel then
        self:HandleSelectionChange(sel.SelectionChanged)
    else
        warn("No selection service found")
    end
end

function ConfigurationWidget:render()
    local active
    if self.state.CurrentSelection then
        for _, component in pairs(self.state.CurrentSelection:GetComponents()) do

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
                    Size = UDim2.new(0, 128, 1.0, 16),
                    BackgroundTransparency = 1,
                }, {
                    c(TextLabel, {
                        Size = UDim2.new(0, 128, 1.0, 16),
                        Text = "Name",
                    }),
                    c(TextLabel, {
                        Size = UDim2.new(0, 64, 1.0, 16),
                        Text = "Type",
                    }),
                    c(TextLabel, {
                        Size = UDim2.new(0, 64, 1.0, 16),
                        Text = "Overridable",
                    })
                })
            }

            -- Now iterate across the props and add rows
            local idx = 2
            for key, val in pairs(component:Properties()) do
                local trans = 1.0
                if not(idx % 2) then
                    trans = 0.9
                end

                props[tostring(idx)] = c("Frame", {
                    Size = UDim2.new(0, 128, 0, 16),
                    BackgroundTransparency = trans,
                }, {
                    c(TextLabel, {
                        Size = UDim2.new(0, 96, 0, 16),
                        Text = key,
                    }),
                    c(TextLabel, {
                        Size = UDim2.new(0, 64, 0, 16),
                        Text = val.Type,
                    }),
                    c(TextLabel, {
                        Size = UDim2.new(0, 64, 0, 16),
                        Text = "TODO",
                }),
                })

                idx = idx + 1
            end

            -- Now wrap it in a scrolling frame
            active = c("ScrollingFrame", {
                Size = UDim2.new(1.0, 0, 1.0, 0),
                BackgroundTransparency = 1,
            }, {
                c("UIListLayout"),
                c(TextLabel,{
                    Size = UDim2.new(0, 128, 1.0, 16),
                    Text = "Script: " .. self.state.CurrentSelection:GetClassName(),
                }),
                c("Frame", {
                    Size = UDim2.new(0.9, 0, 0, 128),
                    BackgroundTransparency = 1,
                }, props)
            })
        end


    else
        active = c(TextLabel, {
            Size = UDim2.new(0, 128, 0, 16),
            Text = "Select a BTK: script to configure it",
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

return ConfigurationWidget