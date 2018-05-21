local BaseUtil = require(script.Parent.BaseUtil)
local Schema = require(script.Parent.util.Schema)
local s = require(script.Parent.lib.schema)
local inspect = require(script.Parent.lib.inspect)

local HttpService = game:GetService("HttpService")

--[[
	DiscordApp provides facilities for communicating with DiscordApp
--]]
local DiscordApp = BaseUtil:subclass(script.Name)

function DiscordApp.static:Send(input)
	self:AssertSchema(
		input,
		s.Record {
			Message = s.String,
			Webhook = Schema:HttpsURL(),
		}
	)

	self:Dbg("Received " .. inspect(input))

	local data = {
		content = input.Message,
	}
	local dataJSON = HttpService:JSONEncode(data)
	local success, err = pcall(function()
		HttpService:PostAsync(input.Webhook, dataJSON)
	end)
	if not success then
		self:Warn("Unable to send to discord: " .. err)
	end
end

return DiscordApp
