-- See LICENSE for terms

local pairs, type = pairs, type

local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local Translate = ChoGGi.ComFuncs.Translate
local Random = ChoGGi.ComFuncs.Random
local TableConcat = ChoGGi.ComFuncs.TableConcat
local SelObject = ChoGGi.ComFuncs.SelObject
local Strings = ChoGGi.Strings
local GetCursorWorldPos = GetCursorWorldPos

function ChoGGi.MenuFuncs.SpawnPOIs()
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

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000931--[[Spawn POIs]]],
		multisel = true,
	}
end

function ChoGGi.MenuFuncs.UnlockBreakthroughs()
	local function reveal(anomaly)
		if not IsValid(anomaly) or anomaly.tech_action ~= "breakthrough" then
			return
		end
		anomaly:SetRevealed(true)
		anomaly:ScanCompleted(false)
		DoneObject(anomaly)
	end
	MapForEach("map", "SubsurfaceAnomalyMarker", function(marker)
		if marker.tech_action == "breakthrough" then
			reveal(marker:PlaceDeposit())
			DoneObject(marker)
		end
	end)
	MapForEach("map", "SubsurfaceAnomaly", reveal)
end

function ChoGGi.MenuFuncs.MeteorStrike(_, _, input)
	local strike_pos
	if input == "keyboard" then
		strike_pos = GetCursorWorldPos()
	else
		strike_pos = GetRandomPassable()
	end

	ChoGGi.MenuFuncs.DisasterTriggerMeteor("Meteor_High", "single", strike_pos)
end

function ChoGGi.MenuFuncs.MissileStrike(_, _, input)
	local strike_pos
	if input == "keyboard" then
		strike_pos = GetCursorWorldPos()
	else
		strike_pos = GetRandomPassable()
	end

	ChoGGi.MenuFuncs.DisasterTriggerMissle()
end

function ChoGGi.MenuFuncs.LightningStrike(_, _, input)
	local strike_pos
	if input == "keyboard" then
		strike_pos = GetCursorWorldPos()
	else
		strike_pos = GetRandomPassable()
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

function ChoGGi.MenuFuncs.CompleteConstructions()
	-- speed up buildings/ground
	SuspendPassEdits("ChoGGi.MenuFuncs.CompleteConstructions")
  SuspendTerrainInvalidations("ChoGGi.MenuFuncs.CompleteConstructions")
	CheatCompleteAllConstructions()
	ResumePassEdits("ChoGGi.MenuFuncs.CompleteConstructions")
  ResumeTerrainInvalidations("ChoGGi.MenuFuncs.CompleteConstructions")
end

function ChoGGi.MenuFuncs.InfopanelCheats_Toggle()
	local config = config
	config.BuildingInfopanelCheats = not config.BuildingInfopanelCheats
	ReopenSelectionXInfopanel()
	ChoGGi.UserSettings.InfopanelCheats = config.BuildingInfopanelCheats

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		Strings[302535920001122--[[%s: HAXOR]]]:format(ChoGGi.UserSettings.InfopanelCheats),
		Strings[302535920000696--[[Infopanel Cheats]]]
	)
end

function ChoGGi.MenuFuncs.InfopanelCheatsCleanup_Toggle()
	if ChoGGi.UserSettings.CleanupCheatsInfoPane then
		-- needs default?
		ChoGGi.UserSettings.CleanupCheatsInfoPane = false
	else
		ChoGGi.UserSettings.CleanupCheatsInfoPane = true
		ChoGGi.InfoFuncs.InfopanelCheatsCleanup()
	end

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.CleanupCheatsInfoPane),
		Strings[302535920000698--[[Infopanel Cheats Cleanup]]]
	)
end

function ChoGGi.MenuFuncs.UnlockAchievements()
	local AchievementUnlock = AchievementUnlock
	local EngineCanUnlockAchievement = EngineCanUnlockAchievement

	local XPlayerActive = XPlayerActive

	local item_list = {}
	local c = 0

	local AchievementPresets = AchievementPresets
	for id, item in pairs(AchievementPresets) do
		if EngineCanUnlockAchievement(XPlayerActive, id) then
			c = c + 1
			item_list[c] = {
				text = Translate(item.display_name),
				value = id,
				hint = Translate(item.how_to) .. "\n\n" .. Translate(item.description)
					.. "\n\n<image UI/Achievements/" .. item.image .. ".tga 2500>",
			}
		end
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end

		CreateRealTimeThread(function()
			for i = 1, #choice do
				AchievementUnlock(XPlayerActive, choice[i].value)
				WaitMsg("OnRender")
			end

			MsgPopup(
				#choice,
				Strings[302535920000318--[[Unlock]]] .. " " .. Translate(697482021580--[[Achievements]])
			)
		end)
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000318--[[Unlock]]] .. " " .. Translate(697482021580--[[Achievements]]),
		hint = title,
		multisel = true,
	}
end

