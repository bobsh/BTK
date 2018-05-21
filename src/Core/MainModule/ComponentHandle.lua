local BaseObject = require(script.Parent.BaseObject)
local Schema = require(script.Parent.Schema)

ComponentHandle = BaseObject:subclass(script.Name)

--[[
	Ref<ComponentHandle> ComponentHandle.new({
		Root = <.. model of the component ..>,
	})
--]]
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

--[[
	string ComponentHandle:GetComponent()
--]]
function ComponentHandle:GetComponent()
	return self:GetRoot().BTKComponent.Configuration.Component.Value
end

--[[
	Ref<Model, Tool> ComponentHandle:GetRoot()
--]]
function ComponentHandle:GetRoot()
	return self.Root
end

--[[
	Any GetData(
		string key
	)
--]]
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

--[[
	void SendMessage({
		MessageType Type,
		table Payload,
	})
--]]
function ComponentHandle:SendMessage(input)
	self:AssertSchema(input, Schema.Message)
	
	local inputEvent = self:GetData("InputEvent")
	inputEvent:Fire(input)
end

--[[
	void SendDamage({
		Number Damage,
	})
--]]
function ComponentHandle:SendDamage(input)
	self:AssertSchema(input, Schema.DamagePayload)
	
	self:Dbg("Doing damage " .. input.Damage)

	self:SendMessage({
		Type = Schema.Enums.InputEventType.Damage,
		Payload = input,
	})
end

return ComponentHandle
