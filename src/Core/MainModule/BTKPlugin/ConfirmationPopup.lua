--[[
	ConfirmationPopup
--]]

local UI = require(script.Parent.UI)

local ConfirmationPopupObject = nil

-- Unload the conformation popup if it exists.
-- Does nothing if the popup isn't set.
local function ClearConfirmation()
	print "Clear conformation"
	if nil ~= ConfirmationPopupObject then
		ConfirmationPopupObject:Clear()
		ConfirmationPopupObject = nil
	end
end



-- Confirmation Popup GUI
local ConfirmationPopup = {}
ConfirmationPopup.__index = ConfirmationPopup
do
	-- Create a confirmation popup.
	--
	-- confirmText       - What to display in the popup.
	-- confirmButtonText - What to display in the popup.
	-- declineButtonText - What to display in the popup.
	-- confirmFunction   - Function to run on confirmation.
	-- declineFunction   - Function to run when declining.
	--
	-- Return:
	-- Value a table with confirmation gui and options.
	function ConfirmationPopup.Create(
										gui,
										confirmText,
									  confirmButtonText,
									  declineButtonText,
								      confirmFunction,
								      declineFunction)
		local popup = {}
		popup.confirmButton = nil			-- Hold the button to confirm a choice.
		popup.declineButton = nil			-- Hold the button to decline a choice.
		popup.confirmationFrame = nil       -- Hold the conformation frame.
		popup.confirmationText = nil        -- Hold the text label to display the conformation message.
		popup.confirmationHelpText = nil    -- Hold the text label to display the conformation message help.


		popup.confirmationFrame = Instance.new("Frame", gui)
		popup.confirmationFrame.Name = "ConfirmationFrame"
		popup.confirmationFrame.Size = UDim2.new(0, 280, 0, 140)
		popup.confirmationFrame.Position = UDim2.new(
			.5,
			-popup.confirmationFrame.Size.X.Offset/2,
			0.5,
			-popup.confirmationFrame.Size.Y.Offset/2
		)
		popup.confirmationFrame.Style = Enum.FrameStyle.RobloxRound
		popup.confirmLabel = UI:CreateStandardLabel(
			"ConfirmLabel",
			UDim2.new(0,0,0,15),
			UDim2.new(1, 0, 0, 24),
			confirmText,
			popup.confirmationFrame
		)
		popup.confirmLabel.FontSize = Enum.FontSize.Size18
		popup.confirmLabel.TextXAlignment = Enum.TextXAlignment.Center

		-- Confirm
		popup.confirmButton = UI:CreateStandardButton("ConfirmButton",
											UDim2.new(0.5, -120, 1, -50),
										    confirmButtonText,
											function()
												print("Confirm button pushed")
												confirmFunction()
												ClearConfirmation()
											end,
										    popup.confirmationFrame)

		-- Decline
		popup.declineButton  = UI:CreateStandardButton("DeclineButton",
											UDim2.new(0.5, 0, 1, -50),
										    declineButtonText,
											function()
												declineFunction()
												ClearConfirmation()
											end,
										    popup.confirmationFrame)

		setmetatable(popup, ConfirmationPopup)

		return popup
	end

	-- Clear the popup, free up assets.
	function ConfirmationPopup:Clear()

		if nil ~= self.confirmButton then
			self.confirmButton.Parent = nil
		end

		if nil ~= self.declineButton then
			self.declineButton.Parent = nil
		end

		if nil ~= self.confirmationFrame then
			self.confirmationFrame.Parent = nil
		end

		if nil ~= self.confirmLabel then
			self.confirmLabel.Parent = nil
		end

		self.confirmButton = nil
		self.declineButton = nil
		self.conformationFrame = nil
		self.conformText = nil
	end
end

return ConfirmationPopup
