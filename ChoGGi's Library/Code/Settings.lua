-- See LICENSE for terms

local Translate = ChoGGi.ComFuncs.Translate
local Strings = ChoGGi.Strings

-- easy access to colonist data, cargo, mystery
ChoGGi.Tables = {
	-- display names only!
	ColonistRaces = {
		-- caucasian
		Translate(1859--[[White--]]),[Translate(1859--[[White--]])] = true,
		-- african
		Strings[302535920000739--[[Black--]]],[Strings[302535920000739--[[Black--]]]] = true,
		-- asian
		Strings[302535920000740--[[Asian--]]],[Strings[302535920000740--[[Asian--]]]] = true,
		-- aryan (indo-iranian is too much of a mouthful and aryan will just make some people pissy)
		Strings[302535920001283--[[Indian--]]],[Strings[302535920001283--[[Indian--]]]] = true,
		-- hispanic
		Strings[302535920001284--[[Hispanic--]]],[Strings[302535920001284--[[Hispanic--]]]] = true,
	},
	ColonistRacesImages = {
		[Translate(1859--[[White--]])] = "UI/Icons/Colonists/Pin/Unit_Male_Ca_Adult_01.tga",
		[Strings[302535920000739--[[Black--]]]] = "UI/Icons/Colonists/Pin/Unit_Male_Af_Adult_01.tga",
		[Strings[302535920000740--[[Asian--]]]] = "UI/Icons/Colonists/Pin/Unit_Male_As_Adult_01.tga",
		[Strings[302535920001283--[[Indian--]]]] = "UI/Icons/Colonists/Pin/Unit_Male_Ar_Adult_01.tga",
		[Strings[302535920001284--[[Hispanic--]]]] = "UI/Icons/Colonists/Pin/Unit_Male_Hs_Adult_01.tga",
		-- android
		[Translate(3490--[[Random--]])] = "UI/Icons/Colonists/Pin/Unit_Male_An_Adult_01.tga",
		[Translate(1000121--[[Default--]])] = "UI/Icons/Colonists/Pin/Unit_Male_An_Adult_01.tga",
	},
--~ 	ColonistRacesImagesFemale = {
--~ 		[Translate(1859--[[White--]])] = "UI/Icons/Colonists/Pin/Unit_Female_Ca_Adult_01.tga",
--~ 		[Strings[302535920000739--[[Black--]]]] = "UI/Icons/Colonists/Pin/Unit_Female_Af_Adult_01.tga",
--~ 		[Strings[302535920000740--[[Asian--]]]] = "UI/Icons/Colonists/Pin/Unit_Female_As_Adult_01.tga",
--~ 		[Strings[302535920001283--[[Indian--]]]] = "UI/Icons/Colonists/Pin/Unit_Female_Ar_Adult_01.tga",
--~ 		[Strings[302535920001284--[[Hispanic--]]]] = "UI/Icons/Colonists/Pin/Unit_Female_Hs_Adult_01.tga",
--~ 		[Translate(3490--[[Random--]])] = "UI/Icons/Colonists/Pin/Unit_Female_An_Adult_01.tga",
--~ 		[Translate(1000121--[[Default--]])] = "UI/Icons/Colonists/Pin/Unit_Female_An_Adult_01.tga",
--~ 	},
	ColonistSpecImages = {
		botanist = "UI/Icons/Colonists/Pin/Botanist_Male.tga",
		engineer = "UI/Icons/Colonists/Pin/Engineer_Female.tga",
		geologist = "UI/Icons/Colonists/Pin/Geologist_Female.tga",
		medic = "UI/Icons/Colonists/Pin/Medic_Male.tga",
		scientist = "UI/Icons/Colonists/Pin/Scientist_Male.tga",
		security = "UI/Icons/Colonists/Pin/Security_Female.tga",
		none = "UI/Icons/Colonists/Pin/Colonist_Male.tga",
	},
	ColonistAgeImages = {
		Adult = "UI/Icons/Colonists/Pin/Unit_Male_Ca_Adult_02.tga",
		Child = "UI/Icons/Colonists/Pin/Unit_Male_Ca_Child_02.tga",
		["Middle Aged"] = "UI/Icons/Colonists/Pin/Unit_Male_Ca_Adult_03.tga",
		Senior = "UI/Icons/Colonists/Pin/Unit_Male_Ca_Retiree_01.tga",
		Youth = "UI/Icons/Colonists/Pin/Unit_Male_Ca_Child_01.tga",
	},
	ColonistGenderImages = {
		Female = "UI/Icons/Colonists/Pin/Unit_Female_Ca_Adult_02.tga",
		Male = "UI/Icons/Colonists/Pin/Unit_Male_Ca_Adult_02.tga",
		OtherGender = "UI/Icons/Buildings/placeholder.tga",
	},


--~ s.race = 1
--~ s:ChooseEntity()

	-- some names need to be fixed when doing construction placement
	ConstructionNamesListFix = {
		-- can't build em
		Rocket = "",
		-- added when a rocket lands
		RocketLandingSite = "LandingPad",
	},
	Cargo = {},
	CargoPresets = {},
	Mystery = {},
	NegativeTraits = {},
	PositiveTraits = {},
	OtherTraits = {},
	ColonistAges = {},
	ColonistGenders = {},
	ColonistSpecializations = {},
	ColonistBirthplaces = {},
	Resources = {},
	SchoolTraits = {},
	SanatoriumTraits = {},
}
-- also called after mods are loaded, we call it now for any functions that use it before then
ChoGGi.ComFuncs.UpdateDataTables()

