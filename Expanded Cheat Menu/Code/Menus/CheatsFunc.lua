-- See LICENSE for terms

if ChoGGi.what_game ~= "Mars" then
	return
end

local pairs, type = pairs, type
local T = T

local ChoGGi_Funcs = ChoGGi_Funcs
local Translate = ChoGGi_Funcs.Common.Translate
local MsgPopup = ChoGGi_Funcs.Common.MsgPopup
local Random = ChoGGi_Funcs.Common.Random
local SelObject = ChoGGi_Funcs.Common.SelObject
local GetCursorWorldPos = GetCursorWorldPos
local GetCityLabels = ChoGGi_Funcs.Common.GetCityLabels

function ChoGGi_Funcs.Menus.TriggerFireworks()
	local city = Cities[ActiveMapID]
	local domes = city.labels.Domes or ""
	if #domes < 11 then
		for i = 1, #domes do
			Dome.TriggerFireworks(domes[i], const.HourDuration, 15)
		end
	else
		local domes_copy = table.copy(domes)
		table.shuffle(domes_copy)
		for i = 1, 10 do
			Dome.TriggerFireworks(domes_copy[i], const.HourDuration, 15)
		end
	end
end

function ChoGGi_Funcs.Menus.CaveIn()
	local TriggerCaveIn = TriggerCaveIn
	local IsValid = IsValid
	local ActiveMapID = ActiveMapID

	-- disable any struts around
	for _ = 1, 25 do
		local strut = TriggerCaveIn(ActiveMapID, GetCursorWorldPos())
		if IsValid(strut) and strut:IsKindOf("SupportStruts") then
			strut:CheatMalfunction()
		else
			break
		end
	end

end

function ChoGGi_Funcs.Menus.SpawnPOIs()
	local item_list = {}
	local c = 0

	local POIPresets = POIPresets
	for id, item in pairs(POIPresets) do
		c = c + 1
		item_list[c] = {
			text = Translate(item.display_name),
			value = id,
			icon = item.display_icon,
			hint = Translate(item.description),
		}
	end

	local function CallBackFunc(choices)
		if choices.nothing_selected then
			return
		end
		for i = 1, #choices do
			local value = choices[i].value
			if POIPresets[value] then
				CheatSpawnSpecialProjects(value)
			end
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000931--[[Spawn POIs]]),
		multisel = true,
	}
end

function ChoGGi_Funcs.Menus.UnlockBreakthroughs()
	local function reveal(anomaly)
		if not IsValid(anomaly) or anomaly.tech_action ~= "breakthrough" then
			return
		end
		anomaly:SetRevealed(true)
		anomaly:ScanCompleted(false)
		anomaly:delete()
	end
	MapForEach("map", "SubsurfaceAnomalyMarker", function(marker)
		if marker.tech_action == "breakthrough" then
			reveal(marker:PlaceDeposit())
			marker:delete()
		end
	end)
	MapForEach("map", "SubsurfaceAnomaly", reveal)
end

function ChoGGi_Funcs.Menus.MeteorStrike(_, _, input)
	local strike_pos
	if input == "keyboard" then
		strike_pos = GetCursorWorldPos()
	else
		strike_pos = GetRandomPassable(UICity)
	end

	ChoGGi_Funcs.Menus.DisasterTriggerMeteor("Meteor_High", "single", strike_pos)
end

function ChoGGi_Funcs.Menus.MissileStrike(_, _, input)
	local strike_pos
	if input == "keyboard" then
		strike_pos = GetCursorWorldPos()
	else
		strike_pos = GetRandomPassable(UICity)
	end

	ChoGGi_Funcs.Menus.DisasterTriggerMissle()
end

function ChoGGi_Funcs.Menus.LightningStrike(_, _, input)
	local strike_pos
	if input == "keyboard" then
		strike_pos = GetCursorWorldPos()
	else
		strike_pos = GetRandomPassable(UICity)
	end

	local dust_storm = table.rand(DataInstances.MapSettings_DustStorm)

	local strike_radius = dust_storm.strike_radius
	PlayFX("ElectrostaticStormArea", "start", nil, nil, strike_pos)
	PlayFX("ElectrostaticStorm", "hit-moment" .. Random(1, 4), nil, nil, strike_pos)
	local fuel_explosions = {}
	local IsValid = IsValid
	local IsObjInDome = IsObjInDome
	local IsCloser2D = IsCloser2D
	local FuelExplosion = FuelExplosion
	MapForEach(strike_pos, strike_radius + GetEntityMaxSurfacesRadius(),
			"Colonist", "Building", "Drone", "RCRover", "ResourceStockpileBase", function(obj)
		if not IsCloser2D(obj, strike_pos, strike_radius) or IsObjInDome(obj) then
			return
		end
		PlayFX("ElectrostaticStormObject", "start", nil, obj, strike_pos)
		if IsValid(obj) then
			if obj:IsKindOf("Drone") then
				obj:UseBattery(obj.battery)
			elseif obj:IsKindOf("RCRover") then
				obj:SetCommand("Malfunction")
			elseif obj:IsKindOf("UniversalStorageDepot") then
				if not obj:IsKindOf("RocketBase") and obj:GetStoredAmount("Fuel") > 0 then
					obj:CheatEmpty()
					fuel_explosions[#fuel_explosions + 1] = obj
				end
			elseif obj:IsKindOf("ResourceStockpileBase") then
				local amount = obj:GetStoredAmount()
				if obj.resource == "Fuel" and amount > 0 then
					obj:AddResourceAmount(-amount, true)
					fuel_explosions[#fuel_explosions + 1] = obj
				end
			elseif obj:IsKindOf("Building") then
				obj:SetSuspended(true, "Suspended", dust_storm.strike_suspend)
				if obj:IsKindOf("ElectricityStorage") then
					obj.electricity.current_storage = Max(0, obj.electricity.current_storage - dust_storm.strike_discharge)
				end
			elseif obj:IsKindOf("Colonist") then
				if not obj:IsDying() then
					obj:SetCommand("Die", "lighting strike")
				end
			end
		end

	end)
	for i = 1, #fuel_explosions do
		local obj = fuel_explosions[i]
		if IsValid(obj) then
			FuelExplosion(obj)
		end
	end
end

function ChoGGi_Funcs.Menus.CompleteConstructions()
	-- speed up buildings/ground
	SuspendPassEdits("ChoGGi_Funcs.Menus.CompleteConstructions")
  SuspendTerrainInvalidations("ChoGGi_Funcs.Menus.CompleteConstructions")
	CheatCompleteAllConstructions()
	ResumePassEdits("ChoGGi_Funcs.Menus.CompleteConstructions")
  ResumeTerrainInvalidations("ChoGGi_Funcs.Menus.CompleteConstructions")
end

function ChoGGi_Funcs.Menus.InfopanelCheats_Toggle()
	local config = config
	config.BuildingInfopanelCheats = not config.BuildingInfopanelCheats
	ReopenSelectionXInfopanel()
	ChoGGi.UserSettings.InfopanelCheats = config.BuildingInfopanelCheats

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		Translate(302535920001122--[[%s: HAXOR]]):format(ChoGGi.UserSettings.InfopanelCheats),
		T(302535920000696--[[Infopanel Cheats]])
	)
end

function ChoGGi_Funcs.Menus.InfopanelCheatsCleanup_Toggle()
	if ChoGGi.UserSettings.CleanupCheatsInfoPane then
		-- needs default?
		ChoGGi.UserSettings.CleanupCheatsInfoPane = false
	else
		ChoGGi.UserSettings.CleanupCheatsInfoPane = true
		ChoGGi_Funcs.InfoPane.InfopanelCheatsCleanup()
	end

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.CleanupCheatsInfoPane),
		T(302535920000698--[[Infopanel Cheats Cleanup]])
	)
end

local achievement_ids = {
	"AsteroidHopping",
	"BlueSunExportedAlot",
	"BlueSunProducedFunding",
	"BrazilConvertedWasteRock",
	"Built1000Buildings",
	"BuiltArtificialSun",
	"BuiltExcavator",
	"BuiltGeoscapeDome",
	"BuiltMoholeMine",
	"BuiltOmegaTelescope",
	"BuiltProjectMorpheus",
	"BuiltSeveralWonders",
	"BuiltSpaceElevator",
	"ChinaReachedHighPopulation",
	"ChinaTaiChiGardens",
	"ColonistWithRareTraits",
	"CompletedLandscapeProject",
	"CompletedMeltThePolarCapsSP",
	"CompletedMystery1",
	"CompletedMystery2",
	"CompletedMystery3",
	"CompletedMystery4",
	"CompletedMystery5",
	"CompletedMystery6",
	"CompletedOpenCity",
	"CuredColonists",
	"DeepScannedAllSectors",
	"EarthsickColonistStays",
	"EuropeResearchedAlot",
	"EuropeResearchedBreakthroughs",
	"FirstAnalyzedAnomaly",
	"FirstAndroid",
	"FirstBlueSky",
	"FirstChildBorn",
	"FirstDome",
	"FirstDomeSpire",
	"FirstHarvest",
	"FirstLiquidLake",
	"FirstNormalRain",
	"FirstRebornColonist",
	"FirstRefueledRocket",
	"FirstSeedsHarvest",
	"FirstShuttleHub",
	"FirstTreePlanted",
	"GatheredFunding",
	"Had100ColonistsInDome",
	"Had50AndroidsInDome",
	"HadColonistWith5Perks",
	"HadVegans",
	"IndiaBuiltDomes",
	"IndiaConvertedWasteRock",
	"IntotheUnknown",
	"JapanTrainedSpecialists",
	"JobDone",
	"Landed50Rockets",
	"LastFounderPassedColonyApproval",
	"MaxedAllTPs",
	"MaximumSatisfaction",
	"MissionSuccess",
	"Multitasking",
	"MysteriesofMars",
	"NewArcChurchMartianborns",
	"NewArkChurchHappyColonists",
	"NoMoreToxicRains",
	"PassedColonyApproval",
	"PerfectRun",
	"Reached1000Colonists",
	"Reached250Colonists",
	"ResearchedAllTechs",
	"RussiaExtractedAlot",
	"RussiaHadManyColonists",
	"ScannedAllSectors",
	"ShotDownAMeteorite",
	"SpaceDwarves",
	"SpaceExplorer",
	"SpaceYBuiltDrones",
	"SpaceYCompletedGoals",
	"USAGeoscapeDomeWithMegamall",
	"USAResearchedEngineering",
	"Willtheyhold",
}
function ChoGGi_Funcs.Menus.UnlockAchievements()
	local item_list = {}

	local AchievementPresets = AchievementPresets
	for i = 1, #achievement_ids do
		local id = achievement_ids[i]
		local item = AchievementPresets[id]

		if item then
			item_list[i] = {
				text = Translate(item.display_name),
				value = id,
				hint = Translate(item.how_to) .. "\n\n<image UI/Achievements/"
					.. item.image .. ".tga 2500>",
			}
		else
			item_list[i] = {
				text = id,
				value = id,
				hint = T(302535920001733--[[Missing DLC Achievement]]),
			}
		end
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end

		local AchievementUnlock = AchievementUnlock
		local XPlayerActive = XPlayerActive
		CreateRealTimeThread(function()
			for i = 1, #choice do
				AchievementUnlock(XPlayerActive, choice[i].value)
				WaitMsg("OnRender")
			end

			MsgPopup(
				#choice,
				T(302535920000318--[[Unlock]]) .. " " .. T(697482021580--[[Achievements]])
			)
		end)
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000318--[[Unlock]]) .. " " .. T(697482021580--[[Achievements]]),
		hint = title,
		multisel = true,
	}
