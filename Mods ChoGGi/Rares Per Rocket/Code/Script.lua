-- See LICENSE for terms

local SetTaskReqAmount = ChoGGi_Funcs.Common.SetTaskReqAmount

local mod_EnableMod
local mod_AmountOfRares

local function UpdateExistingRockets()
	local rockets = UIColony:GetCityLabels("AllRockets")
	for i = 1, #rockets do
		local rocket = rockets[i]
		if rocket.export_requests then
			SetTaskReqAmount(rocket, mod_AmountOfRares, "export_requests", "max_export_storage")
		else
			rocket.max_export_storage = mod_AmountOfRares
		end
	end
end
-- Update on new/load game
OnMsg.CityStart = UpdateExistingRockets
OnMsg.LoadGame = UpdateExistingRockets

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_AmountOfRares = CurrentModOptions:GetProperty("AmountOfRares") * const.ResourceScale

	if not UIColony then
		return
	end
	UpdateExistingRockets()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- Set when new rocket made
function OnMsg.BuildingInit(obj)
	if not mod_EnableMod then
		return
	end

	if obj:IsKindOf("RocketBase") then
		obj.max_export_storage = mod_AmountOfRares
	end
end

-- Rocket landed
local ChoOrig_RocketBase_LandOnMars = RocketBase.LandOnMars
function RocketBase:LandOnMars(...)
	if not mod_EnableMod then
		return ChoOrig_RocketBase_LandOnMars(self, ...)
	end

	self.max_export_storage = mod_AmountOfRares

	return ChoOrig_RocketBase_LandOnMars(self, ...)
end
