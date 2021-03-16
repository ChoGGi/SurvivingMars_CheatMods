-- See LICENSE for terms

local table_remove = table.remove
local RemoveFromRules = RemoveFromRules
local PlayFX = PlayFX
local ToggleWorking = ChoGGi.ComFuncs.ToggleWorking

local options
local mod_SensorSensorTowerBeeping
local mod_RCCommanderDronesDeployed
local mod_MirrorSphereCrackling
local mod_NurseryChild
local mod_SpacebarMusic

local DisableSounds

-- fired when settings are changed/init
local function ModOptions()
	options = CurrentModOptions
	mod_SensorSensorTowerBeeping = options:GetProperty("SensorSensorTowerBeeping")
	mod_RCCommanderDronesDeployed = options:GetProperty("RCCommanderDronesDeployed")
	mod_MirrorSphereCrackling = options:GetProperty("MirrorSphereCrackling")
	mod_NurseryChild = options:GetProperty("NurseryChild")
	mod_SpacebarMusic = options:GetProperty("SpacebarMusic")

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

	if mod_SensorSensorTowerBeeping then
		table_remove(FXRules.Working.start.SensorTower.any, 3)
		RemoveFromRules("Object SensorTower Loop")
		BldToggleWorking("SensorTower")
	end

	if mod_RCCommanderDronesDeployed then
		local list = FXRules.RoverDeploy.start.RCRover.any
		for i = #list, 1, -1 do
			if list[i].Sound == "Unit Rover DeployAntennaON" or list[i].Sound == "Unit Rover DeployLoop" then
				table_remove(list, i)
			end
		end
		RemoveFromRules("Unit Rover DeployLoop")
		RemoveFromRules("Unit Rover DeployAntennaON")

		BldToggleSounds("RCRover", "RoverDeploy")
	end

	if mod_MirrorSphereCrackling then
		table_remove(FXRules.Freeze.start.MirrorSphere.any, 2)
		FXRules.Freeze.start.any = nil
		RemoveFromRules("Mystery Sphere Freeze")

		BldToggleSounds("MirrorSpheres", "Freeze")
	end

	if mod_NurseryChild then
		table_remove(FXRules.Working.start.Nursery.any, 1)
		RemoveFromRules("Building Nurcery LoopEmpty")
		BldToggleWorking("Nursery")
	end

	if mod_SpacebarMusic then
		table_remove(FXRules.Working.start.Spacebar.any, 1)
		table_remove(FXRules.Working.start.Spacebar_Small.any, 1)
		RemoveFromRules("Building Spacebar Loop")
		RemoveFromRules("Building SpacebarSmall Loop")
		-- Includes reg and small
		BldToggleWorking("Spacebar")
	end
end


OnMsg.CityStart = DisableSounds
OnMsg.LoadGame = DisableSounds


--~ -- Data\SoundPreset.lua, and Lua\Config\__SoundTypes.lua
--~ -- test sounds:
function TestSound(snd)
	StopSound(ChoGGi.Temp.Sound)
	ChoGGi.Temp.Sound = PlaySound(snd, "UI")
end
--~ TestSound("Object MOXIE Loop")

--~ TestSound("Building Spacebar Loop")

