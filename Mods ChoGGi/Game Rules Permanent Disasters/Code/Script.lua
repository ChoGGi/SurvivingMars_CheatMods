-- See LICENSE for terms

-- local some globals
local IsGameRuleActive = IsGameRuleActive
local OverrideDisasterDescriptor = OverrideDisasterDescriptor
local GetDisasterWarningTime = GetDisasterWarningTime
local GameTime = GameTime
local Sleep = Sleep
local MeteorsDisaster = MeteorsDisaster
local GenerateDustDevil = GenerateDustDevil
local GetRandomPassableAwayFromBuilding = GetRandomPassableAwayFromBuilding
local table_find = table.find
local IsValidXWin = ChoGGi.ComFuncs.IsValidXWin

local SolDuration = const.Scale.sols
local SolDuration9 = SolDuration * 999
local HourDuration = const.HourDuration
local HourDurationHalf = HourDuration / 2
local MinuteDuration = const.MinuteDuration

-- mod options
local mod_MeteorsOverkill
local mod_MeteorsNoDeposits
local mod_DustStormsAllowRockets
local mod_DustStormsMOXIEPerformance
local mod_DustStormsElectrostatic
local mod_DustStormsGreatStorm
local mod_DustDevilsTwisterAmount
local mod_DustDevilsTwisterMaxAmount
local mod_DustDevilsElectrostatic
local options

-- fired when settings are changed/init
local function ModOptions()
	options = CurrentModOptions
	mod_MeteorsOverkill = options:GetProperty("MeteorsOverkill")
	mod_MeteorsNoDeposits = options:GetProperty("MeteorsNoDeposits")
	mod_DustStormsAllowRockets = options:GetProperty("DustStormsAllowRockets")
	mod_DustStormsMOXIEPerformance = options:GetProperty("DustStormsMOXIEPerformance")
	mod_DustStormsElectrostatic = options:GetProperty("DustStormsElectrostatic")
	mod_DustStormsGreatStorm = options:GetProperty("DustStormsGreatStorm")
	mod_DustDevilsTwisterAmount = options:GetProperty("DustDevilsTwisterAmount")
	mod_DustDevilsTwisterMaxAmount = options:GetProperty("DustDevilsTwisterMaxAmount")
	mod_DustDevilsElectrostatic = options:GetProperty("DustDevilsElectrostatic")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

local function UpdateMOXIE(obj)
	if obj.ChoGGi_DustStormsMOXIEPerformance then
		obj.ChoGGi_DustStormsMOXIEPerformance:Change(0, -mod_DustStormsMOXIEPerformance)
	else
		obj.ChoGGi_DustStormsMOXIEPerformance = ObjectModifier:new({
			target = obj,
			prop = "air_production",
			percent = -mod_DustStormsMOXIEPerformance,
		})
	end
end

local function UpdateMOXIES()
	local objs = UICity.labels.MOXIE or ""
	for i = 1, #objs do
		UpdateMOXIE(objs[i])
	end
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()

	if not GameState.gameplay then
		return
	end

	-- update MOXIE performance
	if IsGameRuleActive("ChoGGi_GreatBakersfield") then
		UpdateMOXIES()
		-- force update dust storm
		g_DustStormStopped = true
	end
end

local function GetMeteorsDescr()
	local data = DataInstances.MapSettings_Meteor
	return OverrideDisasterDescriptor(
		data[mapdata.MapSettings_Meteor] or data["Meteor_VeryHigh"]
	)
end

local orig_GenerateMeteor = GenerateMeteor
function GenerateMeteor(...)
	local meteor = orig_GenerateMeteor(...)
	if mod_MeteorsNoDeposits then
		meteor.deposit_type = "Rocks"
	end
	return meteor
end

GlobalGameTimeThread("ChoGGi_MeteorThreat_Thread", function()
	local meteor = GetMeteorsDescr()
	if not meteor or not IsGameRuleActive("ChoGGi_MeteorThreat") then
		return
	end

	local UICity = UICity
	while true do
--~ 		local spawn_time = UICity:Random(meteor.spawntime, meteor.spawntime + meteor.spawntime_random)
		local spawn_time = UICity:Random(mod_MeteorsOverkill and MinuteDuration or HourDurationHalf)
		local warning_time = GetDisasterWarningTime(meteor)
		local start_time = GameTime()
		if GameTime() - start_time > spawn_time - warning_time then
			Sleep(5000)
		end
		local chance = UICity:Random(100)
		local meteors_type
		if mod_MeteorsOverkill or chance < meteor.multispawn_chance then
			meteors_type = "multispawn"
		else
			meteors_type = "single"
		end
		local hit_time = Min(spawn_time, warning_time)
		Sleep(hit_time)
		MeteorsDisaster(meteor, meteors_type)

		local new_meteors = GetMeteorsDescr()
		while not new_meteors do
			Sleep(HourDuration)
			new_meteors = GetMeteorsDescr()
		end
		meteor = new_meteors
	end
end)

