-- See LICENSE for terms

local next,type = next,type

local Translate = ChoGGi.ComFuncs.Translate
local TableConcat = ChoGGi.ComFuncs.TableConcat
local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local RetName = ChoGGi.ComFuncs.RetName
local Strings = ChoGGi.Strings

function ChoGGi.MenuFuncs.ShowAutoUnpinObjectList()
	local item_list = {
		{text = Translate(547--[[Colonists--]]),value = "Colonist"},
		{text = Translate(1120--[[Space Elevator--]]),value = "SpaceElevator"},
		{text = Translate(3518--[[Drone Hub--]]),value = "DroneHub"},
		{text = Translate(1685--[[Rocket--]]),value = "SupplyRocket"},

		{text = Translate(1682--[[RC Rover--]]),value = "RCRover"},
		{text = Translate(1684--[[RC Explorer--]]),value = "RCExplorer"},
		{text = Translate(1683--[[RC Transport--]]),value = "RCTransport"},

		{text = Translate(5017--[[Basic Dome--]]),value = "DomeBasic"},
		{text = Translate(5146--[[Medium Dome--]]),value = "DomeMedium"},
		{text = Translate(5152--[[Mega Dome--]]),value = "DomeMega"},
		{text = Translate(5188--[[Oval Dome--]]),value = "DomeOval"},
		{text = Translate(5093--[[Geoscape Dome--]]),value = "GeoscapeDome"},
		{text = Translate(9000--[[Micro Dome--]]),value = "DomeMicro"},
		{text = Translate(9003--[[Trigon Dome--]]),value = "DomeTrigon"},
		{text = Translate(9009--[[Mega Trigon Dome--]]),value = "DomeMegaTrigon"},
		{text = Translate(9012--[[Diamond Dome--]]),value = "DomeDiamond"},
		{text = Strings[302535920000347--[[Star Dome--]]],value = "DomeStar"},
		{text = Strings[302535920000351--[[Hexa Dome--]]],value = "DomeHexa"},
	}

	if not ChoGGi.UserSettings.UnpinObjects then
		ChoGGi.UserSettings.UnpinObjects = {}
	end

	-- other hint type
	local EnabledList = {Strings[302535920001096--[[Auto Unpinned--]]],":"}
	local c = 0
	local list = ChoGGi.UserSettings.UnpinObjects
	if next(list) then
		local objs = list or ""
		for i = 1, #objs do
			c = c + 1
			EnabledList[c] = " "
			c = c + 1
			EnabledList[c] = objs[i]
		end
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local check1 = choice[1].check1
		local check2 = choice[1].check2

		local pins = ChoGGi.UserSettings.UnpinObjects
		local p_c = #pins
		for i = 1, #choice do
			local value = choice[i].value
			if check2 then
				for j = 1, #pins do
					local pin = pins[j]
					if pin == value then
						pin = false
					end
				end
			elseif check1 then
				p_c = p_c + 1
				pins[p_c] = value
			end
		end

		-- remove dupes
		ChoGGi.ComFuncs.TableCleanDupes(ChoGGi.UserSettings.UnpinObjects)

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
			Strings[302535920001093--[[Toggled: %s pinnable objects.--]]]:format(#choice),
			Strings[302535920000686--[[Auto Unpin Objects--]]]
		)
	end

	c = c + 1
	EnabledList[c] = "\n"
	c = c + 1
	EnabledList[c] = Strings[302535920001097--[[Enter a class name (SelectedObj.class) to add a custom entry.--]]]
	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920001095--[[Auto Remove Items From Pin List--]]],
		hint = TableConcat(EnabledList),
		multisel = true,
		skip_sort = true,
		checkboxes = {
			at_least_one = true,
			only_one = true,
			{
				title = Strings[302535920001098--[[Add to list--]]],
				hint = Strings[302535920001099--[[Add these items to the unpin list.--]]],
				checked = true,
			},
			{
				title = Strings[302535920001100--[[Remove from list--]]],
				hint = Strings[302535920001101--[[Remove these items from the unpin list.--]]],
			},
		},
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
		Strings[302535920000688--[[Clean All Objects--]]]
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
		Strings[302535920000690--[[Fix All Objects--]]]
	)
