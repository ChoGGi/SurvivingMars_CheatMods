-- See LICENSE for terms

local that_time_of_the_year = GetDate():find("Dec")

-- copy n paste from ChoGGi.ComFuncs.LoadEntity
do -- LoadEntity
	-- no sense in making a new one for each entity
	local entity_templates = {
		decal = {
			category_Decors = true,
			entity = {
				fade_category = "Never",
				material_type = "Metal",
			},
		},
		building = {
			category_Buildings = true,
			entity = {
				class_parent = "BuildingEntityClass",
				fade_category = "Never",
				material_type = "Metal",
			},
		},
	}

	-- local instead of global is quicker
	local EntityData = EntityData
	local EntityLoadEntities = EntityLoadEntities
	local SetEntityFadeDistances = SetEntityFadeDistances

	local function LoadEntity(name, path, mod, template)
		EntityData[name] = entity_templates[template or "decal"]

		EntityLoadEntities[#EntityLoadEntities + 1] = {
			mod,
			name,
			path
		}
		SetEntityFadeDistances(name, -1, -1)
	end

	LoadEntity(
		"ChristmasMars",
		CurrentModPath .. "Entities/ChristmasMars.ent",
		CurrentModDef
	)
end -- LoadEntity

function OnMsg.ClassesPostprocess()
	if not MissionLogoPresetMap.ChristmasMars then
		PlaceObj("MissionLogoPreset", {
			decal_entity = "ChristmasMars",
			display_name = T(0, "Christmas Mars"),
			entity_name = "ChristmasMars",
			id = "ChristmasMars",
			image = CurrentModPath .. "UI/ChristmasMars.png",
		})
	end
	-- default logo during spending month
	if that_time_of_the_year then
		-- sugar... corn syrup water ftw
		g_CurrentMissionParams.idMissionLogo = "ChristmasMars"
	end
end

-- on to the good stuff
if not that_time_of_the_year then
	-- or not
	return
end

local green = -16711936
local red = -65536
local white = -1

-- we can't use CityStart since deposits aren't spawned yet and SetTerrainType screws that up
function OnMsg.CityStart()
	CreateRealTimeThread(function()
		WaitMsg("DepositsSpawned")

		UICity.ChristmasMars = true

		-- less brown rocks
		SuspendPassEdits("ChoGGi.ChristmasMars.CityStart")
		MapForEach("map", {"Deposition", "WasteRockObstructorSmall", "WasteRockObstructor", "StoneSmall"}, function(o)
			if o.class:find("Dark") then
				o:SetColorModifier(white)
			else
				-- these ones don't look good like this so buhbye
				o:delete()
			end
		end)

		-- starter rockets spawn with new map
		local rockets = UICity.labels.SupplyRocket or ""
		for i = 1, #rockets do
			local s = rockets[i]
			s:SetColor1(green)
			s:SetColor2(red)
			s:SetColor3(green)

			s:ForEachAttach(function(a)
				if a.class == "LampWallInner_01" then
					a:SetColorModifier(green)
				end
			end)
		end

		local TerrainTextures = TerrainTextures

		-- polar map texture
		local polar_idx = table.find(TerrainTextures, "name", "Polar_01")
		terrain.SetTerrainType{type = polar_idx}

		-- add back dome grass
		local domes = UICity.labels.Dome or ""
		for i = 1, #domes do
			domes[i]:ChangeSkin(domes[i]:GetCurrentSkin())
		end

		-- re-paint concrete
		local GridOpFree = GridOpFree
		local AsyncSetTypeGrid = AsyncSetTypeGrid
		local MulDivRound = MulDivRound
		local sqrt = sqrt
		local guim = guim

		-- re-build concrete textures (if any are visible)
		local texture_idx1 = table.find(TerrainTextures, "name", "Regolith") + 1
		local texture_idx2 = table.find(TerrainTextures, "name", "Regolith_02") + 1
		local deposits = UICity.labels.TerrainDeposit or ""
		local NoisePreset = DataInstances.NoisePreset

		for i = 1, #deposits do
			local d = deposits[i]
			local pattern = NoisePreset.ConcreteForm:GetNoise(128, AsyncRand())
			pattern:land_i(NoisePreset.ConcreteNoise:GetNoise(128, AsyncRand()))
			-- any over 1000 get the more noticeable texture
			if d.max_amount > 1000000 then
				pattern:mul_i(texture_idx2, 1)
			else
				pattern:mul_i(texture_idx1, 1)
			end
			-- blend in with surrounding ground
			pattern:sub_i(1, 1)
			-- ?
			pattern = GridOpFree(pattern, "repack", 8)
			-- paint deposit
			AsyncSetTypeGrid{
				type_grid = pattern,
				pos = d:GetPos(),
				scale = sqrt(MulDivRound(10000, d.max_amount / guim, d.radius_max)),
				centered = true,
				invalid_type = -1,
			}
		end
		ResumePassEdits("ChoGGi.ChristmasMars.CityStart")

	end)
