-- See LICENSE for terms

local next,type = next,type

function OnMsg.ClassesGenerate()
	local Trans = ChoGGi.ComFuncs.Translate
	local TableConcat = ChoGGi.ComFuncs.TableConcat
	local MsgPopup = ChoGGi.ComFuncs.MsgPopup
	local RetName = ChoGGi.ComFuncs.RetName
	local S = ChoGGi.Strings

	function ChoGGi.MenuFuncs.ShowAutoUnpinObjectList()
		local ChoGGi = ChoGGi
		local ItemList = {
			{text = Trans(547--[[Colonists--]]),value = "Colonist"},
			{text = Trans(1120--[[Space Elevator--]]),value = "SpaceElevator"},
			{text = Trans(3518--[[Drone Hub--]]),value = "DroneHub"},
			{text = Trans(1685--[[Rocket--]]),value = "SupplyRocket"},

			{text = Trans(1682--[[RC Rover--]]),value = "RCRover"},
			{text = Trans(1684--[[RC Explorer--]]),value = "RCExplorer"},
			{text = Trans(1683--[[RC Transport--]]),value = "RCTransport"},

			{text = Trans(5017--[[Basic Dome--]]),value = "DomeBasic"},
			{text = Trans(5146--[[Medium Dome--]]),value = "DomeMedium"},
			{text = Trans(5152--[[Mega Dome--]]),value = "DomeMega"},
			{text = Trans(5188--[[Oval Dome--]]),value = "DomeOval"},
			{text = Trans(5093--[[Geoscape Dome--]]),value = "GeoscapeDome"},
			{text = Trans(9000--[[Micro Dome--]]),value = "DomeMicro"},
			{text = Trans(9003--[[Trigon Dome--]]),value = "DomeTrigon"},
			{text = Trans(9009--[[Mega Trigon Dome--]]),value = "DomeMegaTrigon"},
			{text = Trans(9012--[[Diamond Dome--]]),value = "DomeDiamond"},
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
			if choice.nothing_selected then
				return
			end
			local check1 = choice[1].check1
			local check2 = choice[1].check2

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

			-- remove dupes
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
				S[302535920000686--[[Auto Unpin Objects--]]]
			)
		end

		EnabledList[#EnabledList+1] = "\n"
		EnabledList[#EnabledList+1] = S[302535920001097--[[Enter a class name (SelectedObj.class) to add a custom entry.--]]]
		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = S[302535920001095--[[Auto Remove Items From Pin List--]]],
			hint = TableConcat(EnabledList),
			multisel = true,
			check = {
				at_least_one = true,
				only_one = true,
				{
					title = S[302535920001098--[[Add to list--]]],
					hint = S[302535920001099--[[Add these items to the unpin list.--]]],
					checked = true,
				},
				{
					title = S[302535920001100--[[Remove from list--]]],
					hint = S[302535920001101--[[Remove these items from the unpin list.--]]],
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
			"true",
			S[302535920000688--[[Clean All Objects--]]]
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
			"true",
			S[302535920000690--[[Fix All Objects--]]]
		)
	end

	function ChoGGi.MenuFuncs.ScannerQueueLarger_Toggle()
		const.ExplorationQueueMaxSize = ChoGGi.ComFuncs.ValueRetOpp(const.ExplorationQueueMaxSize,100,ChoGGi.Consts.ExplorationQueueMaxSize)
		ChoGGi.ComFuncs.SetSavedSetting("ExplorationQueueMaxSize",const.ExplorationQueueMaxSize)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.ExplorationQueueMaxSize),
			S[302535920000700--[[Scanner Queue Larger--]]],
			"UI/Icons/Notifications/scan.tga"
		)
	end

--~ 	SetTimeFactor(1000) = normal speed
	-- use GetTimeFactor() to check time for changing it so it can be paused?
	function ChoGGi.MenuFuncs.SetGameSpeed()
		local hint_str = S[302535920000523--[[How many to multiple the default speed by: <color 0 200 0>%s</color>--]]]
		local ItemList = {
			{text = Trans(1000121--[[Default--]]),value = 1,hint = hint_str:format(1)},
			{text = S[302535920001126--[[Double--]]],value = 2,hint = hint_str:format(2)},
			{text = S[302535920001127--[[Triple--]]],value = 3,hint = hint_str:format(3)},
			{text = S[302535920001128--[[Quadruple--]]],value = 4,hint = hint_str:format(4)},
			{text = S[302535920001129--[[Octuple--]]],value = 8,hint = hint_str:format(8)},
			{text = S[302535920001130--[[Sexdecuple--]]],value = 16,hint = hint_str:format(16)},
			{text = S[302535920001131--[[Duotriguple--]]],value = 32,hint = hint_str:format(32)},
			{text = S[302535920001132--[[Quattuorsexaguple--]]],value = 64,hint = hint_str:format(64)},
		}

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				local const = const
				-- update values that are checked when speed is changed
				const.mediumGameSpeed = ChoGGi.Consts.mediumGameSpeed * value
				const.fastGameSpeed = ChoGGi.Consts.fastGameSpeed * value
				-- so it changes the speed immediately
				if UISpeedState == "pause" then
					ChangeGameSpeedState(1)
					ChangeGameSpeedState(-1)
				else
					ChangeGameSpeedState(-1)
					ChangeGameSpeedState(1)
				end

				-- update settings
				ChoGGi.UserSettings.mediumGameSpeed = const.mediumGameSpeed
				ChoGGi.UserSettings.fastGameSpeed = const.fastGameSpeed

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					S[302535920001135--[[%s: Excusa! Esta too mucho rapido for the eyes to follow? I'll show you in el slow motiono.--]]]:format(choice[1].text),
					S[302535920000702--[[Game Speed--]]],
					"UI/Icons/Notifications/timer.tga",
					true
				)
			end
		end

		local speeds = {
			[3] = Trans(1000121--[[Default--]]),
			[6] = S[302535920001126--[[Double--]]],
			[9] = S[302535920001127--[[Triple--]]],
			[12] = S[302535920001128--[[Quadruple--]]],
			[24] = S[302535920001129--[[Octuple--]]],
			[48] = S[302535920001130--[[Sexdecuple--]]],
			[96] = S[302535920001131--[[Duotriguple--]]],
			[192] = S[302535920001132--[[Quattuorsexaguple--]]],
		}

		local const = const
		local current = speeds[const.mediumGameSpeed]
		if not current then
			current = S[302535920001134--[[Custom: %s < base number 3 multipled by custom amount.--]]]:format(const.mediumGameSpeed)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = S[302535920000702--[[Game Speed--]]],
			hint = S[302535920000933--[[Current speed: %s--]]]:format(current),
			skip_sort = true,
		}
	end

	do -- SetEntity
		local entity_table = {}
		local function SetEntity(obj,entity)
			--backup orig
			if not obj.ChoGGi_OrigEntity then
				obj.ChoGGi_OrigEntity = obj:GetEntity()
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

		function ChoGGi.MenuFuncs.ChangeEntity()
			local ChoGGi = ChoGGi
			local sel = ChoGGi.ComFuncs.SelObject()
			if not sel then
				MsgPopup(
					S[302535920001139--[[You need to select an object.--]]],
					S[302535920000682--[[Change Entity--]]]
				)
				return
			end

			local hint_noanim = S[302535920001140--[[No animation.--]]]
			if #entity_table == 0 then
				entity_table = {
					{text = " " .. S[302535920001141--[[Default Entity--]]],value = "Default"},
					{text = " " .. S[302535920001142--[[Kosmonavt--]]],value = "Kosmonavt"},
					{text = " " .. S[302535920001143--[[Jama--]]],value = "Lama"},
					{text = " " .. S[302535920001144--[[Green Man--]]],value = "GreenMan"},
					{text = " " .. S[302535920001145--[[Planet Mars--]]],value = "PlanetMars",hint = hint_noanim},
					{text = " " .. S[302535920001146--[[Planet Earth--]]],value = "PlanetEarth",hint = hint_noanim},
					{text = " " .. S[302535920001147--[[Rocket Small--]]],value = "RocketUI",hint = hint_noanim},
					{text = " " .. S[302535920001148--[[Rocket Regular--]]],value = "Rocket",hint = hint_noanim},
					{text = " " .. S[302535920001149--[[Combat Rover--]]],value = "CombatRover",hint = hint_noanim},
					{text = " " .. S[302535920001150--[[PumpStation Demo--]]],value = "PumpStationDemo",hint = hint_noanim},
				}
				local c = #entity_table
				local EntityData = EntityData
				for key in pairs(EntityData) do
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
				if choice.nothing_selected then
					return
				end
				local value = choice[1].value
				local check1 = choice[1].check1
				local check2 = choice[1].check2

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
						choice[1].text .. ": " .. RetName(sel),
						S[302535920000682--[[Change Entity--]]]
					)
				end
			end

			ChoGGi.ComFuncs.OpenInListChoice{
				callback = CallBackFunc,
				items = ItemList,
				title = S[302535920000682--[[Change Entity--]]] .. ": " .. RetName(sel),
				hint = S[302535920000106--[[Current--]]] .. ": "
					.. (sel.ChoGGi_OrigEntity or sel:GetEntity()) .. "\n"
					.. S[302535920001157--[[If you don't pick a checkbox it will change all of selected type.--]]]
					.. "\n\n"
					.. S[302535920001153--[[Post a request if you want me to add more entities from EntityData (use ex(EntityData) to list).

Not permanent for colonists after they exit buildings (for now).--]]],
					check = {
					only_one = true,
					{
						title = S[302535920000750--[[Dome Only--]]],
						hint = S[302535920001255--[[Will only apply to objects in the same dome as selected object.--]]],
					},
					{
						title = S[302535920000752--[[Selected Only--]]],
						hint = S[302535920001256--[[Will only apply to selected object.--]]],
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
						obj:SetMoveSpeed(ChoGGi.ComFuncs.GetResearchedTechValue("SpeedDrone"))
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
						obj:SetMoveSpeed(ChoGGi.ComFuncs.GetResearchedTechValue("SpeedRC"))
					end
				end
			end)
		end

		function ChoGGi.MenuFuncs.SetEntityScale()
			local ChoGGi = ChoGGi
			local sel = ChoGGi.ComFuncs.SelObject()
			if not sel then
				MsgPopup(
					S[302535920001139--[[You need to select an object.--]]],
					S[302535920000684--[[Change Entity Scale--]]]
				)
				return
			end

			local ItemList = {
				{text = Trans(1000121--[[Default--]]),value = 100},
				{text = 25,value = 25},
				{text = 50,value = 50},
				{text = 100,value = 100},
				{text = 250,value = 250},
				{text = 500,value = 500},
				{text = 1000,value = 1000},
				{text = 10000,value = 10000},
			}

			local function CallBackFunc(choice)
				if choice.nothing_selected then
					return
				end
				local value = choice[1].value
				local check1 = choice[1].check1
				local check2 = choice[1].check2

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
						choice[1].text .. ": " .. RetName(sel),
						S[302535920000684--[[Change Entity Scale--]]],
						nil,
						nil,
						sel
					)
				end
			end

			ChoGGi.ComFuncs.OpenInListChoice{
				callback = CallBackFunc,
				items = ItemList,
				title = S[302535920000684--[[Change Entity Scale--]]] .. ": " .. RetName(sel),
				hint = S[302535920001156--[[Current object--]]] .. ": " .. sel:GetScale()
					.. "\n" .. S[302535920001157--[[If you don't pick a checkbox it will change all of selected type.--]]],
				check = {
					only_one = true,
					{
						title = S[302535920000750--[[Dome Only--]]],
						hint = S[302535920000751--[[Will only apply to colonists in the same dome as selected colonist.--]]],
					},
					{
						title = S[302535920000752--[[Selected Only--]]],
						hint = S[302535920000753--[[Will only apply to selected colonist.--]]],
					},
				},
				skip_sort = true,
			}
		end
	end -- do

end
