local that_time_of_the_year = GetDate():find("Dec")

-- we always add the logo
pcall(function()
	-- needs to happen before the decal object is placed
	DelayedLoadEntity(Mods.ChoGGi_ChristmasMars, "ChristmasMars", string.format("%sEntities/ChristmasMars.ent",CurrentModPath))

	PlaceObj("Decal", {
		"name", "ChristmasMars",
		"entity_name", "ChristmasMars",
	})
end)
function OnMsg.ClassesPostprocess()
	PlaceObj("MissionLogoPreset", {
		decal_entity = "ChristmasMars",
		display_name = "Christmas Mars",
		entity_name = "ChristmasMars",
		id = "ChristmasMars",
		image = string.format("%sUI/logo.png",CurrentModPath),
	})
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

-- we can't use CityStart since deposits aren't spawned yet and SetTerrainType fucks that up
function OnMsg.DepositsSpawned()
--~ function OnMsg.LoadGame()

	UICity.ChristmasMars = true

	-- less brown rocks
	local function WhiteThoseRocks(cls)
		MapForEach("map",cls,function(o)
			if o.class:find("Dark") then
				o:SetColorModifier(white)
			-- skip delete StoneSmall since it takes too damned long
			elseif not cls ~= "StoneSmall" then
				-- these ones don't look good like this so buhbye
				o:delete()
			end
		end)
	end
	WhiteThoseRocks("Deposition")
	WhiteThoseRocks("WasteRockObstructorSmall")
	WhiteThoseRocks("WasteRockObstructor")
	WhiteThoseRocks("StoneSmall")

	-- starter rockets spawn with new map
	local rockets = UICity.labels.AllRockets or ""
	for i = 1, #rockets do
		local s = rockets[i]
		s:SetColor1(green)
		s:SetColor2(red)
		s:SetColor3(green)

		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			if attaches[i].class == "LampWallInner_01" then
				attaches[i]:SetColorModifier(green)
			end
		end
	end

	-- polar map texture
	terrain.SetTerrainType{type = 34}

	-- re-paint concrete
	local new_texture = 24
	local SetTypeCircle = terrain.SetTypeCircle
	local GetHeight = terrain.GetHeight
	local TerrainDeposit_Decode = TerrainDeposit_Decode
	local point = point
	local grid_spacing = const.GridSpacing/2
	local TerrainDepositsInfo = TerrainDepositsInfo
	local guim = guim

	local gpts = HexGridWorldValues(TerrainDepositGrid, true)
	if #gpts == 0 then
		return
	end
	local mx, my, data = gpts[1]:xyz()
	local gtype, gvol = TerrainDeposit_Decode(data)
	local gmin, gmax = gvol, gvol
	for i = 2, #gpts do
		mx, my, data = gpts[i]:xyz()
		gtype, gvol = TerrainDeposit_Decode(data)
		if gvol < gmin then gmin = gvol
		elseif gvol > gmax then gmax = gvol
		end
	end
	if gmax <= gmin then
		return
	end
	for i = 1, #gpts do
		mx, my, data = gpts[i]:xyz()
		gtype, gvol = TerrainDeposit_Decode(data)
		local info = TerrainDepositsInfo[gtype]
		local dv = gvol - gmin
		if dv > 0 and info then
			SetTypeCircle(point(mx, my, GetHeight(mx, my) + guim), grid_spacing, new_texture)
		end
	end

end -- OnMsg.DepositsSpawned()

-- backup orginal function for later use (checks if we already have a backup, or else problems)
local Msg = Msg
local select = select
local OrigFuncs = {}
local function AddMsgToFunc(ClassName,FuncName,sMsg)
	local name = string.format("%s_%s",ClassName,FuncName)
	if not OrigFuncs[name] then
		-- save orig
		OrigFuncs[name] = _G[ClassName][FuncName]
		-- redefine it
		_G[ClassName][FuncName] = function(...)
			-- only change vehicle colour if it's a new game started in Dec
			if UICity.ChristmasMars then
				-- I just care about adding self to the msgs
				Msg(sMsg,select(1,...))
			end
			return OrigFuncs[name](...)
		end
	end
end

local DelayedCall = DelayedCall

