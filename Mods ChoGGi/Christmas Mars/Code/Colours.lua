if not GetDate():find("Dec") then
	return
end

local OnMsg = OnMsg
local DelayedCall = DelayedCall

local green = -16711936
local red = -65536
local white = -1

-- oh it happens more than you'd think
local function AttachColour(s,class,colour)
	local attaches = s:GetAttaches() or ""
	for i = 1, #attaches do
		if attaches[i].class == class then
			attaches[i]:SetColorModifier(colour)
		end
	end
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

function OnMsg.ChristmasMars_SpawnedPlayground(s)
	DelayedCall(1, function()
		GRGR(s)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
			if a.class == "DecPlaygroundBase" then
				a:SetColorModifier(green)
			elseif a.class == "DecorInt_04" then
				a:SetColorModifier(red)
			end
		end
	end)
end

function OnMsg.ChristmasMars_SpawnedPassageRamp(s)
	DelayedCall(1, function()
		local colour
		if Random(1,10) > 5 then
			s:SetColorModifier(green)
			colour = red
		else
			s:SetColorModifier(red)
			colour = green
		end
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
			if a.class == "LampInt_05" then
				a:SetColorModifier(colour)
			end
		end
	end)
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
function OnMsg.ChristmasMars_SpawnedHangingGardens(s)
	DelayedCall(1, function()
		s:SetColorModifier(green)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
			if HangingGardensElements[a.class] then
				a:SetColorModifier(red)
			end
		end
	end)
end

function OnMsg.ChristmasMars_SpawnedArcology(s)
	DelayedCall(1, function()
		s:SetColorModifier(white)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
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
	end)
end

function OnMsg.ChristmasMars_SpawnedSanatorium(s)
	DelayedCall(1, function()
		GRGR(s)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
			if a.class == "LampInt_02" then
				a:SetColorModifier(red)
			elseif a.class == "DecorInt_05" then
				a:SetColorModifier(red)
			elseif a.class:find("Door_0") then
				a:SetColor1(red)
				a:SetColor2(green)
			end
		end
	end)
end

function OnMsg.ChristmasMars_SpawnedMedicalCenter(s)
	DelayedCall(1, function()
		GRGR(s)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
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
	end)
end

function OnMsg.ChristmasMars_SpawnedNetworkNode(s)
	DelayedCall(1, function()
		RGRG(s)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
			if a.class == "LampInt_01" then
				a:SetColorModifier(red)
			elseif a.class == "LampInt_02" then
				a:SetColorModifier(red)
			elseif a.class == "NetworkNodeDoor_01" or a.class == "NetworkNodeDoor_02" then
				a:SetColor2(red)
			end
		end
	end)
end

function OnMsg.ChristmasMars_SpawnedCloningVats(s)
	DelayedCall(1, function()
		RGRG(s)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
			if a.class:find("CloningVatsDoor") then
				a:SetColor2(green)
			elseif a.class == "LampInt_02" then
				a:SetColorModifier(red)
			end
		end
	end)
end

function OnMsg.ChristmasMars_SpawnedWaterReclamationSpire(s)
	DelayedCall(1, function()
		GRGR(s)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
			if a.class == "LampInt_02" then
				a:SetColorModifier(red)
			end
		end
	end)
end

function OnMsg.ChristmasMars_SpawnedFarmConventional(s)
	DelayedCall(1, function()
		GRGR(s)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
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
	end)
end

function OnMsg.ChristmasMars_SpawnedWaterTankLarge(s)
	s:SetColorModifier(green)
end

function OnMsg.ChristmasMars_SpawnedFarmHydroponic(s)
	DelayedCall(1, function()
		RGRG(s)
		local attaches = s:GetAttaches() or ""
		local stockpile
		local decal
		for i = 1, #attaches do
			local a = attaches[i]
			if a.class == "HydroponicFarmDoor" or a.class == "HydroponicFarmFloorDoor" then
				a:SetColor2(green)
			elseif a.class == "LampInt_02" then
				a:SetColorModifier(red)
			elseif a.class == "LampWallInner_01" then
				a:SetColorModifier(green)
			elseif a.class == "DecSecurityCenterBase" then
				if not decal then
					decal = true
					a:SetColorModifier(green)
				else
					a:SetColorModifier(red)
				end
			elseif a.class == "ResourceStockpile" then
				if not stockpile then
					stockpile = true
					a:SetColorModifier(green)
				else
					a:SetColorModifier(red)
				end
			end
		end
	end)
end

