-- See LICENSE for terms

local properties = {}
local c = 0

local Consts = ChoGGi.Consts
local r = const.ResourceScale
local other = Consts.StorageOtherDepot / r
local mech = Consts.StorageMechanizedDepot / r

local lookup_default_size = {
	UniversalStorageDepot = Consts.StorageUniversalDepot / r,
	WasteRockDumpBig = Consts.StorageWasteDepot / r,
	WasteRockDumpHuge = Consts.StorageWasteDepotHuge / r,
	BlackCubeDump = other,
	StorageConcrete = other,
	StorageElectronics = other,
	StorageFood = other,
	StorageFuel = other,
	StorageMachineParts = other,
	StorageMetals = other,
	StorageMysteryResource = other,
	StoragePolymers = other,
	StorageRareMetals = other,
	StorageSeeds = other,
	MechanizedDepotConcrete = mech,
	MechanizedDepotElectronics = mech,
	MechanizedDepotFood = mech,
	MechanizedDepotFuel = mech,
	MechanizedDepotMachineParts = mech,
	MechanizedDepotMetals = mech,
	MechanizedDepotMysteryResource = mech,
	MechanizedDepotPolymers = mech,
	MechanizedDepotRareMetals = mech,
	MechanizedDepotSeeds = mech,
}

local lookup_name_prefixes = {
	WasteRockDumpBig = "WasteRock",
	WasteRockDumpHuge = "WasteRock",
}
local Resources = Resources

local function AddProps(list)
	for i = 1, #list do
		local depot = list[i]
		c = c + 1
		local icon = depot.encyclopedia_image ~= "" and depot.encyclopedia_image or depot.display_icon ~= "" and depot.display_icon
		if icon then
			icon = "\n\n<image " .. icon .. ">"
		else
			icon = ""
		end
		local size = lookup_default_size[depot.id] or 30
		local max = 2500
		local step = 10
		if size > 1000 then
			max = 25000
			step = 500
		end
		-- add prefix for certain buildings
		local name = lookup_name_prefixes[depot.id]
		if name then
			name = table.concat(T(Resources[name].display_name) .. " " .. T(depot.display_name))
		else
			name = T(depot.display_name)
		end

		properties[c] = PlaceObj("ModItemOptionNumber", {
			"name", "Capacity_" .. depot.id,
			"DisplayName", name,
			"Help", table.concat(T(depot.description) .. icon),
			"DefaultValue", size,
			"MinValue", 0,
			"MaxValue", max,
			"StepSize", step,
		})
	end
end

local templates = Presets.BuildingTemplate
AddProps(templates.Depots)
AddProps(templates.Storages)
AddProps(templates.MechanizedDepots)

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(properties, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return properties
