-- See LICENSE for terms

local Translate = ChoGGi.ComFuncs.Translate

do -- stored tables stuff
	-- called below and when translation changes
	function ChoGGi.ComFuncs.UpdateOtherTables()
		-- easy access to colonist data, cargo, mystery
		local Tables = ChoGGi.Tables
		-- display names only!
		Tables.ColonistRaces = {
			-- caucasian
			Translate(1859--[[White]]), [Translate(1859--[[White]])] = true,
			-- african
			Translate(302535920000739--[[Black]]), [Translate(302535920000739--[[Black]])] = true,
			-- asian
			Translate(302535920000740--[[Asian]]), [Translate(302535920000740--[[Asian]])] = true,
			-- aryan (indo-iranian is too much of a mouthful and aryan will just make some people pissy)
			Translate(302535920001283--[[Indian]]), [Translate(302535920001283--[[Indian]])] = true,
			-- hispanic
			Translate(302535920001284--[[Hispanic]]), [Translate(302535920001284--[[Hispanic]])] = true,
		}
		-- go with what you know (guess i could make it randomly pick one of each to be fairer?)
		Tables.ColonistRacesImages = {
			[Translate(1859--[[White]])] = "UI/Icons/Colonists/Pin/Unit_Male_Ca_Adult_01.tga",
			[Translate(302535920000739--[[Black]])] = "UI/Icons/Colonists/Pin/Unit_Male_Af_Adult_01.tga",
			[Translate(302535920000740--[[Asian]])] = "UI/Icons/Colonists/Pin/Unit_Male_As_Adult_01.tga",
			[Translate(302535920001283--[[Indian]])] = "UI/Icons/Colonists/Pin/Unit_Male_Ar_Adult_01.tga",
			[Translate(302535920001284--[[Hispanic]])] = "UI/Icons/Colonists/Pin/Unit_Male_Hs_Adult_01.tga",
			-- android
			[Translate(3490--[[Random]])] = "UI/Icons/Colonists/Pin/Unit_Male_An_Adult_01.tga",
			[Translate(1000121--[[Default]])] = "UI/Icons/Colonists/Pin/Unit_Male_An_Adult_01.tga",
		}
		--~ Tables.ColonistRacesImagesFemale = {
		--~ 	[Translate(1859--[[White]])] = "UI/Icons/Colonists/Pin/Unit_Female_Ca_Adult_01.tga",
		--~ 	[Translate(302535920000739--[[Black]])] = "UI/Icons/Colonists/Pin/Unit_Female_Af_Adult_01.tga",
		--~ 	[Translate(302535920000740--[[Asian]])] = "UI/Icons/Colonists/Pin/Unit_Female_As_Adult_01.tga",
		--~ 	[Translate(302535920001283--[[Indian]])] = "UI/Icons/Colonists/Pin/Unit_Female_Ar_Adult_01.tga",
		--~ 	[Translate(302535920001284--[[Hispanic]])] = "UI/Icons/Colonists/Pin/Unit_Female_Hs_Adult_01.tga",
		--~ 	[Translate(3490--[[Random]])] = "UI/Icons/Colonists/Pin/Unit_Female_An_Adult_01.tga",
		--~ 	[Translate(1000121--[[Default]])] = "UI/Icons/Colonists/Pin/Unit_Female_An_Adult_01.tga",
		--~ }
	end
	local Tables = ChoGGi.Tables
	Tables.ColonistSpecImages = {
		botanist = "UI/Icons/Colonists/Pin/Botanist_Male.tga",
		engineer = "UI/Icons/Colonists/Pin/Engineer_Female.tga",
		geologist = "UI/Icons/Colonists/Pin/Geologist_Female.tga",
		medic = "UI/Icons/Colonists/Pin/Medic_Male.tga",
		scientist = "UI/Icons/Colonists/Pin/Scientist_Male.tga",
		security = "UI/Icons/Colonists/Pin/Security_Female.tga",
		none = "UI/Icons/Colonists/Pin/Colonist_Male.tga",
	}
	Tables.ColonistAgeImages = {
		Adult = "UI/Icons/Colonists/Pin/Unit_Male_Ca_Adult_02.tga",
		Child = "UI/Icons/Colonists/Pin/Unit_Male_Ca_Child_02.tga",
		["Middle Aged"] = "UI/Icons/Colonists/Pin/Unit_Male_Ca_Adult_03.tga",
		Senior = "UI/Icons/Colonists/Pin/Unit_Male_Ca_Retiree_01.tga",
		Youth = "UI/Icons/Colonists/Pin/Unit_Male_Ca_Child_01.tga",
	}
	Tables.ColonistGenderImages = {
		Female = "UI/Icons/Colonists/Pin/Unit_Female_Ca_Adult_02.tga",
		Male = "UI/Icons/Colonists/Pin/Unit_Male_Ca_Adult_02.tga",
		OtherGender = "UI/Icons/Buildings/placeholder.tga",
	}
	-- some names need to be fixed when doing construction placement
	Tables.ConstructionNamesListFix = {
		SupplyRocket = "SupplyRocketBuilding",
		Rocket = "SupplyRocketBuilding",
		-- added when a rocket lands
		RocketLandingSite = "LandingPad",
		RCConstructor = "RCConstructorBuilding",
		RCDriller = "RCDrillerBuilding",
		ExplorerRover = "RCExplorerBuilding",
		RCHarvester = "RCHarvesterBuilding",
		RCRover = "RCRoverBuilding",
		RCSensor = "RCSensorBuilding",
		RCSolar = "RCSolarBuilding",
		RCTerraformer = "RCTerraformerBuilding",
		RCTransport = "RCTransportBuilding",
	}
	-- these are edited when removing building limits
	local ConstructionStatus = ConstructionStatus
	local table = table
	-- if I table.copy(ConstructionStatus) then all the tables inside are still the same tables
	for id, status in pairs(ConstructionStatus) do
		Tables.ConstructionStatus[id] = table.copy(status)
	end

	ChoGGi.ComFuncs.UpdateOtherTables()

	-- also called after mods are loaded, we call it now for any functions that use it before then
	ChoGGi.ComFuncs.UpdateDataTables()
	-- only updated when mods reloaded
	ChoGGi.ComFuncs.UpdateTablesSponComm()
