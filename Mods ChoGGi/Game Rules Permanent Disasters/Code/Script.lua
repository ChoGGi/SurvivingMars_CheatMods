-- See LICENSE for terms

-- local some globals
local table = table

local IsValidXWin = ChoGGi.ComFuncs.IsValidXWin

local SolDuration = const.Scale.sols
local SolDuration9 = SolDuration * 999
local HourDuration = const.HourDuration
local HourDurationHalf = HourDuration / 2
local MinuteDuration = const.MinuteDuration

-- mod options
local mod_MeteorsOverkill
local mod_MeteorsNoDeposits
local mod_MeteorsMDSLasers
local mod_MeteorsDefensiveTurrets
local mod_DustStormsUnbreakableCP
local mod_DustStormsAllowRockets
local mod_DustStormsAllowMOXIEs
local mod_DustStormsMOXIEPerformance
local mod_DustStormsElectrostatic
local mod_DustStormsGreatStorm
local mod_DustDevilsTwisterAmount
local mod_DustDevilsTwisterMaxAmount
local mod_DustDevilsElectrostatic
local mod_ColdAreaGiveSubsurfaceHeaters
local mod_ColdAreaUnlockSubsurfaceHeaters

-- fired when settings are changed/init
local function ModOptions()
	local options = CurrentModOptions
	mod_MeteorsOverkill = options:GetProperty("MeteorsOverkill")
	mod_MeteorsNoDeposits = options:GetProperty("MeteorsNoDeposits")
	mod_MeteorsMDSLasers = options:GetProperty("MeteorsMDSLasers")
	mod_MeteorsDefensiveTurrets = options:GetProperty("MeteorsDefensiveTurrets")
	mod_DustStormsUnbreakableCP = options:GetProperty("DustStormsUnbreakableCP")
	mod_DustStormsAllowRockets = options:GetProperty("DustStormsAllowRockets")
	mod_DustStormsAllowMOXIEs = options:GetProperty("DustStormsAllowMOXIEs")
	mod_DustStormsMOXIEPerformance = options:GetProperty("DustStormsMOXIEPerformance")
	mod_DustStormsElectrostatic = options:GetProperty("DustStormsElectrostatic")
	mod_DustStormsGreatStorm = options:GetProperty("DustStormsGreatStorm")
	mod_DustDevilsTwisterAmount = options:GetProperty("DustDevilsTwisterAmount")
	mod_DustDevilsTwisterMaxAmount = options:GetProperty("DustDevilsTwisterMaxAmount")
	mod_DustDevilsElectrostatic = options:GetProperty("DustDevilsElectrostatic")
	mod_ColdAreaGiveSubsurfaceHeaters = options:GetProperty("ColdAreaGiveSubsurfaceHeaters")
	mod_ColdAreaUnlockSubsurfaceHeaters = options:GetProperty("ColdAreaUnlockSubsurfaceHeaters")
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

	if not UICity then
		return
	end

	-- update MOXIE performance
	if IsGameRuleActive("ChoGGi_GreatBakersfield") then
		UpdateMOXIES()
		-- force update dust storm
		g_DustStormStopped = true
	end
end

local ChoOrig_GenerateMeteor = GenerateMeteor
function GenerateMeteor(...)
	local meteor = ChoOrig_GenerateMeteor(...)
	if mod_MeteorsNoDeposits then
		meteor.deposit_type = "Rocks"
	end
	return meteor
end

local function GetMeteorsDescr()
	local data = DataInstances.MapSettings_Meteor
	return OverrideDisasterDescriptor(
		data[ActiveMapData.MapSettings_Meteor] or data["Meteor_VeryHigh"]
	)
end

GlobalGameTimeThread("ChoGGi_MeteorThreat_Thread", function()
	local meteor
	while true do
		if not meteor then
			meteor = GetMeteorsDescr()
		end
		if meteor and IsGameRuleActive("ChoGGi_MeteorThreat") then
	--~ 		local spawn_time = Random(meteor.spawntime, meteor.spawntime + meteor.spawntime_random)
			local spawn_time = MainCity:Random(mod_MeteorsOverkill and MinuteDuration or HourDurationHalf)
			local warning_time = GetDisasterWarningTime(meteor)
			local start_time = GameTime()
			if GameTime() - start_time > spawn_time - warning_time then
				Sleep(5000)
			end
			local chance = MainCity:Random(100)
			local meteors_type
			if mod_MeteorsOverkill or chance < meteor.multispawn_chance then
				meteors_type = "multispawn"
			else
				meteors_type = "single"
			end
			local hit_time = Min(spawn_time, warning_time)
			Sleep(hit_time or HourDuration)
			MeteorsDisaster(meteor, meteors_type)

			local new_meteor = GetMeteorsDescr()
			while not new_meteor do
				Sleep(HourDuration)
				new_meteor = GetMeteorsDescr()
			end
			meteor = new_meteor
		end
		Sleep(1000)
	end
end)