local function GetDustDevilsDescr()
	local data = DataInstances.MapSettings_DustDevils
	return OverrideDisasterDescriptor(
		data[mapdata.MapSettings_DustDevils] or data["DustDevils_VeryHigh"]
	)
end

GlobalGameTimeThread("ChoGGi_Twister_Thread", function()
	local dustdevil = GetDustDevilsDescr()
	if not dustdevil or not IsGameRuleActive("ChoGGi_Twister") then
		return
	end

	dustdevil.electro_chance = mod_DustDevilsElectrostatic

	local Min = Min
	local Max = Max
	local UICity = UICity
	local g_DustDevils = g_DustDevils
	while true do
--~ 		local spawn_time = UICity:Random(dustdevil.spawntime, dustdevil.spawntime + dustdevil.spawntime_random)
		local spawn_time = UICity:Random(HourDurationHalf)
		local warning_time = dustdevil.warning_time
		Sleep(Max(spawn_time - warning_time, 1000))

--~ 		local count = UICity:Random(dustdevil.count_min, dustdevil.count_max) * dustdevil.spawn_chance / 100
		local a = mod_DustDevilsTwisterAmount
		local max = mod_DustDevilsTwisterMaxAmount > 0
			and mod_DustDevilsTwisterMaxAmount or a + UICity:Random(a+1)
		-- skip if none allowed or onmap amount is at max already
		if a > 0 and #g_DustDevils < max then
			-- spawn just add enough to be at max amount
			for _ = 1, (max - a) do
				local hit_time = Min(spawn_time, warning_time)
				Sleep(hit_time)
				local pos = GetRandomPassableAwayFromBuilding()
				if not pos then
					break
				end
				GenerateDustDevil(pos, dustdevil):Start()
				Sleep(UICity:Random(
					dustdevil.spawn_delay_min,
					dustdevil.spawn_delay_max
				))
			end

			local new_dustdevil = GetDustDevilsDescr()
			while not new_dustdevil do
				Sleep(HourDuration)
				new_dustdevil = GetDustDevilsDescr()
			end
			dustdevil = new_dustdevil
			dustdevil.electro_chance = mod_DustDevilsElectrostatic
		end
	end
end)

local function RemoveSuspend(list, name)
	local idx = table_find(list, name)
	if idx then
		table.remove(list, idx)
	end
end

local orig_SupplyRocket_IsFlightPermitted = SupplyRocket.IsFlightPermitted
function SupplyRocket:IsFlightPermitted(...)
	if mod_DustStormsAllowRockets then
		return true
	end
	return orig_SupplyRocket_IsFlightPermitted(self, ...)
end

-- remove dust storm notification button
function OnMsg.NewHour()
	local dlg = Dialogs
	if not dlg then
		return
	end
	dlg = dlg.OnScreenNotificationsDlg
	if not dlg then
		return
	end
	local notif = dlg:GetNotificationById("greatDustStormDuration")
		or dlg:GetNotificationById("normalDustStormDuration")
		or dlg:GetNotificationById("popupDisaster_DustStorm")
	if IsValidXWin(notif) then
		notif:delete()
	end
end

local function GetDustStormDescr()
	local data = DataInstances.MapSettings_DustStorm
	return OverrideDisasterDescriptor(
		data[mapdata.MapSettings_DustStorm] or data["DustStorm_VeryHigh"]
	)
end

GlobalGameTimeThread("ChoGGi_Bakersfield_Thread", function()
	local dust_storm = GetDustStormDescr()
	if not dust_storm or not IsGameRuleActive("ChoGGi_GreatBakersfield") then
		return
	end
	dust_storm.electrostatic = mod_DustStormsElectrostatic
	dust_storm.great = mod_DustStormsGreatStorm
	dust_storm.min_duration = SolDuration9
	dust_storm.max_duration = SolDuration9

	local wait_time = 0
	while true do
		wait_time = UICity:Random(HourDurationHalf)

		if not g_DustStormType then
			local rand = UICity:Random(101)
			if rand < dust_storm.electrostatic then
				g_DustStormType = "electrostatic"
			elseif rand < dust_storm.electrostatic + dust_storm.great then
				g_DustStormType = "great"
			else
				g_DustStormType = "normal"
			end
		end

		-- wait and show the notification
		local start_time = GameTime()
		while true do
			local warn_time = GetDisasterWarningTime(dust_storm)
			if GameTime() - start_time > wait_time - warn_time then
				WaitMsg("TriggerDustStorm", wait_time - (GameTime() - start_time))
				while IsDisasterActive() do
					WaitMsg("TriggerDustStorm", 5000)
				end
				break
			end

			local forced = WaitMsg("TriggerDustStorm", 5000)
			if forced then
				break
			end
		end

		wait_time = 0
		local next_storm = g_DustStormType
		g_DustStormType = false
		if not DustStormsDisabled then
			StartDustStorm(next_storm, dust_storm)
		end

		local new_dust_storm = GetDustStormDescr()
		while not new_dust_storm do
--~ 			Sleep(const.DayDuration)
			Sleep(HourDuration)
			new_dust_storm = GetDustStormDescr()
		end
		dust_storm = new_dust_storm
		dust_storm.electrostatic = mod_DustStormsElectrostatic
		dust_storm.great = mod_DustStormsGreatStorm
		dust_storm.min_duration = SolDuration9
		dust_storm.max_duration = SolDuration9
	end
end)