local function GetValueCls(obj,value,fallback)
	if obj then
		return obj:GetDefaultPropertyValue(value)
	end
	return fallback
end
local function GetValueBT(bt,value,fallback)
	if bt and bt[value] then
		return bt[value]
	end
	return fallback
end

function OnMsg.ClassesBuilt()
	local Consts = Consts
	local const = const
	local g_Classes = g_Classes

	local cConsts = ChoGGi.Consts
	local r = cConsts.ResourceScale

	-- get the default values for our Consts
	for key,value in pairs(cConsts) do
		if value == false then
			local setting = Consts:GetDefaultPropertyValue(key)
			if setting then
				cConsts[key] = setting
			end
		end
	end

	-- get other defaults not stored in Consts
	ChoGGi.Consts.DroneFactoryBuildSpeed = GetValueCls(g_Classes.DroneFactory,"performance",100)
	ChoGGi.Consts.StorageShuttle = GetValueCls(g_Classes.CargoShuttle,"max_shared_storage",3 * r)
	ChoGGi.Consts.SpeedShuttle = GetValueCls(g_Classes.CargoShuttle,"move_speed",3 * r)
	ChoGGi.Consts.ShuttleHubShuttleCapacity = GetValueCls(g_Classes.ShuttleHub,"max_shuttles",10)
	ChoGGi.Consts.SpeedDrone = GetValueCls(g_Classes.Drone,"move_speed",1440)
	ChoGGi.Consts.SpeedRC = GetValueCls(g_Classes.RCRover,"move_speed",1 * r)
	ChoGGi.Consts.SpeedColonist = GetValueCls(g_Classes.Colonist,"move_speed",1 * r)
	ChoGGi.Consts.RCTransportStorageCapacity = GetValueCls(g_Classes.RCTransport,"max_shared_storage",30 * r)
	if rawget(g_Classes,"RCConstructor") then
		ChoGGi.Consts.RCConstructorStorageCapacity = GetValueCls(g_Classes.RCConstructor,"max_shared_storage",42 * r)
	end
	ChoGGi.Consts.StorageUniversalDepot = GetValueCls(g_Classes.UniversalStorageDepot,"max_storage_per_resource",30 * r)
	local bt = BuildingTemplates
	ChoGGi.Consts.StorageWasteDepot = GetValueBT(bt.WasteRockDumpBig,"max_amount_WasteRock",70 * r)
	ChoGGi.Consts.StorageOtherDepot = GetValueBT(bt.StorageConcrete,"max_storage_per_resource",180 * r)
	ChoGGi.Consts.StorageMechanizedDepot = GetValueBT(bt.MechanizedDepotConcrete,"max_storage_per_resource",3950 * r) -- the other 50 is stored on the "porch"
	-- ^ they're all UniversalStorageDepot
	ChoGGi.Consts.RocketMaxExportAmount = GetValueBT(bt.SupplyRocket,"max_export_storage",30 * r)
	ChoGGi.Consts.LaunchFuelPerRocket = GetValueBT(bt.SupplyRocket,"launch_fuel",60 * r)
	ChoGGi.Consts.GravityColonist = 0
	ChoGGi.Consts.GravityDrone = 0
	ChoGGi.Consts.GravityRC = 0

	ChoGGi.Consts.CameraScrollBorder = const.DefaultCameraRTS.ScrollBorder
	ChoGGi.Consts.CameraLookatDist = const.DefaultCameraRTS.LookatDist
	ChoGGi.Consts.CameraMaxZoom = const.DefaultCameraRTS.MaxZoom
	ChoGGi.Consts.CameraMinZoom = const.DefaultCameraRTS.MinZoom
	ChoGGi.Consts.HigherRenderDist = hr.LODDistanceModifier
end
