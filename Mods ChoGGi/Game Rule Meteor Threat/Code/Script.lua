-- See LICENSE for terms

local ConstantDisastersModLoaded

local mod_Overkill
local mod_NoDeposits
local options

-- fired when settings are changed/init
local function ModOptions()
	options = options or CurrentModOptions
	mod_Overkill = options:GetProperty("Overkill")
	mod_NoDeposits = options:GetProperty("NoDeposits")
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	-- abort if "main" mod is installed
	if table.find(ModsLoaded, "id", "ChoGGi_GameRulesConstantDisasters") then
		ConstantDisastersModLoaded = true
		return
	end
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

-- local some globals
local OverrideDisasterDescriptor = OverrideDisasterDescriptor
local IsGameRuleActive = IsGameRuleActive
local GetDisasterWarningTime = GetDisasterWarningTime
local GameTime = GameTime
local Sleep = Sleep
local Min = Min
local MeteorsDisaster = MeteorsDisaster
local HourDuration = const.HourDuration
local HourDurationHalf = HourDuration / 2
local MinuteDuration = const.MinuteDuration

local function GetMeteorsDescr()
	if mapdata.MapSettings_Meteor == "disabled" then
		return
	end
	local data = DataInstances.MapSettings_Meteor
	local orig_data = data[mapdata.MapSettings_Meteor] or data["Meteor_VeryLow"]
	return OverrideDisasterDescriptor(orig_data)
end

GlobalGameTimeThread("ChoGGi_MeteorThreat_Thread", function()
	local meteors = GetMeteorsDescr()
	if ConstantDisastersModLoaded
		or not IsGameRuleActive("ChoGGi_MeteorThreat") or not meteors
	then
		return
	end

	local UICity = UICity
	while true do
--~ 		local spawn_time = UICity:Random(meteors.spawntime, meteors.spawntime + meteors.spawntime_random)
		local spawn_time = UICity:Random(mod_Overkill and MinuteDuration or HourDurationHalf)
		local warning_time = GetDisasterWarningTime(meteors)
		local start_time = GameTime()
		if GameTime() - start_time > spawn_time - warning_time then
			Sleep(5000)
		end
		local chance = UICity:Random(100)
		local meteors_type
		if mod_Overkill or chance < meteors.multispawn_chance then
			meteors_type = "multispawn"
		else
			meteors_type = "single"
		end
		local hit_time = Min(spawn_time, warning_time)
		Sleep(hit_time)
		MeteorsDisaster(meteors, meteors_type)

		local new_meteors = GetMeteorsDescr()
		while not new_meteors do
			Sleep(HourDuration)
			new_meteors = GetMeteorsDescr()
		end
		meteors = new_meteors
	end
end)

local orig_GenerateMeteor = GenerateMeteor
function GenerateMeteor(...)
	local meteor = orig_GenerateMeteor(...)
	if ConstantDisastersModLoaded then
		return meteor
	end
	if mod_NoDeposits then
		meteor.deposit_type = "Rocks"
	end
	return meteor
end

function OnMsg.ClassesPostprocess()
	if ConstantDisastersModLoaded or GameRulesMap.ChoGGi_MeteorThreat then
		return
	end

	PlaceObj("GameRules", {
		description = T(302535920011603, "Meteors will constantly rain down upon your poor colony."),
		display_name = T(302535920011604, "Meteor Threat"),
		flavor = T(302535920011605, [[<grey>"Why don't you stick a broom up my ass? I can sweep the carpet on the way out."<newline><right>Dr. Paul Bradley</grey><left>]]),
		group = "Default",
		id = "ChoGGi_MeteorThreat",
	})
end
