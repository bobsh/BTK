local class = require(script.Parent.lib.middleclass)
local s = require(script.Parent.lib.schema)

--[[--------------------------------------------
	
	ENUMS
	
----------------------------------------------]]

EnumerationItem = class("EnumerationItem")

function EnumerationItem:initialize(input)
	self.Name = input.Name
	self.Value = input.Value
	self.EnumType = input.EnumType
end

Enumeration = class("Enumeration")

function Enumeration:initialize(input)
	self._data = {}
	for key, idx in pairs(input) do
		assert(type(key) == "string")
		assert(type(idx) == "number")
		self[key] = EnumerationItem({
			Name = key,
			Value = idx,
			EnumType = self,
		})
		self._data[key] = self[key]
	end
end

function EnumerationItem:GetEnumItems()
	return self._data
end

Schema = class(script.Name)

--[[--------------------------------------------
	
	ENUMS
	
----------------------------------------------]]

--[[
	All enums get placed in this table
--]]
Schema.static.Enums = {}

--[[--------------------------------------------
	
	PROXIES
	
----------------------------------------------]]

Schema.static.Record = s.Record
Schema.static.Function = s.Function
Schema.static.Optional = s.Optional
Schema.static.Boolean = s.Boolean
Schema.static.NumberFrom = s.NumberFrom

--[[--------------------------------------------
	
	SIMPLE
	
----------------------------------------------]]

Schema.static.IntegerFrom = function(min, max)
	return s.AllOf(
		s.Integer,
		s.NumberFrom(min, max)
	)
end

--[[
	Matches camelcase pretty poorly, lua has crap
	regexp support
--]]
Schema.static.CamelCase = s.AllOf(
	s.String,
	s.Pattern("%u[%l%d%u]+")
)

Schema.static.StringLength = function(min, max)
	min = min or 0
	max = max or 128
	return function(obj, path)
		local err = s.String(obj, path)
		if err then return err end		
				
		local len = string.len(obj)
		if len < min or len > max then
			return s.Error(
				"Length of string " ..
				tostring(len) ..
				" is out of bounds " ..
				" (" .. min .. "-" .. max .. ")",
				path
			)
		end
	end
end

--[[--------------------------------------------
	
	ROBLOX
	
----------------------------------------------]]

function Schema.static:TypeOf(className)
	return function(obj, path)
		if not obj then
			return s.Error("Checked component is nil", path)
		end
				
		-- If it is, return nothing
		if typeof(obj) == className then
			return nil
		end

		-- Otherwise a nice message
		local err = (
			"Instance %s with class name %s is not a type of %s"
		):format(
			obj.Name,
			obj.ClassName,
			className
		)
		return s.Error(err, path)
	end
end

--[[
	Ref<SchemaError> function(obj, path) Schema:IsA(className)
--]]
function Schema.static:IsA(className)
	return function(obj, path)
		if not obj then
			return s.Error("Checked component is nil", path)
		end
		
		local isa = obj:IsA(className)
		
		-- If it is, return nothing
		if isa then
			return nil
		end

		-- Otherwise a nice message
		local err = (
			"Instance %s with class name %s is not an instance nor does it inherit from class %s"
		):format(
			obj.Name,
			obj.ClassName,
			className
		)
		return s.Error(err, path)
	end
end

--[[
	Matches the instance name provided
--]]
function Schema.static:InstanceName(name)
	return function(obj, path)
		if not obj then
			return s.Error("Checked component is nil", path)
		end		
		
		if obj.Name == name then
			return nil
		end
		
		local err = (
			"Instance of name %s does not match required instance name %s"
		):format(
			obj.Name,
			name
		)
		return s.Error(err, path)
	end
end

Schema.static.PlaceId = s.Number

--[[--------------------------------------------
	
	LOGGING
	
----------------------------------------------]]

Schema.static.Enums.LogLevel = Enumeration({
	None = 0,
	Fatal = 1,	
	Error = 2,
	Warn = 3,
	Info = 4,
	Debug = 5,
	Trace = 6,
})

Schema.static.LogEntry = Schema.Record {
	Level = Schema.IntegerFrom(1, 6),
	Message = Schema.StringLength(3, 128),
	Data = Schema.Optional(Schema.Table),
	Player = Schema.Optional(Schema:IsA("Player")),
}

Schema.static.LogInit = Schema.Record {
	Config = Schema.Optional(Schema.Table),
	Player = Schema.Optional(Schema:IsA("Player")),
	ClassName = Schema.CamelCase,
}

--[[--------------------------------------------
	
	COMPONENTS
	
----------------------------------------------]]

--[[
	IsARoot Instance
--]]
Schema.static.IsARoot = s.OneOf(
	Schema:IsA("Model"),
	Schema:IsA("Tool")
)

