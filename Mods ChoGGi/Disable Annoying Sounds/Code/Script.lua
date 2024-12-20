-- See LICENSE for terms

local table = table
local RemoveFromRules = RemoveFromRules
local StopSound = StopSound
local PlayFX = PlayFX

local mod_SensorSensorTowerBeeping
local mod_RCCommanderDronesDeployed
local mod_MirrorSphereCrackling
local mod_NurseryChild
local mod_SpacebarMusic
local mod_BioroboticsWorkshop
local mod_RareMetalsExtractor
local mod_SelectBuildingSound
local mod_ResearchComplete
local mod_ColdWaveCrackling
local mod_ArtificialSunZapping
local mod_DustGeyserBurst
local mod_SupportStrutGrind

local DisableSounds

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	mod_SensorSensorTowerBeeping = options:GetProperty("SensorSensorTowerBeeping")
	mod_RCCommanderDronesDeployed = options:GetProperty("RCCommanderDronesDeployed")
	mod_MirrorSphereCrackling = options:GetProperty("MirrorSphereCrackling")
	mod_NurseryChild = options:GetProperty("NurseryChild")
	mod_SpacebarMusic = options:GetProperty("SpacebarMusic")
	mod_BioroboticsWorkshop = options:GetProperty("BioroboticsWorkshop")
	mod_RareMetalsExtractor = options:GetProperty("RareMetalsExtractor")
	mod_SelectBuildingSound = options:GetProperty("SelectBuildingSound")
	mod_ResearchComplete = options:GetProperty("ResearchComplete")
	mod_ColdWaveCrackling = options:GetProperty("ColdWaveCrackling")
	mod_ArtificialSunZapping = options:GetProperty("ArtificialSunZapping")
	mod_DustGeyserBurst = options:GetProperty("DustGeyserBurst")
	mod_SupportStrutGrind = options:GetProperty("SupportStrutGrind")

	if UICity then
		DisableSounds()
	end
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function BldStopSounds(label)
	local objs = UIColony:GetCityLabels(label)
	for i = 1, #objs do
		objs[i]:StopSound()
	end
end

local function BldToggleSounds(label, snd)
	local objs = UIColony:GetCityLabels(label)
	for i = 1, #objs do
		local obj = objs[i]
		PlayFX(snd, "end", obj)
		PlayFX(snd, "start", obj)
	end
end

DisableSounds = function()
	local FXRules = FXRules

	if mod_SensorSensorTowerBeeping then
		table.remove(FXRules.Working.start.SensorTower.any, 3)
		RemoveFromRules("Object SensorTower Loop")
		BldStopSounds("SensorTower")
	end

	if mod_RCCommanderDronesDeployed then
		local rules = FXRules.RoverDeploy.start
		for id, list in pairs(rules) do
--~ 			local list = FXRules.RoverDeploy.start.RCRover.any
			list = rules[id].any
			for i = #list, 1, -1 do
				local sound = list[i].Sound
				if sound == "Unit Rover DeployAntennaON" or sound == "Unit Rover DeployLoop" then
					table.remove(list, i)
				end
			end
			RemoveFromRules("Unit Rover DeployLoop")
			RemoveFromRules("Unit Rover DeployAntennaON")

			BldToggleSounds(id, "RoverDeploy")
		end

	end

	if mod_MirrorSphereCrackling then
		table.remove(FXRules.Freeze.start.MirrorSphere.any, 2)
		FXRules.Freeze.start.any = nil
		RemoveFromRules("Mystery Sphere Freeze")

		BldToggleSounds("MirrorSpheres", "Freeze")
	end

	if mod_NurseryChild then
		table.remove(FXRules.Working.start.Nursery.any, 1)
		RemoveFromRules("Building Nurcery LoopEmpty")
		BldStopSounds("Nursery")
	end

	if mod_SpacebarMusic then
		table.remove(FXRules.Working.start.Spacebar.any, 1)
		table.remove(FXRules.Working.start.Spacebar_Small.any, 1)
		RemoveFromRules("Building Spacebar Loop")
		RemoveFromRules("Building SpacebarSmall Loop")
		-- Includes reg and small
		BldStopSounds("Spacebar")
	end

	if mod_BioroboticsWorkshop then
		table.remove(FXRules.Working.start.BioroboticsWorkshop.any, 1)
		RemoveFromRules("Building WorkshopBiorobotics Loop")
		BldStopSounds("BioroboticsWorkshop")
	end

	if mod_RareMetalsExtractor then
		table.remove(FXRules.Working.start.PreciousMetalsExtractor.any, 1)
		RemoveFromRules("Object PreciousExtractor Loop")
		BldStopSounds("PreciousMetalsExtractor")
	end

	if mod_SelectBuildingSound then
		RemoveFromRules("UI SelectBuilding")
		local rules = FXRules.SelectObj.start

		for id, list in pairs(rules) do
			list = rules[id].any
			for i = #list, 1, -1 do
				local sound = list[i].Sound
				if sound == "UI SelectBuilding" or sound:sub(-6) == "Select" then
					RemoveFromRules(sound)
					table.remove(list, i)
				end
			end
		end
	end

	if mod_ColdWaveCrackling then
		local list = FXRules.ColdWave.start.any.any
		for i = #list, 1, -1 do
			local sound = list[i].Sound
			if sound == "Ambience Disaster ColdwaveWave" or sound == "Ambience Disaster ColdwaveCracks" then
				StopSound(sound.handle)
				table.remove(list, i)
			end
		end
		RemoveFromRules("Ambience Disaster ColdwaveWave")
		RemoveFromRules("Ambience Disaster ColdwaveCracks")
	end

	if mod_ArtificialSunZapping then
		local list = FXRules.ArtificialSunProduce.start.ArtificialSun.any
		for i = #list, 1, -1 do
			local sound = list[i].Sound
			if sound == "Object ArtificialSun Produce" then
				StopSound(sound.handle)
				table.remove(list, i)
			end
		end
		RemoveFromRules("Object ArtificialSun Produce")
		BldStopSounds("ArtificialSun")
	end

	if mod_DustGeyserBurst then
		RemoveFromRules("Ambience Geyser BurstLoop")
		local rules = FXRules.BurstOut.start
		for id, list in pairs(rules) do
			list = rules[id].PrefabFeatureMarker
			for i = #list, 1, -1 do
				local sound = list[i].Sound
				if sound == "Ambience Geyser BurstLoop" then
					RemoveFromRules(sound)
					table.remove(list, i)
				end
			end
		end
	end

	if mod_SupportStrutGrind then
		table.remove(FXRules.Working.start.SupportStrut.any, 1)
		RemoveFromRules("Building SupportStruts Loop")
		BldStopSounds("SupportStruts")
	end

end


OnMsg.CityStart = DisableSounds
OnMsg.LoadGame = DisableSounds

-- Disable voiced text
local complete = T(7058, "Research complete")
local ChoOrig_Voice_Play = Voice.Play
function Voice:Play(text, ...)
	if mod_ResearchComplete and text == complete then
		return
	end
	return ChoOrig_Voice_Play(self, text, ...)
end

--~ -- Data\SoundPreset.lua, and Lua\Config\__SoundTypes.lua
--~ -- test sounds:
--~ TestSound("Ambience Disaster ColdwaveWave")
--~ TestSound("Ambience Disaster ColdwaveCracks")
--~ TestSound("Ambience Geyser BurstStart")

if rawget(_G, "ChoGGi") and ChoGGi.testing then
	function TestSound(snd)
		StopSound(ChoGGi.Temp.Sound)
		ChoGGi.Temp.Sound = PlaySound(snd, "UI")
	end
end
