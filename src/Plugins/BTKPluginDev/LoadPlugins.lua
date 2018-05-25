--[[--
	Load plugins
	@module BTKPluginDev.LoadPlugins
	@export
--]]

local loaded = {}

--[[
	LoadPlugin reloads individual plugins
--]]
local function LoadPlugin(name, pluginBase)
	local newPlugin = PluginManager():CreatePlugin()
	newPlugin.Name = name
	if typeof(pluginBase) == "Instance" then
		pluginBase.Parent = newPlugin
	else
		for _, v in next, pluginBase do
			v.Parent = newPlugin
		end
	end
	local descendants = newPlugin:GetDescendants()
	local ranAtLeastOne = false
	for _, v in next, descendants do
		if v:IsA('Script') and not v.Disabled then
			local scriptFunction, syntaxError = loadstring(v.Source, v:GetFullName())
			if syntaxError then
				warn(syntaxError)
			else
				local event = Instance.new('BindableEvent')
				event.Event:Connect(function()
					local env = getfenv(scriptFunction)
					setfenv(scriptFunction, setmetatable({
						plugin = newPlugin,
						script = v
					}, {__index = env}))
					scriptFunction()
				end)
				event:Fire()
				ranAtLeastOne = true
			end
		end
	end
	return ranAtLeastOne
end

--[[
	LoadPlugins loads all BTK plugins
--]]
local function LoadPlugins(plugins)
	print "LoadPlugins: Start"
	for _, pluginBase in next, plugins:GetChildren() do
		if not loaded[pluginBase.Name] then
			if (pluginBase:IsA('NumberValue') or pluginBase:IsA('StringValue')) and #pluginBase:GetChildren() == 0 then
				local assetUrl = pluginBase.Value
				if tonumber(assetUrl) then
					assetUrl = 'rbxassetid://'..assetUrl
				end
				local success, errorOrChildren = pcall(game.GetObjects, game, assetUrl)
				if not success then
					warn(string.format('Failed to load plugin \'%s\' because: %s', pluginBase.Name, errorOrChildren))
				else
					if LoadPlugin(pluginBase.Name, errorOrChildren) then
						loaded[pluginBase.Name] = true
					end
				end
			else
				if LoadPlugin(pluginBase.Name, pluginBase:Clone()) then
					loaded[pluginBase.Name] = true
				end
			end
		end
	end
	print "LoadPlugins: End"
end

return LoadPlugins