--[[--
	Schema related utilities
	@module Schema
--]]

local class = require(script.Parent.lib.middleclass)
local s = require(script.Parent.lib.schema)

--[[--
	Represents an item
	@type EnumerationItem
--]]
local EnumerationItem = class("EnumerationItem")

--- Init
function EnumerationItem:initialize(input)
	self.Name = input.Name
	self.Value = input.Value
	self.EnumType = input.EnumType
end

--[[--
	An eneumeration
	@type Enumeration
--]]
local Enumeration = class("Enumeration")

--- Init
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

--- Get all enum items
-- @treturn {table}
function EnumerationItem:GetEnumItems()
	return self._data
end

--[[--
	Schema utility class
	@type Schema
--]]
local Schema = class(script.Name)

--- All enums get placed in this table
Schema.static.Enums = {}

--[[--------------------------------------------
	Proxies
	@section proxies
----------------------------------------------]]

Schema.static.Record = s.Record
Schema.static.Function = s.Function
Schema.static.Optional = s.Optional
Schema.static.Boolean = s.Boolean
Schema.static.NumberFrom = s.NumberFrom
Schema.static.OneOf = s.OneOf
Schema.static.NonNegativeNumber = s.NonNegativeNumber

--[[--------------------------------------------
	Simple
	@section simple
----------------------------------------------]]

--- Match a range from and to
-- @tparam int min
-- @tparam int max
-- @treturn func
Schema.static.IntegerFrom = function(min, max)
	return s.AllOf(
		s.Integer,
		s.NumberFrom(min, max)
	)
end

--[[--
	Matches camelcase pretty poorly
	Lua has crap regexp support
	@treturn func
--]]
Schema.static.CamelCase = s.AllOf(
	s.String,
	s.Pattern("%u[%l%d%u]+")
)

--- StringLength matching
-- @tparam int min
-- @tparam int max
-- @treturn func
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
	Roblox
	@section roblox
----------------------------------------------]]

--- Type of roblox instance
function Schema.static:TypeOf(className)
	local _ = self
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

--- IsA like for roblox instances
function Schema.static:IsA(className)
	local _ = self
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

--- Matches instance name
function Schema.static:InstanceName(name)
	local _ = self
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

--- PlaceId is a number
Schema.static.PlaceId = s.Number

--[[--------------------------------------------
	Logging
	@section logging
----------------------------------------------]]

--- Logging level
Schema.static.Enums.LogLevel = Enumeration({
	None = 0,
	Fatal = 1,
	Error = 2,
	Warn = 3,
	Info = 4,
	Debug = 5,
	Trace = 6,
})

--- Represents a log entry
Schema.static.LogEntry = Schema.Record {
	Level = Schema.IntegerFrom(1, 6),
	Message = Schema.StringLength(3, 128),
	Data = Schema.Optional(Schema.Table),
	Player = Schema.Optional(Schema:IsA("Player")),
}

--- Logging initialization data
Schema.static.LogInit = Schema.Record {
	Config = Schema.Optional(Schema.Table),
	Player = Schema.Optional(Schema:IsA("Player")),
	ClassName = Schema.CamelCase,
}

--[[--------------------------------------------
	Components
	@section components
----------------------------------------------]]

---	IsARoot Instance
Schema.static.IsARoot = s.OneOf(
	Schema:IsA("Model"),
	Schema:IsA("Tool")
)

--- Does the object have a component attached.
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

--- Is this a character model?
Schema.static.CharacterModel = s.AllOf(
	Schema.Component,
	Schema:IsA("Model")
)

--- Is the data a valid component name?
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

--- A calling component script
Schema.static.ComponentScript = s.AllOf(
	Schema:IsA("Script"),
	Schema:InstanceName("BTKComponent")
)

--- Component Query
Schema.static.ComponentQuery = Schema.Record({
	Inst = Schema:IsA("Instance"),
})

--- Is this a valid root object, and does it have a component attached.
Schema.static.Root = s.AllOf(
	Schema.IsARoot,
	Schema.Component
)

--[[--------------------------------------------
	Scripts
	@section scripts
----------------------------------------------]]

--- Is this a script
Schema.static.Script = Schema.OneOf(
	Schema:IsA("Script"),
	Schema:IsA("LocalScript")
)

--[[--------------------------------------------
	Data
	@section data
----------------------------------------------]]

---	A valid data key
Schema.static.DataFolder = Schema:IsA("Folder")

--- Data key
Schema.static.DataKey = s.AllOf(
	Schema.StringLength(3,32),
	Schema.CamelCase
)

--- Type
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

--- Value
Schema.static.DataValue = s.Any

--- Data definition
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
	Properties
	@section properties
----------------------------------------------]]

--- Property definition
Schema.static.PropertyDefinition = Schema.Record {
	Name = Schema.DataKey,
	Type = Schema.DataType,
	Value = Schema.DataValue,
	ValueFn = Schema.Optional(
		s.Function
	),
	ValueInstance = Schema.Optional(
		Schema.OneOf(
			Schema:IsA("ValueBase"),
			--- @TODO lemur doesn't populate the IsA handling properly
			Schema:IsA("NumberValue"),
			Schema:IsA("ObjectValue"),
			Schema:IsA("StringValue"),
			Schema:IsA("Vector3Value"),
			Schema:IsA("BoolValue")
		)
	),
	SchemaFn = s.Function,
	WatchFn = Schema.Optional(
		s.Function
	),
	AllowOverride = Schema.Optional(s.Boolean),
}

--[[--------------------------------------------
	Configuraton
	@section configuration
----------------------------------------------]]

--- key
Schema.static.ConfigurationKey = Schema.DataKey

--- folder
Schema.static.ConfigurationFolder = s.OneOf(
	Schema:IsA("Folder"),
	Schema:IsA("Configuration")
)

--[[--------------------------------------------
	Events
	@section events
----------------------------------------------]]

--- Input event type
Schema.static.Enums.InputEventType = Enumeration({
	Damage = 1,
})

--- An general message
Schema.static.Message = s.OneOf(
	Schema.Record {
		Type = Schema.Enums.InputEventType.Damage,
		Payload = Schema.DamagePayload,
	}
)

---	A damage message
Schema.static.DamagePayload = Schema.Record {
	Damage = Schema.DamageAmount,
}

--- max
Schema.static.DamageMax = 99

--- amount
Schema.static.DamageAmount = Schema.IntegerFrom(
	0,
	Schema.DamageMax
)

--[[--------------------------------------------
	Assets
	@section assets
----------------------------------------------]]

--- data
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
	@section url
----------------------------------------------]]

--- http url
Schema.static.HttpURL = s.AllOf(
	s.String,
	s.Pattern("^http://.*")
)

--- https
Schema.static.HttpsURL = s.AllOf(
	s.String,
	s.Pattern("^https://.*")
)

--[[--------------------------------------------
	Currency
	@section currency
----------------------------------------------]]

--- max
Schema.static.MaximumCurrency = 1000000

--- currency
Schema.static.Currency = Schema.IntegerFrom(
	0,
	Schema.MaximumCurrency
)

--[[--------------------------------------------
	Weapons
	@section weapons
----------------------------------------------]]

--- type
Schema.static.Enums.WeaponType = Enumeration({
	Melee = 1,
	Ranged = 2,
})

--- type
Schema.static.WeaponType = s.OneOf(
	"Melee",
	"Ranged"
)

--- max attack dist
Schema.static.MaxAttackDistance = 999.0

--- attack dist
Schema.static.AttackDistance = s.NumberFrom(
	0.0, Schema.MaxAttackDistance
)

return Schema
