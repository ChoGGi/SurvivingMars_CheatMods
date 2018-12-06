-- See LICENSE for terms

local S = ChoGGi.Strings

-- easy access to colonist data, cargo, mystery
ChoGGi.Tables = {
	-- display names only! (they're stored as numbers, not names like the rest; which is why i'm guessing)
	ColonistRaces = {
		S[1859--[[White--]]],[S[1859--[[White--]]]] = true,
		S[302535920000739--[[Black--]]],[S[302535920000739--[[Black--]]]] = true,
		S[302535920000740--[[Asian--]]],[S[302535920000740--[[Asian--]]]] = true,
		S[302535920001283--[[Indian--]]],[S[302535920001283--[[Indian--]]]] = true,
		S[302535920001284--[[Southeast Asian--]]],[S[302535920001284--[[Southeast Asian--]]]] = true,
	},
--~ s.race = 1
--~ s:ChooseEntity()

	-- some names need to be fixed when doing construction placement
	ConstructionNamesListFix = {
		RCRover = "RCRoverBuilding",
		RCDesireTransport = "RCDesireTransportBuilding",
		RCTransport = "RCTransportBuilding",
		ExplorerRover = "RCExplorerBuilding",
		Rocket = "SupplyRocket",
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
	ChoGGi.Consts.DroneFactoryBuildSpeed = g_Classes.DroneFactory:GetDefaultPropertyValue("performance")
	ChoGGi.Consts.StorageShuttle = g_Classes.CargoShuttle:GetDefaultPropertyValue("max_shared_storage")
	ChoGGi.Consts.SpeedShuttle = g_Classes.CargoShuttle:GetDefaultPropertyValue("move_speed")
	ChoGGi.Consts.ShuttleHubShuttleCapacity = g_Classes.ShuttleHub:GetDefaultPropertyValue("max_shuttles")
	ChoGGi.Consts.SpeedDrone = g_Classes.Drone:GetDefaultPropertyValue("move_speed")
	ChoGGi.Consts.SpeedRC = g_Classes.RCRover:GetDefaultPropertyValue("move_speed")
	ChoGGi.Consts.SpeedColonist = g_Classes.Colonist:GetDefaultPropertyValue("move_speed")
	ChoGGi.Consts.RCTransportStorageCapacity = g_Classes.RCTransport:GetDefaultPropertyValue("max_shared_storage")
	ChoGGi.Consts.StorageUniversalDepot = g_Classes.UniversalStorageDepot:GetDefaultPropertyValue("max_storage_per_resource")
--~ 	ChoGGi.Consts.StorageWasteDepot = WasteRockDumpSite:GetDefaultPropertyValue("max_amount_WasteRock")
	ChoGGi.Consts.StorageWasteDepot = 70 * r --^ that has 45000 as default...
	ChoGGi.Consts.StorageOtherDepot = 180 * r
	ChoGGi.Consts.StorageMechanizedDepot = 3950 * r -- the other 50 is stored on the "porch"
	-- ^ they're all UniversalStorageDepot
	ChoGGi.Consts.GravityColonist = 0
	ChoGGi.Consts.GravityDrone = 0
	ChoGGi.Consts.GravityRC = 0
	-- not sure what the 100K is for with SupplyRocket, but ah well 30K it is
	ChoGGi.Consts.RocketMaxExportAmount = 30 * r
	ChoGGi.Consts.LaunchFuelPerRocket = 60 * r

	ChoGGi.Consts.CameraScrollBorder = const.DefaultCameraRTS.ScrollBorder
	ChoGGi.Consts.CameraLookatDist = const.DefaultCameraRTS.LookatDist
	ChoGGi.Consts.CameraMaxZoom = const.DefaultCameraRTS.MaxZoom
	ChoGGi.Consts.CameraMinZoom = const.DefaultCameraRTS.MinZoom
	ChoGGi.Consts.HigherRenderDist = 120 -- hr.LODDistanceModifier
end
