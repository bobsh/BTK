--[[--
	Dropdown
	@classmod UI.Dropdown
--]]

--local IMAGE = "rbxassetid://1267570372"

local Roact = require(script.Parent.Parent.Parent.lib.Roact)
local c = Roact.createElement

local Dropdown = Roact.Component:extend("Dropdown")

function Dropdown:init(props)
	self.state = {
		Open = props.Open or false,
		Items = props.Items or {},
		ChangeFn = props.ChangeFn,
		CurrentItem = nil,
	}
end

function Dropdown:render()
	local items = {}

	for _, item in ipairs(self.state.Items) do
		table.insert(items, c("TextButton", {
			Font = Enum.Font.Arial,
			TextSize = 12,
			BorderSizePixel = 0,
			Text = item,
			Size = UDim2.new(1, 0, 0, 20),

			[Roact.Event.MouseButton1Click] = function(_)
				if self.state.ChangeFn ~= nil then
					self.state.ChangeFn(item)
				end

				self:setState({
					CurrentItem = item,
					Open = false,
				})
			end,
		}))
	end

	local containerHeight = #items * 20

	return c("TextButton", {
		Size = UDim2.new(0, 200, 0, 30),
		Font = Enum.Font.Arial,
		TextSize = 12,

		Text = "",

		[Roact.Event.MouseButton1Click] = function(_)
			self:setState({
				Open = not self.state.Open,
			})
		end,
	}, {
		Label = c("TextLabel", {
			Font = Enum.Font.Arial,
			TextSize = 12,

			BackgroundTransparency = 1,
			Size = UDim2.new(1, -56, 1, 0),
			Position = UDim2.new(0, 20, 0, 0),
			Text = self.state.CurrentItem or "select an item",
		}, {
			c("UITextSizeConstraint", {
				MaxTextSize = 18,
			})
		}),
		ChildContainer = c("Frame", {
			Visible = self.state.Open,
			Size = UDim2.new(1, 0, 0, containerHeight),
			Position = UDim2.new(0, 0, 1, 0),
		}, {
			c("UIListLayout"),
			unpack(items),
		})
	})
end

return Dropdown