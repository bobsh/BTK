local ClassModule = {
	static = {},
	included = function(_, klass)
		print("ClassyModule was included by: " .. klass.name)
	end
}

local helpers = {
	GetClassName = function(self)
		if self.class then
			return self.class.name
		end
		return self.name
	end,

	--[[
	Adds a member to self using key and value if the member exists
	throw an error
	--]]
	AddMember = function(self, key, value)
		if self:HasMember(key) then
			error("Member already exists: " .. key)
		end
		self[key] = value
	end,

	--[[
		Checks if a member of this class exists
	--]]
	HasMember = function(self, key)
		local member = self:GetMember(key)
		if member == nil then
			return false
		end
		return true
	end,

	--[[
		Gets a member of this classes table
	--]]
	GetMember = function(self, key)
		return self[key]
	end,
}

for k, v in pairs(helpers) do
	ClassModule.static[k] = v
	ClassModule[k] = v
end

return ClassModule