function OnMsg.ChristmasMars_SpawnedTheExcavator(s)
	DelayedCall(1, function()
		RGRG(s)
		s.arm:SetColor1(red)
		s.arm:SetColor2(green)
		s.arm:SetColor4(green)
		s.belt:SetColorModifier(red)
		s.tower:SetColor1(green)
		s.tower:SetColor2(green)
		s.tower:SetColor3(green)
		s.tower:SetColor4(red)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
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
	end)
end

function OnMsg.ChristmasMars_SpawnedProjectMorpheus(s)
	DelayedCall(1, function()
		GRGR(s)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
			if a.class == "ProjectMorpheusLights" then
				a:SetColorModifier(green)
			elseif a.class == "LampInt_03" then
				a:SetColorModifier(green)
			elseif a.class == "ParSystem" then
				a:SetColorModifier(green)
			end
		end
	end)
end

function OnMsg.ChristmasMars_SpawnedArtificialSun(s)
	DelayedCall(1, function()
		RGRG(s)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
			if a.class == "ArtificialSunLights" then
				a:SetColorModifier(green)
			elseif a.class == "ParSystem" then
				a:SetColorModifier(red)
			end
		end
	end)
end

function OnMsg.ChristmasMars_SpawnedOmegaTelescope(s)
	DelayedCall(1, function()
		RGRG(s)
		s.antenna:SetColor1(red)
		s.antenna:SetColor2(green)
		s.antenna:SetColor3(green)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
			if a.class == "RadioDishLights" then
				a:SetColorModifier(green)
			elseif a.class == "LampWallInner_01" then
				a:SetColorModifier(red)
			end
		end
	end)
end

function OnMsg.ChristmasMars_SpawnedMoholeMine(s)
	DelayedCall(1, function()
		GRGR(s)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
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
	end)
end

function OnMsg.ChristmasMars_SpawnedSpaceElevator(s)
	DelayedCall(1, function()
		RGRG(s)
		s.pod:SetColor1(green)
		s.pod:SetColor2(red)
		s.pod:SetColor4(green)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
			if a.class:find("SpaceElevatorDoor") then
				a:SetColor2(red)
			elseif a.class == "LampWallInner_01" then
				a:SetColorModifier(red)
			elseif a.class == "SpaceElevatorLights" then
				a:SetColorModifier(red)
			end
		end
	end)
end

function OnMsg.ChristmasMars_SpawnedElectronicsFactory(s)
	DelayedCall(1, function()
		-- don't set 4
		s:SetColor1(green)
		s:SetColor2(red)
		s:SetColor3(green)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
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
	end)
end

function OnMsg.ChristmasMars_SpawnedMachinePartsFactory(s)
	DelayedCall(1, function()
		GRGR(s)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
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
	end)
end

function OnMsg.ChristmasMars_SpawnedFuelFactory(s)
	DelayedCall(1, function()
		s:SetColor1(green)
		s:SetColor2(red)
		s:SetColor3(red)
		s:SetColor4(red)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
			if a.class == "ResourceStockpile" or a.class == "WasteRockStockpile" then
				a:SetColorModifier(green)
			elseif a.class == "LampWallInner_01" then
				a:SetColorModifier(green)
			end
		end
	end)
end

function OnMsg.ChristmasMars_SpawnedDroneFactory(s)
	DelayedCall(1, function()
		GRGR(s)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
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
	end)
end

function OnMsg.ChristmasMars_SpawnedRegolithExtractor(s)
	DelayedCall(1, function()
		GRGR(s)
		s.anim_obj.digger:SetColor1(white)
		s.anim_obj.digger:SetColor2(green)
		s.anim_obj.digger:SetColor4(red)

		s.anim_obj.ring:SetColor2(red)
		s.anim_obj.ring:SetColor4(green)
		s.anim_obj.rope1:SetColorModifier(green)
		s.anim_obj.rope2:SetColorModifier(green)

		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
			if a.class == "ResourceStockpile" then
				a:SetColorModifier(red)
			elseif a.class == "WasteRockStockpile" then
				a:SetColorModifier(green)
			elseif a.class == "LampWallOuter_01" then
				a:SetColorModifier(red)
			end
		end
	end)
end

function OnMsg.ChristmasMars_SpawnedMetalsExtractor(s)
	DelayedCall(1, function()
		s:SetColor1(red)
		s:SetColor2(green)
		s:SetColor3(red)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
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
	end)
end

function OnMsg.ChristmasMars_SpawnedPreciousMetalsExtractor(s)
	DelayedCall(1, function()
		GRGR(s)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
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
	end)
end

function OnMsg.ChristmasMars_SpawnedPolymerPlant(s)
	DelayedCall(1, function()
		GRGR(s)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
			if a.class == "ResourceStockpile" then
				a:SetColorModifier(green)
			elseif a.class == "PolymerPlantDoor" then
				a:SetColor1(green)
			end
		end
	end)
