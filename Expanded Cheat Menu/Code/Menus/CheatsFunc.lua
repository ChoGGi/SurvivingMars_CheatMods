-- See LICENSE for terms

function OnMsg.ClassesGenerate()

	local MsgPopup = ChoGGi.ComFuncs.MsgPopup
	local Trans = ChoGGi.ComFuncs.Translate
	local Random = ChoGGi.ComFuncs.Random
	local S = ChoGGi.Strings
	local default_icon = "UI/Icons/Notifications/research.tga"

	local pairs,type = pairs,type
	local StringFormat = string.format

	function ChoGGi.MenuFuncs.SetOutsourceMaxOrderCount()
		local ChoGGi = ChoGGi
		local DefaultSetting = ChoGGi.Consts.OutsourceMaxOrderCount
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
			{text = 100,value = 100},
			{text = 150,value = 150},
			{text = 250,value = 250},
			{text = 500,value = 500},
			{text = 1000,value = 1000},
			{text = 2500,value = 2500},
			{text = 5000,value = 5000},
			{text = 10000,value = 10000},
			{text = 25000,value = 25000},
			{text = 50000,value = 50000},
			{text = 100000,value = 100000},
		}

		local hint = DefaultSetting
		if ChoGGi.UserSettings.OutsourceMaxOrderCount then
			hint = ChoGGi.UserSettings.OutsourceMaxOrderCount
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				ChoGGi.ComFuncs.SetConstsG("OutsourceMaxOrderCount",value)
				ChoGGi.ComFuncs.SetSavedSetting("OutsourceMaxOrderCount",value)

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.OutsourceMaxOrderCount,302535920001342--[[Change Outsource Limit--]]),
					889032422791--[[OUTSOURCE--]],
					default_icon
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920001342--[[Change Outsource Limit--]],
			hint = StringFormat("%s: %s",S[302535920000106--[[Current--]]],hint),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.InstantResearch_toggle()
		local ChoGGi = ChoGGi
		ChoGGi.UserSettings.InstantResearch = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.InstantResearch)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.InstantResearch,302535920001278--[[Instant Research--]]),
			311--[[Research--]]
		)
	end

	function ChoGGi.MenuFuncs.DraggableCheatsMenu_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.UserSettings.DraggableCheatsMenu = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.DraggableCheatsMenu)

		ChoGGi.ComFuncs.DraggableCheatsMenu(ChoGGi.UserSettings.DraggableCheatsMenu)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.DraggableCheatsMenu,302535920000232--[[Draggable Cheats Menu--]]),
			1000162--[[Menu--]]
		)
	end

	function ChoGGi.MenuFuncs.KeepCheatsMenuPosition_Toggle()
		local ChoGGi = ChoGGi
		if ChoGGi.UserSettings.KeepCheatsMenuPosition then
			ChoGGi.UserSettings.KeepCheatsMenuPosition = nil
		else
			ChoGGi.UserSettings.KeepCheatsMenuPosition = XShortcutsTarget:GetPos()
		end
		-- toggle the menu, to reset/set position
		XShortcutsTarget:ToggleMenu()
		XShortcutsTarget:ToggleMenu()

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.KeepCheatsMenuPosition,302535920000234--[[Cheats menu save position--]]),
			1000162--[[Menu--]]
		)
	end

	function ChoGGi.MenuFuncs.OpenModEditor()
		local function CallBackFunc(answer)
			if answer then
				ModEditorOpen()
			end
		end
		ChoGGi.ComFuncs.QuestionBox(
			StringFormat("%s!\n%s",S[6779--[[Warning--]]],S[302535920000235--[[Save your game.
	This will switch to a new map.--]]]),
			CallBackFunc,
			StringFormat("%s: %s",S[6779--[[Warning--]]],S[302535920000236--[[Mod Editor--]]]),
			302535920000237--[[Okay (change map)--]]
		)
	end

	--~ UICity.tech_status[tech_id].researched = nil
	--~ UICity.tech_status[tech_id].discovered= nil
	function ChoGGi.MenuFuncs.ResetAllResearch()
		local function CallBackFunc(answer)
			if answer then
				UICity:InitResearch()
			end
		end
		ChoGGi.ComFuncs.QuestionBox(
			StringFormat("%s!\n%s",S[6779--[[Warning--]]],S[302535920000238--[[Are you sure you want to reset all research (includes breakthrough tech)?

	Buildings are still unlocked.--]]]),
			CallBackFunc,
			StringFormat("%s!",S[6779--[[Warning--]]])
		)
	end

	function ChoGGi.MenuFuncs.DisasterTriggerMissle(amount)
		amount = amount or 1
		if amount == 1 then
			-- (pt, radius, count, delay_min, delay_max)
			StartBombard(
				ChoGGi.ComFuncs.SelObject() or GetTerrainCursor(),
				1000,
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
					Sleep(Random(100,750))
				end
				-- restore popup
				osnp.Bombardment = preset
			end)
		end
	end

	function ChoGGi.MenuFuncs.DisasterTriggerColdWave(severity)
		CreateGameTimeThread(function()
			local data = DataInstances.MapSettings_ColdWave
			local descr = data[severity] or data[mapdata.MapSettings_ColdWave] or data.ColdWave_VeryLow
			StartColdWave(descr)
		end)
	end
	function ChoGGi.MenuFuncs.DisasterTriggerDustStorm(severity,storm_type)
		CreateGameTimeThread(function()
			local data = DataInstances.MapSettings_DustStorm
			local descr = data[severity] or data[mapdata.MapSettings_DustStorm] or data.DustStorm_VeryLow
			StartDustStorm(storm_type or "normal",descr)
		end)
	end
	function ChoGGi.MenuFuncs.DisasterTriggerDustDevils(severity,major)
		local pos = ChoGGi.ComFuncs.SelObject() or GetTerrainCursor()
		if type(pos) == "table" then
			pos = pos:GetPos()
		end

		local data = DataInstances.MapSettings_DustDevils
		local descr = data[severity] or data[mapdata.MapSettings_DustDevils] or data.DustDevils_VeryLow
		GenerateDustDevil(pos, descr, nil, major):Start()
	end
	function ChoGGi.MenuFuncs.DisasterTriggerMeteor(severity,meteors_type)
		meteors_type = meteors_type or "single"
		local pos = ChoGGi.ComFuncs.SelObject() or GetTerrainCursor()
		if type(pos) == "table" then
			pos = pos:GetPos()
		end
	--~	 pos = point(pos:x(),pos:y())

		local data = DataInstances.MapSettings_Meteor
		local descr = data[severity] or data[mapdata.MapSettings_Meteor] or data.Meteor_VeryLow
		if meteors_type == "single" then
			-- defaults to 50000, which is fine for multiple ones i suppose.
			descr.storm_radius = 1000
		else
			-- reset it back to 50000
			descr.storm_radius = descr:GetDefaultPropertyValue("storm_radius")
		end
		CreateGameTimeThread(function()
			MeteorsDisaster(descr, meteors_type, pos)
		end)
	end
	function ChoGGi.MenuFuncs.DisasterTriggerMetatronIonStorm()
		local ChoGGi = ChoGGi

		local pos = ChoGGi.ComFuncs.SelObject() or GetTerrainCursor()
		if type(pos) == "table" then
			pos = pos:GetPos()
		end

		local const = const
		local storm = PlaceObject("MetatronIonStorm")
		storm.expiration_time = ChoGGi.ComFuncs.Random(50 * const.HourDuration, 75 * const.HourDuration) + 14450
		storm:SetPos(pos)
		storm:SetAngle(ChoGGi.ComFuncs.Random(1,21600))
	end

	do -- DisasterTriggerLightningStrike
		local dust_storm
		local strike_radius
		local fuel_explosions
		local fuel_exp_count
		local strike_pos

		local Sleep = Sleep
		local MapForEach = MapForEach
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
					if not obj:IsKindOf("SupplyRocket") and obj:GetStoredAmount("Fuel") > 0 then
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
					PlayFX("ElectrostaticStorm", StringFormat("hit-moment%s",Random(1,5)), nil, nil, strike_pos)
					MapForEach(strike_pos, strike_radius + GetEntityMaxSurfacesRadius(), "Colonist", "Building", "Drone", "RCRover", "ResourceStockpileBase", MapForEachObjStrike)
					local exp = fuel_explosions or ""
					for i = 1, #exp do
						if IsValid(exp[i]) then
							FuelExplosion(exp[i])
						end
					end
					-- don't want to spam all at once
					Sleep(Random(100,750))
				end
			end)
		end
	end -- do

	function ChoGGi.MenuFuncs.DisastersStop()
		local mis = g_IncomingMissiles or {}
		for Key,_ in pairs(mis) do
			Key:ExplodeInAir()
		end

		if g_DustStorm then
			StopDustStorm()
			-- stop doesn't always seem to work, so adding this as well
			g_DustStormType = false
		end
		if g_ColdWave then
			StopColdWave()
			g_ColdWave = false
		end

		local objs = g_DustDevils
		if objs then
			for i = #objs, 1, -1 do
				objs[i]:delete()
			end
		end

		objs = g_MeteorsPredicted or ""
		for i = #objs, 1, -1 do
			Msg("MeteorIntercepted", objs[i])
			objs[i]:ExplodeInAir()
		end

		objs = g_IonStorms or ""
		for i = #objs, 1, -1 do
			objs[i]:delete()
			table.remove(g_IonStorms,i)
		end
	end

	do -- DisastersTrigger
		local trigger_table = {
			Stop = ChoGGi.MenuFuncs.DisastersStop,
			ColdWave = ChoGGi.MenuFuncs.DisasterTriggerColdWave,
			DustDevils = ChoGGi.MenuFuncs.DisasterTriggerDustDevils,
			DustDevilsMajor = function()
				ChoGGi.MenuFuncs.DisasterTriggerDustDevils(nil,"major")
			end,
			DustStormElectrostatic = function()
				ChoGGi.MenuFuncs.DisasterTriggerDustStorm(nil,"electrostatic")
			end,
			DustStormGreat = function()
				ChoGGi.MenuFuncs.DisasterTriggerDustStorm(nil,"great")
			end,
			DustStorm = ChoGGi.MenuFuncs.DisasterTriggerDustStorm,
			MeteorStorm = function()
				ChoGGi.MenuFuncs.DisasterTriggerMeteor(nil,"storm")
			end,
			MeteorMultiSpawn = function()
				ChoGGi.MenuFuncs.DisasterTriggerMeteor(nil,"multispawn")
			end,
			Meteor = ChoGGi.MenuFuncs.DisasterTriggerMeteor,
			MetatronIonStorm = ChoGGi.MenuFuncs.DisasterTriggerMetatronIonStorm,
		}
		local function AddTableToList(t,c,list,text,disaster,types)
			local func_name = StringFormat("DisasterTrigger%s",disaster)
			local remove_name = StringFormat("%s_",disaster)
			-- blanky blank
			types[#types+1] = false
			-- go through the DataInstances
			for i = 1, #list do
				local severity = list[i].name
				-- add one for each type
				for j = 1, #types do
					local d_type = types[j]
					local name = StringFormat("%s %s",severity,d_type or "")

					trigger_table[name] = function()
						ChoGGi.MenuFuncs[func_name](name,d_type)
					end
					c = c + 1
					t[c] = {
						text = StringFormat("%s: %s",S[text],name:gsub(remove_name,"")),
						value = name,
					}
				end
			end
			return t,c
		end

		local missile_hint = S[302535920001372--[[Change the number on the end to fire that amount (ex: %s25).--]]]:format(S[302535920000246--[[Missle--]]])
		local strike_hint = S[302535920001372--[[Change the number on the end to fire that amount (ex: %s25).--]]]:format(S[302535920001374--[[LightningStrike--]]])
		local default_mapdata_type = S[302535920000250--[[Default mapdata type--]]]
		function ChoGGi.MenuFuncs.DisastersTrigger()
			local ChoGGi = ChoGGi
			local ItemList = {
				{text = StringFormat(" %s %s",S[302535920000240--[[Stop--]]],S[3983--[[Disasters--]]]),value = "Stop",hint = S[302535920000123--[[Stops most disasters--]]]},

				{text = S[4149--[[Cold Wave--]]],value = "ColdWave",hint = default_mapdata_type},

				{text = S[4142--[[Dust Devils--]]],value = "DustDevils",hint = default_mapdata_type},
				{text = StringFormat("%s %s",S[4142--[[Dust Devils--]]],S[302535920000241--[[Major--]]]),value = "DustDevilsMajor",hint = default_mapdata_type},

				{text = S[4250--[[Dust Storm--]]],value = "DustStorm",hint = default_mapdata_type},
				{text = S[5627--[[Great Dust Storm--]]],value = "DustStormGreat",hint = default_mapdata_type},
				{text = S[5628--[[Electrostatic Dust Storm--]]],value = "DustStormElectrostatic",hint = default_mapdata_type},

				{text = S[4146--[[Meteors--]]],value = "Meteor",hint = default_mapdata_type},
				{text = StringFormat("%s %s",S[4146--[[Meteors--]]],S[302535920000245--[[Multi-Spawn--]]]),value = "MeteorMultiSpawn",hint = default_mapdata_type},
				{text = S[5620--[[Meteor Storm--]]],value = "MeteorStorm",hint = default_mapdata_type},

				{text = S[302535920000251--[[Metatron Ion Storm--]]],value = "MetatronIonStorm"},

				{text = StringFormat("%s %s",S[302535920000246--[[Missle--]]],1),value = "Missle1",hint = missile_hint},
				{text = StringFormat("%s %s",S[302535920000246--[[Missle--]]],50),value = "Missle50",hint = missile_hint},
				{text = StringFormat("%s %s",S[302535920000246--[[Missle--]]],100),value = "Missle100",hint = missile_hint},
				{text = StringFormat("%s %s",S[302535920000246--[[Missle--]]],500),value = "Missle500",hint = missile_hint},

				{text = StringFormat("%s %s",S[302535920001373--[[Lightning Strike--]]],1),value = "LightningStrike1",hint = strike_hint},
				{text = StringFormat("%s %s",S[302535920001373--[[Lightning Strike--]]],50),value = "LightningStrike50",hint = strike_hint},
				{text = StringFormat("%s %s",S[302535920001373--[[Lightning Strike--]]],100),value = "LightningStrike100",hint = strike_hint},
				{text = StringFormat("%s %s",S[302535920001373--[[Lightning Strike--]]],500),value = "LightningStrike500",hint = strike_hint},
			}
			-- add map settings for disasters
			local DataInstances = DataInstances
			local c = #ItemList
			ItemList,c = AddTableToList(ItemList,c,DataInstances.MapSettings_ColdWave,4149--[[Cold Wave--]],"ColdWave",{})
			ItemList,c = AddTableToList(ItemList,c,DataInstances.MapSettings_DustStorm,4250--[[Dust Storm--]],"DustStorm",{"major"})
			ItemList,c = AddTableToList(ItemList,c,DataInstances.MapSettings_DustDevils,4142--[[Dust Devils--]],"DustDevils",{"electrostatic","great"})
			ItemList,c = AddTableToList(ItemList,c,DataInstances.MapSettings_Meteor,4146--[[Meteors--]],"Meteor",{"storm","multispawn"})

			local function CallBackFunc(choice)
				if #choice < 1 then
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
						3983--[[Disasters--]]
					)
				end
			end

			ChoGGi.ComFuncs.OpenInListChoice{
				callback = CallBackFunc,
				items = ItemList,
				title = StringFormat("%s %s",S[1694--[[Start--]]],S[3983--[[Disasters--]]]),
				hint = 302535920000252--[[Targeted to mouse cursor (use arrow keys to select and enter to start, Ctrl/Shift to multi-select).--]],
				multisel = true,
			}
		end
	end -- do

	function ChoGGi.MenuFuncs.ShowScanAnomaliesOptions()
		local ItemList = {
			{text = S[4493--[[All--]]],value = "All",hint = S[302535920000329--[[Scan all anomalies.--]]]},
			{text = S[9--[[Anomaly--]]],value = "SubsurfaceAnomaly",icon = "<image UI/Icons/Anomaly_Event.tga 750>",hint = S[14--[[We have detected alien artifacts at this location that will <em>speed up</em> our Research efforts.<newline><newline>Send an <em>Explorer</em> to analyze the Anomaly.--]]]},
			{text = S[8--[[Breakthrough Tech--]]],value = "SubsurfaceAnomaly_breakthrough",icon = "<image UI/Icons/Anomaly_Breakthrough.tga 750>",hint = S[11--[[Our scientists believe that this Anomaly may lead to a <em>Breakthrough</em>.<newline><newline>Send an <em>Explorer</em> to analyze the Anomaly.--]]]},
			{text = S[3--[[Grant Research--]]],value = "SubsurfaceAnomaly_complete",icon = "<image UI/Icons/Anomaly_Research.tga 750>",hint = S[13--[[Sensors readings suggest that this Anomaly will help us with our current <em>Research</em> goals.<newline><newline>Send an <em>Explorer</em> to analyze the Anomaly.--]]]},
			{text = S[2--[[Unlock Tech--]]],value = "SubsurfaceAnomaly_unlock",icon = "<image UI/Icons/Anomaly_Tech.tga 750>",hint = S[12--[[Scans have detected some interesting readings that might help us discover <em>new Technologies</em>.<newline><newline>Send an <em>Explorer</em> to analyze the Anomaly.--]]]},
		}

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end

			for i = 1, #choice do
				local value = choice[i].value

				-- if 4 are selected that's all
				if value == "All" or #choice > 3 then
					local a = UICity.labels.Anomaly or ""
					for j = #a, 1, -1 do
						a[j]:CheatScan()
					end
					-- no sense in doing other choices as we just did all
					break
				else
					local a = UICity.labels.Anomaly or ""
					for j = #a, 1, -1 do
						if a[j]:IsKindOf(value) then
							a[j]:CheatScan()
						end
					end
				end
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 25--[[Anomaly Scanning--]],
			hint = 302535920000264--[[You can select multiple items.--]],
			multisel = true,
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.ShowScanAndMapOptions()
		local ChoGGi = ChoGGi
		local Consts = Consts
		local UICity = UICity
		local hint_core = S[302535920000253--[[Core: Repeatable, exploit core resources.--]]]
		local hint_deep = S[302535920000254--[[Deep: Toggleable, exploit deep resources.--]]]
		local ItemList = {
			{text = S[4493--[[All--]]],value = 1,hint = StringFormat("%s\n%s",hint_core,hint_deep)},
			{text = S[302535920000255--[[Deep--]]],value = 2,hint = hint_deep},
			{text = S[302535920000256--[[Core--]]],value = 3,hint = hint_core},

			{text = S[302535920000258--[[Reveal Map--]]],value = 12,hint = 302535920000259--[[Reveals the map squares--]]},
			{text = S[302535920000260--[[Reveal Map (Deep)--]]],value = 13,hint = 302535920000261--[[Reveals the map and unlocks "Deep" resources--]]},

			{text = S[302535920000257--[[Deep Scan--]]],value = 4,hint = StringFormat("%s\n%s: %s",hint_deep,S[302535920000030--[[Enabled--]]],Consts.DeepScanAvailable)},
			{text = S[797--[[Deep Water--]]],value = 5,hint = StringFormat("%s\n%s: %s",hint_deep,S[302535920000030--[[Enabled--]]],Consts.IsDeepWaterExploitable)},
			{text = S[793--[[Deep Metals--]]],value = 6,hint = StringFormat("%s\n%s: %s",hint_deep,S[302535920000030--[[Enabled--]]],Consts.IsDeepMetalsExploitable)},
			{text = S[801--[[Deep Rare Metals--]]],value = 7,hint = StringFormat("%s\n%s: %s",hint_deep,S[302535920000030--[[Enabled--]]],Consts.IsDeepPreciousMetalsExploitable)},
			{text = S[6548--[[Core Water--]]],value = 8,hint = hint_core},
			{text = S[6546--[[Core Metals--]]],value = 9,hint = hint_core},
			{text = S[6550--[[Core Rare Metals--]]],value = 10,hint = hint_core},
			{text = S[6556--[[Alien Imprints--]]],value = 11,hint = hint_core},
		}

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local function ExploreDeep()
				ChoGGi.ComFuncs.SetConstsG("DeepScanAvailable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.DeepScanAvailable))
				ChoGGi.ComFuncs.SetConstsG("IsDeepWaterExploitable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepWaterExploitable))
				ChoGGi.ComFuncs.SetConstsG("IsDeepMetalsExploitable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepMetalsExploitable))
				ChoGGi.ComFuncs.SetConstsG("IsDeepPreciousMetalsExploitable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepPreciousMetalsExploitable))
			end
			local function ExploreCore()
				Msg("TechResearched","CoreWater", UICity)
				Msg("TechResearched","CoreMetals", UICity)
				Msg("TechResearched","CoreRareMetals", UICity)
				Msg("TechResearched","AlienImprints", UICity)
			end

			for i = 1,#choice do
				local value = choice[i].value
				if value == 1 then
					CheatMapExplore("deep scanned")
	--~				 ExploreDeep()
					ExploreCore()
				elseif value == 2 then
					ExploreDeep()
				elseif value == 3 then
					ExploreCore()
				elseif value == 4 then
					ChoGGi.ComFuncs.SetConstsG("DeepScanAvailable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.DeepScanAvailable))
				elseif value == 5 then
					ChoGGi.ComFuncs.SetConstsG("IsDeepWaterExploitable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepWaterExploitable))
				elseif value == 6 then
					ChoGGi.ComFuncs.SetConstsG("IsDeepMetalsExploitable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepMetalsExploitable))
				elseif value == 7 then
					ChoGGi.ComFuncs.SetConstsG("IsDeepPreciousMetalsExploitable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepPreciousMetalsExploitable))
				elseif value == 8 then
					Msg("TechResearched","CoreWater", UICity)
				elseif value == 9 then
					Msg("TechResearched","CoreMetals", UICity)
				elseif value == 10 then
					Msg("TechResearched","CoreRareMetals", UICity)
				elseif value == 11 then
					Msg("TechResearched","AlienImprints", UICity)
				elseif value == 12 then
					CheatMapExplore("scanned")
				elseif value == 13 then
					CheatMapExplore("deep scanned")
				end
			end
			ChoGGi.ComFuncs.SetSavedSetting("DeepScanAvailable",Consts.DeepScanAvailable)
			ChoGGi.ComFuncs.SetSavedSetting("IsDeepWaterExploitable",Consts.IsDeepWaterExploitable)
			ChoGGi.ComFuncs.SetSavedSetting("IsDeepMetalsExploitable",Consts.IsDeepMetalsExploitable)
			ChoGGi.ComFuncs.SetSavedSetting("IsDeepPreciousMetalsExploitable",Consts.IsDeepPreciousMetalsExploitable)

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				302535920000262--[[Alice thought to herself. ""Now you will see a film made for children"".
Perhaps.
But I nearly forgot! You must close your eyes.
Otherwise you won't see anything."--]],
				302535920001355--[[Map--]],
				"UI/Achievements/TheRabbitHole.tga",
				true
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000263--[[Scan Map--]],
			hint = 302535920000264--[[You can select multiple items.--]],
			multisel = true,
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SpawnColonists()
		local ChoGGi = ChoGGi
		local ItemList = {
			{text = 1,value = 1},
			{text = 10,value = 10},
			{text = 25,value = 25},
			{text = 50,value = 50},
			{text = 75,value = 75},
			{text = 100,value = 100},
			{text = 250,value = 250},
			{text = 500,value = 500},
			{text = 1000,value = 1000},
			{text = 2500,value = 2500},
			{text = 5000,value = 5000},
			{text = 10000,value = 10000},
		}

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				CheatSpawnNColonists(value)
				MsgPopup(
					ChoGGi.ComFuncs.SettingState(choice[1].text,302535920000014--[[Spawned--]]),
					547--[[Colonists--]],
					"UI/Icons/Sections/colonist.tga"
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = StringFormat("%s %s",S[302535920000266--[[Spawn--]]],S[547--[[Colonists--]]]),
			hint = 302535920000267--[[Colonist placing priority: Selected dome, Evenly between domes, or centre of map if no domes.--]],
		}
	end

	do -- StartMystery
		local function StartMystery(mystery_id,instant)
			local ChoGGi = ChoGGi
			local UICity = UICity

			-- inform people of actions, so they don't add a bunch of them
			ChoGGi.UserSettings.ShowMysteryMsgs = true

			UICity.mystery_id = mystery_id

			for tech_id,tech in pairs(TechDef) do
				if tech.mystery == mystery_id then
					if not UICity.tech_status[tech_id] then
						UICity.tech_status[tech_id] = {points = 0, field = tech.group}
						tech:EffectsInit(UICity)
					end
				end
			end
			UICity:InitMystery()

			-- might help
			if UICity.mystery then
				UICity.mystery:ApplyMysteryResourceProperties()
			end

			-- instant start
			if instant then
				local seqs = UICity.mystery.seq_player.seq_list[1]
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


			-- needed to start mystery
			UICity.mystery.seq_player:AutostartSequences()
		end

		function ChoGGi.MenuFuncs.ShowMysteryList()
			local ChoGGi = ChoGGi
			local ItemList = {}
			local mysteries = ChoGGi.Tables.Mystery
			for i = 1, #mysteries do
				ItemList[i] = {
					text = StringFormat("%s: %s",mysteries[i].number,mysteries[i].name),
					value = mysteries[i].class,
					hint = StringFormat("%s\n\n\n\n<image %s>\n\n",mysteries[i].description,mysteries[i].image),
				}
			end

			local function CallBackFunc(choice)
				if #choice < 1 then
					return
				end
				local value = choice[1].value
				if choice[1].check1 then
					-- instant
					StartMystery(value,true)
				else
					StartMystery(value)
				end
			end

			ChoGGi.ComFuncs.OpenInListChoice{
				callback = CallBackFunc,
				items = ItemList,
				title = 302535920000268--[[Start A Mystery--]],
				hint = StringFormat("%s: %s",S[6779--[[Warning--]]],S[302535920000269--[["Adding a mystery is cumulative, this will NOT replace existing mysteries.

	See Cheats>%s to remove."--]]]:format(S[5661--[[Mystery Log--]]])),
				check = {
					{
						title = 302535920000270--[[Instant Start--]],
						hint = 302535920000271--[["May take up to one Sol to ""instantly"" activate mystery."--]],
					},
				},
			}
		end
	end -- do

	-- loops through all the sequences and adds the logs we've already seen
	local function ShowMysteryLog(MystName)
		local msgs = {StringFormat("%s\n\n%s\n",MystName,S[302535920000272--[["To play back speech use ""Tools>Exec"" and type in
g_Voice:Play(ChoGGi.CurObj.speech)"--]]])}
		local s_SeqListPlayers = s_SeqListPlayers
		-- 1 is some default map thing
		if #s_SeqListPlayers < 2 then
			return
		end
		for i = 1, #s_SeqListPlayers do
			if i > 1 then
				local seq_list = s_SeqListPlayers[i].seq_list
				if seq_list.name == MystName then
					for j = 1, #seq_list do
						local scenarios = seq_list[j]
						local state = s_SeqListPlayers[i].seq_states[scenarios.name]
						--have we started this seq yet?
						if state then
	--~						local ip = state and (state.ip or state.end_ip or 10000)
							for k = 1, #scenarios do
								local seq = scenarios[k]
								if seq:IsKindOf("SA_WaitMessage") then
									-- add to msg list
									msgs[#msgs+1] = {
										[" "] = StringFormat("%s: %s\n\n\n\n%s: %s",S[302535920000273--[[Speech--]]],Trans(seq.voiced_text),S[302535920000274--[[Message--]]],Trans(seq.text)),
										speech = seq.voiced_text,
										class = Trans(seq.title)
									}
								end
							end
						end
					end
				end
			end
		end
		-- display to user
		ChoGGi.ComFuncs.OpenInExamineDlg(msgs,nil,point(550,100))
	end

	function ChoGGi.MenuFuncs.ShowStartedMysteryList()
		local ChoGGi = ChoGGi
		local ItemList = {}
		local s_SeqListPlayers = s_SeqListPlayers
		local mysteries = ChoGGi.Tables.Mystery
		for i = 1, #s_SeqListPlayers do
			--1 is always there from map loading
			if i > 1 then
				local seq_list = s_SeqListPlayers[i].seq_list
				local totalparts = #seq_list[1]
				local id = seq_list.name
				local ip = s_SeqListPlayers[i].seq_states[seq_list[1].name].ip

				s_SeqListPlayers[i].mystery_idx = i
				ItemList[#ItemList+1] = {
					text = StringFormat("%s: %s",id,mysteries[id].name),
					value = id,
					func = id,
					mystery_idx = i,
					hint = StringFormat(
						"%s\n\n<color 255 75 75>%s</color>: %s <color 255 75 75>%s</color>: %s\n\n\n\n<image %s>\n\n",
						mysteries[id].description,
						S[302535920000275--[[Total parts--]]],
						totalparts,
						S[302535920000289--[[Current part--]]],
						ip or S[302535920000276--[[done?--]]],
						mysteries[id].image
					)
				}
			end
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			local mystery_idx = choice[1].mystery_idx
			if choice[1].check2 then
				--remove all
				for i = #s_SeqListPlayers, 1, -1 do
					if i > 1 then
						s_SeqListPlayers[i]:delete()
--~ 						table.remove(s_SeqListPlayers,i)
					end
				end
				for t in pairs(ThreadsMessageToThreads) do
					if t.player and t.player.seq_list.file_name then
						DeleteThread(t.thread)
						t = nil
					end
				end
				MsgPopup(
					302535920000277--[[Removed all!--]],
					3486--[[Mystery--]]
				)
			elseif choice[1].check1 then
				-- remove mystery
				for i = #s_SeqListPlayers, 1, -1 do
					if s_SeqListPlayers[i].mystery_idx == mystery_idx then
						s_SeqListPlayers[i]:delete()
--~ 						table.remove(s_SeqListPlayers,i)
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
					StringFormat("%s: %s %s!",choice[1].text,S[3486--[[Mystery--]]],S[302535920000278--[[Removed--]]]),
					3486--[[Mystery--]]
				)
			elseif value then
				-- next step
				ChoGGi.MenuFuncs.NextMysterySeq(value,mystery_idx)
			end

		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000279--[[Manage--]],
			hint = 302535920000280--[[Skip the timer delay, and optionally skip the requirements (applies to all mysteries that are the same type).

	Sequence part may have more then one check, you may have to skip twice or more.

	Double right-click selected mystery to review past messages.--]],
			check = {
				{
					title = 302535920000281--[[Remove--]],
					hint = StringFormat("%s: %s",S[6779--[[Warning--]]],S[302535920000282--[[This will remove the mystery, if you start it again; it'll be back to the start.--]]]),
				},
				{
					title = 302535920000283--[[Remove All--]],
					hint = StringFormat("%s: %s",S[6779--[[Warning--]]],S[302535920000284--[[This will remove all the mysteries!--]]]),
				},
			},
			custom_type = 6,
			custom_func = ShowMysteryLog,
		}
	end

	function ChoGGi.MenuFuncs.NextMysterySeq(mystery,mystery_idx)
		local ChoGGi = ChoGGi
		local g_Classes = g_Classes

		local warning = StringFormat("\n\n%s",S[302535920000285--[["Click ""Ok"" to skip requirements (Warning: may cause issues later on, untested)."--]]])
		local name = StringFormat("%s: %s",S[3486--[[Mystery--]]],ChoGGi.Tables.Mystery[mystery].name)

		for t in pairs(ThreadsMessageToThreads) do
			if t.player and t.player.mystery_idx == mystery_idx then

				-- only remove finished waittime threads, can cause issues removing other threads
				if t.finished == true and t.action:IsKindOfClasses("SA_WaitMarsTime","SA_WaitTime","SA_RunSequence") then
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
						local title = StringFormat("%s %s: %s",name,S[302535920000286--[[Part--]]],ip)

						-- seqs that add delays/tasks
						if seq:IsKindOfClasses("SA_WaitMarsTime","SA_WaitTime") then
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
							--t.action:EndWait(t)
							-- may not be needed
							Player:UpdateCurrentIP(seq_list)
							-- let them know
							MsgPopup(
								302535920000287--[[Timer delay removed (may take upto a Sol).--]],
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
										ChoGGi.Temp.SA_WaitMarsTime_StopWait = {mystery_idx = mystery_idx,again = true}
									else
										ChoGGi.Temp.SA_WaitMarsTime_StopWait = {mystery_idx = mystery_idx}
									end

									t.finished = true
									Player:UpdateCurrentIP(seq_list)
								end
							end
							ChoGGi.ComFuncs.QuestionBox(
								StringFormat("%s: %s\n\n%s%s",
									S[302535920000288--[[Advancement requires--]]],seq.expression,S[302535920000290--[[Time duration has been set to 0 (you still need to complete the requirements).

	Wait for a Sol or two for it to update (should give a popup msg).--]]],
									warning
								),
								CallBackFunc,
								title
							)
							break

						elseif seq:IsKindOf("SA_WaitMsg") then
							local function CallBackFunc(answer)
								if answer then
									ChoGGi.Temp.SA_WaitMarsTime_StopWait = {mystery_idx = mystery_idx,again = true}
									-- send fake msg (ok it's real, but it hasn't happened)
									Msg(seq.msg)
									Player:UpdateCurrentIP(seq_list)
								end
							end
							ChoGGi.ComFuncs.QuestionBox(
								StringFormat("%s: %s%s",S[302535920000288--[[Advancement requires--]]],seq.msg,warning),
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
								StringFormat("%s: %s%s",S[302535920000288--[[Advancement requires--]]],seq.Research,warning),
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
								S[302535920000291--[[Waiting for %s to finish.

	Skip it?--]]]:format(seq.sequence),
								CallBackFunc,
								title
							)

						end -- if seq type

					end --if i >= ip
				end --for seq_list

			end --if mystery thread
		end --for t

	end

	function ChoGGi.MenuFuncs.UnlockAllBuildings()
		CheatUnlockAllBuildings()
		RefreshXBuildMenu()
		MsgPopup(
			302535920000293--[[Unlocked all buildings for construction.--]],
			3980--[[Buildings--]],
			"UI/Icons/Upgrades/build_2.tga"
		)
	end

	function ChoGGi.MenuFuncs.AddResearchPoints()
		local ChoGGi = ChoGGi
		local ItemList = {
			{text = S[302535920001084--[[Reset--]]],value = "Reset",hint = 302535920000292--[[Resets sponsor points to default for that sponsor--]]},
			{text = 100,value = 100},
			{text = 100,value = 100},
			{text = 250,value = 250},
			{text = 500,value = 500},
			{text = 1000,value = 1000},
			{text = 2500,value = 2500},
			{text = 5000,value = 5000},
			{text = 10000,value = 10000},
			{text = 25000,value = 25000},
			{text = 50000,value = 50000},
			{text = 100000,value = 100000},
			{text = 100000000,value = 100000000},
		}

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				UICity:AddResearchPoints(value)
			elseif value == "Reset" then
				local default = GetMissionSponsor().research_points
				g_Consts.SponsorResearch = default
				Consts.SponsorResearch = default
			end
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice[1].text,302535920000294--[[Added--]]),
				311--[[Research--]],
				"UI/Icons/Upgrades/eternal_fusion_04.tga"
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000295--[[Add Research Points--]],
			hint = 302535920000296--[[If you need a little boost (or a lotta boost) in research.--]],
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.OutsourcingFree_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.SetConstsG("OutsourceResearchCost",ChoGGi.ComFuncs.NumRetBool(Consts.OutsourceResearchCost) and 0 or ChoGGi.Consts.OutsourceResearchCost)

		ChoGGi.ComFuncs.SetSavedSetting("OutsourceResearchCost",Consts.OutsourceResearchCost)
		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000297--[["%s
	Best hope you picked India as your Mars sponsor..."--]]]:format(ChoGGi.UserSettings.OutsourceResearchCost),
			311--[[Research--]],
			"UI/Icons/Sections/research_1.tga",
			true
		)
	end

	local hint_maxa = S[302535920000298--[[Max amount in UICity.tech_field list, you could make the amount larger if you want (an update/mod can add more).--]]]
	function ChoGGi.MenuFuncs.SetBreakThroughsOmegaTelescope()
		local ChoGGi = ChoGGi
		local DefaultSetting = ChoGGi.Consts.OmegaTelescopeBreakthroughsCount
		local MaxAmount = #UICity.tech_field.Breakthroughs
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
			{text = 6,value = 6},
			{text = 12,value = 12},
			{text = 24,value = 24},
			{text = MaxAmount,value = MaxAmount,hint = hint_maxa},
		}

		local hint = DefaultSetting
		if ChoGGi.UserSettings.OmegaTelescopeBreakthroughsCount then
			hint = ChoGGi.UserSettings.OmegaTelescopeBreakthroughsCount
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				const.OmegaTelescopeBreakthroughsCount = value
				ChoGGi.ComFuncs.SetSavedSetting("OmegaTelescopeBreakthroughsCount",value)

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					S[302535920000299--[[%s: Research is what I'm doing when I don't know what I'm doing.--]]]:format(choice[1].text),
					5182--[[Omega Telescope--]],
					default_icon
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000300--[[BreakThroughs From Omega--]],
			hint = StringFormat("%s: %s",S[302535920000106--[[Current--]]],hint),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetBreakThroughsAllowed()
		local ChoGGi = ChoGGi
		local DefaultSetting = ChoGGi.Consts.BreakThroughTechsPerGame
		local MaxAmount = #UICity.tech_field.Breakthroughs
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
			{text = 26,value = 26,hint = 302535920000301--[[Doubled the base amount.--]]},
			{text = MaxAmount,value = MaxAmount,hint = hint_maxa},
		}

		local hint = DefaultSetting
		if ChoGGi.UserSettings.BreakThroughTechsPerGame then
			hint = ChoGGi.UserSettings.BreakThroughTechsPerGame
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				const.BreakThroughTechsPerGame = value
				ChoGGi.ComFuncs.SetSavedSetting("BreakThroughTechsPerGame",value)

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					S[302535920000302--[[%s: S M R T--]]]:format(choice[1].text),
					311--[[Research--]],
					default_icon
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000303--[[BreakThroughs Allowed--]],
			hint = StringFormat("%s: %s",S[302535920000106--[[Current--]]],hint),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetResearchQueueSize()
		local ChoGGi = ChoGGi
		local DefaultSetting = ChoGGi.Consts.ResearchQueueSize
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
			{text = 5,value = 5},
			{text = 10,value = 10},
			{text = 25,value = 25},
			{text = 50,value = 50},
			{text = 100,value = 100},
			{text = 250,value = 250},
			{text = 500,value = 500},
		}

		--other hint type
		local hint = DefaultSetting
		local ResearchQueueSize = ChoGGi.UserSettings.ResearchQueueSize
		if ResearchQueueSize then
			hint = ResearchQueueSize
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then

				const.ResearchQueueSize = value
				ChoGGi.ComFuncs.SetSavedSetting("ResearchQueueSize",value)

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					S[302535920000304--[[%s: Nerdgasm--]]]:format(ChoGGi.UserSettings.ResearchQueueSize),
					311--[[Research--]],
					default_icon
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000305--[[Research Queue Size--]],
			hint = StringFormat("%s: %s",S[302535920000106--[[Current--]]],hint),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.ShowResearchTechList()
		local ChoGGi = ChoGGi
		local ItemList = {}
		local c = 1
		ItemList[c] = {
			text = StringFormat(" %s",S[302535920000306--[[Everything--]]]),
			value = "Everything",
			hint = 302535920000307--[[All the tech/breakthroughs/mysteries--]],
		}
		c = c + 1
		ItemList[c] = {
			text = StringFormat(" %s",S[302535920000308--[[All Tech--]]]),
			value = "AllTech",
			hint = 302535920000309--[[All the regular tech--]],
		}
		c = c + 1
		ItemList[c] = {
			text = StringFormat(" %s",S[302535920000310--[[All Breakthroughs--]]]),
			value = "AllBreakthroughs",
			hint = 302535920000311--[[All the breakthroughs--]],
		}
		c = c + 1
		ItemList[c] = {
			text = StringFormat(" %s",S[302535920000312--[[All Mysteries--]]]),
			value = "AllMysteries",
			hint = 302535920000313--[[All the mysteries--]],
		}

		local icon = "<image %s 250>"
		local hint = "%s\n\n%s: %s\n\n<image %s 1500>"
		local IsTechResearched = IsTechResearched
		for tech_id,tech in pairs(TechDef) do
			-- only show stuff not yet researched
			if not IsTechResearched(tech_id) then
				local text = Trans(tech.display_name)
				-- remove " from that one tech...
				if text:find("\"") then
					text = text:gsub("\"","")
				end
				c = c + 1
				ItemList[c] = {
					text = text,
					value = tech_id,
					icon = icon:format(tech.icon),
					hint = hint:format(Trans(T{tech.description,tech}),S[1000097--[[Category--]]],tech.group,tech.icon),
				}
			end
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
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
				text = S[2--[[Unlock Tech--]]]
			end
			-- override if both checked
			if check2 then
				func = "GrantTech"
				text = S[3--[[Grant Research--]]]
			end

			for i = 1, #choice do
				local value = choice[i].value
				if value == "Everything" then
					ChoGGi.MenuFuncs.SetTech_EveryMystery(func)
					ChoGGi.MenuFuncs.SetTech_EveryBreakthrough(func)
					ChoGGi.MenuFuncs.SetTech_EveryTech(func)
				elseif value == "AllTech" then
					ChoGGi.MenuFuncs.SetTech_EveryTech(func)
				elseif value == "AllBreakthroughs" then
					ChoGGi.MenuFuncs.SetTech_EveryBreakthrough(func)
				elseif value == "AllMysteries" then
					ChoGGi.MenuFuncs.SetTech_EveryMystery(func)
				else
					_G[func](value)
				end
			end

			MsgPopup(
				S[302535920000315--[[%s: Unleash your inner Black Monolith Mystery.--]]]:format(text),
				311--[[Research--]],
				default_icon
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = StringFormat("%s %s",S[311--[[Research--]]],S[3734--[[Tech--]]]),
			hint = 302535920000317--[[Select Unlock or Research then select the tech you want. Most mystery tech is locked to that mystery.--]],
			multisel = true,
			check = {
				{
					title = 2--[[Unlock Tech--]],
					hint = 302535920000319--[[Just unlocks in the research tree.--]],
					checked = true,
				},
				{
					title = 311--[[Research--]],
					hint = 302535920000320--[[Unlocks and researchs.--]],
				},
			},
			height = 800,
		}
	end

	-- tech_func = DiscoverTech_Old/GrantTech
	local function ListFields(tech_func,group)
		for tech_id,tech in pairs(TechDef) do
			if tech.group == group then
				_G[tech_func](tech_id)
			end
		end
	end

	function ChoGGi.MenuFuncs.SetTech_EveryMystery(tech_func)
		ListFields(tech_func,"Mysteries")
	end

	function ChoGGi.MenuFuncs.SetTech_EveryBreakthrough(tech_func)
		ListFields(tech_func,"Breakthroughs")
	end

	local groups = {
		Biotech = true,
		Engineering = true,
		Physics = true,
		Robotics = true,
		Social = true,
	}

	function ChoGGi.MenuFuncs.SetTech_EveryTech(tech_func)
		for tech_id,tech in pairs(TechDef) do
			if groups[tech.group] then
				_G[tech_func](tech_id)
			end
		end
	end

end