end -- OnMsg

local DelayedCall = DelayedCall
local Msg = Msg

-- backup orginal function for later use (checks if we already have a backup, or else problems)
local OrigFuncs = {}

local function SendMsg(msg_name, obj, cls_name)
	Msg(msg_name, obj, cls_name)
end
local function AddMsgToFunc(cls_name, msg_name)
	local name = cls_name .. "_GameInit"
	if not OrigFuncs[name] then
		-- save orig
		OrigFuncs[name] = _G[cls_name].GameInit
		-- redefine it
		_G[cls_name].GameInit = function(obj, ...)
			-- only change colour if it's a game started in Dec
			if UICity.ChristmasMars then
				DelayedCall(1, SendMsg, msg_name, obj, cls_name)
			end
			return OrigFuncs[name](obj, ...)
		end
	end
end

AddMsgToFunc("CargoShuttle", "ChristmasMars_DefaultColourGRWG")
AddMsgToFunc("RCTransport", "ChristmasMars_DefaultColourGRWG")
AddMsgToFunc("RCRover", "ChristmasMars_DefaultColourGRWG")
AddMsgToFunc("ExplorerRover", "ChristmasMars_DefaultColourGRWG")
AddMsgToFunc("PowerDecoy", "ChristmasMars_DefaultColourGRWG")
AddMsgToFunc("LightTrap", "ChristmasMars_DefaultColourGRWG")
AddMsgToFunc("SubsurfaceHeater", "ChristmasMars_DefaultColourGRWG")

function OnMsg.ChristmasMars_DefaultColourGRWG(s)
	s:SetColor1(green)
	s:SetColor2(red)
	s:SetColor3(white)
	if not s.class == "ExplorerRover" then
		s:SetColor4(red)
	end
end

AddMsgToFunc("StirlingGenerator", "ChristmasMars_DefaultColourGRGR")
AddMsgToFunc("WindTurbine", "ChristmasMars_DefaultColourGRGR")
AddMsgToFunc("SensorTower", "ChristmasMars_DefaultColourGRGR")
AddMsgToFunc("ElectricityStorage", "ChristmasMars_DefaultColourGRGR")

AddMsgToFunc("Apartments", "ChristmasMars_DefaultColourGRGR")
AddMsgToFunc("Spacebar", "ChristmasMars_DefaultColourGRGR")
AddMsgToFunc("Diner", "ChristmasMars_DefaultColourGRGR")
AddMsgToFunc("Infirmary", "ChristmasMars_DefaultColourGRGR")
AddMsgToFunc("CasinoComplex", "ChristmasMars_DefaultColourGRGR")
AddMsgToFunc("Grocery", "ChristmasMars_DefaultColourGRGR")
AddMsgToFunc("SecurityStation", "ChristmasMars_DefaultColourGRGR")

function OnMsg.ChristmasMars_DefaultColourGRGR(s)
	s:SetColor1(green)
	s:SetColor2(red)
	s:SetColor3(green)
	s:SetColor4(red)
end

AddMsgToFunc("ServiceWorkplace", "ChristmasMars_DefaultColourRGRG")
AddMsgToFunc("Nursery", "ChristmasMars_DefaultColourRGRG")
AddMsgToFunc("ArtWorkshop", "ChristmasMars_DefaultColourRGRG")
AddMsgToFunc("BioroboticsWorkshop", "ChristmasMars_DefaultColourRGRG")
AddMsgToFunc("School", "ChristmasMars_DefaultColourRGRG")
AddMsgToFunc("VRWorkshop", "ChristmasMars_DefaultColourRGRG")
AddMsgToFunc("MartianUniversity", "ChristmasMars_DefaultColourRGRG")
AddMsgToFunc("BaseResearchLab", "ChristmasMars_DefaultColourRGRG")

function OnMsg.ChristmasMars_DefaultColourRGRG(s)
	s:SetColor1(red)
	s:SetColor2(green)
	s:SetColor3(red)
	s:SetColor4(green)
end