local function GetDustDevilsDescr()
	local data = DataInstances.MapSettings_DustDevils
	return OverrideDisasterDescriptor(
		data[ActiveMapData.MapSettings_DustDevils] or data["DustDevils_VeryHigh"]
	)
end

GlobalGameTimeThread("ChoGGi_Twister_Thread", function()
	local dustdevil
	while true do
		if not dustdevil then
			dustdevil = GetDustDevilsDescr()
		end
		if dustdevil and IsGameRuleActive("ChoGGi_Twister") then
			dustdevil.electro_chance = mod_DustDevilsElectrostatic

			local spawn_time = MainCity:Random(HourDurationHalf)
			local warning_time = dustdevil.warning_time
			Sleep(Max(spawn_time - warning_time, 1000) or HourDuration)

			local a = mod_DustDevilsTwisterAmount
			local max = mod_DustDevilsTwisterMaxAmount > 0
				and mod_DustDevilsTwisterMaxAmount or a + MainCity:Random(a+1)
			-- skip if none allowed or on-map amount is at max already
			if a > 0 and #g_DustDevils < max then
				-- spawn just add enough to be at max amount
				for _ = 1, (max - a) do
					local hit_time = Min(spawn_time, warning_time)
					Sleep(hit_time or HourDuration)
					local pos = GetRandomPassableAwayFromBuilding()
					if not pos then
						break
					end
					GenerateDustDevil(pos, dustdevil):Start()
					Sleep(MainCity:Random(
						-- 500/1500 default in dustdevil props
						dustdevil.spawn_delay_min or 500,
						dustdevil.spawn_delay_max or 1500
					) or HourDuration)
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
		Sleep(1000)
	end
end)

local function RemoveSuspend(list, name)
	local idx = table.find(list, name)
	if idx then
		table.remove(list, idx)
	end
end

local ChoOrig_RocketBase_IsFlightPermitted = RocketBase.IsFlightPermitted
function RocketBase:IsFlightPermitted(...)
	return mod_DustStormsAllowRockets or ChoOrig_RocketBase_IsFlightPermitted(self, ...)
end

local ChoOrig_RocketBase_GetLaunchIssue = RocketBase.GetLaunchIssue
function RocketBase:GetLaunchIssue(...)
	-- save orig value
	if mod_DustStormsAllowRockets and self.affected_by_dust_storm then
		self.ChoGGi_Orig_affected_by_dust_storm = self.affected_by_dust_storm
		self.affected_by_dust_storm = false
	-- restore orig value
	elseif not mod_DustStormsAllowRockets and self.ChoGGi_Orig_affected_by_dust_storm then
		self.affected_by_dust_storm = self.ChoGGi_Orig_affected_by_dust_storm
		self.ChoGGi_Orig_affected_by_dust_storm = nil
	end

	return ChoOrig_RocketBase_GetLaunchIssue(self, ...)
end


local ChoOrig_UpdateConstructionStatuses = ConstructionController.UpdateConstructionStatuses
function ConstructionController:UpdateConstructionStatuses(_, ...)
	local ret = ChoOrig_UpdateConstructionStatuses(self, ...)
	if mod_DustStormsAllowRockets then
		local statuses = self.construction_statuses
		for i = 1, #statuses do
			if statuses[i] == ConstructionStatus.RocketLandingDustStorm then
				table.remove(statuses, i)
				self:PickCursorObjColor()
				break
			end
		end
	end
	return ret
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
		data[ActiveMapData.MapSettings_DustStorm] or data["DustStorm_VeryHigh"]
	)
end

GlobalGameTimeThread("ChoGGi_Bakersfield_Thread", function()
	local dust_storm
	local wait_time = 0
	while true do
		if not dust_storm then
			dust_storm = GetDustStormDescr()
		end
		if dust_storm and IsGameRuleActive("ChoGGi_GreatBakersfield") then

			dust_storm.electrostatic = mod_DustStormsElectrostatic
			dust_storm.great = mod_DustStormsGreatStorm
			dust_storm.min_duration = SolDuration9
			dust_storm.max_duration = SolDuration9

			wait_time = MainCity:Random(HourDurationHalf)

			if not g_DustStormType then
				local rand = MainCity:Random(101)
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

		Sleep(1000)
	end
end)

-- don't break when mod option enabled
local classes = {
	"ElectricityGridElement",
	"LifeSupportGridElement",
}
local g = _G
for i = 1, #classes do
	local cls_obj = g[classes[i]]
	local func = cls_obj.CanBreak
	function cls_obj.CanBreak(...)
		if mod_DustStormsUnbreakableCP then
			return false
		end
		return func(...)
	end
end

-- cold areas
local ChoOrig_RandomMapGenerator_OnGenerateLogic = RandomMapGenerator.OnGenerateLogic
function RandomMapGenerator:OnGenerateLogic(env, ...)
	if IsGameRuleActive("ChoGGi_WinterWonderland") then
		self.ColdFeatureRadius = 100
		self.ColdAreaChance = 100
		self.ColdAreaCount = 1
		-- max map size * 4 (make sure everything is covered no matter where the area is)
		self.ColdAreaSize = range(4857600, 4857600)
	end
	-- testing
