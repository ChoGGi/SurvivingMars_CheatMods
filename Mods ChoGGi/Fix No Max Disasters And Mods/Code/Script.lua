-- See LICENSE for terms

local mod_EnableMod

local function RestartDisaster(disaster, rule_name, rule_id, thread_name)
	-- only restart if it should be maxed out and it isn't
	if ActiveMapData[disaster] ~= rule_id and IsGameRuleActive(rule_name) then
		ActiveMapData[disaster] = rule_id
		RestartGlobalGameTimeThread(thread_name)
	end
end

local function UpdateDisasters()
	if not mod_EnableMod then
		return
	end

	RestartDisaster("MapSettings_ColdWave", "WinterIsComing", "ColdWave_GameRule", "ColdWave")
	RestartDisaster("MapSettings_DustDevils", "Twister", "DustDevils_GameRule", "DustDevils")
	RestartDisaster("MapSettings_Meteor", "Armageddon", "Meteor_GameRule", "Meteors")
	RestartDisaster("MapSettings_DustStorm", "DustInTheWind", "DustStorm_GameRule", "DustStorm")

end

OnMsg.CityStart = UpdateDisasters
OnMsg.LoadGame = UpdateDisasters
-- switch between different maps (can happen before UICity)
OnMsg.ChangeMapDone = UpdateDisasters

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- make sure we're in-game UIColony
	if not UICity then
		return
	end

	UpdateDisasters()
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
