-- not that it matters if this file loads, nothing here will fire without Script.lua doing it's thing
if not GetDate():find("Dec") then
	return
end

local green = -16711936
local red = -65536
local white = -1

local function AttachesColoured(a, class, colour)
	if a.class == class then
		a:SetColorModifier(colour)
	end
end
-- oh it happens more than you'd think
local function AttachColour(s, class, colour)
	s:ForEachAttach(AttachesColoured, class, colour)
end

local function RGRG(s)
	s:SetColor1(red)
	s:SetColor2(green)
	s:SetColor3(red)
	s:SetColor4(green)
end

local function GRGR(s)
	s:SetColor1(green)
	s:SetColor2(red)
	s:SetColor3(green)
	s:SetColor4(red)
end

local function AttachesPassageRamp(a, colour)
	if a.class == "LampInt_05" then
		a:SetColorModifier(colour)
	end
end
local function SpawnedPassageRamp(s)
	local colour
	if Random(1, 10) > 5 then
		s:SetColorModifier(green)
		colour = red
	else
		s:SetColorModifier(red)
		colour = green
	end
	s:ForEachAttach(AttachesPassageRamp, colour)
end

local HangingGardensElements = {
	DecorInt_02 = true,
	LampInt_02 = true,
	DecorInt_04 = true,
	DecorInt_06 = true,
	HangingGardensFoliage = true,
	LampWallInner_01 = true,
	HangingGardensFloorDoor_01 = true,
	HangingGardensFloorDoor_02 = true,
	HangingGardensFloorDoor_03 = true,
}
local function AttachesHangingGardens(a)
	if HangingGardensElements[a.class] then
		a:SetColorModifier(red)
	end
end
local function SpawnedHangingGardens(s)
	s:SetColorModifier(green)
	s:ForEachAttach(AttachesHangingGardens)
end

local function AttachesArcology(a)
	if a.class == "DecorInt_02" then
		a:SetColorModifier(red)
	elseif a.class == "LampInt_02" then
		a:SetColorModifier(red)
	elseif a.class == "DecorInt_03" then
		a:SetColorModifier(green)
	elseif a.class == "LampWallInner_01" then
		a:SetColorModifier(green)
	end
end
local function SpawnedArcology(s)
	s:SetColorModifier(white)
	s:ForEachAttach(AttachesArcology)
end

local function AttachesSanatorium(a)
	if a.class == "LampInt_02" then
		a:SetColorModifier(red)
	elseif a.class == "DecorInt_05" then
		a:SetColorModifier(red)
	elseif a.class:find("Door_0") then
		a:SetColor1(red)
		a:SetColor2(green)
	end
end
local function SpawnedSanatorium(s)
	GRGR(s)
	s:ForEachAttach(AttachesSanatorium)
end

local function AttachesMedicalCenter(a)
	if a.class == "LampInt_02" then
		a:SetColorModifier(green)
	elseif a.class == "DecorInt_04" then
		a:SetColorModifier(red)
	elseif a.class == "DecorInt_03" then
		a:SetColorModifier(green)
	elseif a.class == "DecorInt_02" then
		a:SetColorModifier(green)
	elseif a.class:find("MedicalCenterFloorDoor") or a.class:find("MedicalCenterDoor") then
		a:SetColor3(green)
	end
end
local function SpawnedMedicalCenter(s)
	GRGR(s)
	s:ForEachAttach(AttachesMedicalCenter)
end

local function AttachesNetworkNode(a)
	if a.class == "LampInt_01" then
		a:SetColorModifier(red)
	elseif a.class == "LampInt_02" then
		a:SetColorModifier(red)
	elseif a.class == "NetworkNodeDoor_01" or a.class == "NetworkNodeDoor_02" then
		a:SetColor2(red)
	end
end
local function SpawnedNetworkNode(s)
	RGRG(s)
	s:ForEachAttach(AttachesNetworkNode)
end

local function AttachesCloningVats(a)
	if a.class:find("CloningVatsDoor") then
		a:SetColor2(green)
	elseif a.class == "LampInt_02" then
		a:SetColorModifier(red)
	end
end
local function SpawnedCloningVats(s)
	RGRG(s)
	s:ForEachAttach(AttachesCloningVats)
end

local function AttachesWaterReclamationSpire(a)
	if a.class == "LampInt_02" then
		a:SetColorModifier(red)
	end