-- make sure there's one (broad) cold area
local orig_FillRandomMapProps = FillRandomMapProps
function FillRandomMapProps(gen, ...)
	local map = orig_FillRandomMapProps(gen, ...)

	if gen and IsGameRuleActive("ChoGGi_WinterWonderland") then
		gen.ColdAreaChance = 100
		gen.ColdAreaCount = 1
		-- max map size * 4 (make sure everything is covered no matter where the area is)
		gen.ColdAreaSize = range(4857600, 4857600)
	end

	return map
end

local function StartupCode()
	if IsGameRuleActive("ChoGGi_GreatBakersfield") then
		RemoveSuspend(g_SuspendLabels, "MOXIE")
		RemoveSuspend(const.DustStormSuspendBuildings, "MOXIE")

		BuildingTemplates.MOXIE.suspend_on_dust_storm = false
		ClassTemplates.Building.MOXIE.suspend_on_dust_storm = false
		UpdateMOXIES()
	end

	if IsGameRuleActive("ChoGGi_WinterWonderland") then
		GrantTech("SubsurfaceHeating")
	end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

-- we need to update MOXIEs when they're built
ChoGGi.ComFuncs.AddMsgToFunc("MOXIE", "GameInit", "ChoGGi_GreatBakersfield_Msg", true)
function OnMsg.ChoGGi_GreatBakersfield_Msg(obj)
	if IsGameRuleActive("ChoGGi_GreatBakersfield") then
		UpdateMOXIE(obj)
	end
end

function OnMsg.ClassesPostprocess()
	-- trand func from City.lua>function CreateRand(stable, ...) doesn't like < 2
	local orig_MapSector_new = MapSector.new
	function MapSector.new(...)
		local sector = orig_MapSector_new(...)
		-- good thing avg_heat is added when the sector is created
		if sector.avg_heat == 0 and IsGameRuleActive("ChoGGi_WinterWonderland") then
			sector.avg_heat = 2
		end
		return sector
	end

	-- don't want rules added more than once
	if GameRulesMap.ChoGGi_MeteorThreat then
		return
	end

	PlaceObj("GameRules", {
		description = T(302535920011603, "Meteors will constantly rain down upon your poor colony."),
		display_name = T(302535920011604, "Meteor Threat"),
		flavor = T(302535920011605, [[<grey>"Why don't you stick a broom up my ass? I can sweep the carpet on the way out."<newline><right>Dr. Paul Bradley</grey><left>]]),
		group = "Default",
		id = "ChoGGi_MeteorThreat",
	})

	PlaceObj("GameRules", {
		description = T(486621856457, "A team of Scientists argues over the satellite data as you quietly ponder the situation. It's going to be a long winter."),
		display_name = T(293468065101, "Winter Wonderland"),
		flavor = T{"<grey><text><newline><right>Haemimont Games</grey><left>",
			text = T(838846202028, "I know! Let's organize a winter festival!"),
		},
		group = "Default",
		id = "ChoGGi_WinterWonderland",
	})

	PlaceObj("GameRules", {
		description = T(302535920011624, "Permanent dust storm (MOXIEs work at a reduced rate)."),
		display_name = T(302535920011625, "Great Bakersfield Dust Storm"),
		flavor = T(302535920011626, [[<grey>"The wind blew the big plate glass window in and all the others out. They went out of business right then and there."<newline><right>Michael Boyt</grey><left>]]),
		group = "Default",
		id = "ChoGGi_GreatBakersfield",
	})

	PlaceObj("GameRules", {
		description = T(302535920011627, "Have at least one dust devil on the map at all times (see mod options to change amount)."),
		display_name = T(302535920011628, "'74 Super Outbreak"),
		flavor = T(302535920011629, [[<grey>"'The Suck Zone'. It's the point basically when the twister... sucks you up. That's not the technical term for it, obviously."<newline><right>Dusty</grey><left>]]),
		group = "Default",
		id = "ChoGGi_Twister",
	})
end
