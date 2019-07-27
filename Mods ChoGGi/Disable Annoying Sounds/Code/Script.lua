-- See LICENSE for terms

local options
local mod_SensorSensorTowerBeeping
local mod_RCCommanderDronesDeployed
local mod_MirrorSphereCrackling
local mod_NurseryChild
local mod_SpacebarMusic

local DisableSounds

-- fired when settings are changed/init
local function ModOptions()
	mod_SensorSensorTowerBeeping = options.SensorSensorTowerBeeping
	mod_RCCommanderDronesDeployed = options.RCCommanderDronesDeployed
	mod_MirrorSphereCrackling = options.MirrorSphereCrackling
	mod_NurseryChild = options.NurseryChild
	mod_SpacebarMusic = options.SpacebarMusic

	if GameState.gameplay then
		DisableSounds()
	end
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_DisableAnnoyingSounds" then
		return
	end

	ModOptions()
end

--~ 	-- Data\SoundPreset.lua, and Lua\Config\__SoundTypes.lua
--~ 	-- test sounds:
--~ 	function TestSound(snd)
--~ 		StopSound(ChoGGi.Temp.Sound)
--~ 		ChoGGi.Temp.Sound = PlaySound(snd, "UI")
--~ 	end
--~ 	TestSound("Object MOXIE Loop")
--~
--~ TestSound("Building Nurcery LoopEmpty")

local function BldToggleWorking(label)
	local ToggleWorking = ChoGGi.ComFuncs.ToggleWorking
	local objs = UICity.labels[label] or ""
	for i = 1, #objs do
		ToggleWorking(objs[i])
	end
end
local function BldToggleSounds(label, snd)
	local PlayFX = PlayFX
	local objs = UICity.labels[label] or ""
	for i = 1, #objs do
		local obj = objs[i]
		PlayFX(snd, "end", obj)
		PlayFX(snd, "start", obj)
	end
end

DisableSounds = function()
	local remove = table.remove
	local RemoveFromRules = RemoveFromRules

	if mod_SensorSensorTowerBeeping then
		remove(FXRules.Working.start.SensorTower.any, 3)
		RemoveFromRules("Object SensorTower Loop")
		BldToggleWorking("SensorTower")
	end

	if mod_RCCommanderDronesDeployed then
		local list = FXRules.RoverDeploy.start.RCRover.any
		for i = #list, 1, -1 do
			if list[i].Sound == "Unit Rover DeployAntennaON" or list[i].Sound == "Unit Rover DeployLoop" then
				remove(list, i)
			end
		end
		RemoveFromRules("Unit Rover DeployLoop")
		RemoveFromRules("Unit Rover DeployAntennaON")

		BldToggleSounds("RCRover", "RoverDeploy")
	end

	if mod_MirrorSphereCrackling then
		remove(FXRules.Freeze.start.MirrorSphere.any, 2)
		FXRules.Freeze.start.any = nil
		RemoveFromRules("Mystery Sphere Freeze")

		BldToggleSounds("MirrorSpheres", "Freeze")
	end

	if mod_NurseryChild then
		remove(FXRules.Working.start.Nursery.any, 1)
		RemoveFromRules("Building Nurcery LoopEmpty")
		BldToggleWorking("Nursery")
	end

	if mod_SpacebarMusic then
		remove(FXRules.Working.start.Spacebar.any, 1)
		remove(FXRules.Working.start.Spacebar_Small.any, 1)
		RemoveFromRules("Building Spacebar Loop")
		RemoveFromRules("Building SpacebarSmall Loop")
		-- includes reg and small
		BldToggleWorking("Spacebar")
	end
end


OnMsg.CityStart = DisableSounds
OnMsg.LoadGame = DisableSounds