end
local function SpawnedWaterReclamationSpire(s)
	GRGR(s)
	s:ForEachAttach(AttachesWaterReclamationSpire)
end

local function AttachesFarmConventional(a)
	if a.class == "FarmSprinkler" then
		a:SetColor2(green)
	elseif a.class == "LampInt_04" then
		a:SetColorModifier(green)
	elseif a.class == "ResourceStockpile" then
		if i % 2 == 0 then
			a:SetColorModifier(green)
		else
			a:SetColorModifier(red)
		end
	end
end
local function SpawnedFarmConventional(s)
	GRGR(s)
	s:ForEachAttach(AttachesFarmConventional)
end

local function SpawnedWaterTankLarge(s)
	s:SetColorModifier(green)
end

local FarmHydroponic_stockpile
local FarmHydroponic_decal
local function AttachesFarmHydroponic(a)
	if a.class == "HydroponicFarmDoor" or a.class == "HydroponicFarmFloorDoor" then
		a:SetColor2(green)
	elseif a.class == "LampInt_02" then
		a:SetColorModifier(red)
	elseif a.class == "LampWallInner_01" then
		a:SetColorModifier(green)
	elseif a.class == "DecSecurityCenterBase" then
		if not FarmHydroponic_decal then
			FarmHydroponic_decal = true
			a:SetColorModifier(green)
		else
			a:SetColorModifier(red)
		end
	elseif a.class == "ResourceStockpile" then
		if not FarmHydroponic_stockpile then
			FarmHydroponic_stockpile = true
			a:SetColorModifier(green)
		else
			a:SetColorModifier(red)
		end
	end
end
local function SpawnedFarmHydroponic(s)
	FarmHydroponic_stockpile = nil
	FarmHydroponic_decal = nil
	RGRG(s)
	s:ForEachAttach(AttachesFarmHydroponic)
end

local function AttachesTheExcavator(a)
	if a.class == "ExcavatorLights" then
		a:SetColorModifier(red)
	elseif a.class == "LampWallInner_01" then
		a:SetColorModifier(red)
	elseif a.class == "ResourceStockpile" then
		a:SetColorModifier(red)
	elseif a.class == "WasteRockStockpile" then
		a:SetColorModifier(green)
	end
end
local function SpawnedTheExcavator(s)
	RGRG(s)
	s.arm:SetColor1(red)
	s.arm:SetColor2(green)
	s.arm:SetColor4(green)
	s.belt:SetColorModifier(red)
	s.tower:SetColor1(green)
	s.tower:SetColor2(green)
	s.tower:SetColor3(green)
	s.tower:SetColor4(red)
	s:ForEachAttach(AttachesTheExcavator)
end

local function AttachesProjectMorpheus(a)
	if a.class == "ProjectMorpheusLights" then
		a:SetColorModifier(green)
	elseif a.class == "LampInt_03" then
		a:SetColorModifier(green)
	elseif a.class == "ParSystem" then
		a:SetColorModifier(green)
	end
end
local function SpawnedProjectMorpheus(s)
	GRGR(s)
	s:ForEachAttach(AttachesProjectMorpheus)
end

local function AttachesArtificialSun(a)
	if a.class == "ArtificialSunLights" then
		a:SetColorModifier(green)
	elseif a.class == "ParSystem" then
		a:SetColorModifier(red)
	end
end
local function SpawnedArtificialSun(s)
	RGRG(s)
	s:ForEachAttach(AttachesArtificialSun)
end

local function AttachesOmegaTelescope(a)
	if a.class == "RadioDishLights" then
		a:SetColorModifier(green)
	elseif a.class == "LampWallInner_01" then
		a:SetColorModifier(red)
	end
end
local function SpawnedOmegaTelescope(s)
	RGRG(s)
	s.antenna:SetColor1(red)
	s.antenna:SetColor2(green)
	s.antenna:SetColor3(green)
	s:ForEachAttach(AttachesOmegaTelescope)
end

local function AttachesMoholeMine(a)
	if a.class == "MoholeMineLights" then
		a:SetColorModifier(green)
	elseif a.class == "MoholeMineElevator" then
		a:SetColor1(red)
		a:SetColor2(green)
		a:SetColor3(green)
	elseif a.class == "ResourceStockpile" then
		a:SetColorModifier(red)
	elseif a.class == "WasteRockStockpile" then
		a:SetColorModifier(green)
	elseif a.class == "LampInt_03" then
		a:SetColorModifier(red)
	end