function ChoGGi.MenuFuncs.SpawnPlanetaryAnomalies()
	-- GenerateMarsScreenPoI has an inf loop in it that happens when it runs out of spots to place POIs
	-- might be had now, I think they fixed it
	local max = #PlanetaryAnomaly.anomaly_names

	local spots = MarsScreenLandingSpots

	-- for "current" hint
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
		{text = max, value = max},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			local safe_count = 0
			-- naughty naughty
			if value > max then
				value = max
			end

			-- just in case it's changed
			count = 0
			for i = 1, #spots do
				if spots[i]:IsKindOf("PlanetaryAnomaly") then
					count = count + 1
				end
			end

			safe_count = value - count

			if safe_count < 1 then
				safe_count = 0
			end

			-- CheatSpawnPlanetaryAnomalies() but with a limit so GenerateMarsScreenPoI doesn't screw us
			for _ = 1, safe_count do
				local lat, long = GenerateMarsScreenPoI("anomaly")
				-- I assume they'll fix it so there isn't an inf loop
				if lat and long then
					PlaceObject("PlanetaryAnomaly", {
						display_name = T(11234, "Planetary Anomaly"),
						longitude = long,
						latitude = lat,
					})
				end
			end

			MsgPopup(
				Strings[302535920000014--[[Spawned]]] .. ": " .. safe_count .. ", "
					.. Strings[302535920000834--[[Max]]] .. ": " .. max,
				Strings[302535920001394--[[Spawn Planetary Anomalies]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920001394--[[Spawn Planetary Anomalies]]],
		hint = Strings[302535920000106--[[Current]]] .. ": " .. count .. ", "
			.. Strings[302535920000834--[[Max]]] .. ": " .. max,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetOutsourceMaxOrderCount()
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
			ChoGGi.ComFuncs.SetConstsG("OutsourceMaxOrderCount", value)
			ChoGGi.ComFuncs.SetSavedConstSetting("OutsourceMaxOrderCount")

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.OutsourceMaxOrderCount),
				T(970197122036, "Maximum Outsource Orders")
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Translate(970197122036--[[Maximum Outsource Orders]]),
		hint = Strings[302535920000106--[[Current]]] .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.InstantResearch_toggle()
	ChoGGi.UserSettings.InstantResearch = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.InstantResearch)

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.InstantResearch),
		Strings[302535920001278--[[Instant Research]]]
	)
end

function ChoGGi.MenuFuncs.DraggableCheatsMenu_Toggle()
	ChoGGi.UserSettings.DraggableCheatsMenu = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.DraggableCheatsMenu)

	ChoGGi.ComFuncs.DraggableCheatsMenu(ChoGGi.UserSettings.DraggableCheatsMenu)

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.DraggableCheatsMenu),
		Strings[302535920000232--[[Draggable Cheats Menu]]]
	)
end

function ChoGGi.MenuFuncs.KeepCheatsMenuPosition_Toggle()
	if ChoGGi.UserSettings.KeepCheatsMenuPosition then
		ChoGGi.UserSettings.KeepCheatsMenuPosition = nil
		ChoGGi.ComFuncs.SetCheatsMenuPos()
	else
		local pos = XShortcutsTarget:GetPos()
		ChoGGi.UserSettings.KeepCheatsMenuPosition = pos
		ChoGGi.ComFuncs.SetCheatsMenuPos(pos)
	end


	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.KeepCheatsMenuPosition),
		Strings[302535920000325--[[Keep Cheats Menu Position]]]
	)
end

function ChoGGi.MenuFuncs.ResetAllResearch()
	local function CallBackFunc(answer)
		if answer then
			UICity:InitResearch()
		end
	end
	ChoGGi.ComFuncs.QuestionBox(
		Translate(6779--[[Warning]]) .. "!\n" .. Strings[302535920000238--[[Are you sure you want to reset all research (includes breakthrough tech)?

Buildings are still unlocked.]]],
		CallBackFunc,
		Translate(6779--[[Warning]]) .. "!"
	)
end

function ChoGGi.MenuFuncs.DisasterTriggerUndergroundMarsquake()
	if not IsDlcAccessible("picard") then
		return
	end
	if ChoGGi.ComFuncs.RetMapType() == "underground" then
		CheatTriggerUndergroundMarsquake()
	end
end
function ChoGGi.MenuFuncs.DisasterTriggerMissle(amount)
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
					GetRandomPassable(),
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

function ChoGGi.MenuFuncs.DisasterTriggerColdWave(severity)
	CreateGameTimeThread(function()
		local data = DataInstances.MapSettings_ColdWave
		local descr = data[severity] or data[ActiveMapData.MapSettings_ColdWave] or data.ColdWave_VeryLow
		StartColdWave(descr)
	end)
end
function ChoGGi.MenuFuncs.DisasterTriggerDustStorm(severity, storm_type)
	CreateGameTimeThread(function()
		local data = DataInstances.MapSettings_DustStorm
		local descr = data[severity] or data[ActiveMapData.MapSettings_DustStorm] or data.DustStorm_VeryLow
		StartDustStorm(storm_type or "normal", descr)
	end)