end

function OnMsg.ChristmasMars_SpawnedFungalFarm(s)
	DelayedCall(1, function()
		GRGR(s)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
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
	end)
end

function OnMsg.ChristmasMars_SpawnedWaterTank(s)
	DelayedCall(1, function()
		GRGR(s)
		AttachColour(s,"WaterTankFloat",green)
	end)
end

function OnMsg.ChristmasMars_SpawnedWaterExtractor(s)
	DelayedCall(1, function()
		GRGR(s)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
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
	end)
end

function OnMsg.ChristmasMars_SpawnedMoistureVaporator(s)
	DelayedCall(1, function()
		GRGR(s)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
			if a.class == "MoistureVaporatorBalloon" then
				a:SetColor1(red)
			end
		end
	end)
end

function OnMsg.ChristmasMars_SpawnedOxygenTank(s)
	DelayedCall(1, function()
		GRGR(s)
		AttachColour(s,"AirTankArrow",red)
	end)
end

function OnMsg.ChristmasMars_SpawnedMOXIE(s)
	DelayedCall(1, function()
		GRGR(s)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
			if a.class == "MoxiePump" then
				a:SetColor2(red)
				a:SetColor3(green)
			end
		end
	end)
end

--~ function OnMsg.ChristmasMars_SpawnedElectricityGridElement(s)
--~ 	DelayedCall(1, function()
--~ 		s:SetColor3(green)
--~ 		local attaches = s:GetAttaches() or ""
--~ 		for i = 1, #attaches do
--~ 			attaches[i]:SetColor3(green)
--~ 		end
--~ 	end)
--~ end

--~ function OnMsg.ChristmasMars_SpawnedLifeSupportGridElement(s)
--~ 	DelayedCall(1, function()
--~ 	s:SetColor1(green)
--~ 	s:SetColor2(red)
--~ 	s:SetColor3(red)
--~ 	end)
--~ end

function OnMsg.ChristmasMars_SpawnedFusionReactor(s)
	DelayedCall(1, function()
		GRGR(s)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
			if a.class:find("FusionReactorDoor") then
				a:SetColor2(red)
			end
		end
	end)
end

function OnMsg.ChristmasMars_SpawnedSolarPanel(s)
	DelayedCall(1, function()
		GRGR(s)
		s.panel_obj:SetColor1(green)
		s.panel_obj:SetColor2(red)
		s.panel_obj:SetColor3(green)
	end)
end

function OnMsg.ChristmasMars_SpawnedTriboelectricScrubber(s)
	DelayedCall(1, function()
		RGRG(s)
		s.sphere:SetColor1(green)
		s.sphere:SetColor2(red)
		s.sphere:SetColor3(green)
	end)
end

function OnMsg.ChristmasMars_SpawnedShuttleHub(s)
	DelayedCall(1, function()
		GRGR(s)
		s.consumption_resource_stockpile:SetColorModifier(green)
	end)
end

function OnMsg.ChristmasMars_SpawnedDroneHub(s)
	DelayedCall(1, function()
		GRGR(s)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
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
	end)
end

function OnMsg.ChristmasMars_SpawnedRechargeStation(s)
	DelayedCall(1, function()
		s.platform:SetColor1(red)
		s.platform:SetColor2(green)
		s.platform:SetColor3(red)
	end)
end

function OnMsg.ChristmasMars_SpawnedLandingPad(s)
	AttachColour(s,"LampInt_04",green)
	AttachColour(s,"LampInt_05",red)
end

function OnMsg.ChristmasMars_SpawnedTunnel(s)
	DelayedCall(1, function()
		GRGR(s)
		AttachColour(s,"TunnelEntranceDoor",green)
	end)
end

function OnMsg.ChristmasMars_SpawnedSupplyRocket(s)
	DelayedCall(1, function()
		GRGR(s)
		local attaches = s:GetAttaches() or ""
		for i = 1, #attaches do
			if attaches[i].class == "LampWallInner_01" then
				attaches[i]:SetColorModifier(green)
			end
		end
	end)
end

function OnMsg.ChristmasMars_SpawnedMDSLaser(s)
	DelayedCall(1, function()
		s.tube:SetColor1(green)
		s.tube:SetColor2(red)
		s.tube:SetColor3(green)
		s.platform:SetColor2(green)
	end)
end

function OnMsg.ChristmasMars_SpawnedDefenceTower(s)
	DelayedCall(1, function()
		GRGR(s)
		s.platform:SetColor2(green)
		s.tube:SetColor1(green)
		s.tube:SetColor2(red)
		s.tube:SetColor3(red)
	end)
end
