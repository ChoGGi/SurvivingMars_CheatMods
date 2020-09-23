-- See LICENSE for terms

-- CurrentModPath, CurrentModOptions, CurrentModDef, CurrentModId

local UpdateDepotCapacity = ChoGGi.ComFuncs.UpdateDepotCapacity

local mod_options = {
	UniversalStorageDepot = 0,
	WasteRockDumpBig = 0,
	WasteRockDumpHuge = 0,
	BlackCubeDump = 0,
	StorageConcrete = 0,
	StorageElectronics = 0,
	StorageFood = 0,
	StorageFuel = 0,
	StorageMachineParts = 0,
	StorageMetals = 0,
	StorageMysteryResource = 0,
	StoragePolymers = 0,
	StorageRareMetals = 0,
	StorageSeeds = 0,
	MechanizedDepotConcrete = 0,
	MechanizedDepotElectronics = 0,
	MechanizedDepotFood = 0,
	MechanizedDepotFuel = 0,
	MechanizedDepotMachineParts = 0,
	MechanizedDepotMetals = 0,
	MechanizedDepotMysteryResource = 0,
	MechanizedDepotPolymers = 0,
	MechanizedDepotRareMetals = 0,
	MechanizedDepotSeeds = 0,
}

local r = const.ResourceScale

local function UpdateCapacity(func, obj, ...)
	local template = obj.template_name
	local mod_option = mod_options[template]

	if mod_option then
		local max_store = "max_storage_per_resource"
		local storable
		if template == "WasteRockDumpBig" or template == "WasteRockDumpHuge" then
			max_store = "max_amount_WasteRock"
			storable = {"WasteRock"}
		elseif template == "BlackCubeDump" then
			max_store = "max_amount_BlackCube"
			storable = {"BlackCube"}
		end

		obj[max_store] = mod_option * r
		UpdateDepotCapacity(obj, obj[max_store], storable)
	end

	if func then
		return func(obj, ...)
	end

end

local function UpdateDepots(list)
	for i = 1, #list do
		UpdateCapacity(nil, list[i])
	end
end

local options

-- fired when settings are changed/init
local function ModOptions()
	options = CurrentModOptions

	for id in pairs(mod_options) do
		mod_options[id] = options:GetProperty("Capacity_" .. id)
	end

	-- make sure we're ingame
	if not UICity then
		return
	end

	-- update all existing depots
	local labels = UICity.labels
	UpdateDepots(labels.WasteRockDumpSite or "")
	UpdateDepots(labels.UniversalStorageDepot or "")
	UpdateDepots(labels.MechanizedDepots or "")
	UpdateDepots(labels.BlackCubeDumpSite or "")
	UpdateDepots(labels.MysteryDepot or "")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

OnMsg.CityStart = ModOptions
OnMsg.LoadGame = ModOptions

local orig_UniversalStorageDepot_GameInit = UniversalStorageDepot.GameInit
function UniversalStorageDepot:GameInit(...)
	return UpdateCapacity(orig_UniversalStorageDepot_GameInit, self, ...)
end

local orig_MechanizedDepot_GameInit = MechanizedDepot.GameInit
function MechanizedDepot:GameInit(...)
	return UpdateCapacity(orig_MechanizedDepot_GameInit, self, ...)
end

local orig_WasteRockDumpSite_GameInit = WasteRockDumpSite.GameInit
function WasteRockDumpSite:GameInit(...)
	return UpdateCapacity(orig_WasteRockDumpSite_GameInit, self, ...)
end

local orig_BlackCubeDumpSite_GameInit = BlackCubeDumpSite.GameInit
function BlackCubeDumpSite:GameInit(...)
	return UpdateCapacity(orig_BlackCubeDumpSite_GameInit, self, ...)
end