AddMsgToFunc("CargoShuttle","GameInit","ChristmasMars_DefaultColourGRWG")
AddMsgToFunc("RCTransport","GameInit","ChristmasMars_DefaultColourGRWG")
AddMsgToFunc("RCRover","GameInit","ChristmasMars_DefaultColourGRWG")
AddMsgToFunc("ExplorerRover","GameInit","ChristmasMars_DefaultColourGRWG")
AddMsgToFunc("PowerDecoy","GameInit","ChristmasMars_DefaultColourGRWG")
AddMsgToFunc("LightTrap","GameInit","ChristmasMars_DefaultColourGRWG")
AddMsgToFunc("SubsurfaceHeater","GameInit","ChristmasMars_DefaultColourGRWG")

function OnMsg.ChristmasMars_DefaultColourGRWG(s)
	DelayedCall(1, function()
		s:SetColor1(green)
		s:SetColor2(red)
		s:SetColor3(white)
		if not s.class == "ExplorerRover" then
			s:SetColor4(red)
		end
	end)
end

AddMsgToFunc("StirlingGenerator","GameInit","ChristmasMars_DefaultColourGRGR")
AddMsgToFunc("WindTurbine","GameInit","ChristmasMars_DefaultColourGRGR")
AddMsgToFunc("SensorTower","GameInit","ChristmasMars_DefaultColourGRGR")
AddMsgToFunc("ElectricityStorage","GameInit","ChristmasMars_DefaultColourGRGR")

AddMsgToFunc("Apartments","GameInit","ChristmasMars_DefaultColourGRGR")
AddMsgToFunc("Spacebar","GameInit","ChristmasMars_DefaultColourGRGR")
AddMsgToFunc("Diner","GameInit","ChristmasMars_DefaultColourGRGR")
AddMsgToFunc("Infirmary","GameInit","ChristmasMars_DefaultColourGRGR")
AddMsgToFunc("CasinoComplex","GameInit","ChristmasMars_DefaultColourGRGR")
AddMsgToFunc("Grocery","GameInit","ChristmasMars_DefaultColourGRGR")
AddMsgToFunc("SecurityStation","GameInit","ChristmasMars_DefaultColourGRGR")

function OnMsg.ChristmasMars_DefaultColourGRGR(s)
	DelayedCall(1, function()
		s:SetColor1(green)
		s:SetColor2(red)
		s:SetColor3(green)
		s:SetColor4(red)
	end)
end

AddMsgToFunc("ServiceWorkplace","GameInit","ChristmasMars_DefaultColourRGRG")
AddMsgToFunc("Nursery","GameInit","ChristmasMars_DefaultColourRGRG")
AddMsgToFunc("ArtWorkshop","GameInit","ChristmasMars_DefaultColourRGRG")
AddMsgToFunc("BioroboticsWorkshop","GameInit","ChristmasMars_DefaultColourRGRG")
AddMsgToFunc("School","GameInit","ChristmasMars_DefaultColourRGRG")
AddMsgToFunc("VRWorkshop","GameInit","ChristmasMars_DefaultColourRGRG")
AddMsgToFunc("MartianUniversity","GameInit","ChristmasMars_DefaultColourRGRG")
AddMsgToFunc("BaseResearchLab","GameInit","ChristmasMars_DefaultColourRGRG")

function OnMsg.ChristmasMars_DefaultColourRGRG(s)
	DelayedCall(1, function()
		s:SetColor1(red)
		s:SetColor2(green)
		s:SetColor3(red)
		s:SetColor4(green)
	end)
end