end

function ChoGGi_Funcs.Menus.SpawnPlanetaryAnomalies()
	-- for "current" hint
	local spots = MarsScreenLandingSpots
	local count = 0
	for i = 1, #spots do
		if spots[i]:IsKindOf("PlanetaryAnomaly") then
			count = count + 1
		end
	end

	local item_list = {
		{text = 1, value = 1},
		{text = 5, value = 5},
		{text = 10, value = 10},
		{text = 15, value = 15},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 100, value = 100},
		{text = 250, value = 250},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then

			-- CheatBatchSpawnPlanetaryAnomalies() Batch Spawn Planetary Anomalies with at least 1 Breakthrough
			local lat, long
			for _ = 1, value do
				lat, long = GenerateMarsScreenPoI("anomaly")
				-- I assume they'll fix it so there isn't an inf loop
				if lat and long then
					PlaceObjectIn("PlanetaryAnomaly", MainMapID, {
						display_name = T(11234, "Planetary Anomaly"),
						longitude = long,
						latitude = lat,
					})
				end
			end

			MsgPopup(
				T(302535920000014--[[Spawned]]) .. ": " .. value,
				T(302535920001394--[[Spawn Planetary Anomalies]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920001394--[[Spawn Planetary Anomalies]]),
		hint = T(302535920000106--[[Current]]) .. ": " .. count,
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.SetOutsourceMaxOrderCount()
	local default_setting = ChoGGi.Consts.OutsourceMaxOrderCount
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 100, value = 100},
		{text = 150, value = 150},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
		{text = 2500, value = 2500},
		{text = 5000, value = 5000},
		{text = 10000, value = 10000},
		{text = 25000, value = 25000},
		{text = 50000, value = 50000},
		{text = 100000, value = 100000},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.OutsourceMaxOrderCount then
		hint = ChoGGi.UserSettings.OutsourceMaxOrderCount
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			ChoGGi_Funcs.Common.SetConsts("OutsourceMaxOrderCount", value)
			ChoGGi_Funcs.Common.SetSavedConstSetting("OutsourceMaxOrderCount")

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.OutsourceMaxOrderCount),
				T(970197122036, "Maximum Outsource Orders")
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(970197122036--[[Maximum Outsource Orders]]),
		hint = T(302535920000106--[[Current]]) .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.InstantResearch_toggle()
	ChoGGi.UserSettings.InstantResearch = ChoGGi_Funcs.Common.ToggleValue(ChoGGi.UserSettings.InstantResearch)

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.InstantResearch),
		T(302535920001278--[[Instant Research]])
	)
end

function ChoGGi_Funcs.Menus.DraggableCheatsMenu_Toggle()
	ChoGGi.UserSettings.DraggableCheatsMenu = ChoGGi_Funcs.Common.ToggleValue(ChoGGi.UserSettings.DraggableCheatsMenu)

	ChoGGi_Funcs.Common.DraggableCheatsMenu(ChoGGi.UserSettings.DraggableCheatsMenu)

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.DraggableCheatsMenu),
		T(302535920000232--[[Draggable Cheats Menu]])
	)
end

function ChoGGi_Funcs.Menus.KeepCheatsMenuPosition_Toggle()
	if ChoGGi.UserSettings.KeepCheatsMenuPosition then
		ChoGGi.UserSettings.KeepCheatsMenuPosition = nil
		ChoGGi_Funcs.Common.SetCheatsMenuPos()
	else
		local pos = XShortcutsTarget:GetPos()
		ChoGGi.UserSettings.KeepCheatsMenuPosition = pos
		ChoGGi_Funcs.Common.SetCheatsMenuPos(pos)
	end

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.KeepCheatsMenuPosition),
		T(302535920000325--[[Keep Cheats Menu Position]])
	)
end

function ChoGGi_Funcs.Menus.ResetAllResearch()
	local function CallBackFunc(answer)
		if answer then
			UIColony:InitResearch()
		end
	end
	ChoGGi_Funcs.Common.QuestionBox(
		T(6779--[[Warning]]) .. "!\n" .. T(302535920000238--[[Are you sure you want to reset all research (includes breakthrough tech)?

Buildings are still unlocked.]]),
		CallBackFunc,
		T(6779--[[Warning]]) .. "!"
	)
end

function ChoGGi_Funcs.Menus.DisasterTriggerUndergroundMarsquake()
	if not IsDlcAccessible("picard") then
		return
	end
	if ChoGGi_Funcs.Common.RetMapType() == "underground" then
		CheatTriggerUndergroundMarsquake()
	end
end
function ChoGGi_Funcs.Menus.DisasterTriggerMissle(amount)
	amount = amount or 1
	if amount == 1 then
		-- (pt, radius, count, delay_min, delay_max)
		StartBombard(
			SelObject() or GetCursorWorldPos(),
			-- somewhere between 1K and 2K is too small to target some buildings for whatever reason...
			2000,
			amount
		)
	else
		-- stop that popup msg (it triggers over n over)
		local osnp = OnScreenNotificationPresets
		local preset = osnp.Bombardment
		osnp.Bombardment = nil

		local GetRandomPassable = GetRandomPassable
		local Sleep = Sleep
		CreateGameTimeThread(function()
			for _ = 1, amount do
				StartBombard(
					GetRandomPassable(UICity),
					1000,
					1
				)
				Sleep(Random(100, 750))
			end
			-- restore popup
			osnp.Bombardment = preset
		end)
	end
end

function ChoGGi_Funcs.Menus.DisasterTriggerColdWave(severity)
	CreateGameTimeThread(function()
		local data = DataInstances.MapSettings_ColdWave
		local descr = data[severity] or data[ActiveMapData.MapSettings_ColdWave] or data.ColdWave_VeryLow
		StartColdWave(descr)
	end)
end
function ChoGGi_Funcs.Menus.DisasterTriggerDustStorm(severity, storm_type)
	CreateGameTimeThread(function()
		local data = DataInstances.MapSettings_DustStorm
		local descr = data[severity] or data[ActiveMapData.MapSettings_DustStorm] or data.DustStorm_VeryLow
		StartDustStorm(storm_type or "normal", descr)
	end)
end

function ChoGGi_Funcs.Menus.DisasterTriggerDustDevils(severity, major)
	local pos = SelObject() or GetCursorWorldPos()
	if type(pos) == "table" then
		pos = pos:GetPos()
	end

	local data = DataInstances.MapSettings_DustDevils
	local descr = data[severity] or data[ActiveMapData.MapSettings_DustDevils] or data.DustDevils_VeryLow
	GenerateDustDevil(pos, descr, nil, major):Start()
end
function ChoGGi_Funcs.Menus.DisasterTriggerMeteor(severity, meteors_type, pos)
	meteors_type = meteors_type or "single"
	pos = pos or SelObject() or GetCursorWorldPos()
  -- target object
	if IsValid(pos) then
		pos = pos.GetVisualPos and pos:GetVisualPos() or pos:GetPos()
	end

	local data = DataInstances.MapSettings_Meteor
	local descr = data[severity] or data[ActiveMapData.MapSettings_Meteor] or data.Meteor_VeryLow

	local orig_storm_radius = descr.storm_radius
	if meteors_type == "single" then
		-- defaults to 50000 (no good for aiming).
		descr.storm_radius = 2500
	end

	CreateGameTimeThread(function()
		MeteorsDisaster(descr, meteors_type, pos)
		descr.storm_radius = orig_storm_radius
	end)
end
function ChoGGi_Funcs.Menus.DisasterTriggerMetatronIonStorm()
	local pos = SelObject() or GetCursorWorldPos()
	if type(pos) == "table" then
		pos = pos:GetPos()
	end

	local const = const
	local storm = MetatronIonStorm:new()
	storm.expiration_time = Random(50 * const.HourDuration, 75 * const.HourDuration) + 14450
	storm:SetPos(pos)
	storm:SetAngle(Random(0, 21600))
end