end
local function SpawnedMoholeMine(s)
	GRGR(s)
	s:ForEachAttach(AttachesMoholeMine)
end

local function AttachesSpaceElevator(a)
	if a.class:find("SpaceElevatorDoor") then
		a:SetColor2(red)
	elseif a.class == "LampWallInner_01" then
		a:SetColorModifier(red)
	elseif a.class == "SpaceElevatorLights" then
		a:SetColorModifier(red)
	end
end
local function SpawnedSpaceElevator(s)
	RGRG(s)
	s.pod:SetColor1(green)
	s.pod:SetColor2(red)
	s.pod:SetColor4(green)
	s:ForEachAttach(AttachesSpaceElevator)
end

local function AttachesElectronicsFactory(a)
	if a.class:find("ElectronicsFactoryFloorDoor") then
		a:SetColorModifier(red)
	elseif a.class == "ResourceStockpile" or a.class == "ConsumptionResourceStockpile" then
		a:SetColorModifier(red)
	elseif a.class == "DecorInt_03" then
		a:SetColorModifier(red)
	elseif a.class == "DecorInt_02" then
		a:SetColorModifier(red)
	elseif a.class == "LampInt_02" then
		a:SetColorModifier(red)
	elseif a.class == "ElectronicsFactoryElevator_01" then
		a:SetColor1(red)
		a:SetColor3(green)
	elseif a.class == "ElectronicsFactoryElevator_02" then
		a:SetColor1(green)
		a:SetColor3(red)
	end
end
local function SpawnedElectronicsFactory(s)
	-- don't set 4
	s:SetColor1(green)
	s:SetColor2(red)
	s:SetColor3(green)
	s:ForEachAttach(AttachesElectronicsFactory)
end

local function AttachesMachinePartsFactory(a)
	if a.class:find("DecMachinePartsFactoryBase") then
		a:SetColorModifier(green)
	elseif a.class == "ResourceStockpile" or a.class == "ConsumptionResourceStockpile" then
		a:SetColorModifier(red)
	elseif a.class == "LampInt_05" then
		a:SetColorModifier(red)
	elseif a.class == "MachinePartsFactoryDoor" then
		a:SetColor1(red)
		a:SetColor2(green)
	end
end
local function SpawnedMachinePartsFactory(s)
	GRGR(s)
	s:ForEachAttach(AttachesMachinePartsFactory)
end

local function AttachesFuelFactory(a)
	if a.class == "ResourceStockpile" or a.class == "WasteRockStockpile" then
		a:SetColorModifier(green)
	elseif a.class == "LampWallInner_01" then
		a:SetColorModifier(green)
	end
end
local function SpawnedFuelFactory(s)
	s:SetColor1(green)
	s:SetColor2(red)
	s:SetColor3(red)
	s:SetColor4(red)
	s:ForEachAttach(AttachesFuelFactory)
end

local function AttachesDroneFactory(a)
	if a.class == "WorkshopDoor_01" then
		a:SetColor1(green)
		a:SetColor2(red)
	elseif a.class == "WorkshopDoor_02" then
		a:SetColor1(red)
		a:SetColor2(green)
	elseif a.class == "WorkshopDoor_03" then
		a:SetColor3(red)
	end
end
local function SpawnedDroneFactory(s)
	GRGR(s)
	s:ForEachAttach(AttachesDroneFactory)
end

local function RegolithExtractor(a)
	if a.class == "ResourceStockpile" then
		a:SetColorModifier(red)
	elseif a.class == "WasteRockStockpile" then
		a:SetColorModifier(green)
	elseif a.class == "LampWallOuter_01" then
		a:SetColorModifier(red)
	end
end
local function SpawnedRegolithExtractor(s)
	GRGR(s)
	s.anim_obj.digger:SetColor1(white)
	s.anim_obj.digger:SetColor2(green)
	s.anim_obj.digger:SetColor4(red)

	s.anim_obj.ring:SetColor2(red)
	s.anim_obj.ring:SetColor4(green)
	s.anim_obj.rope1:SetColorModifier(green)
	s.anim_obj.rope2:SetColorModifier(green)
	s:ForEachAttach(RegolithExtractor)
end

local function AttachesMetalsExtractor(a)
	if a.class == "ResourceStockpile" or a.class == "WasteRockStockpile" then
		a:SetColorModifier(green)
	elseif a.class == "MetalsExtractorElevator" then
		a:SetColor1(green)
		a:SetColor2(green)
		a:SetColor3(red)
		a:SetColor4(red)
	elseif a.class == "LampGroundOuter_01" then
		a:SetColorModifier(red)
	end