AddMsgToFunc("DefenceTower","GameInit","ChristmasMars_SpawnedDefenceTower")
AddMsgToFunc("MDSLaser","GameInit","ChristmasMars_SpawnedMDSLaser")
AddMsgToFunc("SupplyRocket","GameInit","ChristmasMars_SpawnedSupplyRocket")
AddMsgToFunc("Tunnel","GameInit","ChristmasMars_SpawnedTunnel")
AddMsgToFunc("LandingPad","GameInit","ChristmasMars_SpawnedLandingPad")
AddMsgToFunc("RechargeStation","GameInit","ChristmasMars_SpawnedRechargeStation")
AddMsgToFunc("DroneHub","GameInit","ChristmasMars_SpawnedDroneHub")
AddMsgToFunc("ShuttleHub","GameInit","ChristmasMars_SpawnedShuttleHub")
AddMsgToFunc("TriboelectricScrubber","GameInit","ChristmasMars_SpawnedTriboelectricScrubber")
AddMsgToFunc("SolarPanel","GameInit","ChristmasMars_SpawnedSolarPanel")
AddMsgToFunc("FusionReactor","GameInit","ChristmasMars_SpawnedFusionReactor")
--~ AddMsgToFunc("LifeSupportGridElement","GameInit","ChristmasMars_SpawnedLifeSupportGridElement")
--~ AddMsgToFunc("ElectricityGridElement","GameInit","ChristmasMars_SpawnedElectricityGridElement")
AddMsgToFunc("MOXIE","GameInit","ChristmasMars_SpawnedMOXIE")
AddMsgToFunc("OxygenTank","GameInit","ChristmasMars_SpawnedOxygenTank")
AddMsgToFunc("MoistureVaporator","GameInit","ChristmasMars_SpawnedMoistureVaporator")
AddMsgToFunc("WaterExtractor","GameInit","ChristmasMars_SpawnedWaterExtractor")
AddMsgToFunc("WaterTank","GameInit","ChristmasMars_SpawnedWaterTank")
AddMsgToFunc("FungalFarm","GameInit","ChristmasMars_SpawnedFungalFarm")
AddMsgToFunc("PolymerPlant","GameInit","ChristmasMars_SpawnedPolymerPlant")
AddMsgToFunc("PreciousMetalsExtractor","GameInit","ChristmasMars_SpawnedPreciousMetalsExtractor")
AddMsgToFunc("MetalsExtractor","GameInit","ChristmasMars_SpawnedMetalsExtractor")
AddMsgToFunc("RegolithExtractor","GameInit","ChristmasMars_SpawnedRegolithExtractor")
AddMsgToFunc("DroneFactory","GameInit","ChristmasMars_SpawnedDroneFactory")
AddMsgToFunc("FuelFactory","GameInit","ChristmasMars_SpawnedFuelFactory")
AddMsgToFunc("MachinePartsFactory","GameInit","ChristmasMars_SpawnedMachinePartsFactory")
AddMsgToFunc("ElectronicsFactory","GameInit","ChristmasMars_SpawnedElectronicsFactory")
AddMsgToFunc("SpaceElevator","GameInit","ChristmasMars_SpawnedSpaceElevator")
AddMsgToFunc("MoholeMine","GameInit","ChristmasMars_SpawnedMoholeMine")
AddMsgToFunc("OmegaTelescope","GameInit","ChristmasMars_SpawnedOmegaTelescope")
AddMsgToFunc("ArtificialSun","GameInit","ChristmasMars_SpawnedArtificialSun")
AddMsgToFunc("ProjectMorpheus","GameInit","ChristmasMars_SpawnedProjectMorpheus")
AddMsgToFunc("TheExcavator","GameInit","ChristmasMars_SpawnedTheExcavator")
AddMsgToFunc("FarmHydroponic","GameInit","ChristmasMars_SpawnedFarmHydroponic")
AddMsgToFunc("WaterTankLarge","GameInit","ChristmasMars_SpawnedWaterTankLarge")
AddMsgToFunc("FarmConventional","GameInit","ChristmasMars_SpawnedFarmConventional")
AddMsgToFunc("WaterReclamationSpire","GameInit","ChristmasMars_SpawnedWaterReclamationSpire")
AddMsgToFunc("CloningVats","GameInit","ChristmasMars_SpawnedCloningVats")
AddMsgToFunc("NetworkNode","GameInit","ChristmasMars_SpawnedNetworkNode")
AddMsgToFunc("MedicalCenter","GameInit","ChristmasMars_SpawnedMedicalCenter")
AddMsgToFunc("Sanatorium","GameInit","ChristmasMars_SpawnedSanatorium")
AddMsgToFunc("Arcology","GameInit","ChristmasMars_SpawnedArcology")
AddMsgToFunc("HangingGardens","GameInit","ChristmasMars_SpawnedHangingGardens")
AddMsgToFunc("PassageRamp","GameInit","ChristmasMars_SpawnedPassageRamp")
AddMsgToFunc("Playground","GameInit","ChristmasMars_SpawnedPlayground")