do -- DisasterTriggerLightningStrike
	local dust_storm
	local strike_radius
	local fuel_explosions
	local fuel_exp_count
	local strike_pos

	local Sleep = Sleep
	local GetRandomPassable = GetRandomPassable
	local PlayFX = PlayFX
	local IsValid = IsValid
	local IsObjInDome = IsObjInDome
	local IsCloser2D = IsCloser2D
	local FuelExplosion = FuelExplosion
	local function MapForEachObjStrike(obj)
		if not IsCloser2D(obj, strike_pos, strike_radius) or IsObjInDome(obj) then
			return
		end
		PlayFX("ElectrostaticStormObject", "start", nil, obj, strike_pos)
		if IsValid(obj) then
			if obj:IsKindOf("Drone") then
				obj:UseBattery(obj.battery)
			elseif obj:IsKindOf("RCRover") then
				obj:SetCommand("Malfunction")
			elseif obj:IsKindOf("UniversalStorageDepot") then
				if not obj:IsKindOf("RocketBase") and obj:GetStoredAmount("Fuel") > 0 then
					obj:CheatEmpty()
					fuel_exp_count = fuel_exp_count + 1
					fuel_explosions[fuel_exp_count] = obj
				end
			elseif obj:IsKindOf("ResourceStockpileBase") then
				local amount = obj:GetStoredAmount()
				if obj.resource == "Fuel" and amount > 0 then
					obj:AddResourceAmount(-amount, true)
					fuel_exp_count = fuel_exp_count + 1
					fuel_explosions[fuel_exp_count] = obj
				end
			elseif obj:IsKindOf("Building") then
				obj:SetSuspended(true, "Suspended", dust_storm.strike_suspend)
				if obj:IsKindOf("ElectricityStorage") then
					obj.electricity.current_storage = Max(0, obj.electricity.current_storage - dust_storm.strike_discharge)
				end
			elseif obj:IsKindOf("Citizen") and not self:IsDying() then
				obj:SetCommand("Die", "lighting strike")
			end
		end
	end

	-- somewhat a copy/paste from StartDustStorm
	function ChoGGi_Funcs.Menus.DisasterTriggerLightningStrike(amount)
		-- set/reset some vars
		dust_storm = DataInstances.MapSettings_DustStorm.DustStorm_VeryHigh_1
		strike_radius = dust_storm.strike_radius
		fuel_explosions = {}
		fuel_exp_count = 0
		-- audio cue
		PlayFX("ElectrostaticStorm", "start")
		-- stick it in a thread so we can sleep
		CreateGameTimeThread(function()
			for _ = 1, amount or 1 do
				strike_pos = GetRandomPassable(UICity)
				PlayFX("ElectrostaticStormArea", "start", nil, nil, strike_pos)
				PlayFX("ElectrostaticStorm", "hit-moment" .. Random(1, 5), nil, nil, strike_pos)
				MapForEach(strike_pos, strike_radius + GetEntityMaxSurfacesRadius(), "Colonist", "Building", "Drone", "RCRover", "ResourceStockpileBase", MapForEachObjStrike)
				local exp = fuel_explosions or ""
				for i = 1, #exp do
					if IsValid(exp[i]) then
						FuelExplosion(exp[i])
					end
				end
				-- don't want to spam all at once
				Sleep(Random(100, 750))
			end
		end)
	end
end -- do

do -- DisastersTrigger
	local trigger_table = {
		Stop = ChoGGi_Funcs.Common.DisastersStop,
		ColdWave = ChoGGi_Funcs.Menus.DisasterTriggerColdWave,
		DustStorm = ChoGGi_Funcs.Menus.DisasterTriggerDustStorm,
		Meteor = ChoGGi_Funcs.Menus.DisasterTriggerMeteor,
		MetatronIonStorm = ChoGGi_Funcs.Menus.DisasterTriggerMetatronIonStorm,
		DustDevils = ChoGGi_Funcs.Menus.DisasterTriggerDustDevils,
		UndergroundMarsquake = ChoGGi_Funcs.Menus.DisasterTriggerUndergroundMarsquake,

		DustDevilsMajor = function()
			ChoGGi_Funcs.Menus.DisasterTriggerDustDevils(nil, "major")
		end,
		DustStormElectrostatic = function()
			ChoGGi_Funcs.Menus.DisasterTriggerDustStorm(nil, "electrostatic")
		end,
		DustStormGreat = function()
			ChoGGi_Funcs.Menus.DisasterTriggerDustStorm(nil, "great")
		end,
		MeteorStorm = function()
			ChoGGi_Funcs.Menus.DisasterTriggerMeteor(nil, "storm")
		end,
		MeteorMultiSpawn = function()
			ChoGGi_Funcs.Menus.DisasterTriggerMeteor(nil, "multispawn")
		end,
	}

	local function AddTableToList(t, c, list, text, disaster, types)
		types = types or {}
		local func_name = "DisasterTrigger" .. disaster
		local remove_name = disaster .. "_"
		-- blanky blank
		types[#types+1] = false
		-- go through the DataInstances
		for i = 1, #list do
			local rule = list[i]
			local severity = rule.name

			-- add rule settings to tooltip
			local hint = {}
			local hc = 0
			for key, value in pairs(rule) do
				if key ~= "name" and key ~= "use_in_gen" then
					hc = hc + 1
					hint[hc] = key .. ": " .. tostring(value)
				end
			end

			-- add one for each type
			for j = 1, #types do
				local d_type = types[j]
				local name = severity .. (d_type and (" " .. d_type) or "")

				-- add entry to the lookup table
				trigger_table[name] = function()
					local func = ChoGGi_Funcs.Menus[func_name]
					if type(func) == "function" then
						func(name, d_type)
					else
						-- GreenPlanet
						func = rawget(_G, "CheatTrigger" .. disaster)
						if type(func) == "function" then
							func(name, d_type)
						else
							func = rawget(_G, "Cheat" .. disaster)
							if type(func) == "function" then
								func(name, d_type)
							end
						end
					end

				end

				c = c + 1
				t[c] = {
					text = text .. ": " .. name:gsub(remove_name, ""),
					value = name,
					hint = table.concat(hint, "\n"),
				}
			end
		end
		return c
	end

	function ChoGGi_Funcs.Menus.DisastersTrigger()
		local missile_hint = T{302535920001372--[["Change the number on the end to fire that amount (ex: <color ChoGGi_green><str>25</color>)."]],
			str = T(302535920000246--[[Missle]]),
		}	.. "\n\n" .. T(302535920001546--[[Random delay added (to keep game from lagging on large amounts).]])
		local strike_hint = T{302535920001372--[[snipped]],
			str = T(302535920001374--[[LightningStrike]]),
		}
			.. "\n\n" .. T(302535920001546--[[snipped]])
		local default_mapdata_type = T(302535920000250--[[Default mapdata type]])

		local item_list = {
			{text = " " .. Translate(302535920000240--[[Stop]]) .. " " .. Translate(3983--[[Disasters]]), value = "Stop", hint = T(302535920000123--[[Stops most disasters]])},

			{text = Translate(4149--[[Cold Wave]]), value = "ColdWave", hint = default_mapdata_type},
			{text = Translate(13683--[[Underground Marsquakes]]), value = "UndergroundMarsquake"},

			{text = Translate(4142--[[Dust Devils]]), value = "DustDevils", hint = default_mapdata_type},
			{text = Translate(4142--[[Dust Devils]]) .. " " .. Translate(302535920000241--[[Major]]), value = "DustDevilsMajor", hint = default_mapdata_type},

			{text = Translate(4250--[[Dust Storm]]), value = "DustStorm", hint = default_mapdata_type},
			{text = Translate(5627--[[Great Dust Storm]]), value = "DustStormGreat", hint = default_mapdata_type},
			{text = Translate(5628--[[Electrostatic Dust Storm]]), value = "DustStormElectrostatic", hint = default_mapdata_type},

			{text = Translate(4146--[[Meteors]]), value = "Meteor", hint = default_mapdata_type},
			{text = Translate(4146--[[Meteors]]) .. " " .. Translate(302535920000245--[[Multi-Spawn]]), value = "MeteorMultiSpawn", hint = default_mapdata_type},
			{text = Translate(5620--[[Meteor Storm]]), value = "MeteorStorm", hint = default_mapdata_type},

			{text = Translate(302535920000251--[[Metatron Ion Storm]]), value = "MetatronIonStorm"},

			{text = Translate(302535920000246--[[Missle]]) .. " " .. 1, value = "Missle1", hint = missile_hint},
			{text = Translate(302535920000246--[[Missle]]) .. " " .. 50, value = "Missle50", hint = missile_hint},
			{text = Translate(302535920000246--[[Missle]]) .. " " .. 100, value = "Missle100", hint = missile_hint},
			{text = Translate(302535920000246--[[Missle]]) .. " " .. 500, value = "Missle500", hint = missile_hint},

			{text = Translate(302535920001373--[[Lightning Strike]]) .. " " .. 1, value = "LightningStrike1", hint = strike_hint},
			{text = Translate(302535920001373--[[Lightning Strike]]) .. " " .. 50, value = "LightningStrike50", hint = strike_hint},
			{text = Translate(302535920001373--[[Lightning Strike]]) .. " " .. 100, value = "LightningStrike100", hint = strike_hint},
			{text = Translate(302535920001373--[[Lightning Strike]]) .. " " .. 500, value = "LightningStrike500", hint = strike_hint},
		}
		-- add map settings for disasters
		local DataInstances = DataInstances
		local c = #item_list

		-- add any disaster map settings in DataInstances
		local name_lookup = {
			ColdWave = {
				display = T(4149--[[Cold Wave]]),
			},
			DustStorm = {
				display = T(4250--[[Dust Storm]]),
				types = {"major"},
			},
			DustDevils = {
				display = T(4142--[[Dust Devils]]),
				types = {"electrostatic", "great"},
			},
			Meteor = {
				display = T(4146--[[Meteors]]),
				types = {"storm", "multispawn"},
			},
			Marsquake = {
				display = T(382404446864--[[Marsquake]]),
			},
			RainsDisaster = {
				display = T(553301803055--[[Rain!]]),
			},
		}
		for key, value in pairs(DataInstances) do
			if key:sub(1, 12) == "MapSettings_" then
				local name = key:sub(13)
				local lookup = name_lookup[name]
				if lookup then
					c = AddTableToList(item_list, c, value, lookup.display, name, lookup.types)
				else
					-- any new disasters not yet added
					c = AddTableToList(item_list, c, value, name, name)
				end
			end
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			for i = 1, #choice do
				local value = choice[i].value
				if trigger_table[value] then
					trigger_table[value]()
				elseif value:find("Missle") then
					local amount = tonumber(value:sub(7))
					if amount then
						ChoGGi_Funcs.Menus.DisasterTriggerMissle(amount)
					end
				elseif value:find("LightningStrike") then
					local amount = tonumber(value:sub(16))
					if amount then
						ChoGGi_Funcs.Menus.DisasterTriggerLightningStrike(amount)
					end
				end

				MsgPopup(
					choice[i].text,
					T(3983, "Disasters")
				)
			end
		end

		ChoGGi_Funcs.Common.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = T(1694--[[Start]]) .. " " .. T(3983--[[Disasters]]),
			hint = T(302535920000252--[[Targeted to mouse cursor (use arrow keys to select and enter to start).]]),
			multisel = true,
		}
	end
end -- do

function ChoGGi_Funcs.Menus.ShowScanAnomaliesOptions()
	-- what did this do?
