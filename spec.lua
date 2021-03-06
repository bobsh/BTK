--[[
	Loads our library and all of its dependencies, then runs tests using TestEZ.
]]

-- If you add any dependencies, add them to this table so they'll be loaded!
local LOAD_MODULES = {
	{"src", "BTK"},
	{"modules/testez/lib", "TestEZ"},
}

-- This makes sure we can load Lemur and other libraries that depend on init.lua
package.path = package.path .. ";?/init.lua"

-- If this fails, make sure you've run `lua bin/install-dependencies.lua` first!
local lemur = require("modules.lemur")

--[[
	Collapses ModuleScripts named 'init' into their parent folders.

	This is the same behavior as the collapsing mechanism from rbxpacker.
]]
local function collapse(root)
	local init = root:FindFirstChild("init")
	if init then
		init.Name = root.Name
		init.Parent = root.Parent

		for _, child in ipairs(root:GetChildren()) do
			child.Parent = init
		end

		root:Destroy()
		root = init
	end

	for _, child in ipairs(root:GetChildren()) do
		if child:IsA("Folder") then
			collapse(child)
		end
	end

	return root
end

-- Create a virtual Roblox tree
local habitat = lemur.Habitat.new()

-- Get replicated storage
local ReplicatedStorage = habitat.game:GetService("ReplicatedStorage")

-- We'll put all of our library code and dependencies here
local Root = lemur.Instance.new("Folder")
Root.Name = "Root"

-- Load all of the modules specified above
for _, module in ipairs(LOAD_MODULES) do
	local container = habitat:loadFromFs(module[1], ReplicatedStorage)
	container.Name = module[2]
	container.Parent = ReplicatedStorage
end

collapse(ReplicatedStorage)

-- Load TestEZ and run our tests
local TestEZ = habitat:require(ReplicatedStorage.TestEZ)

local results = TestEZ.TestBootstrap:run(
	ReplicatedStorage.BTK,
	TestEZ.Reporters.TextReporter,
	true
)

-- Did something go wrong?
if results.failureCount > 0 then
	os.exit(1)
end