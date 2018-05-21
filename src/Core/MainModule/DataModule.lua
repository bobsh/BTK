local Schema = require(script.Parent.Schema)

local DataModule = {
	_data = {
		_folder = nil,
		_defs = {}
	},

	--[[
		Data handling setup
	--]]
	DataSetup = function(self, input)
		-- Create data folder so we can use data methods
		self._data._folder = input.Root:FindFirstChild("Data")
		if self._data._folder == nil then
			self._data._folder = Instance.new("Folder", input.Root)
			self._data._folder.Name = "Data"
		end
		self:AssertSchema(self._data._folder, Schema.DataFolder)

		-- Find the configuration folder
		self:CreateData({
			Name = "ConfigurationFolder",
			Type = "ObjectValue",
			Value = input.Root:FindFirstChild("Configuration"),
			Schema = Schema.Optional(
				Schema.ConfigurationFolder
			),
			AllowOverride = false,
		})
	end,

	--[[
		Create Data using a definition, and return the value
		of it.
	--]]
	CreateData = function(self, input)
		self:AssertSchema(
			input,
			Schema.DataDefinition
		)

		if not input.ValueInstance then
			input.ValueInstance = Instance.new(input.Type, self._data._folder)
			input.ValueInstance.Name = input.Name
		end

		-- Store the created stuff in an internal thing so we can
		-- lookup the schema and such
		self._data._defs[input.Name] = input

		if input.Watch then
			self:WatchData(input.Name, input.Watch)
		end

		-- Override with user config if provided
		if input.AllowOverride ~= false then
			local override = self:_getConfiguration(input.Name)
			if override ~= nil then
				input.Value = override
			end
		end

		-- Now do our first set
		self:SetData(input.Name, input.Value)

		-- Create convenience methods
		if input.Type == "BoolValue" then
			self:AddMember("Is" .. input.Name, function()
				return self:GetData(input.Name)
			end)
		else
			self:AddMember("Get" .. input.Name, function()
				return self:GetData(input.Name)
			end)
		end
		self:AddMember("Set" .. input.Name, function()
			return self:SetData(input.Name)
		end)
		self:AddMember("Watch" .. input.Name, function()
			return self:WatchData(input.Name)
		end)

		-- Return the value for convenience
		return self:GetData(input.Name)
	end,

	_getDataValue = function(self, key)
		self:AssertSchema(key, Schema.DataKey)

		local def = self._data._defs[key]

		return self:AssertSchema(
			def.ValueInstance,
			Schema:IsA(def.Type)
		)
	end,

	--[[
		GetData and validate
	--]]
	GetData = function(self, key)
		local dataPart = self:_getDataValue(key)

		return self:AssertSchema(
			dataPart.Value,
			self._data._defs[key].Schema
		)
	end,

	_getConfiguration = function(self, key)
		self:AssertSchema(key, Schema.ConfigurationKey)

		local confVal = self:GetConfigurationFolder()
		if not confVal then
			return nil
		end

		local conf = confVal:FindFirstChild(key)
		if not conf then
			return nil
		end

		return conf.Value
	end,

	--[[
		Sets data
	--]]
	SetData = function(self, key, value)
		local dataPart = self:_getDataValue(key)
		dataPart.Value = self:AssertSchema(
			value,
			self._data._defs[key].Schema
		)
	end,

	--[[
		Watches data for changes
	--]]
	WatchData = function(self, key, fn)
		local dataPart = self:_getDataValue(key)
		self:AssertSchema(fn, Schema.Function)

		return dataPart.Changed:Connect(fn)
	end,
}

return DataModule