--~ AddMsgToFunc("DefenceTower", "ChristmasMars_SpawnedDefenceTower")
--~ AddMsgToFunc("MDSLaser", "ChristmasMars_SpawnedMDSLaser")
--~ AddMsgToFunc("SupplyRocket", "ChristmasMars_SpawnedSupplyRocket")
--~ AddMsgToFunc("Tunnel", "ChristmasMars_SpawnedTunnel")
--~ AddMsgToFunc("LandingPad", "ChristmasMars_SpawnedLandingPad")
--~ AddMsgToFunc("RechargeStation", "ChristmasMars_SpawnedRechargeStation")
--~ AddMsgToFunc("DroneHub", "ChristmasMars_SpawnedDroneHub")
--~ AddMsgToFunc("ShuttleHub", "ChristmasMars_SpawnedShuttleHub")
--~ AddMsgToFunc("TriboelectricScrubber", "ChristmasMars_SpawnedTriboelectricScrubber")
--~ AddMsgToFunc("SolarPanel", "ChristmasMars_SpawnedSolarPanel")
--~ AddMsgToFunc("FusionReactor", "ChristmasMars_SpawnedFusionReactor")
--~ AddMsgToFunc("MOXIE", "ChristmasMars_SpawnedMOXIE")
--~ AddMsgToFunc("OxygenTank", "ChristmasMars_SpawnedOxygenTank")
--~ AddMsgToFunc("MoistureVaporator", "ChristmasMars_SpawnedMoistureVaporator")
--~ AddMsgToFunc("WaterExtractor", "ChristmasMars_SpawnedWaterExtractor")
--~ AddMsgToFunc("WaterTank", "ChristmasMars_SpawnedWaterTank")
--~ AddMsgToFunc("FungalFarm", "ChristmasMars_SpawnedFungalFarm")
--~ AddMsgToFunc("PolymerPlant", "ChristmasMars_SpawnedPolymerPlant")
--~ AddMsgToFunc("PreciousMetalsExtractor", "ChristmasMars_SpawnedPreciousMetalsExtractor")
--~ AddMsgToFunc("MetalsExtractor", "ChristmasMars_SpawnedMetalsExtractor")
--~ AddMsgToFunc("RegolithExtractor", "ChristmasMars_SpawnedRegolithExtractor")
--~ AddMsgToFunc("DroneFactory", "ChristmasMars_SpawnedDroneFactory")
--~ AddMsgToFunc("FuelFactory", "ChristmasMars_SpawnedFuelFactory")
--~ AddMsgToFunc("MachinePartsFactory", "ChristmasMars_SpawnedMachinePartsFactory")
--~ AddMsgToFunc("ElectronicsFactory", "ChristmasMars_SpawnedElectronicsFactory")
--~ AddMsgToFunc("SpaceElevator", "ChristmasMars_SpawnedSpaceElevator")
--~ AddMsgToFunc("MoholeMine", "ChristmasMars_SpawnedMoholeMine")
--~ AddMsgToFunc("OmegaTelescope", "ChristmasMars_SpawnedOmegaTelescope")
--~ AddMsgToFunc("ArtificialSun", "ChristmasMars_SpawnedArtificialSun")
--~ AddMsgToFunc("ProjectMorpheus", "ChristmasMars_SpawnedProjectMorpheus")
--~ AddMsgToFunc("TheExcavator", "ChristmasMars_SpawnedTheExcavator")
--~ AddMsgToFunc("FarmHydroponic", "ChristmasMars_SpawnedFarmHydroponic")
--~ AddMsgToFunc("WaterTankLarge", "ChristmasMars_SpawnedWaterTankLarge")
--~ AddMsgToFunc("FarmConventional", "ChristmasMars_SpawnedFarmConventional")
--~ AddMsgToFunc("WaterReclamationSpire", "ChristmasMars_SpawnedWaterReclamationSpire")
--~ AddMsgToFunc("CloningVats", "ChristmasMars_SpawnedCloningVats")
--~ AddMsgToFunc("NetworkNode", "ChristmasMars_SpawnedNetworkNode")
--~ AddMsgToFunc("MedicalCenter", "ChristmasMars_SpawnedMedicalCenter")
--~ AddMsgToFunc("Sanatorium", "ChristmasMars_SpawnedSanatorium")
--~ AddMsgToFunc("Arcology", "ChristmasMars_SpawnedArcology")
--~ AddMsgToFunc("HangingGardens", "ChristmasMars_SpawnedHangingGardens")
--~ AddMsgToFunc("PassageRamp", "ChristmasMars_SpawnedPassageRamp")
--~ AddMsgToFunc("Playground", "ChristmasMars_SpawnedPlayground")
AddMsgToFunc("DefenceTower", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("MDSLaser", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("SupplyRocket", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("Tunnel", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("LandingPad", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("RechargeStation", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("DroneHub", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("ShuttleHub", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("TriboelectricScrubber", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("SolarPanel", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("FusionReactor", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("MOXIE", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("OxygenTank", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("MoistureVaporator", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("WaterExtractor", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("WaterTank", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("FungalFarm", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("PolymerPlant", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("PreciousMetalsExtractor", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("MetalsExtractor", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("RegolithExtractor", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("DroneFactory", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("FuelFactory", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("MachinePartsFactory", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("ElectronicsFactory", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("SpaceElevator", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("MoholeMine", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("OmegaTelescope", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("ArtificialSun", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("ProjectMorpheus", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("TheExcavator", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("FarmHydroponic", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("WaterTankLarge", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("FarmConventional", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("WaterReclamationSpire", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("CloningVats", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("NetworkNode", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("MedicalCenter", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("Sanatorium", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("Arcology", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("HangingGardens", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("PassageRamp", "ChristmasMars_SpawnedBuilding")
AddMsgToFunc("Playground", "ChristmasMars_SpawnedBuilding")