end
local function SpawnedMetalsExtractor(s)
	s:SetColor1(red)
	s:SetColor2(green)
	s:SetColor3(red)
	s:ForEachAttach(AttachesMetalsExtractor)
end

local function AttachesPreciousMetalsExtractor(a)
	if a.class == "ResourceStockpile" or a.class == "WasteRockStockpile" then
		a:SetColorModifier(green)
	elseif a.class == "LampGroundOuter_01" then
		a:SetColorModifier(red)
	elseif a.class == "UniversalExtractorDoor" then
		a:SetColor1(green)
		a:SetColor2(red)
		a:SetColor3(green)
	elseif a.class == "UniversalExtractorHammer" then
		a:SetColor1(green)
		a:SetColor2(red)
	end
end
local function SpawnedPreciousMetalsExtractor(s)
	GRGR(s)
	s:ForEachAttach(AttachesPreciousMetalsExtractor)
end

local function AttachesPolymerPlant(a)
	if a.class == "ResourceStockpile" then
		a:SetColorModifier(green)
	elseif a.class == "PolymerPlantDoor" then
		a:SetColor1(green)
	end
end
local function SpawnedPolymerPlant(s)
	GRGR(s)
	s:ForEachAttach(AttachesPolymerPlant)
end

local function AttachesFungalFarm(a)
	if a.class == "ResourceStockpile" then
		a:SetColorModifier(red)
	elseif a.class == "FungalFarmFan" then
		a:SetColor3(red)
	elseif a.class == "FungalFarmDoor" or a.class == "FungalFarmFloorDoor" then
		a:SetColor1(red)
		a:SetColor2(green)
		a:SetColor3(red)
	end
end
local function SpawnedFungalFarm(s)
	GRGR(s)
	s:ForEachAttach(AttachesFungalFarm)
end

local function SpawnedWaterTank(s)
	GRGR(s)
	AttachColour(s, "WaterTankFloat", green)
end

local function AttachesWaterExtractor(a)
	if a.class == "LampGroundOuter_01" then
		a:SetColorModifier(red)
	elseif a.class == "WasteRockStockpile" then
		a:SetColorModifier(green)
	elseif a.class == "WaterExtractorPump" then
		a:SetColor1(red)
		a:SetColor2(green)
		a:SetColor3(green)
	end
end
local function SpawnedWaterExtractor(s)
	GRGR(s)
	s:ForEachAttach(AttachesWaterExtractor)
end

local function AttachesMoistureVaporator(a)
	if a.class == "MoistureVaporatorBalloon" then
		a:SetColor1(red)
	end
end
local function SpawnedMoistureVaporator(s)
	GRGR(s)
	s:ForEachAttach(AttachesMoistureVaporator)
end

local function SpawnedOxygenTank(s)
	GRGR(s)
	AttachColour(s, "AirTankArrow", red)
end

local function AttachesMOXIE(a)
	if a.class == "MoxiePump" then
		a:SetColor2(red)
		a:SetColor3(green)
	end
end
local function SpawnedMOXIE(s)
	GRGR(s)
	s:ForEachAttach(AttachesMOXIE)
end

local function AttachesFusionReactor(a)
	if a.class:find("FusionReactorDoor") then
		a:SetColor2(red)
	end
end
local function SpawnedFusionReactor(s)
	GRGR(s)
	s:ForEachAttach(AttachesFusionReactor)
end

local function SpawnedSolarPanel(s)
	GRGR(s)
	s.panel_obj:SetColor1(green)
	s.panel_obj:SetColor2(red)
	s.panel_obj:SetColor3(green)
end

local function SpawnedTriboelectricScrubber(s)
	RGRG(s)
	s.sphere:SetColor1(green)
	s.sphere:SetColor2(red)
	s.sphere:SetColor3(green)
end

local function SpawnedShuttleHub(s)
	GRGR(s)
	s.consumption_resource_stockpile:SetColorModifier(green)
end

local function AttachesDroneHub(a)
	if a.class == "CableHardLeft" then
		a:SetColor3(green)
	elseif a.class == "LampWallOuter_01" then
		a:SetColorModifier(green)
	elseif a.class == "DroneHubDoor" then
		a:SetColor1(green)
		a:SetColor2(red)
	elseif a.class == "CablePlug_01" then
		a:SetColorModifier(red)
	elseif a.class == "DroneHubAntenna" then
		a:SetColor1(green)
		a:SetColor2(red)
	elseif a.class == "RechargeStationPlatform" then
		a:SetColor1(red)
		a:SetColor2(green)
		a:SetColor3(red)
	end
