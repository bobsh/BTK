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
		CurrentItem = nil,
	}
end

function Dropdown:render()
	local items = {}

	for _, item in ipairs(self.state.Items) do
		table.insert(items, c("TextButton", {
			BorderSizePixel = 0,
			Text = item,
			Size = UDim2.new(1, 0, 0, 20),

			[Roact.Event.MouseButton1Click] = function(_)
				self:setState({
					CurrentItem = item,
					Open = false,
				})
			end,
		}))
	end

	return c("TextButton", {
		Size = UDim2.new(0, 200, 0, 30),
		Text = "",

		[Roact.Event.MouseButton1Click] = function(_)
			self:setState({
				Open = not self.state.Open,
			})
		end,
	}, {
		--[[
		Icon = c("ImageLabel", {
			Image = IMAGE,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 18, 0, 18),
			Position = UDim2.new(1, 0, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			ImageColor3 = Color3.new(0, 0, 0),
		}),
		--]]
		Label = c("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -56, 1, 0),
			Position = UDim2.new(0, 20, 0, 0),
			Text = self.state.CurrentItem or "select an item",
			Font = Enum.Font.SourceSans,
			TextSize = 18,
			TextScaled = true,
		}, {
			c("UITextSizeConstraint", {
				MaxTextSize = 18,
			})
		}),
		ChildContainer = c("Frame", {
			Visible = self.state.Open,
			Size = UDim2.new(1, 0, 0, 100),
			Position = UDim2.new(0, 0, 1, 0),
		}, {
			c("UIListLayout"),
			unpack(items),
		})
	})
end

return Dropdown