end
function ChoGGi.MenuFuncs.DisasterTriggerDustDevils(severity, major)
	local pos = SelObject() or GetCursorWorldPos()
	if type(pos) == "table" then
		pos = pos:GetPos()
	end

	local data = DataInstances.MapSettings_DustDevils
	local descr = data[severity] or data[ActiveMapData.MapSettings_DustDevils] or data.DustDevils_VeryLow
	GenerateDustDevil(pos, descr, nil, major):Start()
end
function ChoGGi.MenuFuncs.DisasterTriggerMeteor(severity, meteors_type, pos)
	meteors_type = meteors_type or "single"
	pos = pos or SelObject() or GetCursorWorldPos()
  -- target object
	if IsValid(pos) then
		pos = pos.GetVisualPos and pos:GetVisualPos() or pos:GetPos()
	end

	local data = DataInstances.MapSettings_Meteor
	local descr = ChoGGi.ComFuncs.CopyTable(
		data[severity] or data[ActiveMapData.MapSettings_Meteor] or data.Meteor_VeryLow
	)
	if meteors_type == "single" then
		-- defaults to 50000 (no good for aiming).
		descr.storm_radius = 2500
	end

	CreateGameTimeThread(function()
		MeteorsDisaster(descr, meteors_type, pos)
	end)
