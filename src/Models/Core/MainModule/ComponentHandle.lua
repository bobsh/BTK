--- @classmod ComponentHandle

local BaseObject = require(script.Parent.BaseObject)
local Schema = require(script.Parent.Schema)

local ComponentHandle = BaseObject:subclass(script.Name)

--- init
function ComponentHandle:initialize(input)
	BaseObject.initialize(self, input)

	self:AssertSchema(
		input,
		Schema.Record {
			Root = Schema.Root,
		}
	)

	self.Root = input.Root
end

--- get
function ComponentHandle:GetComponent()
	return self:GetRoot().BTKComponent.Configuration.Component.Value
end

--- get root
function ComponentHandle:GetRoot()
	return self.Root
end

--- get data
function ComponentHandle:GetData(key)
	self:AssertSchema(key, Schema.DataKey)

	local data = self:GetRoot():WaitForChild("Data", 5.0)
	assert(data, "Data child not found in time")

	local dataPart = data:FindFirstChild(key)
	if not dataPart then
		return nil
	end

	return dataPart.Value
end

--- send message
function ComponentHandle:SendMessage(input)
	self:AssertSchema(input, Schema.Message)

	local inputEvent = self:GetData("InputEvent")
	inputEvent:Fire(input)
end

--- send damage
function ComponentHandle:SendDamage(input)
	self:AssertSchema(input, Schema.DamagePayload)

	self:Dbg("Doing damage " .. input.Damage)

	self:SendMessage({
		Type = Schema.Enums.InputEventType.Damage,
		Payload = input,
	})
end

return ComponentHandle