--~ 	BuildNames()

	local item_list = {
		{
			text = " " .. T(302535920001691--[[All]]),
			value = "All",
			hint = T(302535920000329--[[Scan all anomalies.]]),
		},
		{
			text = Translate(9--[[Anomaly]]),
			value = "SubsurfaceAnomaly",
			hint = T(22--[[Our scans have found some interesting readings in this Sector. Further analysis is needed.<newline><newline>Send an RC Explorer to analyze the Anomaly.]]),
			icon = "<image UI/Icons/Anomaly_Custom.tga 750>",
		},
	}
	local c = #item_list

	local names_lookup = {
		SubsurfaceAnomaly_aliens = {
			title = T(5616--[[Alien Artifact Analyzed]]),
			icon = "UI/Icons/Anomaly_Event.tga",
		},
		SubsurfaceAnomaly_breakthrough = {
			title = T(8--[[Breakthrough Tech]]),
			icon = "UI/Icons/Anomaly_Breakthrough.tga",
		},
		SubsurfaceAnomaly_complete = {
			title = T(3--[[Grant Research]]),
			icon = "UI/Icons/Anomaly_Research.tga",
		},
		SubsurfaceAnomaly_unlock = {
			title = T(2--[[Unlock Tech]]),
			icon = "UI/Icons/Anomaly_Tech.tga",
		},
		MetatronAnomaly = {
			title = T(9818--[[Metatron's Challenge]]),
		},
		MirrorSphereAnomaly = {
			title = T(1182--[[Mirror Sphere]]),
		},
	}

	ClassDescendantsList("SubsurfaceAnomaly", function(name, class)
		c = c + 1
		item_list[c] = 		{
			text = names_lookup[name].title or T(class.display_name),
			value = name,
			hint = T(class.description or 25--[[Anomaly Scanning]]),
			icon = "<image " .. (names_lookup[name].icon or "UI/Icons/Anomaly_Custom.tga") .. " 750>",
		}
	end)

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end

		for i = 1, #choice do
			local value = choice[i].value

			-- If 4 are selected that's all
			if value == "All" or #choice > 3 then
				local a = GetCityLabels("Anomaly")
				-- go backwards it'll be removed once scanned
				for j = #a, 1, -1 do
					a[j]:CheatScan()
				end
				-- no sense in doing other choices as we just did all
				break
			else
				local a = GetCityLabels("Anomaly")
				for j = #a, 1, -1 do
					local anomnom = a[j]
					if anomnom.class == value then
						anomnom:CheatScan()
					end
				end
			end
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(25--[[Anomaly Scanning]]),
		multisel = true,
	}
end

function ChoGGi_Funcs.Menus.MapExploration()
	local UICity = UICity
	local title = T(302535920001355--[[Map]]) .. " " .. T(5422--[[Exploration]])
	local hint_core = T(302535920000253--[[Core: Repeatable, exploit core resources.]])
	local hint_deep = T(302535920000254--[[Deep: unlock tech to exploit deep resources.]])
	local item_list = {
		{text = Translate(302535920000258--[[Reveal Map]]), value = 12, hint = T(302535920000259--[[Reveals the map squares]])},
		{text = Translate(302535920000260--[[Reveal Map (Deep)]]), value = 13, hint = T(302535920000261--[[Reveals the map and unlocks "Deep" resources]])},

		{text = Translate(302535920001691--[[All]]), value = 1, hint = hint_core .. "\n" .. hint_deep},
		{text = Translate(302535920000255--[[Deep]]), value = 2, hint = hint_deep},
		{text = Translate(302535920000256--[[Core]]), value = 3, hint = hint_core},

		{text = Translate(302535920000257--[[Deep Scan]]), value = 4, hint = hint_deep .. "\n" .. T(12227--[[Enabled]]) .. ": " .. g_Consts.DeepScanAvailable},
		{text = Translate(797--[[Deep Water]]), value = 5, hint = hint_deep .. "\n" .. T(12227--[[Enabled]]) .. ": " .. g_Consts.IsDeepWaterExploitable},
		{text = Translate(793--[[Deep Metals]]), value = 6, hint = hint_deep .. "\n" .. T(12227--[[Enabled]]) .. ": " .. g_Consts.IsDeepMetalsExploitable},
		{text = Translate(801--[[Deep Rare Metals]]), value = 7, hint = hint_deep .. "\n" .. T(12227--[[Enabled]]) .. ": " .. g_Consts.IsDeepPreciousMetalsExploitable},

		{text = Translate(6548--[[Core Water]]), value = 8, hint = hint_core},
		{text = Translate(6546--[[Core Metals]]), value = 9, hint = hint_core},
		{text = Translate(6550--[[Core Rare Metals]]), value = 10, hint = hint_core},
		{text = Translate(6556--[[Alien Imprints]]), value = 11, hint = hint_core},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local function ExploreDeep()
--~ 			ChoGGi_Funcs.Common.SetConsts("DeepScanAvailable", ChoGGi_Funcs.Common.ToggleBoolNum(Consts.DeepScanAvailable))
--~ 			ChoGGi_Funcs.Common.SetConsts("IsDeepWaterExploitable", ChoGGi_Funcs.Common.ToggleBoolNum(Consts.IsDeepWaterExploitable))
--~ 			ChoGGi_Funcs.Common.SetConsts("IsDeepMetalsExploitable", ChoGGi_Funcs.Common.ToggleBoolNum(Consts.IsDeepMetalsExploitable))
--~ 			ChoGGi_Funcs.Common.SetConsts("IsDeepPreciousMetalsExploitable", ChoGGi_Funcs.Common.ToggleBoolNum(Consts.IsDeepPreciousMetalsExploitable))
			GrantTech("DeepScanning")
			GrantTech("DeepWaterExtraction")
			GrantTech("DeepMetalExtraction")
		end
		local function ExploreCore()
			Msg("TechResearched", "CoreWater", UICity)
			Msg("TechResearched", "CoreMetals", UICity)
			Msg("TechResearched", "CoreRareMetals", UICity)
			Msg("TechResearched", "AlienImprints", UICity)
		end

		for i = 1, #choice do
			local value = choice[i].value
			if value == 1 then
				CheatMapExplore("deep scanned")
				ExploreCore()
			elseif value == 2 then
				ExploreDeep()
			elseif value == 3 then
				ExploreCore()
			elseif value == 4 then
--~ 				ChoGGi_Funcs.Common.SetConsts("DeepScanAvailable", ChoGGi_Funcs.Common.ToggleBoolNum(Consts.DeepScanAvailable))
				GrantTech("DeepScanning")
			elseif value == 5 then
--~ 				ChoGGi_Funcs.Common.SetConsts("IsDeepWaterExploitable", ChoGGi_Funcs.Common.ToggleBoolNum(Consts.IsDeepWaterExploitable))
				GrantTech("DeepWaterExtraction")
			elseif value == 6 then
				GrantTech("DeepMetalExtraction")
--~ 				ChoGGi_Funcs.Common.SetConsts("IsDeepMetalsExploitable", ChoGGi_Funcs.Common.ToggleBoolNum(Consts.IsDeepMetalsExploitable))
			elseif value == 7 then
				GrantTech("DeepMetalExtraction")
--~ 				ChoGGi_Funcs.Common.SetConsts("IsDeepPreciousMetalsExploitable", ChoGGi_Funcs.Common.ToggleBoolNum(Consts.IsDeepPreciousMetalsExploitable))
			elseif value == 8 then
				Msg("TechResearched", "CoreWater", UICity)
			elseif value == 9 then
				Msg("TechResearched", "CoreMetals", UICity)
			elseif value == 10 then
				Msg("TechResearched", "CoreRareMetals", UICity)
			elseif value == 11 then
				Msg("TechResearched", "AlienImprints", UICity)
			elseif value == 12 then
				CheatMapExplore("scanned")
			elseif value == 13 then
				CheatMapExplore("deep scanned")
			end
		end

		MsgPopup(
			T(302535920000262--[[Alice thought to herself. ""Now you will see a film made for children"".
Perhaps.
But I nearly forgot! You must close your eyes.
Otherwise you won't see anything."]]),
			title,
			{image = "UI/Achievements/TheRabbitHole.tga"}
		)
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = title,
		hint = T(302535920000902--[["Anything with Repeatable in the tooltip will spawn more items on the map.
Deep items will unlock the ability to exploit those resources."]]),
		multisel = true,
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.SpawnColonists()
	local ChoOrig_GenerateColonistData = GenerateColonistData

	local title = T(302535920000266--[[Spawn]]) .. " " .. T(547--[[Colonists]])
	local item_list = {
		{text = 1, value = 1},
		{text = 10, value = 10},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
		{text = 2500, value = 2500},
		{text = 5000, value = 5000},
		{text = 10000, value = 10000},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local age_check
		if choice.check1 then
			age_check = "Child"
		elseif choice.check2 then
			age_check = "Youth"
		elseif choice.check3 then
			age_check = "Adult"
		elseif choice.check4 then
			age_check = "Middle Aged"
		elseif choice.check5 then
			age_check = "Senior"
		end

		print(age_check)

		local value = choice.value
		if type(value) == "number" then

			-- override func CheatSpawnNColonists uses
			if age_check then
				function GenerateColonistData(city, _, ...)
					return ChoOrig_GenerateColonistData(city, age_check, ...)
				end
			end

			CheatSpawnNColonists(value)

			-- always restore func
			GenerateColonistData = ChoOrig_GenerateColonistData

			MsgPopup(
				ChoGGi_Funcs.Common.SettingState(choice.text, T(302535920000014--[[Spawned]])),
				title
			)

		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = title,
		hint = T(302535920000267--[[Colonist placing priority: Selected dome, Evenly between domes, or centre of map if no domes.]]),
		skip_sort = true,
		height = 650.0,
		checkboxes = {
			{title = TraitPresets.Child.display_name,
				hint = T(302535920000840--[[All colonists spawn as this age.]]),
			},
			{title = TraitPresets.Youth.display_name,
				hint = T(302535920000840--[[All colonists spawn as this age.]]),
			},
			{title = TraitPresets.Adult.display_name,
				hint = T(302535920000840--[[All colonists spawn as this age.]]),
			},
			{title = TraitPresets["Middle Aged"].display_name,
				hint = T(302535920000840--[[All colonists spawn as this age.]]),
				level = 2,
			},
			{title = TraitPresets.Senior.display_name,
				hint = T(302535920000840--[[All colonists spawn as this age.]]),
				level = 2,
			},
		},
	}
end

do -- StartMystery
	local function StartMystery(mystery_id, instant)
--~ 		local UIColony = UIColony

		-- Inform people of actions
		ChoGGi.UserSettings.ShowMysteryMsgs = true

--~ 		UIColony.mystery_id = mystery_id

--~ 		local TechDef = TechDef
--~ 		for tech_id, tech in pairs(TechDef) do
--~ 			if tech.mystery == mystery_id then
--~ 				if not UIColony.tech_status[tech_id] then
--~ 					UIColony.tech_status[tech_id] = {points = 0, field = tech.group}
--~ 					tech:EffectsInit(UIColony)
--~ 				end
--~ 			end
--~ 		end

		-- else CheatStartMystery will mark the current one as finished
		UIColony.mystery = false
		UIColony.mystery_id = ""

		-- CheatStartMystery checks for cheats enabled...
		local ChoOrig_CheatsEnabled = CheatsEnabled
		CheatsEnabled = function()
			return true
		end
		CheatStartMystery(mystery_id)
		CheatsEnabled = ChoOrig_CheatsEnabled

--~ 		-- might help
--~ 		if UIColony.mystery then
--~ 			UIColony.mystery:ApplyMysteryResourceProperties()
--~ 		end

		-- Instant start
		if instant then
			local seqs = UIColony.mystery.seq_player.seq_list[1]
			for i = 1, #seqs do
				local seq = seqs[i]
				if seq:IsKindOf("SA_WaitExpression") then
					seq.duration = 0
					seq.expression = nil
				elseif seq:IsKindOf("SA_WaitMarsTime") then
					seq.duration = 0
					seq.rand_duration = 0
					break
				end
			end
		end


--~ 		-- needed to start mystery
--~ 		UIColony.mystery.seq_player:AutostartSequences()
	end

	function ChoGGi_Funcs.Menus.ShowMysteryList()
		local item_list = {}
		local mysteries = ChoGGi.Tables.Mystery
		for i = 1, #mysteries do
			item_list[i] = {
				text = mysteries[i].number .. ": " .. mysteries[i].name,
				value = mysteries[i].class,
				hint = mysteries[i].description .. "\n\n\n\n<image " .. mysteries[i].image .. ">\n\n",
			}
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local value = choice[1].value
			if choice[1].check1 then
				-- Instant
				StartMystery(value, true)
			else
				StartMystery(value)
			end
		end

		ChoGGi_Funcs.Common.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = T(302535920000268--[[Start A Mystery]]),
			hint = T(6779--[[Warning]]) .. ": " .. T(302535920000269--[["Adding a mystery is cumulative, this will NOT replace existing mysteries."]]),
			skip_sort = true,
			checkboxes = {
				{
					title = T(302535920000270--[[Instant Start]]),
					hint = T(302535920000271--[["May take up to one Sol to ""instantly"" activate mystery."]]),
				},
			},
		}
	end
end -- do

do -- Remove Mystery
	-- loops through all the sequences and adds the logs we've already seen
	local function ShowMysteryLog(choice)
		local myst_id
		if type(choice) == "string" then
			myst_id = choice
		else
			myst_id = choice[1].value
		end
		local msgs = {myst_id .. "\n\n" .. T{302535920000272--[["To play back speech press the ""<color ChoGGi_green><str></color>"" checkbox and type in
g_Voice:Play(o.speech)"]],
			str = T(302535920000040--[[Exec Code]]),
		}	.. "\n"}
		local c = #msgs
		local s_SeqListPlayers = s_SeqListPlayers
		-- 1 is some default map thing
		if #s_SeqListPlayers < 2 then
			return
		end
		for i = 1, #s_SeqListPlayers do
			if i > 1 then
				local seq_list = s_SeqListPlayers[i].seq_list
				if seq_list.name == myst_id then
					for j = 1, #seq_list do
						local scenarios = seq_list[j]
						local state = s_SeqListPlayers[i].seq_states[scenarios.name]
						-- have we started this seq yet?
						if state then
							for k = 1, #scenarios do
								local seq = scenarios[k]
								if seq:IsKindOf("SA_WaitMessage") then
									-- add to msg list
									c = c + 1
									msgs[c] = {
										[" "] = T(302535920000273--[[Speech]]) .. ": "
											.. Translate(seq.voiced_text) .. "\n\n\n\n"
											.. T(302535920000274--[[Message]]) .. ": "
											.. Translate(seq.text),
										speech = seq.voiced_text,
										class = Translate(seq.title)
									}
								end
							end
						end
					end
				end
			end
		end
		-- display to user
		OpenExamine(msgs, point(550, 100))
	end

	function ChoGGi_Funcs.Menus.MysteryLog()
		local s_SeqListPlayers = s_SeqListPlayers
		if not s_SeqListPlayers then
			return
		end
		if #s_SeqListPlayers == 1 then
			MsgPopup(
				"0",
				T(5661, "Mystery Log")
			)
			return
		end

		local item_list = {}
		local c = 0
		local mysteries = ChoGGi.Tables.Mystery
		for i = 1, #s_SeqListPlayers do
			-- 1 is always there from map loading
			if i > 1 then
				local seq_list = s_SeqListPlayers[i].seq_list
				if not seq_list[1] then
					MsgPopup(
						"0",
						T(5661, "Mystery Log")
					)
					return
				end
				local totalparts = #seq_list[1]
				local id = seq_list.name
				if mysteries[id] then
					local ip = s_SeqListPlayers[i].seq_states[seq_list[1].name].ip

					s_SeqListPlayers[i].mystery_idx = i
					c = c + 1
					item_list[c] = {
						text = id .. ": " .. mysteries[id].name,
						value = id,
						func = id,
						mystery_idx = i,
						hint = "<image " .. mysteries[id].image .. ">\n\n\n<color 255 75 75>"
							.. T(302535920000275--[[Total parts]]) .. "</color>: " .. totalparts
							.. " <color 255 75 75>" .. T(302535920000289--[[Current part]])
							.. "</color>: " .. (ip or T(302535920000276--[[done?]]))
							.. "\n\n" .. mysteries[id].description,
					}
				end
			end
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			choice = choice[1]

			--~ local value = choice.value
			local mystery_idx = choice.mystery_idx
			local ThreadsMessageToThreads = ThreadsMessageToThreads

			if choice.check2 then
				-- remove all
				for i = #s_SeqListPlayers, 1, -1 do
					if i > 1 then
						s_SeqListPlayers[i]:delete()
					end
				end
				for t in pairs(ThreadsMessageToThreads) do
					if t.player and t.player.seq_list.file_name then
						DeleteThread(t.thread)
						t = nil
					end
				end
				MsgPopup(
					T(302535920000277--[[Removed all!]]),
					T(5661--[[Mystery Log]])
				)
			elseif choice.check1 then
				-- remove mystery
				for i = #s_SeqListPlayers, 1, -1 do
					if s_SeqListPlayers[i].mystery_idx == mystery_idx then
						s_SeqListPlayers[i]:delete()
						break
					end
				end
				for t in pairs(ThreadsMessageToThreads) do
					if t.player and t.player.mystery_idx == mystery_idx then
						DeleteThread(t.thread)
						t = nil
					end
				end
				MsgPopup(
					choice.text .. ": " .. T(3486--[[Mystery]]) .. " " .. T(302535920000278--[[Removed]]) .. "!",
					T(5661--[[Mystery Log]])
				)
--~ 			elseif value then
--~ 				-- next step
--~ 				ChoGGi_Funcs.Menus.NextMysterySeq(value, mystery_idx)
			end

		end

		ChoGGi_Funcs.Common.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			custom_type = 6,
			custom_func = ShowMysteryLog,
			title = T(5661--[[Mystery Log]]),
--~ 			hint = T(302535920000280--[[Skip the timer delay, and optionally skip the requirements (applies to all mysteries that are the same type).
--~ 	Sequence part may have more then one check, you may have to skip twice or more.
--~ 	Double right-click selected mystery to review past messages.]]),
			checkboxes = {
				{
					title = T(302535920000281--[[Remove]]),
					hint = T(6779--[[Warning]]) .. ": " .. T(302535920000282--[[This will remove the mystery, if you start it again; it'll be back to the start.]]),
					checked = true,
				},
				{
					title = T(302535920000283--[[Remove All]]),
					hint = T(6779--[[Warning]]) .. ": " .. T(302535920000284--[[This will remove all the mysteries!]]),
				},
			},
		}
	end

--~ 	function ChoGGi_Funcs.Menus.NextMysterySeq(mystery, mystery_idx)
--~ 		local g_Classes = g_Classes

--~ 		local wait_classes = {"SA_WaitMarsTime", "SA_WaitTime"}
--~ 		local thread_classes = {"SA_WaitMarsTime", "SA_WaitTime", "SA_RunSequence"}
--~ 		local warning = "\n\n" .. T(302535920000285--[["Click ""Ok"" to skip requirements (Warning: may cause issues later on, untested)."]])
--~ 		local name = T(3486--[[Mystery]]) .. ": " .. ChoGGi.Tables.Mystery[mystery].name

--~ 		local ThreadsMessageToThreads = ThreadsMessageToThreads
--~ 		for t in pairs(ThreadsMessageToThreads) do
--~ 			if t.player and t.player.mystery_idx == mystery_idx then

--~ 				-- only remove finished waittime threads, can cause issues removing other threads
--~ 				if t.finished == true and t.action:IsKindOfClasses(thread_classes) then
--~ 					DeleteThread(t.thread)
--~ 				end

--~ 				local Player = t.player
--~ 				local seq_list = t.sequence
--~ 				local state = Player.seq_states
--~ 				local ip = state[seq_list.name].ip


--~ 				for i = 1, #seq_list do
--~ 					-- skip older seqs
--~ 					if i >= ip then
--~ 						local seq = seq_list[i]
--~ 						local title = name .. " " .. T(302535920000286--[[Part]]) .. ": " .. ip

--~ 						-- seqs that add delays/tasks
--~ 						if seq:IsKindOfClasses(wait_classes) then
--~ 							ChoGGi.Temp.SA_WaitMarsTime_StopWait = {mystery_idx = mystery_idx}
--~ 							--we don't want to wait
--~ 							seq.wait_type = g_Classes.SA_WaitMarsTime:GetDefaultPropertyValue("wait_type")
--~ 							seq.wait_subtype = g_Classes.SA_WaitMarsTime:GetDefaultPropertyValue("wait_subtype")
--~ 							seq.loops = g_Classes.SA_WaitMarsTime:GetDefaultPropertyValue("loops")
--~ 							seq.duration = 1
--~ 							seq.rand_duration = 1
--~ 							local wait = t.action
--~ 							wait.wait_type = g_Classes.SA_WaitMarsTime:GetDefaultPropertyValue("wait_type")
--~ 							wait.wait_subtype = g_Classes.SA_WaitMarsTime:GetDefaultPropertyValue("wait_subtype")
--~ 							wait.loops = g_Classes.SA_WaitMarsTime:GetDefaultPropertyValue("loops")
--~ 							wait.duration = 1
--~ 							wait.rand_duration = 1

--~ 							t.finished = true
--~ 							-- may not be needed
--~ 							Player:UpdateCurrentIP(seq_list)
--~ 							-- let them know
--~ 							MsgPopup(
--~ 								T(302535920000287--[[Timer delay removed (may take upto a Sol).]]),
--~ 								title
--~ 							)
--~ 							break

--~ 						elseif seq:IsKindOf("SA_WaitExpression") then
--~ 							seq.duration = 1
--~ 							local function CallBackFunc(answer)
--~ 								if answer then
--~ 									seq.expression = nil
--~ 									--the first SA_WaitExpression always has a SA_WaitMarsTime, if they're skipping the first then i doubt they want this
--~ 									if i == 1 or i == 2 then
--~ 										ChoGGi.Temp.SA_WaitMarsTime_StopWait = {mystery_idx = mystery_idx, again = true}
--~ 									else
--~ 										ChoGGi.Temp.SA_WaitMarsTime_StopWait = {mystery_idx = mystery_idx}
--~ 									end

--~ 									t.finished = true
--~ 									Player:UpdateCurrentIP(seq_list)
--~ 								end
--~ 							end
--~ 							ChoGGi_Funcs.Common.QuestionBox(
--~ 								T(302535920000288--[[Advancement requires]]) .. ": "
--~ 									.. seq.expression .. "\n\n"
--~ 									.. T(302535920000290--[[Time duration has been set to 0 (you still need to complete the requirements).
--~ 	Wait for a Sol or two for it to update (should give a popup msg).]]) .. warning,
--~ 								CallBackFunc,
--~ 								title
--~ 							)
--~ 							break

--~ 						elseif seq:IsKindOf("SA_WaitMsg") then
--~ 							local function CallBackFunc(answer)
--~ 								if answer then
--~ 									ChoGGi.Temp.SA_WaitMarsTime_StopWait = {mystery_idx = mystery_idx, again = true}
--~ 									-- send fake msg (ok it's real, but it hasn't happened)
--~ 									Msg(seq.msg)
--~ 									Player:UpdateCurrentIP(seq_list)
--~ 								end
--~ 							end
--~ 							ChoGGi_Funcs.Common.QuestionBox(
--~ 								T(302535920000288--[[Advancement requires]]) .. ": " .. seq.msg .. warning,
--~ 								CallBackFunc,
--~ 								title
--~ 							)
--~ 							break

--~ 						elseif seq:IsKindOf("SA_WaitResearch") then
--~ 							local function CallBackFunc(answer)
--~ 								if answer then
--~ 									GrantTech(seq.Research)
--~ 									t.finished = true
--~ 									Player:UpdateCurrentIP(seq_list)
--~ 								end
--~ 							end
--~ 							ChoGGi_Funcs.Common.QuestionBox(
--~ 								T(302535920000288--[[Advancement requires]]) .. ": " .. seq.Research .. warning,
--~ 								CallBackFunc,
--~ 								title
--~ 							)

--~ 						elseif seq:IsKindOf("SA_RunSequence") then
--~ 							local function CallBackFunc(answer)
--~ 								if answer then
--~ 									seq.wait = false
--~ 									t.finished = true
--~ 									Player:UpdateCurrentIP(seq_list)
--~ 								end
--~ 							end
--~ 							ChoGGi_Funcs.Common.QuestionBox(
--~ 								Translate(302535920000291--[[Waiting for %s to finish.
--~ 	Skip it?]]):format(seq.sequence),
--~ 								CallBackFunc,
--~ 								title
--~ 							)

--~ 						end -- If seq type

--~ 					end --if i >= ip
--~ 				end --for seq_list

--~ 			end --if mystery thread
--~ 		end --for t

--~ 	end

end -- do

function ChoGGi_Funcs.Menus.UnlockAllBuildings_Toggle()
	local item_list = {
		{text = Translate(302535920000547--[[Lock]]), value = "Lock"},
		{text = Translate(302535920000318--[[Unlock]]), value = "Unlock"},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end

		if choice[1].value == "Lock" then
			-- reverse what the unlock cheat does
			local bmpo = BuildMenuPrerequisiteOverrides
			for id, value in pairs(bmpo) do
				if value == true then
					bmpo[id] = nil
				end
			end
		else
			CheatUnlockAllBuildings()
		end

		ChoGGi_Funcs.Common.UpdateBuildMenu()
		MsgPopup(
			Translate(302535920000293--[[%s: all buildings for construction.]]):format(choice[1].text),
			T(302535920000337--[[Toggle Unlock All Buildings]])
		)
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000337--[[Toggle Unlock All Buildings]]),
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.AddResearchPoints()
	local item_list = {
		{text = Translate(302535920001084--[[Reset]]), value = "Reset", hint = T(302535920000292--[[Resets sponsor points to default for that sponsor]])},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
		{text = 2500, value = 2500},
		{text = 5000, value = 5000},
		{text = 10000, value = 10000},
		{text = 25000, value = 25000},
		{text = 50000, value = 50000},
		{text = 100000, value = 100000},
		{text = 100000000, value = 100000000},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if type(value) == "number" then
			UIColony:AddResearchPoints(value)
		elseif value == "Reset" then
			local reset = GetMissionSponsor().research_points or 100
			g_Consts.SponsorResearch = reset
--~ 			Consts.SponsorResearch = reset
		end
		MsgPopup(
			ChoGGi_Funcs.Common.SettingState(choice.text),
			T(302535920000295--[[Add Research Points]])
		)
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000295--[[Add Research Points]]),
		hint = T(302535920000296--[[If you need a little boost (or a lotta boost) in research.]]),
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.OutsourcingFree_Toggle()
	ChoGGi_Funcs.Common.SetConsts("OutsourceResearchCost", ChoGGi_Funcs.Common.NumRetBool(Consts.OutsourceResearchCost, 0, ChoGGi.Consts.OutsourceResearchCost))
	ChoGGi_Funcs.Common.SetSavedConstSetting("OutsourceResearchCost")

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		Translate(302535920000297--[["%s
Best hope you picked India as your Mars sponsor..."]]):format(ChoGGi.UserSettings.OutsourceResearchCost),
		T(302535920000355--[[Outsourcing For Free]])
	)
end

function ChoGGi_Funcs.Menus.BreakThroughsOmegaTelescope_Set()
	local default_setting = ChoGGi.Consts.OmegaTelescopeBreakthroughsCount
	local MaxAmount = #UIColony.tech_field.Breakthroughs
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 6, value = 6},
		{text = 12, value = 12},
		{text = 24, value = 24},
		{text = MaxAmount, value = MaxAmount, hint = T(302535920000298--[[Max amount in UIColony.tech_field list, you could make the amount larger if you want (an update/mod can add more).]])},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.OmegaTelescopeBreakthroughsCount then
		hint = ChoGGi.UserSettings.OmegaTelescopeBreakthroughsCount
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			const.OmegaTelescopeBreakthroughsCount = value
			ChoGGi_Funcs.Common.SetSavedConstSetting("OmegaTelescopeBreakthroughsCount")

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				Translate(302535920000299--[[%s: Research is what I'm doing when I don't know what I'm doing.]]):format(choice[1].text),
				T(302535920000359--[[Breakthroughs From OmegaTelescope]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000359--[[Breakthroughs From OmegaTelescope]]),
		hint = T(302535920000106--[[Current]]) .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.BreakThroughsAllowed_Set()
	local default_setting = ChoGGi.Consts.BreakThroughTechsPerGame
	local MaxAmount = #UIColony.tech_field.Breakthroughs
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 26, value = 26, hint = T(302535920000301--[[Doubled the base amount.]])},
		{text = MaxAmount, value = MaxAmount, hint = T(302535920000298--[[Max amount in UIColony.tech_field list, you could make the amount larger if you want (an update/mod can add more).]])},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.BreakThroughTechsPerGame then
		hint = ChoGGi.UserSettings.BreakThroughTechsPerGame
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			const.BreakThroughTechsPerGame = value
			ChoGGi_Funcs.Common.SetSavedConstSetting("BreakThroughTechsPerGame")

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				Translate(302535920000302--[[%s: Strings M R T]]):format(choice[1].text),
				T(302535920000357--[[Set Amount Of Breakthroughs Allowed]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000303--[[BreakThroughs Allowed]]),
		hint = T(302535920000106--[[Current]]) .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.ResearchQueueSize_Set()
	local default_setting = ChoGGi.Consts.ResearchQueueSize
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 5, value = 5},
		{text = 10, value = 10},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
	}

	local hint = default_setting
	local ResearchQueueSize = ChoGGi.UserSettings.ResearchQueueSize
	if ResearchQueueSize then
		hint = ResearchQueueSize
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then

			const.ResearchQueueSize = value
			ChoGGi_Funcs.Common.SetSavedConstSetting("ResearchQueueSize")

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				ChoGGi.UserSettings.ResearchQueueSize,
				T(302535920000305--[[Research Queue Size]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000305--[[Research Queue Size]]),
		hint = T(302535920000106--[[Current]]) .. ": " .. hint,
		skip_sort = true,
	}
end

do -- ResearchRemove
	local function UpdateColonistPref(city)
		city:ForEachLabelObject("Colonist", "ChangeWorkplacePerformance")
		city:ForEachLabelObject("Workplace", "UpdatePerformance")
	end
	-- reset whatever we can
	local lookup_gvalue = {
		-- global values
		RoverCommandAI = "g_RoverAIResearched",
		ConstructionNanites = "g_ConstructionNanitesResearched",
		ExtractorAI = "g_ExtractorAIResearched",
		EternalFusion = "g_EternalFusionResearched",
		WirelessPower = "g_WirelessPower",
		DustRepulsion = "g_DustRepulsion",
		MartianbornStrength = "g_MartianbornStrength",
		["Vocation-Oriented Society"] = "g_VocationOrientedSociety",
		ForeverYoung = "g_SeniorsCanWork",
		-- other
		SustainedWorkload = function(city)
			city:ForEachLabelObject("Workplace", "UpdatePerformance")
		end,
		InspiringArchitecture = function(city)
			city:ForEachLabelObject("Colonist", Notify, "UpdateMorale")
		end,
		PrintedElectronics = function(city)
			city:ForEachLabelObject("DroneFactory", "ChangeDroneConstructionResource", "Electronics")
		end,
		NanoRefinement = function()
			local IsKindOf = IsKindOf
			MapForEach("map", "DepositExploiter", function(obj)
				if IsKindOf(obj, "BaseBuilding") then
					obj:UpdateConsumption()
					if obj:HasMember("DepositChanged") then
						obj:DepositChanged()
					end
					obj:UpdateWorking()
				end
			end)
		end,
		MartianbornIngenuity = function(city)
			-- the tech unlock uses param1 as a positive number (Lua\Units\Colonist.lua, line: 1074)
			local amount = TechDef.MartianbornIngenuity.param1
			if type(amount) == "number" then
				amount = -amount
			else
				-- just in case
				amount = 0
			end

			local display_text = Translate(7587--[[<green>Martianborn Ingenuity <amount></color>]])
			local domes = city.labels.Dome or ""
			for i = 1, #domes do
				local colonists = domes[i].labels.Martianborn or ""
				for j = 1, #colonists do
					colonists[j]:SetModifier("performance", "MartianbornIngenuity", amount, 0, display_text)
				end
			end
		end,

		NocturnalAdaptation = function(city)
			g_NocturnalAdaptation = false
			UpdateColonistPref(city)
		end,
		GeneralTraining = UpdateColonistPref,
		ProductivityTraining = UpdateColonistPref,
		EmergencyTraining = UpdateColonistPref,
		SystematicTraining = UpdateColonistPref,
	}

	function ChoGGi_Funcs.Menus.ResearchRemove()
		local title = T(311--[[Research]]) .. " " .. T(302535920000281--[[Remove]])
		local item_list = {}
		local c = 0

		local g = _G
		local UIColony = g.UIColony
		local UICity = g.UICity
		local TechDef = g.TechDef

		local tech_status = UIColony.tech_status or ""
		for id, status in pairs(tech_status) do
			if status.researched then
				local tech = TechDef[id]
				local text = Translate(tech.display_name)
				-- remove " from that one tech...
				if text:find("\"") then
					text = text:gsub("\"", "")
				end
				c = c + 1
				item_list[c] = {
					text = text,
					value = id,
					icon = "<image " .. tech.icon .. " 250>",
					hint = Translate(T{tech.description, tech}) .. "\n\n" .. T(1000097--[[Category]]) .. ": " .. tech.group .. "\n\n<image " .. tech.icon .. " 1500>",
				}
			end
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end

			for i = 1, #choice do
				local tech_id = choice[i].value

				-- some tech changes a global value we reset that here
				local global_value = lookup_gvalue[tech_id]
				if global_value then
					if type(global_value) == "function" then
						global_value(UICity)
					else
						g[global_value] = false
					end
				end
				-- the entry needed to reset it in the research screen
				local tech_status = UIColony.tech_status[tech_id]
				if tech_status then
					tech_status.researched = nil
					tech_status.new = nil
				end
			end

			-- If we locked any buildings and the buildmenu is open
			ChoGGi_Funcs.Common.UpdateBuildMenu()

			MsgPopup(
				Translate(302535920000315--[[%s %s tech(s): Unleash your inner Black Monolith Mystery.]]):format("", #choice),
				title
			)
		end
		if #item_list == 0 then
			MsgPopup(
				T(302535920000089--[[Nothing left]]),
				title
			)
			return
		end

		ChoGGi_Funcs.Common.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = title,
			hint = T(302535920001495--[[This tries to reverse the changes made when the tech is researched (emphasis on tries).]]),
			multisel = true,
			height = 800,
		}
	end
end -- do

do -- ResearchTech
	local research_checked
	local ValidateImage = ChoGGi_Funcs.Common.ValidateImage
	local IsTechResearched = IsTechResearched

	local mystery_costs = {
		SolExploration = 5000,
		AlienDiggersDestruction = 20000,
		AlienDiggersDetection = 20000,
		XenoExtraction = 20000,
		["Anti-Sphere Shield"] = 5000,
		["Purpose of the Spheres"] = 5000,
		["Xeno-Terraforming"] = 20000,
		NumberSixTracing = 20000,
		WildfireCure = 90000,
		CrystallineFrequencyJamming = 3000,
		IonStormPrediction = 5000,
	}
	-- needed to be able to unlock/research some mystery tech
	local function AllowMysteryTech(id, colony)
		-- add tech_status if it's a mystery tech from a different mystery
		if not colony.tech_status[id] then
			colony.tech_status[id] = {
				field = "Mysteries",
				points = 0,
			}
			-- Instead of incrementing costs
			if mystery_costs[id] then
				colony.tech_status[id].cost = mystery_costs[id]
			end
		end
		if not table.find(colony.tech_field.Mysteries, id) then
			colony.tech_field.Mysteries[#colony.tech_field.Mysteries+1] = id
		end
	end

	-- tech_func = DiscoverTech_Old/GrantTech
	local function ResearchTechGroup(tech_func, group)
		local TechDef = TechDef
		local UIColony = UIColony
		tech_func = _G[tech_func]

		if not tech_func then
			tech_func = DiscoverTech_Old
		end

		for tech_id, tech in pairs(TechDef) do
			if tech.group == group then
				if tech.group == "Mysteries" then
					AllowMysteryTech(tech_id, UIColony)
				end
				tech_func(tech_id)
			end
		end
	end

	local special_techs = {
		Breakthroughs = true,
		Mysteries = true,
		Storybits = true,
	}
	local function AllRegularTechs(tech_func)
		local TechFields = TechFields
		for key in pairs(TechFields) do
			if not special_techs[key] then
				ResearchTechGroup(tech_func, key)
			end
		end
	end
	ChoGGi_Funcs.Menus.AllRegularTechs = AllRegularTechs

	function ChoGGi_Funcs.Menus.ResearchTech()
		local title = T(311--[[Research]]) .. " / " .. T(302535920000318--[[Unlock]]) .. " " .. T(3734--[[Tech]])
		local item_list = {
			{
				text = "	" .. T(302535920000306--[[Everything]]),
				value = "Everything",
				hint = T(302535920000307--[[All the tech/breakthroughs/mysteries]]),
			},
			{
				text = "	" .. T(302535920000308--[[All Tech]]),
				value = "AllTech",
				hint = T(302535920000309--[[All the regular tech]]),
			},
		}
		local c = #item_list

		-- add tech fields
		local TechFields = TechFields
		for key, value in pairs(TechFields) do
			c = c + 1
			item_list[c] = {
				text = " " .. T(value.display_name),
				value = key,
				hint = T(value.description),
			}
		end

		local TechDef = TechDef
		-- so I can list tech from main menu
		local ingame = GameState.gameplay
		for tech_id, tech in pairs(TechDef) do
			-- only show stuff not yet researched
			if not ingame or ingame and not IsTechResearched(tech_id) then
				local text = Translate(tech.display_name)
				-- remove " from that one tech...
				if text:find("\"") then
					text = text:gsub("\"", "")
				end
				local icon1, icon2 = nil, ""
				if ValidateImage(tech.icon) and not tech.icon:find(" ") then
					icon1 = "<image " .. tech.icon .. " 250>"
					icon2 = "\n\n<image " .. tech.icon .. " 1500>"
				end
				c = c + 1
				item_list[c] = {
					text = text,
					value = tech_id,
					icon = icon1,
					hint = T{tech.description, tech} .. "\n\n" .. T(1000097--[[Category]]) .. ": " .. tech.group .. icon2,
				}
			end
		end
--~ 		ex(item_list)

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local check1 = choice[1].check1
			local check2 = choice[1].check2

			-- nothing checked so we discover
			if not check1 and not check2 then
				check1 = true
			end

			local func
			local text
			if check1 then
				func = "DiscoverTech_Old"
				text = Translate(2--[[Unlock Tech]])
			end
			-- override if both checked
			if check2 then
				func = "GrantTech"
				text = Translate(3--[[Grant Research]])
			end
			local count = 0

			local g = _G
			local UIColony = g.UIColony
			local TechDef = g.TechDef
			for i = 1, #choice do
				if choice[i].list_selected then
					count = count + 1
					local value = choice[i].value
					if value == "Everything" then
						for key in pairs(special_techs) do
							ResearchTechGroup(func, key)
						end
						AllRegularTechs(func)
					elseif value == "AllTech" then
						AllRegularTechs(func)
					elseif value == "AllBreakthroughs" then
						ResearchTechGroup(func, "Breakthroughs")
					elseif value == "AllMysteries" then
						ResearchTechGroup(func, "Mysteries")
					else
						-- make sure it's an actual field
						local field = TechFields[value]
						if field then
							ResearchTechGroup(func, value)
						else
							-- or tech
							local tech = TechDef[value]
							if tech then
								if tech.group == "Mysteries" then
									AllowMysteryTech(value, UIColony)
								end
								g[func](value)
							end
						end
					end
				end
			end

			-- If we unlocked any buildings and the buildmenu is open
			ChoGGi_Funcs.Common.UpdateBuildMenu()

			MsgPopup(
				Translate(302535920000315--[[%s %s tech(s): Unleash your inner Black Monolith Mystery.]]):format(Translate(text), count),
				Translate(title)
			)
		end

		ChoGGi_Funcs.Common.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = title,
			hint = T(302535920000317--[[Select Unlock or Research then select the tech you want. Most mystery tech is locked to that mystery.]]),
			multisel = true,
			custom_type = 8,
			height = 800,
			checkboxes = {
				{
					title = T(2--[[Unlock Tech]]),
					hint = T(302535920000319--[[Just unlocks in the research tree.]]),
					checked = true,
				},
				{
					title = T(311--[[Research]]),
					hint = T(302535920000320--[[Unlocks and researchs.]]),
					checked = research_checked,
					func = function(_, check)
						research_checked = check
					end,
				},
			},
		}
	end

end -- do

function ChoGGi_Funcs.Menus.OpenModEditor()
	local function CallBackFunc(answer)
		if answer then
			ModEditorOpen()
		end
	end
	ChoGGi_Funcs.Common.QuestionBox(
		T(6779--[[Warning]]) .. "!\n" .. T(302535920001508--[[Save your game.
This will switch to a new map.]]),
		CallBackFunc,
		T(6779--[[Warning]]) .. ": " .. T(302535920000236--[[Mod Editor]])
		)
end

do -- Mystery Log
	-- loops through all the sequences and adds the logs we've already seen
	local function ShowMysteryLog(choice)
		local myst_id
		if type(choice) == "string" then
			myst_id = choice
		else
			myst_id = choice[1].value
		end

		local msgs = {myst_id .. "\n\n" .. Translate(302535920000272--[["To play back speech press the ""%s"" checkbox and type in
	g_Voice:Play(o.speech)"]]):format(Translate(302535920000040--[[Exec Code]])) .. "\n"}
		local c = #msgs
		local s_SeqListPlayers = s_SeqListPlayers
		-- 1 is some default map thing
		if #s_SeqListPlayers < 2 then
			return
		end
		for i = 1, #s_SeqListPlayers do
			if i > 1 then
				local seq_list = s_SeqListPlayers[i].seq_list
				if seq_list.name == myst_id then
					for j = 1, #seq_list do
						local scenarios = seq_list[j]
						local state = s_SeqListPlayers[i].seq_states[scenarios.name]
						-- have we started this seq yet?
						if state then
							for k = 1, #scenarios do
								local seq = scenarios[k]
								if seq:IsKindOf("SA_WaitMessage") then
									-- add to msg list
									c = c + 1
									msgs[c] = {
										[" "] = Translate(302535920000273--[[Speech]]) .. ": "
											.. Translate(seq.voiced_text) .. "\n\n\n\n"
											.. Translate(302535920000274--[[Message]]) .. ": "
											.. Translate(seq.text),
										speech = seq.voiced_text,
										class = Translate(seq.title)
									}
								end
							end
						end
					end
				end
			end
		end
		-- display to user
		OpenExamine(msgs, point(550, 100))
	end

	function ChoGGi_Funcs.Menus.MysteryLog()
		local s_SeqListPlayers = s_SeqListPlayers
		if not s_SeqListPlayers then
			return
		end
		if #s_SeqListPlayers == 1 then
			MsgPopup(
				"0",
				T(5661, "Mystery Log")
			)
			return
		end

		local item_list = {}
		local c = 0
		local mysteries = ChoGGi.Tables.Mystery
		for i = 1, #s_SeqListPlayers do
			-- 1 is always there from map loading
			if i > 1 then
				local seq_list = s_SeqListPlayers[i].seq_list
				if not seq_list[1] then
					MsgPopup(
						"0",
						T(5661, "Mystery Log")
					)
					return
				end
				local totalparts = #seq_list[1]
				local id = seq_list.name
				if mysteries[id] then
					local ip = s_SeqListPlayers[i].seq_states[seq_list[1].name].ip

					s_SeqListPlayers[i].mystery_idx = i
					c = c + 1
					item_list[c] = {
						text = id .. ": " .. mysteries[id].name,
						value = id,
						func = id,
						mystery_idx = i,
						hint = "<image " .. mysteries[id].image .. ">\n\n\n<color 255 75 75>"
							.. Translate(302535920000275--[[Total parts]]) .. "</color>: " .. totalparts
							.. " <color 255 75 75>" .. Translate(302535920000289--[[Current part]])
							.. "</color>: " .. (ip or Translate(302535920000276--[[done?]]))
							.. "\n\n" .. mysteries[id].description,
					}
				end
			end
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			choice = choice[1]

			local value = choice.value
			local mystery_idx = choice.mystery_idx
			local ThreadsMessageToThreads = ThreadsMessageToThreads

			if choice.check2 then
				-- remove all
				for i = #s_SeqListPlayers, 1, -1 do
					if i > 1 then
						s_SeqListPlayers[i]:delete()
					end
				end
				for t in pairs(ThreadsMessageToThreads) do
					if t.player and t.player.seq_list.file_name then
						DeleteThread(t.thread)
						t = nil
					end
				end
				MsgPopup(
					Translate(302535920000277--[[Removed all!]]),
					T(5661--[[Mystery Log]])
				)
			elseif choice.check1 then
				-- remove mystery
				for i = #s_SeqListPlayers, 1, -1 do
					if s_SeqListPlayers[i].mystery_idx == mystery_idx then
						s_SeqListPlayers[i]:delete()
						break
					end
				end
				for t in pairs(ThreadsMessageToThreads) do
					if t.player and t.player.mystery_idx == mystery_idx then
						DeleteThread(t.thread)
						t = nil
					end
				end
				MsgPopup(
					choice.text .. ": " .. Translate(3486--[[Mystery]]) .. " " .. Translate(302535920000278--[[Removed]]) .. "!",
					T(5661--[[Mystery Log]])
				)
			elseif value then
				-- next step
				ChoGGi_Funcs.Menus.NextMysterySeq(value, mystery_idx)
			end

		end

		ChoGGi_Funcs.Common.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			custom_type = 6,
			custom_func = ShowMysteryLog,
			title = T(5661--[[Mystery Log]]),
			hint = Translate(302535920000280--[[Skip the timer delay, and optionally skip the requirements (applies to all mysteries that are the same type).
	Sequence part may have more then one check, you may have to skip twice or more.
	Double right-click selected mystery to review past messages.]]),
			checkboxes = {
				{
					title = Translate(302535920000281--[[Remove]]),
					hint = Translate(6779--[[Warning]]) .. ": " .. Translate(302535920000282--[[This will remove the mystery, if you start it again; it'll be back to the start.]]),
				},
				{
					title = Translate(302535920000283--[[Remove All]]),
					hint = Translate(6779--[[Warning]]) .. ": " .. Translate(302535920000284--[[This will remove all the mysteries!]]),
				},
			},
		}
	end

	function ChoGGi_Funcs.Menus.NextMysterySeq(mystery, mystery_idx)
		local g_Classes = g_Classes

		local wait_classes = {"SA_WaitMarsTime", "SA_WaitTime"}
		local thread_classes = {"SA_WaitMarsTime", "SA_WaitTime", "SA_RunSequence"}
		local warning = "\n\n" .. Translate(302535920000285--[["Click ""Ok"" to skip requirements (Warning: may cause issues later on, untested)."]])
		local name = Translate(3486--[[Mystery]]) .. ": " .. ChoGGi.Tables.Mystery[mystery].name

		local ThreadsMessageToThreads = ThreadsMessageToThreads
		for t in pairs(ThreadsMessageToThreads) do
			if t.player and t.player.mystery_idx == mystery_idx then

				-- only remove finished waittime threads, can cause issues removing other threads
				if t.finished == true and t.action:IsKindOfClasses(thread_classes) then
					DeleteThread(t.thread)
				end

				local Player = t.player
				local seq_list = t.sequence
				local state = Player.seq_states
				local ip = state[seq_list.name].ip


				for i = 1, #seq_list do
					-- skip older seqs
					if i >= ip then
						local seq = seq_list[i]
						local title = name .. " " .. Translate(302535920000286--[[Part]]) .. ": " .. ip

						-- seqs that add delays/tasks
						if seq:IsKindOfClasses(wait_classes) then
							ChoGGi.Temp.SA_WaitMarsTime_StopWait = {mystery_idx = mystery_idx}
							--we don't want to wait
							seq.wait_type = g_Classes.SA_WaitMarsTime:GetDefaultPropertyValue("wait_type")
							seq.wait_subtype = g_Classes.SA_WaitMarsTime:GetDefaultPropertyValue("wait_subtype")
							seq.loops = g_Classes.SA_WaitMarsTime:GetDefaultPropertyValue("loops")
							seq.duration = 1
							seq.rand_duration = 1
							local wait = t.action
							wait.wait_type = g_Classes.SA_WaitMarsTime:GetDefaultPropertyValue("wait_type")
							wait.wait_subtype = g_Classes.SA_WaitMarsTime:GetDefaultPropertyValue("wait_subtype")
							wait.loops = g_Classes.SA_WaitMarsTime:GetDefaultPropertyValue("loops")
							wait.duration = 1
							wait.rand_duration = 1

							t.finished = true
							-- may not be needed
							Player:UpdateCurrentIP(seq_list)
							-- let them know
							MsgPopup(
								Translate(302535920000287--[[Timer delay removed (may take upto a Sol).]]),
								title
							)
							break

						elseif seq:IsKindOf("SA_WaitExpression") then
							seq.duration = 1
							local function CallBackFunc(answer)
								if answer then
									seq.expression = nil
									--the first SA_WaitExpression always has a SA_WaitMarsTime, if they're skipping the first then i doubt they want this
									if i == 1 or i == 2 then
										ChoGGi.Temp.SA_WaitMarsTime_StopWait = {mystery_idx = mystery_idx, again = true}
									else
										ChoGGi.Temp.SA_WaitMarsTime_StopWait = {mystery_idx = mystery_idx}
									end

									t.finished = true
									Player:UpdateCurrentIP(seq_list)
								end
							end
							ChoGGi_Funcs.Common.QuestionBox(
								Translate(302535920000288--[[Advancement requires]]) .. ": "
									.. seq.expression .. "\n\n"
									.. Translate(302535920000290--[[Time duration has been set to 0 (you still need to complete the requirements).
	Wait for a Sol or two for it to update (should give a popup msg).]]) .. warning,
								CallBackFunc,
								title
							)
							break

						elseif seq:IsKindOf("SA_WaitMsg") then
							local function CallBackFunc(answer)
								if answer then
									ChoGGi.Temp.SA_WaitMarsTime_StopWait = {mystery_idx = mystery_idx, again = true}
									-- send fake msg (ok it's real, but it hasn't happened)
									Msg(seq.msg)
									Player:UpdateCurrentIP(seq_list)
								end
							end
							ChoGGi_Funcs.Common.QuestionBox(
								Translate(302535920000288--[[Advancement requires]]) .. ": " .. seq.msg .. warning,
								CallBackFunc,
								title
							)
							break

						elseif seq:IsKindOf("SA_WaitResearch") then
							local function CallBackFunc(answer)
								if answer then
									GrantTech(seq.Research)
									t.finished = true
									Player:UpdateCurrentIP(seq_list)
								end
							end
							ChoGGi_Funcs.Common.QuestionBox(
								Translate(302535920000288--[[Advancement requires]]) .. ": " .. seq.Research .. warning,
								CallBackFunc,
								title
							)

						elseif seq:IsKindOf("SA_RunSequence") then
							local function CallBackFunc(answer)
								if answer then
									seq.wait = false
									t.finished = true
									Player:UpdateCurrentIP(seq_list)
								end
							end
							ChoGGi_Funcs.Common.QuestionBox(
								Translate(302535920000291--[[Waiting for %s to finish.
	Skip it?]]):format(seq.sequence),
								CallBackFunc,
								title
							)

						end -- If seq type

					end --if i >= ip
				end --for seq_list

			end --if mystery thread
		end --for t

	end
end -- do