end
local function SpawnedDroneHub(s)
	GRGR(s)
	s:ForEachAttach(AttachesDroneHub)
end

local function SpawnedRechargeStation(s)
	s.platform:SetColor1(red)
	s.platform:SetColor2(green)
	s.platform:SetColor3(red)
end

local function SpawnedLandingPad(s)
	AttachColour(s, "LampInt_04", green)
	AttachColour(s, "LampInt_05", red)
end

local function SpawnedTunnel(s)
	GRGR(s)
	AttachColour(s, "TunnelEntranceDoor", green)
end

local function AttachesSupplyRocket(a)
	if a.class == "LampWallInner_01" then
		a:SetColorModifier(green)
	end
end
local function SpawnedSupplyRocket(s)
	GRGR(s)
	s:ForEachAttach(AttachesSupplyRocket)
end

local function SpawnedMDSLaser(s)
	s.tube:SetColor1(green)
	s.tube:SetColor2(red)
	s.tube:SetColor3(green)
	s.platform:SetColor2(green)
end

local function SpawnedDefenceTower(s)
	GRGR(s)
	s.platform:SetColor2(green)
	s.tube:SetColor1(green)
	s.tube:SetColor2(red)
	s.tube:SetColor3(red)
end

local function AttachesPlayground(a)
	if a.class == "DecPlaygroundBase" then
		a:SetColorModifier(green)
	elseif a.class == "DecorInt_04" then
		a:SetColorModifier(red)
	end
end
local function SpawnedPlayground(s)
	GRGR(s)
	s:ForEachAttach(AttachesPlayground)
end

-- list of functions to call
local object_list = {
	Arcology = SpawnedArcology,
	ArtificialSun = SpawnedArtificialSun,
	CloningVats = SpawnedCloningVats,
	DefenceTower = SpawnedDefenceTower,
	DroneFactory = SpawnedDroneFactory,
	DroneHub = SpawnedDroneHub,
	ElectronicsFactory = SpawnedElectronicsFactory,
	FarmConventional = SpawnedFarmConventional,
	FarmHydroponic = SpawnedFarmHydroponic,
	FuelFactory = SpawnedFuelFactory,
	FungalFarm = SpawnedFungalFarm,
	FusionReactor = SpawnedFusionReactor,
	HangingGardens = SpawnedHangingGardens,
	LandingPad = SpawnedLandingPad,
	MachinePartsFactory = SpawnedMachinePartsFactory,
	MDSLaser = SpawnedMDSLaser,
	MedicalCenter = SpawnedMedicalCenter,
	MetalsExtractor = SpawnedMetalsExtractor,
	MoholeMine = SpawnedMoholeMine,
	MoistureVaporator = SpawnedMoistureVaporator,
	MOXIE = SpawnedMOXIE,
	NetworkNode = SpawnedNetworkNode,
	OmegaTelescope = SpawnedOmegaTelescope,
	OxygenTank = SpawnedOxygenTank,
	PassageRamp = SpawnedPassageRamp,
	Playground = SpawnedPlayground,
	PolymerPlant = SpawnedPolymerPlant,
	PreciousMetalsExtractor = SpawnedPreciousMetalsExtractor,
	ProjectMorpheus = SpawnedProjectMorpheus,
	RechargeStation = SpawnedRechargeStation,
	RegolithExtractor = SpawnedRegolithExtractor,
	Sanatorium = SpawnedSanatorium,
	ShuttleHub = SpawnedShuttleHub,
	SolarPanel = SpawnedSolarPanel,
	SpaceElevator = SpawnedSpaceElevator,
	SupplyRocket = SpawnedSupplyRocket,
	TheExcavator = SpawnedTheExcavator,
	TriboelectricScrubber = SpawnedTriboelectricScrubber,
	Tunnel = SpawnedTunnel,
	WaterExtractor = SpawnedWaterExtractor,
	WaterReclamationSpire = SpawnedWaterReclamationSpire,
	WaterTank = SpawnedWaterTank,
	WaterTankLarge = SpawnedWaterTankLarge,
}
function OnMsg.ChristmasMars_SpawnedBuilding(s, cls)
	object_list[cls](s)
end