end

function ChoGGi.MenuFuncs.ScannerQueueLarger_Toggle()
	const.ExplorationQueueMaxSize = ChoGGi.ComFuncs.ValueRetOpp(const.ExplorationQueueMaxSize,100,ChoGGi.Consts.ExplorationQueueMaxSize)
	ChoGGi.ComFuncs.SetSavedConstSetting("ExplorationQueueMaxSize")

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.ExplorationQueueMaxSize),
		Strings[302535920000700--[[Scanner Queue Larger--]]]
	)
end

--~ 	SetTimeFactor(1000) = normal speed
-- use GetTimeFactor() to check time for changing it so it can be paused?
function ChoGGi.MenuFuncs.SetGameSpeed()
	local hint_str = Strings[302535920000523--[[How many to multiple the default speed by: <color 0 200 0>%s</color>--]]]
	local item_list = {
		{text = Translate(1000121--[[Default--]]),value = 1,hint = hint_str:format(1)},
		{text = Strings[302535920001126--[[Double--]]],value = 2,hint = hint_str:format(2)},
		{text = Strings[302535920001127--[[Triple--]]],value = 3,hint = hint_str:format(3)},
		{text = Strings[302535920001128--[[Quadruple--]]],value = 4,hint = hint_str:format(4)},
		{text = Strings[302535920001129--[[Octuple--]]],value = 8,hint = hint_str:format(8)},
		{text = Strings[302535920001130--[[Sexdecuple--]]],value = 16,hint = hint_str:format(16)},
		{text = Strings[302535920001131--[[Duotriguple--]]],value = 32,hint = hint_str:format(32)},
		{text = Strings[302535920001132--[[Quattuorsexaguple--]]],value = 64,hint = hint_str:format(64)},
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
				Strings[302535920001135--[[%s: Excusa! Esta too mucho rapido for the eyes to follow? I'll show you in el slow motiono.--]]]:format(choice[1].text),
				Strings[302535920000702--[[Game Speed--]]],
				nil,
				true
			)
		end
	end

	local speeds = {
		[3] = Translate(1000121--[[Default--]]),
		[6] = Strings[302535920001126--[[Double--]]],
		[9] = Strings[302535920001127--[[Triple--]]],
		[12] = Strings[302535920001128--[[Quadruple--]]],
		[24] = Strings[302535920001129--[[Octuple--]]],
		[48] = Strings[302535920001130--[[Sexdecuple--]]],
		[96] = Strings[302535920001131--[[Duotriguple--]]],
		[192] = Strings[302535920001132--[[Quattuorsexaguple--]]],
	}

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000702--[[Game Speed--]]],
		hint = Strings[302535920000933--[[Current speed: %s--]]]:format(speeds[const.mediumGameSpeed])
			.. "\n" .. Strings[302535920001134--[[%s = base number %s multipled by custom value amount.--]]]:format(Strings[302535920000078--[[Custom Value--]]],const.mediumGameSpeed),
		skip_sort = true,
	}
end

do -- SetEntity
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
		local obj = ChoGGi.ComFuncs.SelObject()
		if not obj then
			MsgPopup(
				Strings[302535920001139--[[You need to select an object.--]]],
				Strings[302535920000682--[[Change Entity--]]]
			)
			return
		end

		local hint_noanim = Strings[302535920001140--[[No animation.--]]]
		local item_list = {
			{text = " " .. Strings[302535920001141--[[Default Entity--]]],value = "Default"},
			{text = " " .. Strings[302535920001142--[[Kosmonavt--]]],value = "Kosmonavt"},
			{text = " " .. Strings[302535920001143--[[Jama--]]],value = "Lama"},
			{text = " " .. Strings[302535920001144--[[Green Man--]]],value = "GreenMan"},
			{text = " " .. Strings[302535920001145--[[Planet Mars--]]],value = "PlanetMars",hint = hint_noanim},
			{text = " " .. Strings[302535920001146--[[Planet Earth--]]],value = "PlanetEarth",hint = hint_noanim},
			{text = " " .. Strings[302535920001147--[[Rocket Small--]]],value = "RocketUI",hint = hint_noanim},
			{text = " " .. Strings[302535920001148--[[Rocket Regular--]]],value = "Rocket",hint = hint_noanim},
			{text = " " .. Strings[302535920001149--[[Combat Rover--]]],value = "CombatRover",hint = hint_noanim},
			{text = " " .. Strings[302535920001150--[[PumpStation Demo--]]],value = "PumpStationDemo",hint = hint_noanim},
		}
		local c = #item_list
		local EntityData = EntityData
		for key in pairs(EntityData) do
			c = c + 1
			item_list[c] = {
				text = key,
				value = key,
				hint = hint_noanim
			}
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local value = choice[1].value
			local check1 = choice[1].check1
			local check2 = choice[1].check2

			local dome
			if obj.dome and check1 then
				dome = obj.dome
			end
			if EntityData[value] or value == "Default" then

				if check2 then
					SetEntity(obj,value)
				else
					MapForEach("map",obj.class,function(o)
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
					choice[1].text .. ": " .. RetName(obj),
					Strings[302535920000682--[[Change Entity--]]]
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = Strings[302535920000682--[[Change Entity--]]] .. ": " .. RetName(obj),
			custom_type = 7,
			hint = Strings[302535920000106--[[Current--]]] .. ": "
				.. (obj.ChoGGi_OrigEntity or obj:GetEntity()) .. "\n"
				.. Strings[302535920001157--[[If you don't pick a checkbox it will change all of selected type.--]]]
				.. "\n\n"
				.. Strings[302535920001153--[[Post a request if you want me to add more entities from EntityData (use ex(EntityData) to list).

Not permanent for colonists after they exit buildings (for now).--]]],
			checkboxes = {
				only_one = true,
				{
					title = Strings[302535920000750--[[Dome Only--]]],
					hint = Strings[302535920001255--[[Will only apply to objects in the same dome as selected object.--]]],
				},
				{
					title = Strings[302535920000752--[[Selected Only--]]],
					hint = Strings[302535920001256--[[Will only apply to selected object.--]]],
				},
			},
		}
	end
end -- do

do -- SetEntityScale
	local function SetScale(obj,Scale)
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
		local obj = ChoGGi.ComFuncs.SelObject()
		if not obj then
			MsgPopup(
				Strings[302535920001139--[[You need to select an object.--]]],
				Strings[302535920000684--[[Change Entity Scale--]]]
			)
			return
		end

		local item_list = {
			{text = Translate(1000121--[[Default--]]),value = 100},
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
			if obj.dome and check1 then
				dome = obj.dome
			end
			if type(value) == "number" then

				if check2 then
					SetScale(obj,value)
				else
					MapForEach("map",obj.class,function(o)
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
					choice[1].text .. ": " .. RetName(obj),
					Strings[302535920000684--[[Change Entity Scale--]]],
					nil,
					nil,
					obj
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = Strings[302535920000684--[[Change Entity Scale--]]] .. ": " .. RetName(obj),
			hint = Strings[302535920001156--[[Current object--]]] .. ": " .. obj:GetScale()
				.. "\n" .. Strings[302535920001157--[[If you don't pick a checkbox it will change all of selected type.--]]],
			skip_sort = true,
			checkboxes = {
				only_one = true,
				{
					title = Strings[302535920000750--[[Dome Only--]]],
					hint = Strings[302535920000751--[[Will only apply to colonists in the same dome as selected colonist.--]]],
				},
				{
					title = Strings[302535920000752--[[Selected Only--]]],
					hint = Strings[302535920000753--[[Will only apply to selected colonist.--]]],
				},
			},
		}
	end
end -- do