end
function ChoGGi.MenuFuncs.DisasterTriggerMetatronIonStorm()
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
	function ChoGGi.MenuFuncs.DisasterTriggerLightningStrike(amount)
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
				strike_pos = GetRandomPassable()
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
		Stop = ChoGGi.ComFuncs.DisastersStop,
		ColdWave = ChoGGi.MenuFuncs.DisasterTriggerColdWave,
		DustStorm = ChoGGi.MenuFuncs.DisasterTriggerDustStorm,
		Meteor = ChoGGi.MenuFuncs.DisasterTriggerMeteor,
		MetatronIonStorm = ChoGGi.MenuFuncs.DisasterTriggerMetatronIonStorm,
		DustDevils = ChoGGi.MenuFuncs.DisasterTriggerDustDevils,
		UndergroundMarsquake = ChoGGi.MenuFuncs.DisasterTriggerUndergroundMarsquake,

		DustDevilsMajor = function()
			ChoGGi.MenuFuncs.DisasterTriggerDustDevils(nil, "major")
		end,
		DustStormElectrostatic = function()
			ChoGGi.MenuFuncs.DisasterTriggerDustStorm(nil, "electrostatic")
		end,
		DustStormGreat = function()
			ChoGGi.MenuFuncs.DisasterTriggerDustStorm(nil, "great")
		end,
		MeteorStorm = function()
			ChoGGi.MenuFuncs.DisasterTriggerMeteor(nil, "storm")
		end,
		MeteorMultiSpawn = function()
			ChoGGi.MenuFuncs.DisasterTriggerMeteor(nil, "multispawn")
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
					local func = ChoGGi.MenuFuncs[func_name]
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
					hint = TableConcat(hint, "\n"),
				}
			end
		end
		return c
	end

	function ChoGGi.MenuFuncs.DisastersTrigger()
		local missile_hint = Strings[302535920001372--[[Change the number on the end to fire that amount (ex: %s25).]]]:format(Strings[302535920000246--[[Missle]]])
			.. "\n\n" .. Strings[302535920001546--[[Random delay added (to keep game from lagging on large amounts).]]]
		local strike_hint = Strings[302535920001372--[[Change the number on the end to fire that amount (ex: %s25).]]]:format(Strings[302535920001374--[[LightningStrike]]])
			.. "\n\n" .. Strings[302535920001546]
		local default_mapdata_type = Strings[302535920000250--[[Default mapdata type]]]

		local item_list = {
			{text = " " .. Strings[302535920000240--[[Stop]]] .. " " .. Translate(3983--[[Disasters]]), value = "Stop", hint = Strings[302535920000123--[[Stops most disasters]]]},

			{text = Translate(4149, "Cold Wave"), value = "ColdWave", hint = default_mapdata_type},
			{text = Translate(13683, "Underground Marsquakes"), value = "UndergroundMarsquake"},

			{text = Translate(4142--[[Dust Devils]]), value = "DustDevils", hint = default_mapdata_type},
			{text = Translate(4142--[[Dust Devils]]) .. " " .. Strings[302535920000241--[[Major]]], value = "DustDevilsMajor", hint = default_mapdata_type},

			{text = Translate(4250--[[Dust Storm]]), value = "DustStorm", hint = default_mapdata_type},
			{text = Translate(5627--[[Great Dust Storm]]), value = "DustStormGreat", hint = default_mapdata_type},
			{text = Translate(5628--[[Electrostatic Dust Storm]]), value = "DustStormElectrostatic", hint = default_mapdata_type},

			{text = Translate(4146--[[Meteors]]), value = "Meteor", hint = default_mapdata_type},
			{text = Translate(4146--[[Meteors]]) .. " " .. Strings[302535920000245--[[Multi-Spawn]]], value = "MeteorMultiSpawn", hint = default_mapdata_type},
			{text = Translate(5620--[[Meteor Storm]]), value = "MeteorStorm", hint = default_mapdata_type},

			{text = Strings[302535920000251--[[Metatron Ion Storm]]], value = "MetatronIonStorm"},

			{text = Strings[302535920000246--[[Missle]]] .. " " .. 1, value = "Missle1", hint = missile_hint},
			{text = Strings[302535920000246--[[Missle]]] .. " " .. 50, value = "Missle50", hint = missile_hint},
			{text = Strings[302535920000246--[[Missle]]] .. " " .. 100, value = "Missle100", hint = missile_hint},
			{text = Strings[302535920000246--[[Missle]]] .. " " .. 500, value = "Missle500", hint = missile_hint},

			{text = Strings[302535920001373--[[Lightning Strike]]] .. " " .. 1, value = "LightningStrike1", hint = strike_hint},
			{text = Strings[302535920001373--[[Lightning Strike]]] .. " " .. 50, value = "LightningStrike50", hint = strike_hint},
			{text = Strings[302535920001373--[[Lightning Strike]]] .. " " .. 100, value = "LightningStrike100", hint = strike_hint},
			{text = Strings[302535920001373--[[Lightning Strike]]] .. " " .. 500, value = "LightningStrike500", hint = strike_hint},
		}
		-- add map settings for disasters
		local DataInstances = DataInstances
		local c = #item_list

		-- add any disaster map settings in DataInstances
		local name_lookup = {
			ColdWave = {
				display = Translate(4149--[[Cold Wave]]),
			},
			DustStorm = {
				display = Translate(4250--[[Dust Storm]]),
				types = {"major"},
			},
			DustDevils = {
				display = Translate(4142--[[Dust Devils]]),
				types = {"electrostatic", "great"},
			},
			Meteor = {
				display = Translate(4146--[[Meteors]]),
				types = {"storm", "multispawn"},
			},
			Marsquake = {
				display = Translate(382404446864--[[Marsquake]]),
			},
			RainsDisaster = {
				display = Translate(553301803055--[[Rain!]]),
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
						ChoGGi.MenuFuncs.DisasterTriggerMissle(amount)
					end
				elseif value:find("LightningStrike") then
					local amount = tonumber(value:sub(16))
					if amount then
						ChoGGi.MenuFuncs.DisasterTriggerLightningStrike(amount)
					end
				end

				MsgPopup(
					choice[i].text,
					T(3983, "Disasters")
				)
			end
		end


--~ 																																										ex(item_list)




		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = Translate(1694--[[Start]]) .. " " .. Translate(3983--[[Disasters]]),
			hint = Strings[302535920000252--[[Targeted to mouse cursor (use arrow keys to select and enter to start).]]],
			multisel = true,
		}
	end
end -- do

function ChoGGi.MenuFuncs.ShowScanAnomaliesOptions()
	-- what did this do?
--~ 	BuildNames()

	local item_list = {
		{
			text = " " .. Translate(4493--[[All]]),
			value = "All",
			hint = Strings[302535920000329--[[Scan all anomalies.]]],
		},
		{
			text = Translate(9--[[Anomaly]]),
			value = "SubsurfaceAnomaly",
			hint = Translate(22--[[Our scans have found some interesting readings in this Sector. Further analysis is needed.<newline><newline>Send an RC Explorer to analyze the Anomaly.]]),
			icon = "<image UI/Icons/Anomaly_Custom.tga 750>",
		},
	}
	local c = #item_list

	local names_lookup = {
		SubsurfaceAnomaly_aliens = {
			title = Translate(5616--[[Alien Artifact Analyzed]]),
			icon = "UI/Icons/Anomaly_Event.tga",
		},
		SubsurfaceAnomaly_breakthrough = {
			title = Translate(8--[[Breakthrough Tech]]),
			icon = "UI/Icons/Anomaly_Breakthrough.tga",
		},
		SubsurfaceAnomaly_complete = {
			title = Translate(3--[[Grant Research]]),
			icon = "UI/Icons/Anomaly_Research.tga",
		},
		SubsurfaceAnomaly_unlock = {
			title = Translate(2--[[Unlock Tech]]),
			icon = "UI/Icons/Anomaly_Tech.tga",
		},
		MetatronAnomaly = {
			title = Translate(9818--[[Metatron's Challenge]]),
		},
		MirrorSphereAnomaly = {
			title = Translate(1182--[[Mirror Sphere]]),
		},
	}

	ClassDescendantsList("SubsurfaceAnomaly", function(name, class)
		c = c + 1
		item_list[c] = 		{
			text = names_lookup[name].title or Translate(class.display_name),
			value = name,
			hint = Translate(class.description or 25--[[Anomaly Scanning]]),
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
				local a = UICity.labels.Anomaly or ""
				-- go backwards it'll be removed once scanned
				for j = #a, 1, -1 do
					a[j]:CheatScan()
				end
				-- no sense in doing other choices as we just did all
				break
			else
				local a = UICity.labels.Anomaly or ""
				for j = #a, 1, -1 do
					local anomnom = a[j]
					if anomnom.class == value then
						anomnom:CheatScan()
					end
				end
			end
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Translate(25--[[Anomaly Scanning]]),
		multisel = true,
	}
end

function ChoGGi.MenuFuncs.MapExploration()
	local UICity = UICity
	local title = Strings[302535920001355--[[Map]]] .. " " .. Translate(5422--[[Exploration]])
	local hint_core = Strings[302535920000253--[[Core: Repeatable, exploit core resources.]]]
	local hint_deep = Strings[302535920000254--[[Deep: unlock tech to exploit deep resources.]]]
	local item_list = {
		{text = Strings[302535920000258--[[Reveal Map]]], value = 12, hint = Strings[302535920000259--[[Reveals the map squares]]]},
		{text = Strings[302535920000260--[[Reveal Map (Deep)]]], value = 13, hint = Strings[302535920000261--[[Reveals the map and unlocks "Deep" resources]]]},

		{text = Translate(4493--[[All]]), value = 1, hint = hint_core .. "\n" .. hint_deep},
		{text = Strings[302535920000255--[[Deep]]], value = 2, hint = hint_deep},
		{text = Strings[302535920000256--[[Core]]], value = 3, hint = hint_core},

		{text = Strings[302535920000257--[[Deep Scan]]], value = 4, hint = hint_deep .. "\n" .. Translate(12227--[[Enabled]]) .. ": " .. g_Consts.DeepScanAvailable},
		{text = Translate(797--[[Deep Water]]), value = 5, hint = hint_deep .. "\n" .. Translate(12227--[[Enabled]]) .. ": " .. g_Consts.IsDeepWaterExploitable},
		{text = Translate(793--[[Deep Metals]]), value = 6, hint = hint_deep .. "\n" .. Translate(12227--[[Enabled]]) .. ": " .. g_Consts.IsDeepMetalsExploitable},
		{text = Translate(801--[[Deep Rare Metals]]), value = 7, hint = hint_deep .. "\n" .. Translate(12227--[[Enabled]]) .. ": " .. g_Consts.IsDeepPreciousMetalsExploitable},

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
--~ 			ChoGGi.ComFuncs.SetConstsG("DeepScanAvailable", ChoGGi.ComFuncs.ToggleBoolNum(Consts.DeepScanAvailable))
--~ 			ChoGGi.ComFuncs.SetConstsG("IsDeepWaterExploitable", ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepWaterExploitable))
--~ 			ChoGGi.ComFuncs.SetConstsG("IsDeepMetalsExploitable", ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepMetalsExploitable))
--~ 			ChoGGi.ComFuncs.SetConstsG("IsDeepPreciousMetalsExploitable", ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepPreciousMetalsExploitable))
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
--~ 				ChoGGi.ComFuncs.SetConstsG("DeepScanAvailable", ChoGGi.ComFuncs.ToggleBoolNum(Consts.DeepScanAvailable))
				GrantTech("DeepScanning")
			elseif value == 5 then
--~ 				ChoGGi.ComFuncs.SetConstsG("IsDeepWaterExploitable", ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepWaterExploitable))
				GrantTech("DeepWaterExtraction")
			elseif value == 6 then
				GrantTech("DeepMetalExtraction")
--~ 				ChoGGi.ComFuncs.SetConstsG("IsDeepMetalsExploitable", ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepMetalsExploitable))
			elseif value == 7 then
				GrantTech("DeepMetalExtraction")
--~ 				ChoGGi.ComFuncs.SetConstsG("IsDeepPreciousMetalsExploitable", ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepPreciousMetalsExploitable))
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
			Strings[302535920000262--[[Alice thought to herself. ""Now you will see a film made for children"".
Perhaps.
But I nearly forgot! You must close your eyes.
Otherwise you won't see anything."]]],
			title,
			{image = "UI/Achievements/TheRabbitHole.tga"}
		)
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = title,
		hint = Strings[302535920000902--[["Anything with Repeatable in the tooltip will spawn more items on the map.
Deep items will unlock the ability to exploit those resources."]]],
		multisel = true,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SpawnColonists()
	local ChoOrig_GenerateColonistData = GenerateColonistData

	local title = Strings[302535920000266--[[Spawn]]] .. " " .. Translate(547--[[Colonists]])
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
				ChoGGi.ComFuncs.SettingState(choice.text, Strings[302535920000014--[[Spawned]]]),
				title
			)

		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = title,
		hint = Strings[302535920000267--[[Colonist placing priority: Selected dome, Evenly between domes, or centre of map if no domes.]]],
		skip_sort = true,
		height = 650.0,
		checkboxes = {
			{title = TraitPresets.Child.display_name,
				hint = Strings[302535920000840--[[All colonists spawn as this age.]]],
			},
			{title = TraitPresets.Youth.display_name,
				hint = Strings[302535920000840--[[All colonists spawn as this age.]]],
			},
			{title = TraitPresets.Adult.display_name,
				hint = Strings[302535920000840--[[All colonists spawn as this age.]]],
			},
			{title = TraitPresets["Middle Aged"].display_name,
				hint = Strings[302535920000840--[[All colonists spawn as this age.]]],
				level = 2,
			},
			{title = TraitPresets.Senior.display_name,
				hint = Strings[302535920000840--[[All colonists spawn as this age.]]],
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

	function ChoGGi.MenuFuncs.ShowMysteryList()
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

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = Strings[302535920000268--[[Start A Mystery]]],
			hint = Translate(6779--[[Warning]]) .. ": " .. Strings[302535920000269--[["Adding a mystery is cumulative, this will NOT replace existing mysteries.

See Cheats>%s to remove."]]]:format(Translate(5661--[[Mystery Log]])),
			skip_sort = true,
			checkboxes = {
				{
					title = Strings[302535920000270--[[Instant Start]]],
					hint = Strings[302535920000271--[["May take up to one Sol to ""instantly"" activate mystery."]]],
				},
			},
		}
	end
end -- do

do -- Mystery Log
	-- loops through all the sequences and adds the logs we've already seen
	local function ShowMysteryLog(choice)
		local myst_id
		if type(choice) == "string" then
			myst_id = choice
		else
			myst_id = choice[1].value
		end

		local msgs = {myst_id .. "\n\n" .. Strings[302535920000272--[["To play back speech press the ""%s"" checkbox and type in
	g_Voice:Play(o.speech)"]]]:format(Strings[302535920000040--[[Exec Code]]]) .. "\n"}
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
										[" "] = Strings[302535920000273--[[Speech]]] .. ": "
											.. Translate(seq.voiced_text) .. "\n\n\n\n"
											.. Strings[302535920000274--[[Message]]] .. ": "
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
		ChoGGi.ComFuncs.OpenInExamineDlg(msgs, point(550, 100))
	end

	function ChoGGi.MenuFuncs.MysteryLog()
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
				local ip = s_SeqListPlayers[i].seq_states[seq_list[1].name].ip

				s_SeqListPlayers[i].mystery_idx = i
				c = c + 1
				item_list[c] = {
					text = id .. ": " .. mysteries[id].name,
					value = id,
					func = id,
					mystery_idx = i,
					hint = "<image " .. mysteries[id].image .. ">\n\n\n<color 255 75 75>"
						.. Strings[302535920000275--[[Total parts]]] .. "</color>: " .. totalparts
						.. " <color 255 75 75>" .. Strings[302535920000289--[[Current part]]]
						.. "</color>: " .. (ip or Strings[302535920000276--[[done?]]])
						.. "\n\n" .. mysteries[id].description,
				}
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
					Strings[302535920000277--[[Removed all!]]],
					T(5661, "Mystery Log")
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
					choice.text .. ": " .. Translate(3486--[[Mystery]]) .. " " .. Strings[302535920000278--[[Removed]]] .. "!",
					T(5661, "Mystery Log")
				)
			elseif value then
				-- next step
				ChoGGi.MenuFuncs.NextMysterySeq(value, mystery_idx)
			end

		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			custom_type = 6,
			custom_func = ShowMysteryLog,
			title = Translate(5661--[[Mystery Log]]),
			hint = Strings[302535920000280--[[Skip the timer delay, and optionally skip the requirements (applies to all mysteries that are the same type).
	Sequence part may have more then one check, you may have to skip twice or more.
	Double right-click selected mystery to review past messages.]]],
			checkboxes = {
				{
					title = Strings[302535920000281--[[Remove]]],
					hint = Translate(6779--[[Warning]]) .. ": " .. Strings[302535920000282--[[This will remove the mystery, if you start it again; it'll be back to the start.]]],
				},
				{
					title = Strings[302535920000283--[[Remove All]]],
					hint = Translate(6779--[[Warning]]) .. ": " .. Strings[302535920000284--[[This will remove all the mysteries!]]],
				},
			},
		}
	end

	function ChoGGi.MenuFuncs.NextMysterySeq(mystery, mystery_idx)
		local g_Classes = g_Classes

		local wait_classes = {"SA_WaitMarsTime", "SA_WaitTime"}
		local thread_classes = {"SA_WaitMarsTime", "SA_WaitTime", "SA_RunSequence"}
		local warning = "\n\n" .. Strings[302535920000285--[["Click ""Ok"" to skip requirements (Warning: may cause issues later on, untested)."]]]
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
						local title = name .. " " .. Strings[302535920000286--[[Part]]] .. ": " .. ip

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
								Strings[302535920000287--[[Timer delay removed (may take upto a Sol).]]],
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
							ChoGGi.ComFuncs.QuestionBox(
								Strings[302535920000288--[[Advancement requires]]] .. ": "
									.. seq.expression .. "\n\n"
									.. Strings[302535920000290--[[Time duration has been set to 0 (you still need to complete the requirements).
	Wait for a Sol or two for it to update (should give a popup msg).]]] .. warning,
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
							ChoGGi.ComFuncs.QuestionBox(
								Strings[302535920000288--[[Advancement requires]]] .. ": " .. seq.msg .. warning,
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
							ChoGGi.ComFuncs.QuestionBox(
								Strings[302535920000288--[[Advancement requires]]] .. ": " .. seq.Research .. warning,
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
							ChoGGi.ComFuncs.QuestionBox(
								Strings[302535920000291--[[Waiting for %s to finish.
	Skip it?]]]:format(seq.sequence),
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

function ChoGGi.MenuFuncs.UnlockAllBuildings_Toggle()
	local item_list = {
		{text = Strings[302535920000547--[[Lock]]], value = "Lock"},
		{text = Strings[302535920000318--[[Unlock]]], value = "Unlock"},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end

		if choice[1].value == "Lock" then
			-- reverse what the unlock cheat does
			local bmpv = BuildMenuPrerequisiteOverrides
			for id, value in pairs(bmpv) do
				if value == true then
					bmpv[id] = nil
				end
			end
		else
			CheatUnlockAllBuildings()
		end

		ChoGGi.ComFuncs.UpdateBuildMenu()
		MsgPopup(
			Strings[302535920000293--[[%s: all buildings for construction.]]]:format(choice[1].text),
			Strings[302535920000337--[[Toggle Unlock All Buildings]]]
		)
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000337--[[Toggle Unlock All Buildings]]],
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.AddResearchPoints()
	local item_list = {
		{text = Strings[302535920001084--[[Reset]]], value = "Reset", hint = Strings[302535920000292--[[Resets sponsor points to default for that sponsor]]]},
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
			ChoGGi.ComFuncs.SettingState(choice.text),
			Strings[302535920000295--[[Add Research Points]]]
		)
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000295--[[Add Research Points]]],
		hint = Strings[302535920000296--[[If you need a little boost (or a lotta boost) in research.]]],
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.OutsourcingFree_Toggle()
	ChoGGi.ComFuncs.SetConstsG("OutsourceResearchCost", ChoGGi.ComFuncs.NumRetBool(Consts.OutsourceResearchCost, 0, ChoGGi.Consts.OutsourceResearchCost))
	ChoGGi.ComFuncs.SetSavedConstSetting("OutsourceResearchCost")

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		Strings[302535920000297--[["%s
Best hope you picked India as your Mars sponsor..."]]]:format(ChoGGi.UserSettings.OutsourceResearchCost),
		Strings[302535920000355--[[Outsourcing For Free]]]
	)
end

function ChoGGi.MenuFuncs.BreakThroughsOmegaTelescope_Set()
	local default_setting = ChoGGi.Consts.OmegaTelescopeBreakthroughsCount
	local MaxAmount = #UIColony.tech_field.Breakthroughs
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 6, value = 6},
		{text = 12, value = 12},
		{text = 24, value = 24},
		{text = MaxAmount, value = MaxAmount, hint = Strings[302535920000298--[[Max amount in UIColony.tech_field list, you could make the amount larger if you want (an update/mod can add more).]]]},
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
			ChoGGi.ComFuncs.SetSavedConstSetting("OmegaTelescopeBreakthroughsCount")

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920000299--[[%s: Research is what I'm doing when I don't know what I'm doing.]]]:format(choice[1].text),
				Strings[302535920000359--[[Breakthroughs From OmegaTelescope]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000359--[[Breakthroughs From OmegaTelescope]]],
		hint = Strings[302535920000106--[[Current]]] .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.BreakThroughsAllowed_Set()
	local default_setting = ChoGGi.Consts.BreakThroughTechsPerGame
	local MaxAmount = #UIColony.tech_field.Breakthroughs
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 26, value = 26, hint = Strings[302535920000301--[[Doubled the base amount.]]]},
		{text = MaxAmount, value = MaxAmount, hint = Strings[302535920000298--[[Max amount in UIColony.tech_field list, you could make the amount larger if you want (an update/mod can add more).]]]},
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
			ChoGGi.ComFuncs.SetSavedConstSetting("BreakThroughTechsPerGame")

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920000302--[[%s: Strings M R T]]]:format(choice[1].text),
				Strings[302535920000357--[[Set Amount Of Breakthroughs Allowed]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000303--[[BreakThroughs Allowed]]],
		hint = Strings[302535920000106--[[Current]]] .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.ResearchQueueSize_Set()
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
			ChoGGi.ComFuncs.SetSavedConstSetting("ResearchQueueSize")

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920000304--[[%s: Nerdgasm]]]:format(ChoGGi.UserSettings.ResearchQueueSize),
				Strings[302535920000305--[[Research Queue Size]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000305--[[Research Queue Size]]],
		hint = Strings[302535920000106--[[Current]]] .. ": " .. hint,
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

			local display_text = T(7587, "<green>Martianborn Ingenuity <amount></color>")
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

	function ChoGGi.MenuFuncs.ResearchRemove()
		local title = Translate(311--[[Research]]) .. " " .. Strings[302535920000281--[[Remove]]]
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
					hint = Translate(T{tech.description, tech}) .. "\n\n" .. Translate(1000097--[[Category]]) .. ": " .. tech.group .. "\n\n<image " .. tech.icon .. " 1500>",
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
			ChoGGi.ComFuncs.UpdateBuildMenu()

			MsgPopup(
				Strings[302535920000315--[[%s %s tech(s): Unleash your inner Black Monolith Mystery.]]]:format("", #choice),
				title
			)
		end
		if #item_list == 0 then
			MsgPopup(
				Strings[302535920000089--[[Nothing left]]],
				title
			)
			return
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = title,
			hint = Strings[302535920001495--[[This tries to reverse the changes made when the tech is researched (emphasis on tries).]]],
			multisel = true,
			height = 800,
		}
	end
end -- do

do -- ResearchTech
	local research_checked
	local ValidateImage = ChoGGi.ComFuncs.ValidateImage
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
		for tech_id, tech in pairs(TechDef) do
			if tech.group == group then
				if tech.group == "Mysteries" then
					AllowMysteryTech(tech_id, UIColony)
				end
				_G[tech_func](tech_id)
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

	function ChoGGi.MenuFuncs.ResearchTech()
		local title = T(311, "Research") .. " / " .. Strings[302535920000318--[[Unlock]]] .. " " .. T(373, "Tech")
		local item_list = {
			{
				text = "	" .. Strings[302535920000306--[[Everything]]],
				value = "Everything",
				hint = Strings[302535920000307--[[All the tech/breakthroughs/mysteries]]],
			},
			{
				text = "	" .. Strings[302535920000308--[[All Tech]]],
				value = "AllTech",
				hint = Strings[302535920000309--[[All the regular tech]]],
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
		for tech_id, tech in pairs(TechDef) do
			-- only show stuff not yet researched
			if not IsTechResearched(tech_id) then
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
					hint = T{tech.description, tech} .. "\n\n" .. T(1000097, "Category") .. ": " .. tech.group .. icon2,
				}
			end
		end

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
			ChoGGi.ComFuncs.UpdateBuildMenu()

			MsgPopup(
				Strings[302535920000315--[[%s %s tech(s): Unleash your inner Black Monolith Mystery.]]]:format(text, count),
				title
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = title,
			hint = Strings[302535920000317--[[Select Unlock or Research then select the tech you want. Most mystery tech is locked to that mystery.]]],
			multisel = true,
			custom_type = 8,
			height = 800,
			checkboxes = {
				{
					title = T(2, "Unlock Tech"),
					hint = Strings[302535920000319--[[Just unlocks in the research tree.]]],
					checked = true,
				},
				{
					title = T(311, "Research"),
					hint = Strings[302535920000320--[[Unlocks and researchs.]]],
					checked = research_checked,
					func = function(_, check)
						research_checked = check
					end,
				},
			},
		}
	end

end -- do

function ChoGGi.MenuFuncs.OpenModEditor()
	local function CallBackFunc(answer)
		if answer then
			ModEditorOpen()
		end
	end
	ChoGGi.ComFuncs.QuestionBox(
		Translate(6779--[[Warning]]) .. "!\n" .. Strings[302535920001508--[[Save your game.
This will switch to a new map.]]],
		CallBackFunc,
		Translate(6779--[[Warning]]) .. ": " .. Strings[302535920000236--[[Mod Editor]]]
		)
end

--~ 	function ChoGGi.MenuFuncs.OpenModEditor()
--~ 		local ModsList = ModsList

--~ 		local item_list = {
--~ 			{
--~ 				text = " " .. Strings[302535920000236--[[Mod Editor]]],
--~ 				value = "ModEditor",
--~ 				hint = Strings[302535920001478--[[Open the Mod Editor and load the Mod map.]]],
--~ 			},
--~ 		}
--~ 		local c = #item_list

--~ 		for i = 1, #ModsList do
--~ 			local mod = ModsList[i]
--~ 			local hint
--~ 			if mod.image:find(" ") or mod.path:find(" ") then
--~ 				hint = mod.description
--~ 			elseif mod.image ~= "" then
--~ 				hint = "<image " .. mod.image .. ">\n\n" .. mod.description
--~ 			end

--~ 			c = c + 1
--~ 			item_list[c] = {
--~ 				text = mod.title .. ", " .. mod.id .. ", " .. mod.version,
--~ 				mod = {mod},
--~ 				value = mod.id,
--~ 				hint = hint,
--~ 			}
--~ 		end

--~ 		local function CallBackFunc(choice)
--~ 			if #choice < 1 then
--~ 				return
--~ 			end
--~ 			choice = choice[1]

--~ 			if choice.value == "ModEditor" then
--~ 				ModEditorOpen()
--~ 			else
--~ 				local context = {
--~ 					mod_items = GedItemsMenu("ModItem"),
--~ 					steam_login = true,
--~ 				}
--~ 				local editor = OpenGedApp("ModEditor", Container:new(choice.mod), context)
--~ 				if editor then
--~ 					editor:Rpc("rpcApp", "SetSelection", "root", {1})
--~ 				end
--~ 			end
--~ 		end

--~ 		ChoGGi.ComFuncs.OpenInListChoice{
--~ 			callback = CallBackFunc,
--~ 			items = item_list,
--~ 			title = Strings[302535920000236--[[Mod Editor]]],
--~ 		}

--~ 	end