--[[
	Does the object have a component attached.
--]]
Schema.static.Component = function(obj, path)
	if not obj then
		return s.Error("Checked component is nil", path)
	end
	if not(obj:FindFirstChild("BTKComponent") and
		obj.BTKComponent:FindFirstChild("Configuration") and
		obj.BTKComponent.Configuration:FindFirstChild("Component")) then
		return s.Error("This does not look like a component", path)
	end
end

--[[
	Is this a character model?
--]]
Schema.static.CharacterModel = s.AllOf(
	Schema.Component,
	Schema:IsA("Model")
)

--[[
	Is the data a valid component name?
--]]
Schema.static.ComponentName = s.OneOf(
	"Area",
	"Currency",
	"NPC",
	"PC",
	"PlatformMover",
	"Smashable",
	'PlaceTeleporter',
	"Teleporter",
	"Waypoints",
	"Weapon"
)

--[[
	A calling component script
--]]
Schema.static.ComponentScript = s.AllOf(
	Schema:IsA("Script"),
	Schema:InstanceName("BTKComponent")
)

--[[
	Is this a valid root object, and does it have a component
	attached.
--]]
Schema.static.Root = s.AllOf(
	Schema.IsARoot,
	Schema.Component
)

--[[--------------------------------------------
	
	DATA
	
----------------------------------------------]]

--[[
	A valid data key
--]]
Schema.static.DataFolder = Schema:IsA("Folder")

Schema.static.DataKey = s.AllOf(
	Schema.StringLength(3,32),
	Schema.CamelCase
)

Schema.static.DataType = s.OneOf(
	"BoolValue",
	"BrickColorValue",
	"CFrameValue",
	"Color3Value",
	"NumberValue",	
	"ObjectValue",
	"RayValue",
	"StringValue",
	"Vector3Value"
)

Schema.static.DataValue = s.Any

--[[
	Data definition
--]]
Schema.static.DataDefinition = Schema.Record {
	Name = Schema.DataKey,
	Type = Schema.DataType,
	Value = Schema.DataValue,
	Schema = s.Function,
	Watch = Schema.Optional(
		s.Function
	),
	ValueInstance = Schema.Optional(
		Schema:IsA("ValueBase")
	),
	AllowOverride = Schema.Optional(s.Boolean),
}

--[[--------------------------------------------
	
	CONFIGURATION
	
----------------------------------------------]]

Schema.static.ConfigurationKey = Schema.DataKey

Schema.static.ConfigurationFolder = s.OneOf(
	Schema:IsA("Folder"),
	Schema:IsA("Configuration")
)

--[[--------------------------------------------
	
	EVENTS
	
----------------------------------------------]]

Schema.static.Enums.InputEventType = Enumeration({
	Damage = 1,
})

--[[
	An general message
--]]
Schema.static.Message = s.OneOf(
	Schema.Record {
		Type = Schema.Enums.InputEventType.Damage,
		Payload = Schema.DamagePayload,
	}
)

--[[
	A damage message
--]]
Schema.static.DamagePayload = Schema.Record {
	Damage = Schema.DamageAmount,
}

Schema.static.DamageMax = 99

--[[
	A damage amount
--]]
Schema.static.DamageAmount = Schema.IntegerFrom(
	0,
	Schema.DamageMax
)

--[[--------------------------------------------
	
	ASSETS
	
----------------------------------------------]]

--[[
	Asset table
--]]
Schema.static.AssetData = Schema.Record {
	Name = s.String,
	ID = Schema.Optional(s.NonNegativeNumber),
	Type = s.String,
	Parent = Schema:IsA("Instance"),
	NoDelete = Schema.Optional(s.Boolean),
	Local = Schema.Optional(
		Schema.Record {
			Folder = s.String,
			Name = s.String,
		}
	),
}

--[[--------------------------------------------
	
	URL
	
----------------------------------------------]]

Schema.static.HttpURL = s.AllOf(
	s.String,
	s.Pattern("^http://.*")
)

Schema.static.HttpsURL = s.AllOf(
	s.String,
	s.Pattern("^https://.*")
)

--[[--------------------------------------------
	
	CURRENCY
	
----------------------------------------------]]

Schema.static.MaximumCurrency = 1000000

Schema.static.Currency = Schema.IntegerFrom(
	0,
	Schema.MaximumCurrency
)

--[[--------------------------------------------
	
	WEAPONS
	
----------------------------------------------]]

Schema.static.Enums.WeaponType = Enumeration({
	Melee = 1,
	Ranged = 2,
})

Schema.static.WeaponType = s.OneOf(
	"Melee",
	"Ranged"
)

Schema.static.MaxAttackDistance = 999.0

Schema.static.AttackDistance = s.NumberFrom(
	0.0, Schema.MaxAttackDistance
)

return Schema