--~ 	if IsGameRuleActive("ChoGGi_WinterWonderland") then
--~ 		env.GenMarkerObj(ColdArea, point(0,0), {Range = 1214400})
--~ 		local marker = env.GenMarkerObj(PrefabFeatureMarker, point(0,0), {FeatureRadius = 607200, FeatureType = "Cold Area"})
--~ 		env.prefab_features[#env.prefab_features + 1] = marker
--~ 	end
	ChoOrig_RandomMapGenerator_OnGenerateLogic(self, env, ...)
end

local function StartupCode()
	if mod_DustStormsAllowMOXIEs and IsGameRuleActive("ChoGGi_GreatBakersfield") then
		RemoveSuspend(g_SuspendLabels, "MOXIE")
		RemoveSuspend(const.DustStormSuspendBuildings, "MOXIE")

		BuildingTemplates.MOXIE.suspend_on_dust_storm = false
		ClassTemplates.Building.MOXIE.suspend_on_dust_storm = false
		UpdateMOXIES()
	end

	if mod_ColdAreaGiveSubsurfaceHeaters then
		GrantTech("SubsurfaceHeating")
	end

	if mod_MeteorsMDSLasers then
		GrantTech("MeteorDefenseSystem")
	end

	if mod_MeteorsDefensiveTurrets then
		GrantTech("DefenseTower")
	end

	if mod_ColdAreaUnlockSubsurfaceHeaters then
		BuildingTemplates.SubsurfaceHeater.disabled_in_environment1 = ""
		BuildingTemplates.SubsurfaceHeater.disabled_in_environment2 = ""
		ClassTemplates.Building.SubsurfaceHeater.disabled_in_environment1 = ""
		ClassTemplates.Building.SubsurfaceHeater.disabled_in_environment2 = ""
	end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

function OnMsg.ClassesPostprocess()
		-- we need to update MOXIEs when they're built
		local ChoOrig_MOXIE_GameInit = MOXIE.GameInit
		function MOXIE:GameInit(...)
			ChoOrig_MOXIE_GameInit(self, ...)
			if IsGameRuleActive("ChoGGi_GreatBakersfield") then
				UpdateMOXIE(self)
			end
		end

	-- trand func from City.lua>function CreateRand(stable, ...) doesn't like < 2 (or maybe < 1, but whatever safety first)
	local ChoOrig_MapSector_new = MapSector.new
	function MapSector.new(...)
		local sector = ChoOrig_MapSector_new(...)
		-- good thing avg_heat is added when the sector is created
		if sector.avg_heat < 2 and IsGameRuleActive("ChoGGi_WinterWonderland") then
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
		challenge_mod = 100,
	})

	PlaceObj("GameRules", {
		description = table.concat(T(486621856457, "A team of Scientists argues over the satellite data as you quietly ponder the situation. It's going to be a long winter.")
			.. "\n\n" .. T(302535920011848, "The ground will always be icy everywhere (unlocks Subsurface Heaters from the get-go).")),
		display_name = T(293468065101, "Winter Wonderland"),
		flavor = T{"<grey><text><newline><right>Haemimont Games</grey><left>",
			text = T(838846202028, "I know! Let's organize a winter festival!"),
		},
		group = "Default",
		id = "ChoGGi_WinterWonderland",
		challenge_mod = 100,
	})

	PlaceObj("GameRules", {
		description = T(302535920011624, "Permanent dust storm (MOXIEs work at a reduced rate)."),
		display_name = T(302535920011625, "Great Bakersfield Dust Storm"),
		flavor = T(302535920011626, [[<grey>"The wind blew the big plate glass window in and all the others out. They went out of business right then and there."<newline><right>Michael Boyt</grey><left>]]),
		group = "Default",
		id = "ChoGGi_GreatBakersfield",
		challenge_mod = 100,
	})

	PlaceObj("GameRules", {
		description = T(302535920011627, "Have at least one dust devil on the map at all times (see mod options to change amount)."),
		display_name = T(302535920011628, "'74 Super Outbreak"),
		flavor = T(302535920011629, [[<grey>"'The Suck Zone'. It's the point basically when the twister... sucks you up. That's not the technical term for it, obviously."<newline><right>Dusty</grey><left>]]),
		group = "Default",
		id = "ChoGGi_Twister",
		challenge_mod = 100,
	})
end

-- restart threads
function SavegameFixups.ChoGGi_GameRulesPermanentDisasters_1()
  RestartGlobalGameTimeThread("ChoGGi_MeteorThreat_Thread")
  RestartGlobalGameTimeThread("ChoGGi_Twister_Thread")
  RestartGlobalGameTimeThread("ChoGGi_Bakersfield_Thread")
end

