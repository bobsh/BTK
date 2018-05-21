local BaseUtil = require(script.Parent.BaseUtil)
local Schema = require(script.Parent.Schema)

local InsertService = game:GetService("InsertService")

local Assets = BaseUtil:subclass(script.Name)

function Assets.static:Get(input)
	self:AssertSchema(
		input,
		Schema.AssetData
	)
	return input.Parent:FindFirstChild(input.Name, false)
end

function Assets.static:GetMany(assets)
	local list = {}
	for _, value in pairs(assets) do
		local a = self:Get(value)
		if a ~= nil then
			table.insert(list, a)
		end
	end
	return list
end

function Assets.static:Install(input)
	self:AssertSchema(
		input,
		Schema.AssetData
	)

	self:Debug("Installing asset", input)

	local currentAsset = Assets:Get(input)
	if currentAsset ~= nil then
		self:Warn("Asset already exists",
			{
				Name = input.Name,
				ParentName = input.Parent.Name,
			}
		)
		return
	end

	local newAsset
	local versionID = 0
	if input.Local ~= nil then
		local ss = game.ServerStorage
		local content = ss:FindFirstChild("BTKContent")
		local folder = content:FindFirstChild(input.Local.Folder)
		if folder == nil then
			self:Error("Folder not found")
		end

		local file = folder:FindFirstChild(input.Local.Name)
		if file == nil then
			self:Error("File not found")
		end

		newAsset = file:Clone()
	else
		versionID = InsertService:GetLatestAssetVersionAsync(input.ID)
		self:Debug(("Found version %d for asset ID %d"):format(versionID, input.ID))

		local assetRef = InsertService:LoadAssetVersion(versionID)
		if not assetRef then
			self:Error("Unable to load asset")
		end
		local assetChildren = assetRef:GetChildren()
		if #assetChildren ~= 1 then
			self:Error("Asset should only have 1 child")
		end
		newAsset = assetChildren[1]
	end

	if not (newAsset:IsA(input.Type)) then
		self:Error("Asset child does not match",
			{
				ShouldType = input.Type,
			}
		)
	end
	newAsset.Parent = input.Parent
	newAsset.Name = input.Name

	-- Add metadata to asset
	local meta = newAsset:FindFirstChild("Meta", false)
	if meta == nil then
		meta = Instance.new("Configuration", newAsset)
		meta.Name = "Meta"
	end

	local metaAssetID = meta:FindFirstChild("AssetID", false)
	if metaAssetID == nil then
		metaAssetID = Instance.new("NumberValue", meta)
		metaAssetID.Name = "AssetID"
	end
	metaAssetID.Value = input.ID

	local metaVersionID = meta:FindFirstChild("VersionID", false)
	if metaVersionID == nil then
		metaVersionID = Instance.new("NumberValue", meta)
		metaVersionID.Name = "VersionID"
	end
	metaVersionID.Value = versionID

	self:Debug(("Done installing %s with id %d version %d into %s"):format(
		input.Name,
		input.ID,
		versionID,
		input.Parent.Name
	))
end

function Assets.static:InstallMany(assets)
	for _, value in pairs(assets) do
		self:Install(value)
	end
end

function Assets.static:Uninstall(input)
	self:AssertSchema(
		input,
		Schema.AssetData
	)

	if input.NoDelete == true then
		return
	end


	self:Debug(("Uninstalling %s from %s"):format(input.Name, input.Parent.Name))

	local currentAsset = Assets:Get(input)
	if currentAsset == nil then
		self:Warn("Cannot uninstall asset",
			{
				Name = input.Name,
				ParentName = input.Parent.Name,
			}
		)
		return
	end

	currentAsset:Destroy()
	self:Debug(("Uninstalled %s from %s"):format(input.Name, input.Parent.Name))
end

function Assets.static:UninstallMany(assets)
	self:Trace("Uninstalling many")
	for _, value in pairs(assets) do
		Assets:Uninstall(value)
	end
end

return Assets
