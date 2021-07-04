-- See LICENSE for terms

local table = table
local RemoveFromRules = RemoveFromRules
local StopSound = StopSound
local PlayFX = PlayFX
local ToggleWorking = ChoGGi.ComFuncs.ToggleWorking

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

local DisableSounds

-- fired when settings are changed/init
local function ModOptions()
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

	if UICity then
		DisableSounds()
	end
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local function BldToggleWorking(label)
	local objs = UICity.labels[label] or ""
	for i = 1, #objs do
		ToggleWorking(objs[i])
	end
end
local function BldToggleSounds(label, snd)
	local objs = UICity.labels[label] or ""
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
		BldToggleWorking("SensorTower")
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
		BldToggleWorking("Nursery")
	end

	if mod_SpacebarMusic then
		table.remove(FXRules.Working.start.Spacebar.any, 1)
		table.remove(FXRules.Working.start.Spacebar_Small.any, 1)
		RemoveFromRules("Building Spacebar Loop")
		RemoveFromRules("Building SpacebarSmall Loop")
		-- Includes reg and small
		BldToggleWorking("Spacebar")
	end

	if mod_BioroboticsWorkshop then
		table.remove(FXRules.Working.start.BioroboticsWorkshop.any, 1)
		RemoveFromRules("Building WorkshopBiorobotics Loop")
		BldToggleWorking("BioroboticsWorkshop")
	end

	if mod_RareMetalsExtractor then
		table.remove(FXRules.Working.start.PreciousMetalsExtractor.any, 1)
		RemoveFromRules("Object PreciousExtractor Loop")
		BldToggleWorking("PreciousMetalsExtractor")
	end

	if mod_SelectBuildingSound then
		RemoveFromRules("UI SelectBuilding")
		local rules = FXRules.SelectObj.start

		for id, list in pairs(rules) do
			list = rules[id].any
			for i = #list, 1, -1 do
				local sound = list[i].Sound
				if sound == "UI SelectBuilding" or sound:sub(-6) == "Select" then
					RemoveFromRules("list[i].Sound")
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

end


OnMsg.CityStart = DisableSounds
OnMsg.LoadGame = DisableSounds

-- disable voiced text
local complete = T(7058, "Research complete")
local orig_Voice_Play = Voice.Play
function Voice:Play(text, ...)
	if mod_ResearchComplete and text == complete then
		return
	end
	return orig_Voice_Play(self, text, ...)
end

if not ChoGGi.testing then
	return
end

--~ -- Data\SoundPreset.lua, and Lua\Config\__SoundTypes.lua
--~ -- test sounds:
function TestSound(snd)
	StopSound(ChoGGi.Temp.Sound)
	ChoGGi.Temp.Sound = PlaySound(snd, "UI")
end
--~ TestSound("Ambience Disaster ColdwaveWave")
--~ TestSound("Ambience Disaster ColdwaveCracks")
--~ TestSound("Building Spacebar Loop")
