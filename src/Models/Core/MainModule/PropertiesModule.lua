--- @module PropertiesModule

local Schema = require(script.Parent.Schema)

local PropertiesModule = {
    static = {
        --[[
            A dictionary of our properties
        --]]
        _property_defs = {},

        _addPropertyHelpers = function(self, input)
            self:AssertSchema(
                input,
                Schema.PropertyDefinition
            )

            if input.Type == "BoolValue" then
                self:AddMember("Is" .. input.Name, function(self2)
                    return self2:GetProperty(input.Name)
                end)
            end

            self:AddMember("Get" .. input.Name, function(self2)
                return self2:GetProperty(input.Name)
            end)

            self:AddMember("Set" .. input.Name, function(self2, value)
                return self2:SetProperty(input.Name, value)
            end)

            self:AddMember("Watch" .. input.Name, function(self2, value)
                return self2:WatchProperty(input.Name, value)
            end)
        end,

        --- Add property using a definition
        AddProperty = function(self, input)
            self:AssertSchema(
                input,
                Schema.PropertyDefinition
            )
            self:Debug("Adding new property", {
                Name = input.Name,
            })
            self._property_defs[input.Name] = input
            self:_addPropertyHelpers(input)
        end,

        --- Return all property definitions
        Properties = function(self)
            return self._property_defs
        end,

        subclassed = function(self, other)
            self:Debug("Subclassed by " .. other:GetClassName())
            local props = self:Properties()
            local new = {}
            for key, val in pairs(props) do
                new[key] = val
            end
            self._property_defs = new
        end,
    },

    _properties = {
        _data_folder = nil,
        _definitions = {},
    },

    _initProperty = function(self, input)
        self:AssertSchema(
            input,
            Schema.PropertyDefinition
        )

        -- Create the ValueBase instances
        if not input.ValueInstance then
            input.ValueInstance = Instance.new(
                input.Type,
                self._properties._data_folder
            )
            input.ValueInstance.Name = input.Name
        end

        -- Save our definition in the objects dictionary
        self._properties._definitions[input.Name] = input

        -- Set the watcher value if it exists
        if input.WatchFn then
            self:WatchProperty(input.Name, input.WatchFn)
        end

        -- Override with user config if provided
		if input.AllowOverride ~= false then
			local override = self:_getConfiguration(input.Name)
			if override ~= nil then
				input.Value = override
			end
		end

        -- Now do our first set, if we have a static, use that
        if input.Value then
            self:SetProperty(input.Name, input.Value)
        elseif input.ValueFn then
            self:SetProperty(input.Name, input.ValueFn(self))
        end
    end,

    --- Init
    InitProperties = function(self, input)
        self:AssertSchema(
            input,
            Schema.Record {
                Script = Schema.Script,
            }
        )

        -- Create data folder so we can use data methods
        self._properties._data_folder = input.Script:FindFirstChild("Data")
        if self._properties._data_folder == nil then
            self._properties._data_folder = Instance.new("Folder", input.Script)
            self._properties._data_folder.Name = "Data"
        end
        self:AssertSchema(self._properties._data_folder, Schema.DataFolder)

        -- Iterate through all our properties and create the ValueBase
        -- for each
        for _, val in pairs(self.class:Properties()) do
            self:_initProperty(val)
        end
    end,

    _getPropertyValue = function(self, key)
		self:AssertSchema(key, Schema.DataKey)

		local def = self._properties._definitions[key]

        --[[
        if def == nil then
            self:Error("Unable to find property key", {
                Key = key,
            })
        end
        --]]
		return self:AssertSchema(
			def.ValueInstance,
			Schema:IsA(def.Type)
		)
	end,

    --- Get property
	GetProperty = function(self, key)
		local propertyPart = self:_getPropertyValue(key)

		return self:AssertSchema(
			propertyPart.Value,
			self._properties._definitions[key].SchemaFn
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

    --- Set property
	SetProperty = function(self, key, value)
		local part = self:_getPropertyValue(key)
		part.Value = self:AssertSchema(
			value,
			self._properties._definitions[key].SchemaFn
		)
	end,

    --- Watch property
	WatchProperty = function(self, key, fn)
		local part = self:_getPropertyValue(key)
		self:AssertSchema(fn, Schema.Function)

		return part.Changed:Connect(fn)
	end,
}

return PropertiesModule
