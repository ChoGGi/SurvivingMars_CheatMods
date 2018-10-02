-- See LICENSE for terms

function OnMsg.ClassesGenerate()

	local TableConcat = ChoGGi.ComFuncs.TableConcat
	local MsgPopup = ChoGGi.ComFuncs.MsgPopup
	local RetName = ChoGGi.ComFuncs.RetName
	local S = ChoGGi.Strings

	local next,type = next,type
	local StringFormat = string.format

	function ChoGGi.MenuFuncs.ShowAutoUnpinObjectList()
		local ChoGGi = ChoGGi
		local ItemList = {
			{text = S[547--[[Colonists--]]],value = "Colonist"},
			{text = S[1120--[[Space Elevator--]]],value = "SpaceElevator"},
			{text = S[3518--[[Drone Hub--]]],value = "DroneHub"},
			{text = S[1685--[[Rocket--]]],value = "SupplyRocket"},

			{text = S[1682--[[RC Rover--]]],value = "RCRover"},
			{text = S[1684--[[RC Explorer--]]],value = "RCExplorer"},
			{text = S[1683--[[RC Transport--]]],value = "RCTransport"},

			{text = S[5017--[[Basic Dome--]]],value = "DomeBasic"},
			{text = S[5146--[[Medium Dome--]]],value = "DomeMedium"},
			{text = S[5152--[[Mega Dome--]]],value = "DomeMega"},
			{text = S[5188--[[Oval Dome--]]],value = "DomeOval"},
			{text = S[5093--[[Geoscape Dome--]]],value = "GeoscapeDome"},
			{text = S[9000--[[Micro Dome--]]],value = "DomeMicro"},
			{text = S[9003--[[Trigon Dome--]]],value = "DomeTrigon"},
			{text = S[9009--[[Mega Trigon Dome--]]],value = "DomeMegaTrigon"},
			{text = S[9012--[[Diamond Dome--]]],value = "DomeDiamond"},
			{text = S[302535920000347--[[Star Dome--]]],value = "DomeStar"},
			{text = S[302535920000351--[[Hexa Dome--]]],value = "DomeHexa"},
		}

		if not ChoGGi.UserSettings.UnpinObjects then
			ChoGGi.UserSettings.UnpinObjects = {}
		end

		--other hint type
		local EnabledList = {S[302535920001096--[[Auto Unpinned--]]],":"}
		local list = ChoGGi.UserSettings.UnpinObjects
		if next(list) then
			local tab = list or ""
			for i = 1, #tab do
				EnabledList[#EnabledList+1] = " "
				EnabledList[#EnabledList+1] = tab[i]
			end
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local check1 = choice[1].check1
			local check2 = choice[1].check2
			--nothing checked so just return
			if not check1 and not check2 then
				MsgPopup(
					302535920000038--[[Pick a checkbox next time...--]],
					302535920001092--[[Pins--]]
				)
				return
			elseif check1 and check2 then
				MsgPopup(
					302535920000039--[[Don't pick both checkboxes next time...--]],
					302535920001092--[[Pins--]]
				)
				return
			end

			local pins = ChoGGi.UserSettings.UnpinObjects
			for i = 1, #choice do
				local value = choice[i].value
				if check2 then
					for j = 1, #pins do
						if pins[j] == value then
							pins[j] = false
						end
					end
				elseif check1 then
					pins[#pins+1] = value
				end
			end

			--remove dupes
			ChoGGi.UserSettings.UnpinObjects = ChoGGi.ComFuncs.RetTableNoDupes(ChoGGi.UserSettings.UnpinObjects)

			local found = true
			while found do
				found = nil
				for i = 1, #ChoGGi.UserSettings.UnpinObjects do
					if ChoGGi.UserSettings.UnpinObjects[i] == false then
						ChoGGi.UserSettings.UnpinObjects[i] = nil
						found = true
						break
					end
				end
			end

			--if it's empty then remove setting
			if not next(ChoGGi.UserSettings.UnpinObjects) then
				ChoGGi.UserSettings.UnpinObjects = nil
			end
			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				S[302535920001093--[[Toggled: %s pinnable objects.--]]]:format(#choice),
				302535920001092--[[Pins--]]
			)
		end

		EnabledList[#EnabledList+1] = "\n"
		EnabledList[#EnabledList+1] = S[302535920001097--[[Enter a class name (SelectedObj.class) to add a custom entry.--]]]
		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920001095--[[Auto Remove Items From Pin List--]],
			hint = TableConcat(EnabledList),
			multisel = true,
			check = {
				{
					title = 302535920001098--[[Add to list--]],
					hint = 302535920001099--[[Add these items to the unpin list.--]],
				},
				{
					title = 302535920001100--[[Remove from list--]],
					hint = 302535920001101--[[Remove these items from the unpin list.--]],
				},
			},
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.CleanAllObjects()
		local dust = const.DustMaterialExterior
		MapForEach("map","BaseBuilding",function(o)
			if o.SetDust then
				o:SetDust(0,dust)
			end
		end)
		MsgPopup(
			302535920001102--[[Cleaned all--]],
			302535920001103--[[Objects--]]
		)
	end

	function ChoGGi.MenuFuncs.FixAllObjects()
		MapForEach("map","BaseBuilding",function(o)
			if o.Repair then
				o:Repair()
				o.accumulated_maintenance_points = 0
			end
		end)

		MapForEach("map","Drone",function(o)
			o:SetCommand("RepairDrone",s)
		end)

		MsgPopup(
			302535920001104--[[Fixed all--]],
			302535920001103--[[Objects--]]
		)
	end

	function ChoGGi.MenuFuncs.InfopanelCheats_Toggle()
		local ChoGGi = ChoGGi
		local config = config
		config.BuildingInfopanelCheats = not config.BuildingInfopanelCheats
		ReopenSelectionXInfopanel()
		ChoGGi.UserSettings.ToggleInfopanelCheats = config.BuildingInfopanelCheats

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920001122--[[%s: HAXOR--]]]:format(ChoGGi.UserSettings.ToggleInfopanelCheats),
			27--[[Cheats--]],
			"UI/Icons/Anomaly_Tech.tga"
		)
	end

	function ChoGGi.MenuFuncs.InfopanelCheatsCleanup_Toggle()
		local ChoGGi = ChoGGi

		if ChoGGi.UserSettings.CleanupCheatsInfoPane then
			-- needs default?
			ChoGGi.UserSettings.CleanupCheatsInfoPane = false
		else
			ChoGGi.UserSettings.CleanupCheatsInfoPane = true
			ChoGGi.InfoFuncs.InfopanelCheatsCleanup()
		end

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920001123--[[%s: Cleanup cheats infopane.--]]]:format(ChoGGi.UserSettings.CleanupCheatsInfoPane),
			27--[[Cheats--]],
			"UI/Icons/Anomaly_Tech.tga"
		)
	end

	function ChoGGi.MenuFuncs.ScannerQueueLarger_Toggle()
		local ChoGGi = ChoGGi
		const.ExplorationQueueMaxSize = ChoGGi.ComFuncs.ValueRetOpp(const.ExplorationQueueMaxSize,100,ChoGGi.Consts.ExplorationQueueMaxSize)
		ChoGGi.ComFuncs.SetSavedSetting("ExplorationQueueMaxSize",const.ExplorationQueueMaxSize)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920001124--[[%s: scans at a time.--]]]:format(ChoGGi.UserSettings.ExplorationQueueMaxSize),
			302535920001125--[[Scanner--]],
			"UI/Icons/Notifications/scan.tga"
		)
	end

	--SetTimeFactor(1000) = normal speed
	-- use GetTimeFactor() to check time for changing it so it can be paused?
	do -- SetGameSpeed
		local ChoGGi = ChoGGi
		local ChangeGameSpeedState = ChangeGameSpeedState

		local ItemList = {
			{text = S[1000121--[[Default--]]],value = 1},
			{text = S[302535920001126--[[Double--]]],value = 2},
			{text = S[302535920001127--[[Triple--]]],value = 3},
			{text = S[302535920001128--[[Quadruple--]]],value = 4},
			{text = S[302535920001129--[[Octuple--]]],value = 8},
			{text = S[302535920001130--[[Sexdecuple--]]],value = 16},
			{text = S[302535920001131--[[Duotriguple--]]],value = 32},
			{text = S[302535920001132--[[Quattuorsexaguple--]]],value = 64},
		}
		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				local const = const
				-- update values that are checked when speed is changed
				const.mediumGameSpeed = ChoGGi.Consts.mediumGameSpeed * value
				const.fastGameSpeed = ChoGGi.Consts.fastGameSpeed * value
				-- so it changes the speed immediately
				ChangeGameSpeedState(-1)
				ChangeGameSpeedState(1)
				-- update settings
				ChoGGi.UserSettings.mediumGameSpeed = const.mediumGameSpeed
				ChoGGi.UserSettings.fastGameSpeed = const.fastGameSpeed

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					S[302535920001135--[[%s: Excusa! Esta too mucho rapido for the eyes to follow? I'll show you in el slow motiono.--]]]:format(choice[1].text),
					302535920001136--[[Speed--]],
					"UI/Icons/Notifications/timer.tga",
					true
				)
			end
		end

		local speeds = {
			[3] = S[1000121--[[Default--]]],
			[6] = S[302535920001126--[[Double--]]],
			[9] = S[302535920001127--[[Triple--]]],
			[12] = S[302535920001128--[[Quadruple--]]],
			[24] = S[302535920001129--[[Octuple--]]],
			[48] = S[302535920001130--[[Sexdecuple--]]],
			[96] = S[302535920001131--[[Duotriguple--]]],
			[192] = S[302535920001132--[[Quattuorsexaguple--]]],
		}

		function ChoGGi.MenuFuncs.SetGameSpeed()
			local const = const
			local current = speeds[const.mediumGameSpeed]
			if not current then
				current = S[302535920001134--[[Custom: %s < base number 3 multipled by custom amount.--]]]:format(const.mediumGameSpeed)
			end

			ChoGGi.ComFuncs.OpenInListChoice{
				callback = CallBackFunc,
				items = ItemList,
				title = 302535920001137--[[Set Game Speed--]],
				hint = S[302535920000933--[[Current speed: %s--]]]:format(current),
				skip_sort = true,
			}
		end
	end -- do

	do -- SetEntity
		local entity_table = {}
		local function SetEntity(obj,entity)
			--backup orig
			if not obj.ChoGGi_OrigEntity then
				obj.ChoGGi_OrigEntity = obj.entity
			end
			if entity == "Default" then
				local orig = obj.ChoGGi_OrigEntity or obj:GetDefaultPropertyValue("entity")
				obj.entity = orig
				obj:ChangeEntity(orig)
				obj.ChoGGi_OrigEntity = nil
			else
				obj.entity = entity
				obj:ChangeEntity(entity)
			end
		end

		function ChoGGi.MenuFuncs.SetEntity()
			local ChoGGi = ChoGGi
			local sel = ChoGGi.ComFuncs.SelObject()
			local entity_str = 155--[[Entity--]]
			if not sel then
				MsgPopup(
					302535920001139--[[You need to select an object.--]],
					entity_str
				)
				return
			end

			local hint_noanim = S[302535920001140--[[No animation.--]]]
			if #entity_table == 0 then
				entity_table = {
					{text = StringFormat(" %s",S[302535920001141--[[Default Entity--]]]),value = "Default"},
					{text = StringFormat(" %s",S[302535920001142--[[Kosmonavt--]]]),value = "Kosmonavt"},
					{text = StringFormat(" %s",S[302535920001143--[[Jama--]]]),value = "Lama"},
					{text = StringFormat(" %s",S[302535920001144--[[Green Man--]]]),value = "GreenMan"},
					{text = StringFormat(" %s",S[302535920001145--[[Planet Mars--]]]),value = "PlanetMars",hint = hint_noanim},
					{text = StringFormat(" %s",S[302535920001146--[[Planet Earth--]]]),value = "PlanetEarth",hint = hint_noanim},
					{text = StringFormat(" %s",S[302535920001147--[[Rocket Small--]]]),value = "RocketUI",hint = hint_noanim},
					{text = StringFormat(" %s",S[302535920001148--[[Rocket Regular--]]]),value = "Rocket",hint = hint_noanim},
					{text = StringFormat(" %s",S[302535920001149--[[Combat Rover--]]]),value = "CombatRover",hint = hint_noanim},
					{text = StringFormat(" %s",S[302535920001150--[[PumpStation Demo--]]]),value = "PumpStationDemo",hint = hint_noanim},
				}
				local c = #entity_table
				for key,_ in pairs(EntityData) do
					c = c + 1
					entity_table[c] = {
						text = key,
						value = key,
						hint = hint_noanim
					}
				end
			end
			local ItemList = entity_table

			local function CallBackFunc(choice)
				if #choice < 1 then
					return
				end
				local value = choice[1].value
				local check1 = choice[1].check1
				local check2 = choice[1].check2
				if check1 and check2 then
					MsgPopup(
						302535920000039--[[Don't pick both checkboxes next time...--]],
						entity_str
					)
					return
				end

				local dome
				if sel.dome and check1 then
					dome = sel.dome
				end
				if EntityData[value] or value == "Default" then

					if check2 then
						SetEntity(sel,value)
					else
						MapForEach("map",sel.class,function(o)
							if dome then
								if o.dome and o.dome.handle == dome.handle then
									SetEntity(o,value)
								end
							else
								SetEntity(o,value)
							end
						end)
					end
					MsgPopup(
						StringFormat("%s: %s",choice[1].text,RetName(sel)),
						entity_str
					)
				end
			end

			ChoGGi.ComFuncs.OpenInListChoice{
				callback = CallBackFunc,
				items = ItemList,
				title = S[302535920001151--[[Set Entity For %s--]]]:format(RetName(sel)),
				hint = StringFormat("%s: %s\n%s\n\n%s",S[302535920000106--[[Current--]]],sel.ChoGGi_OrigEntity or sel.entity,S[302535920001157--[[If you don't pick a checkbox it will change all of selected type.--]]],S[302535920001153--[[Post a request if you want me to add more entities from EntityData (use ex(EntityData) to list).

	Not permanent for colonists after they exit buildings (for now).--]]]),
				check = {
					{
						title = 302535920000750--[[Dome Only--]],
						hint = 302535920001255--[[Will only apply to objects in the same dome as selected object.--]],
					},
					{
						title = 302535920000752--[[Selected Only--]],
						hint = 302535920001256--[[Will only apply to selected object.--]],
					},
				},
			}
		end
	end -- do

	do -- SetEntityScale
		local function SetScale(obj,Scale)
			local ChoGGi = ChoGGi
			local UserSettings = ChoGGi.UserSettings
			obj:SetScale(Scale)

			--changing entity to a static one and changing scale can make things not move so re-apply speeds.
			--and it needs a slight delay
			CreateRealTimeThread(function()
				Sleep(500)
				if obj:IsKindOf("Drone") then
					if UserSettings.SpeedDrone then
						obj:SetMoveSpeed(UserSettings.SpeedDrone)
					else
						obj:SetMoveSpeed(ChoGGi.CodeFuncs.GetSpeedDrone())
					end
				elseif obj:IsKindOf("CargoShuttle") then
					if UserSettings.SpeedShuttle then
						obj.move_speed = ChoGGi.Consts.SpeedShuttle
					else
						obj.move_speed = ChoGGi.Consts.SpeedShuttle
					end
				elseif obj:IsKindOf("Colonist") then
					if UserSettings.SpeedColonist then
						obj:SetMoveSpeed(UserSettings.SpeedColonist)
					else
						obj:SetMoveSpeed(ChoGGi.Consts.SpeedColonist)
					end
				elseif obj:IsKindOf("BaseRover") then
					if UserSettings.SpeedRC then
						obj:SetMoveSpeed(UserSettings.SpeedRC)
					else
						obj:SetMoveSpeed(ChoGGi.CodeFuncs.GetSpeedRC())
					end
				end
			end)
		end

		function ChoGGi.MenuFuncs.SetEntityScale()
			local ChoGGi = ChoGGi
			local sel = ChoGGi.ComFuncs.SelObject()
			if not sel then
				MsgPopup(
					302535920001139--[[You need to select an object.--]],
					1000081--[[Scale--]]
				)
				return
			end

			local ItemList = {
				{text = S[1000121--[[Default--]]],value = 100},
				{text = 25,value = 25},
				{text = 50,value = 50},
				{text = 100,value = 100},
				{text = 250,value = 250},
				{text = 500,value = 500},
				{text = 1000,value = 1000},
				{text = 10000,value = 10000},
			}

			local function CallBackFunc(choice)
				if #choice < 1 then
					return
				end
				local value = choice[1].value
				local check1 = choice[1].check1
				local check2 = choice[1].check2
				if check1 and check2 then
					MsgPopup(
						302535920000039--[[Don't pick both checkboxes next time...--]],
						1000081--[[Scale--]]
					)
					return
				end

				local dome
				if sel.dome and check1 then
					dome = sel.dome
				end
				if type(value) == "number" then

					if check2 then
						SetScale(sel,value)
					else
						MapForEach("map",sel.class,function(o)
							if dome then
								if o.dome and o.dome.handle == dome.handle then
									SetScale(o,value)
								end
							else
								SetScale(o,value)
							end
						end)
					end
					MsgPopup(
						StringFormat("%s: %s",choice[1].text,RetName(sel)),
						1000081--[[Scale--]],
						nil,
						nil,
						sel
					)
				end
			end

			ChoGGi.ComFuncs.OpenInListChoice{
				callback = CallBackFunc,
				items = ItemList,
				title = S[302535920001155--[[Set Entity Scale For %s--]]]:format(RetName(sel)),
				hint = StringFormat("%s: %s\n%s",S[302535920001156--[[Current object--]]],sel:GetScale(),S[302535920001157--[[If you don't pick a checkbox it will change all of selected type.--]]]),
				check = {
					{
						title = 302535920000750--[[Dome Only--]],
						hint = 302535920000751--[[Will only apply to colonists in the same dome as selected colonist.--]],
					},
					{
						title = 302535920000752--[[Selected Only--]],
						hint = 302535920000753--[[Will only apply to selected colonist.--]],
					},
				},
				skip_sort = true,
			}
		end
	end -- do

end