end -- do

local function GetValueCls(obj, value, fallback)
	return obj and obj.GetDefaultPropertyValue
		and obj:GetDefaultPropertyValue(value) or fallback
end

local function GetValueBT(bt, value, fallback)
	return bt and bt[value] or fallback
end

function OnMsg.ClassesBuilt()
	local Consts = Consts
	local const = const
	local g_Classes = g_Classes

	local cConsts = ChoGGi.Consts
	local r = const.ResourceScale

	-- get the default values for our Consts
	for key, value in pairs(cConsts) do
		if value == false then
			local setting = Consts:GetDefaultPropertyValue(key)
			if setting then
				cConsts[key] = setting
			end
		end
	end

	-- get other defaults not stored in Consts
	ChoGGi.Consts.DroneFactoryBuildSpeed = GetValueCls(g_Classes.DroneFactory, "performance", 100)
	ChoGGi.Consts.StorageShuttle = GetValueCls(g_Classes.CargoShuttle, "max_shared_storage", 3 * r)
	ChoGGi.Consts.SpeedShuttle = GetValueCls(g_Classes.CargoShuttle, "move_speed", 3 * r)
	ChoGGi.Consts.ShuttleHubShuttleCapacity = GetValueCls(g_Classes.ShuttleHub, "max_shuttles", 10)
	ChoGGi.Consts.SpeedDrone = GetValueCls(g_Classes.Drone, "move_speed", 1440)
	ChoGGi.Consts.SpeedRC = GetValueCls(g_Classes.RCRover, "move_speed", 1 * r)
	ChoGGi.Consts.SpeedColonist = GetValueCls(g_Classes.Colonist, "move_speed", 1 * r)
	ChoGGi.Consts.RCTransportStorageCapacity = GetValueCls(g_Classes.RCTransport, "max_shared_storage", 30 * r)
	ChoGGi.Consts.StorageUniversalDepot = GetValueCls(g_Classes.UniversalStorageDepot, "max_storage_per_resource", 30 * r)
	-- DLC objects
	if g_Classes.FlyingDrone then
		ChoGGi.Consts.SpeedWaspDrone = GetValueCls(g_Classes.FlyingDrone, "move_speed", 1600)
	end
	if g_Classes.RCConstructor then
		ChoGGi.Consts.RCConstructorStorageCapacity = GetValueCls(g_Classes.RCConstructor, "max_shared_storage", 42 * r)
	end

	local bt = BuildingTemplates
	ChoGGi.Consts.StorageWasteDepot = GetValueBT(bt.WasteRockDumpBig, "max_amount_WasteRock", 70 * r)
	ChoGGi.Consts.StorageWasteDepotHuge = GetValueBT(bt.WasteRockDumpHuge, "max_amount_WasteRock", 285 * r)
	ChoGGi.Consts.StorageOtherDepot = GetValueBT(bt.StorageConcrete, "max_storage_per_resource", 180 * r)
	ChoGGi.Consts.StorageMechanizedDepot = GetValueBT(bt.MechanizedDepotConcrete, "max_storage_per_resource", 3950 * r) -- the other 50 is stored on the "porch"
	-- ^ they're all UniversalStorageDepot
	ChoGGi.Consts.RocketMaxExportAmount = GetValueBT(bt.SupplyRocket, "max_export_storage", 30 * r)
	ChoGGi.Consts.LaunchFuelPerRocket = GetValueBT(bt.SupplyRocket, "launch_fuel", 60 * r)

	ChoGGi.Consts.CameraScrollBorder = const.DefaultCameraRTS.ScrollBorder
	ChoGGi.Consts.CameraLookatDist = const.DefaultCameraRTS.LookatDist
	ChoGGi.Consts.CameraMaxZoom = const.DefaultCameraRTS.MaxZoom
	ChoGGi.Consts.CameraMinZoom = const.DefaultCameraRTS.MinZoom
	ChoGGi.Consts.HigherRenderDist = hr.LODDistanceModifier or 120
end
