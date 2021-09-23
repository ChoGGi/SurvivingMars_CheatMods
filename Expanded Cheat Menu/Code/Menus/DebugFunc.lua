-- See LICENSE for terms

local pairs, type, tostring, table = pairs, type, tostring, table
local IsValid = IsValid
local GetCursorWorldPos = GetCursorWorldPos

local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local RetName = ChoGGi.ComFuncs.RetName
local Translate = ChoGGi.ComFuncs.Translate
local RandomColour = ChoGGi.ComFuncs.RandomColour
local Strings = ChoGGi.Strings

function ChoGGi.MenuFuncs.Interface_Toggle()
	hr.RenderUIL = hr.RenderUIL == 0 and 1 or 0
end

function ChoGGi.MenuFuncs.InfoPanelDlg_Toggle()
	local info = Dialogs.Infopanel
	if not info then
		return
	end

	if info.HAlign == "center" then
		info:SetHAlign("right")
		info:SetVAlign("top")
	else
		info:SetHAlign("center")
		info:SetVAlign("center")
	end
end

function ChoGGi.MenuFuncs.ExamineObjectRadius_Set()
	local item_list = {
		{text = 100, value = 100},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
		{text = "2500 *", value = 2500, hint = T(1000121, "Default")},
		{text = 5000, value = 5000},
		{text = 10000, value = 10000},
		{text = 25000, value = 25000},
		{text = 50000, value = 50000},
		{text = 100000, value = 100000},
		{text = 1000000, value = 1000000},
	}

	local title = Strings[302535920000069--[[Examine]]] .. " " .. Strings[302535920000163--[[Radius]]]

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			ChoGGi.UserSettings.ExamineObjectRadius = value
			MsgPopup(value, title)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = title,
		skip_sort = true,
		hint = Strings[302535920000923--[[Set the radius used for %s examining.]]]:format(ChoGGi.ComFuncs.GetShortcut(".Keys.Examine Objects Shift")),
	}
end

do -- SetEntity
	local function SetEntity(obj, entity)
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
				Strings[302535920001139--[[You need to select an object.]]],
				Strings[302535920000682--[[Change Entity]]]
			)
			return
		end

		local hint_noanim = Strings[302535920001140--[[No animation.]]]
		local item_list = {
			{text = " " .. Strings[302535920001141--[[Default Entity]]], value = "Default"},
			{text = " " .. Strings[302535920001142--[[Kosmonavt]]], value = "Kosmonavt"},
			{text = " " .. Strings[302535920001143--[[Jama]]], value = "Lama"},
			{text = " " .. Strings[302535920001144--[[Green Man]]], value = "GreenMan"},
			{text = " " .. Strings[302535920001145--[[Planet Mars]]], value = "PlanetMars", hint = hint_noanim},
			{text = " " .. Strings[302535920001146--[[Planet Earth]]], value = "PlanetEarth", hint = hint_noanim},
			{text = " " .. Strings[302535920001147--[[Rocket Small]]], value = "RocketUI", hint = hint_noanim},
			{text = " " .. Strings[302535920001148--[[Rocket Regular]]], value = "Rocket", hint = hint_noanim},
			{text = " " .. Strings[302535920001149--[[Combat Rover]]], value = "CombatRover", hint = hint_noanim},
			{text = " " .. Strings[302535920001150--[[PumpStation Demo]]], value = "PumpStationDemo", hint = hint_noanim},
		}
		local c = #item_list
		local EntityData = EntityData
		for key in pairs(EntityData) do
			c = c + 1
			item_list[c] = {
				text = key,
				value = key,
				hint = hint_noanim,
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
					SetEntity(obj, value)
				else
					MapForEach("map", obj.class, function(o)
						if dome then
							if o.dome and o.dome.handle == dome.handle then
								SetEntity(o, value)
							end
						else
							SetEntity(o, value)
						end
					end)
				end
				MsgPopup(
					choice[1].text .. ": " .. RetName(obj),
					Strings[302535920000682--[[Change Entity]]]
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = Strings[302535920000682--[[Change Entity]]] .. ": " .. RetName(obj),
			custom_type = 7,
			hint = Strings[302535920000106--[[Current]]] .. ": "
				.. (obj.ChoGGi_OrigEntity or obj:GetEntity()) .. "\n"
				.. Strings[302535920001157--[[If you don't pick a checkbox it will change all of selected type.]]]
				.. "\n\n"
				.. Strings[302535920001153--[[Post a request if you want me to add more entities from EntityData (use ex(EntityData) to list).

Not permanent for colonists after they exit buildings (for now).]]],
			checkboxes = {
				only_one = true,
				{
					title = Strings[302535920000750--[[Dome Only]]],
					hint = Strings[302535920001255--[[Will only apply to objects in the same dome as selected object.]]],
				},
				{
					title = Strings[302535920000752--[[Selected Only]]],
					hint = Strings[302535920001256--[[Will only apply to selected object.]]],
				},
			},
		}
	end
end -- do

do -- SetEntityScale
	local function SetScale(obj, Scale)
		local UserSettings = ChoGGi.UserSettings
		obj:SetScale(Scale)

		--changing entity to a static one and changing scale can make things not move so re-apply speeds.
		--and it needs a slight delay
		CreateRealTimeThread(function()
			Sleep(500)
			if obj:IsKindOf("Drone") then
				obj:SetBase("move_speed", UserSettings.SpeedDrone or ChoGGi.ComFuncs.GetResearchedTechValue("SpeedDrone"))
			elseif obj:IsKindOf("CargoShuttle") then
				obj:SetBase("move_speed", UserSettings.SpeedShuttle or ChoGGi.Consts.SpeedShuttle)
			elseif obj:IsKindOf("Colonist") then
				obj:SetBase("move_speed", UserSettings.SpeedColonist or ChoGGi.Consts.SpeedColonist)
			elseif obj:IsKindOf("BaseRover") then
				obj:SetBase("move_speed", UserSettings.SpeedRC or ChoGGi.ComFuncs.GetResearchedTechValue("SpeedRC"))
			end
		end)
	end

	function ChoGGi.MenuFuncs.SetEntityScale()
		local obj = ChoGGi.ComFuncs.SelObject()
		if not obj then
			MsgPopup(
				Strings[302535920001139--[[You need to select an object.]]],
				Strings[302535920000684--[[Change Entity Scale]]]
			)
			return
		end

		local item_list = {
			{text = Translate(1000121--[[Default]]), value = 100},
			{text = 25, value = 25},
			{text = 50, value = 50},
			{text = 100, value = 100},
			{text = 250, value = 250},
			{text = 500, value = 500},
			{text = 1000, value = 1000},
			{text = 10000, value = 10000},
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
					SetScale(obj, value)
				else
					MapForEach("map", obj.class, function(o)
						if dome then
							if o.dome and o.dome.handle == dome.handle then
								SetScale(o, value)
							end
						else
							SetScale(o, value)
						end
					end)
				end
				MsgPopup(
					choice[1].text .. ": " .. RetName(obj),
					Strings[302535920000684--[[Change Entity Scale]]],
					{objects = obj}
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = Strings[302535920000684--[[Change Entity Scale]]] .. ": " .. RetName(obj),
			hint = Strings[302535920001156--[[Current object]]] .. ": " .. obj:GetScale()
				.. "\n" .. Strings[302535920001157--[[If you don't pick a checkbox it will change all of selected type.]]],
			skip_sort = true,
			checkboxes = {
				only_one = true,
				{
					title = Strings[302535920000750--[[Dome Only]]],
					hint = Strings[302535920000751--[[Will only apply to colonists in the same dome as selected colonist.]]],
				},
				{
					title = Strings[302535920000752--[[Selected Only]]],
					hint = Strings[302535920000753--[[Will only apply to selected colonist.]]],
				},
			},
		}
	end
end -- do

function ChoGGi.MenuFuncs.DTMSlotsDlg_Toggle()
	local dlg = ChoGGi.ComFuncs.GetDialogECM("ChoGGi_DlgDTMSlots")
	if dlg then
		dlg:Close()
	else
		ChoGGi.ComFuncs.OpenInDTMSlotsDlg()
	end
end

function ChoGGi.MenuFuncs.SetFrameCounter()
	local fps = hr.FpsCounter
	fps = fps + 1
	if fps > 2 then
		fps = 0
	end
	hr.FpsCounter = fps
end

function ChoGGi.MenuFuncs.SetFrameCounterLocation(action)
	local setting = action.setting_mask
	hr.FpsCounterPos = setting

	if setting == 1 then
		ChoGGi.UserSettings.FrameCounterLocation = nil
	else
		ChoGGi.UserSettings.FrameCounterLocation = setting
	end
	ChoGGi.SettingFuncs.WriteSettings()
end

function ChoGGi.MenuFuncs.LoadingScreenLog_Toggle()
	ChoGGi.UserSettings.LoadingScreenLog = not ChoGGi.UserSettings.LoadingScreenLog
	ChoGGi.ComFuncs.SetLoadingScreenLog()

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.LoadingScreenLog),
		Strings[302535920000049--[[Loading Screen Log]]]
	)
end

function ChoGGi.MenuFuncs.DeleteObject(_, _, input)
	if input == "keyboard" then
		ChoGGi.ComFuncs.DeleteObject()
	else
		local obj = ChoGGi.ComFuncs.SelObject()
		if IsValid(obj) then
			ChoGGi.ComFuncs.DeleteObjectQuestion(obj)
		end
	end
end

do -- TestLocaleFile
	local saved_file_path

	function ChoGGi.MenuFuncs.TestLocaleFile()
		local hint = Strings[302535920001155--[["Enter the path to the CSV file you want to test (defaults to mine as an example).
You can edit the CSV then run this again without having to restart the game.
"]]]

		local item_list = {
			{
				text = Strings[302535920001137--[[CSV Path]]],
				value = ChoGGi.library_path .. "Locales/English.csv",
				hint = hint,
			},
			{
				text = Strings[302535920001162--[[Test Columns]]],
				value = "false",
				hint = Strings[302535920001166--[["Reports any columns above the normal amount (5).
Columns are added by commas (, ). Surround the entire string with """" to use them.

Try to increase or decrease the number if not enough or too many errors show up.
For the value enter either ""true"" (to use 5) or a number.

You need my HelperMod installed to be able to use this."]]],
			},
		}
		if saved_file_path then
			item_list[1].value = saved_file_path
		end

		local function CallBackFunc(choice)
			choice = choice[1]

			local path = choice.value
			-- keep path if dialog is closed
			saved_file_path = path

			ChoGGi.ComFuncs.TestLocaleFile(
				path,
				ChoGGi.ComFuncs.RetProperType(choice.value)
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = Strings[302535920001125--[[Test Locale File]]],
			hint = hint,
			custom_type = 9,
			skip_sort = true,
			width = 900,
			height = 250,
		}

	end
end -- do

function ChoGGi.MenuFuncs.ExamineObject()
	-- try to get object in-game first
	local objs = ChoGGi.ComFuncs.SelObjects()
	local c = #objs
	if c > 0 then
		-- If it's a single obj then examine that, otherwise the whole list
		ChoGGi.ComFuncs.OpenInExamineDlg(c == 1 and objs[1] or objs)
		return
	end

	if UseGamepadUI() then
		return
	end

	local terminal = terminal

	-- next we check if there's a ui element under the cursor and return that
	local target = terminal.desktop:GetMouseTarget(terminal.GetMousePos())
	-- everywhere is covered in xdialogs so skip them
	if target and not target:IsKindOf("XDialog") then
		return ChoGGi.ComFuncs.OpenInExamineDlg(target)
	end

	-- If in main menu then open examine and console
	if not Dialogs.HUD then
		local dlg = ChoGGi.ComFuncs.OpenInExamineDlg(terminal.desktop)
		-- off centre of central monitor
		local width = (terminal.desktop.measure_width or 1920) - (dlg.dialog_width_scaled + 100)
		dlg:SetPos(point(width, 100))
		ChoGGi.ComFuncs.ToggleConsole(true)
	end
end

function ChoGGi.MenuFuncs.OpenInGedObjectEditor()
	local obj = ChoGGi.ComFuncs.SelObject()
	if IsValid(obj) then
		GedObjectEditor = false
		OpenGedGameObjectEditor{obj}
	end
end

function ChoGGi.MenuFuncs.ListVisibleObjects()
	local frame = (GetFrameMark() / 1024 - 1) * 1024
	local visible = MapGet("map", "attached", false, function(obj)
		return obj:GetFrameMark() - frame > 0
	end)
	ChoGGi.ComFuncs.OpenInExamineDlg(visible, nil, Strings[302535920001547--[[Visible Objects]]])
end

do -- BuildingPathMarkers_Toggle
--~ 		GetEntityWaypointChains(entity)
	-- mostly a copy n paste from Lua\Buildings\BuildingWayPoints.lua: ShowWaypoints()
	local DoneObject = DoneObject
	local AveragePoint2D = AveragePoint2D
	local OText, OPolyline
--~ 	local XText, OPolyline
--~ 	local parent

	local objlist = objlist
	local points, colours = objlist:new(), objlist:new()
	local function ShowWaypoints(waypoints, open)
		points:Clear()
		colours:Clear()

		local colour_line = RandomColour()
		local colour_door = RandomColour()
		local lines = objlist:new()
		for i = 1, #waypoints do
			local waypoint = waypoints[i]
			local colour = i == open and colour_door or colour_line
			points[i] = waypoint
			colours[i] = colour
			local t = OText:new()
			t:SetPos(waypoint:SetZ(waypoint:z() or waypoint:SetTerrainZ(10 * guic)))
			t:SetColor1(colour)
			t:SetText(i .. "")
			lines[i] = t
		end
		local line = OPolyline:new()
		line:SetPos(AveragePoint2D(points))
		line:SetMesh(points, colours)
		lines.line = line
		return lines
	end
	local function HideWaypoints(data)
		if data then
			if IsValid(data.line) then
				DoneObject(data.line)
			end
			data.line = false
			data:Destroy()
			data:Clear()
		end
	end
	ChoGGi.ComFuncs.SaveOrigFunc("FollowWaypointPath")
	local ChoGGi_OrigFuncs = ChoGGi.OrigFuncs

	function ChoGGi.MenuFuncs.BuildingPathMarkers_Toggle()
		if not OPolyline then
			OPolyline = ChoGGi_OPolyline
		end
		if not OText then
			OText = ChoGGi_OText
		end
		if ChoGGi.Temp.BuildingPathMarkers_Toggle then
			ChoGGi.Temp.BuildingPathMarkers_Toggle = nil
			FollowWaypointPath = ChoGGi_OrigFuncs.FollowWaypointPath
		else
			ChoGGi.Temp.BuildingPathMarkers_Toggle = true
			function FollowWaypointPath(unit, path, first, last, ...)
				if not path then
					return
				end

				local debug_line = ShowWaypoints(
					path,
					path.door and (first <= last and path.openInside or path.openOutside)
				)
				ChoGGi_OrigFuncs.FollowWaypointPath(unit, path, first, last, ...)
				HideWaypoints(debug_line)
			end
		end

		MsgPopup(
			ChoGGi.ComFuncs.SettingState(ChoGGi.Temp.BuildingPathMarkers_Toggle),
			Strings[302535920001527--[[Building Path Markers]]]
		)
	end
end -- do

function ChoGGi.MenuFuncs.ExaminePersistErrors_Toggle()
	ChoGGi.UserSettings.DebugPersistSaves = not ChoGGi.UserSettings.DebugPersistSaves
	ChoGGi.SettingFuncs.WriteSettings()

	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.DebugPersistSaves),
		Strings[302535920001498--[[Examine Persist Errors]]]
	)
end

function ChoGGi.MenuFuncs.ViewAllEntities()
	local function CallBackFunc(answer)
		if not answer then
			return
		end
		local WaitMsg = WaitMsg
		-- a mystery without anything visible added to the ground
		g_CurrentMissionParams.idMystery = "BlackCubeMystery"
		local gen = RandomMapGenerator:new()
		gen.BlankMap = "POCMap_AllBuildings"
		-- see PrefabMarker.lua for these
		gen.AnomEventCount = 0
		gen.AnomTechUnlockCount = 0
		gen.AnomFreeTechCount = 0
		gen.FeaturesRatio = 0
		-- load the map
		gen:Generate()
		CreateRealTimeThread(function()
			-- don't fire the rest till map is good n loaded
			WaitMsg("MessageBoxOpened")

			-- wait a bit till we're sure the map is around
--~ 			local GameState = GameState
--~ 			while not GameState.gameplay do
--~ 				Sleep(500)
--~ 			end
			local UICity = UICity
			while not UICity do
				Sleep(500)
			end

			-- close welcome to mars msg
			local Dialogs = Dialogs
			if Dialogs.PopupNotification then
				Dialogs.PopupNotification:Close()
			end

			-- lightmodel
			LightmodelPresets.TheMartian1_Night.exterior_envmap = nil
			SetLightmodelOverride(1, "TheMartian1_Night")

			local texture = GetTerrainTextureIndex("Prefab_Orange")
			ActiveGameMap.terrain:SetTerrainType{type = texture or 1}

			-- we need a delay when doing this from ingame instead of main menu
			Sleep(1500)

			-- make a (sorted) index table of entities for placement
			local entity_list = {}
			local c = 0
			local EntityData = EntityData
			for key in pairs(EntityData) do
				c = c + 1
				entity_list[c] = key
			end
			table.sort(entity_list)
			local entity_count = #entity_list

			local IsBuildableZoneQR = IsBuildableZoneQR
			local WorldToHex = WorldToHex
			local point = point
			local OBuildingEntityClass = ChoGGi_OBuildingEntityClass

			local width, height = ConstructableArea:sizexyz()
			width = width / 1000
			height = height / 1000

			SuspendPassEdits("ChoGGi.MenuFuncs.ViewAllEntities")
			-- reset for a new count
			c = 0
			for x = 100, width do
				if c > entity_count then
					break
				end
				for y = 10, height do
					if c > entity_count then
						break
					end

					local mod = 5
					local plusone = entity_list[c+1]
					if plusone then
						-- add more space for certain objs
						local sub8 = plusone:sub(1, 8)
						local sub5 = plusone:sub(1, 5)
						if plusone:find("Dome") and sub8 ~= "DomeRoad"
								and sub8 ~= "DomeDoor" and not plusone:find("Entrance") then
							mod = 16
						elseif sub5 == "Unit_" or sub5 == "Arrow" or plusone:find("Door")
								or plusone:find("DecLogo") then
							mod = 1
						elseif plusone:find("Cliff") then
							mod = 8
						end

						local x1000, y1000 = x * 1000, y * 1000
						local q, r = WorldToHex(x1000, y1000)
						if q % mod == 0 and r % mod == 0 and IsBuildableZoneQR(q, r) then
							local obj = OBuildingEntityClass:new()
							-- 11500 so stuff is floating above the ground
							obj:SetPos(point(x1000, y1000, 11500))

							c = c + 1
							local entity = entity_list[c]
							obj:ChangeEntity(entity)
							obj.entity = entity

							-- If it has a working state then set it
--~ 							local states_str = obj:GetStates()
							local default_state = 0
							local states_str = obj:HasState(default_state) and obj:GetStates() or ""
							local idx = table.find(states_str, "working")
									or table.find(states_str, "idleOpened")
									or table.find(states_str, "rotate")
									or table.find(states_str, "moveWalk")
									or table.find(states_str, "walk")
									or table.find(states_str, "run")

							if idx then
								obj:SetState(states_str[idx])
							end

						end
					end

				end -- for
			end -- for
			CheatMapExplore("deep scanned")
			ResumePassEdits("ChoGGi.MenuFuncs.ViewAllEntities")

			if ChoGGi.testing then
				WaitMsg("OnRender")
				ChoGGi.ComFuncs.CloseDialogsECM()
				cls()
			end

			WaitMsg("OnRender")
--~ 			Sleep(2500)
			-- remove all notifications
			local dlg = Dialogs.OnScreenNotificationsDlg
			if dlg then
				local notes = g_ActiveOnScreenNotifications
				for i = #notes, 1, -1 do
					dlg:RemoveNotification(notes[i][1])
				end
			end

		end)
	end

	if ChoGGi.testing then
		return CallBackFunc(true)
	end

	ChoGGi.ComFuncs.QuestionBox(
		Translate(6779--[[Warning]]) .. ": " .. Strings[302535920001493--[["This will change to a new map, anything unsaved will be lost!"]]],
		CallBackFunc,
		Strings[302535920001491--[[View All Entities]]]
	)

end

function ChoGGi.MenuFuncs.OverrideConditionPrereqs_Toggle()
	ChoGGi.UserSettings.OverrideConditionPrereqs = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.OverrideConditionPrereqs)
	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.OverrideConditionPrereqs),
		Strings[302535920000421--[[Override Condition Prereqs]]]
	)
end

function ChoGGi.MenuFuncs.SkipStoryBitsDialogs_Toggle()
	ChoGGi.UserSettings.SkipStoryBitsDialogs = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.SkipStoryBitsDialogs)
	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.SkipStoryBitsDialogs),
		Strings[302535920000978--[["Skip Story Bits"]]]
	)
end

function ChoGGi.MenuFuncs.TestStoryBits()
--~ ~g_StoryBitStates
--~ that'll show all the active story state thingss

	local StoryBits = StoryBits

	local item_list = {}
	local c = 0

	local temp_table = {}
	for id, story_def in pairs(StoryBits) do
		table.clear(temp_table)
		for i = 1, #story_def do
			local def = story_def[i]
			if def.Name and def.Value then
				temp_table[def.Name] = def.Value
			end
		end

		local title = story_def.Title and Translate(story_def.Title) or id
		if not (title:find(": ") or title:find(" - ", 1, true)) then
			title = story_def.group .. ": " .. title
		end
		local voiced
		if story_def.VoicedText then
			voiced = "<yellow>" .. Translate(6855--[[Voiced Text]]) .. "</yellow>: " .. Translate(story_def.VoicedText)
		end

		c = c + 1
		item_list[c] = {
			text = title,
			value = id,
			hint = Strings[302535920001358--[[Group]]] .. ": "
				.. story_def.group .. "\n\n"
				.. (story_def.Text and Translate(T{story_def.Text, temp_table}) or "")
				.. (voiced and "\n\n" .. voiced or "")
				.. (story_def.Image ~= "" and "\n\n<image " .. story_def.Image .. ">" or "")
		}
	end

	local title = Translate(186760604064--[[Test]]) .. " " .. Translate(948928900281--[[Story Bits]])
	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local obj
		if choice.check1 then
			obj = table.rand(UICity.labels.Building or empty_table)
		elseif choice.check2 then
			obj = table.rand(UICity.labels.Dome or empty_table)
		elseif choice.check3 then
			obj = table.rand(UICity.labels.Colonist or empty_table)
		elseif choice.check4 then
			obj = table.rand(UICity.labels.Drone or empty_table)
		elseif choice.check5 then
			obj = table.rand(UICity.labels.Rover or empty_table)
		elseif choice.check6 then
			obj = SelectedObj
		end

		ForceActivateStoryBit(choice.value, ActiveMapID, obj, true)
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = title,
		hint = Strings[302535920001359--[[Test activate a story bit.]]],
		checkboxes = {
			{
				title = Translate(5426--[[Building]]),
				hint = Strings[302535920001555--[[Choose a random %s to be the context for this storybit.]]]:format(Translate(5426--[[Building]])),
			},
			{
				title = Translate(1234--[[Dome]]),
				hint = Strings[302535920001555--[[Choose a random %s to be the context for this storybit.]]]:format(Translate(1234--[[Dome]])),
			},
			{
				title = Translate(4290--[[Colonist]]),
				hint = Strings[302535920001555--[[Choose a random %s to be the context for this storybit.]]]:format(Translate(4290--[[Colonist]])),
			},

			{
				title = Translate(1681--[[Drone]]),
				hint = Strings[302535920001555--[[Choose a random %s to be the context for this storybit.]]]:format(Translate(1681--[[Drone]])),
				level = 2,
			},
			{
				title = Translate(10147--[[Rover]]),
				hint = Strings[302535920001555--[[Choose a random %s to be the context for this storybit.]]]:format(Translate(10147--[[Rover]])),
				level = 2,
			},
			{
				title = Strings[302535920000769--[[Selected]]],
				hint = Strings[302535920001556--[[Use the selected object.]]],
				level = 2,
			},
		},
	}
end

do -- PostProcGrids
	local SetPostProcPredicate = SetPostProcPredicate
	local GetPostProcPredicate = GetPostProcPredicate

	local grids = {
		"grid45",
		"grid",
		"hexgrid",
		"smallgrid",
	}

	function ChoGGi.MenuFuncs.PostProcGrids(action)
		local grid_type = action.grid_mask
		-- always disable other ones
		for i = 1, #grids do
			local name = grids[i]
			if GetPostProcPredicate(name) then
				SetPostProcPredicate(name, false)
			end
		end
		if grid_type then
			SetPostProcPredicate(grid_type, true)
		end
	end
end -- do

function ChoGGi.MenuFuncs.Render_Toggle()
	local item_list = {
		{text = "Shadowmap", value = "Shadowmap"},
		{text = "TerrainAABB", value = "TerrainAABB"},
		{text = "ToggleSafearea", value = "ToggleSafearea"},
	}
	local c = #item_list

	local vars = EnumVars("hr")
	for key in pairs(vars) do
		if key:sub(2, 7) == "Render" and key ~= ".RenderUIL" then
			key = key:sub(2)
			c = c + 1
			item_list[c] = {text = key, value = key}
		end
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		local new_value
		local obj = ChoGGi.ComFuncs.DotPathToObject(value)
		if type(obj) == "function" then
			new_value = obj()
		else
			if hr[value] == 0 then
				hr[value] = 1
			else
				hr[value] = 0
			end
			new_value = hr[value]
		end

		MsgPopup(
			Strings[302535920001316--[[Toggled: %s = %s]]]:format(choice.text, new_value),
			Strings[302535920001314--[[Toggle Render]]]
		)
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920001314--[[Toggle Render]]],
		custom_type = 1,
	}
end

function ChoGGi.MenuFuncs.DebugFX_Toggle()
	local name = action.setting_name
	local trans_str = action.setting_msg

	_G[name] = not _G[name]

	MsgPopup(
		ChoGGi.ComFuncs.SettingState(_G[name]),
		trans_str
	)
end

function ChoGGi.MenuFuncs.ParticlesReload()
	LoadStreamParticlesFromDir("Data/Particles")
	ParticlesReload("", true)
	MsgPopup(
		"true",
		Strings[302535920000495--[[Particles Reload]]]
	)
end

function ChoGGi.MenuFuncs.MeasureTool_Toggle()
	local MeasureTool = MeasureTool
	MeasureTool.Toggle()
	if MeasureTool.enabled then
		MeasureTool.OnMouseButtonDown(nil, "L")
	else
		MeasureTool.OnMouseButtonDown(nil, "R")
	end
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(MeasureTool.enabled),
		Strings[302535920000451--[[Measure Tool]]]
	)
end

function ChoGGi.MenuFuncs.DeleteAllSelectedObjects()
	local obj = ChoGGi.ComFuncs.SelObject()
	local is_valid = IsValid(obj)
	-- domes with objs in them = crashy
	if not is_valid or is_valid and obj:IsKindOf("Dome") then
		return
	end

	local function CallBackFunc(answer)
		if not answer then
			return
		end
		SuspendPassEdits("ChoGGi.MenuFuncs.DeleteAllSelectedObjects")
		MapDelete(true, obj.class)
		ResumePassEdits("ChoGGi.MenuFuncs.DeleteAllSelectedObjects")
	end

	ChoGGi.ComFuncs.QuestionBox(
		Translate(6779--[[Warning]]) .. "!\n"
			.. Strings[302535920000852--[[This will delete all %s of %s]]]:format(MapCount("map", obj.class), obj.class),
		CallBackFunc,
		Translate(6779--[[Warning]]) .. ": " .. Strings[302535920000855--[[Last chance before deletion!]]],
		Strings[302535920000856--[[Yes, I want to delete all: %s]]]:format(obj.class),
		Strings[302535920000857--[["No, I need to backup my save first (like I should've done before clicking something called ""Delete All"")."]]]
	)
end

function ChoGGi.MenuFuncs.ObjectCloner(flat)
	local obj = ChoGGi.ComFuncs.SelObject()
	if not IsValid(obj) then
		return
	end

	if obj:IsKindOf("Colonist") then
		ChoGGi.ComFuncs.SpawnColonist(obj, nil, GetCursorWorldPos())
		return
	end

	local clone
	-- clone dome = crashy
	if obj:IsKindOf("Dome") then
		clone = g_Classes[obj.class]:new()
		clone:CopyProperties(obj)
	else
		clone = obj:Clone()
	end

	if obj.GetEntity then
		clone.entity = obj:GetEntity()
	end

	-- got me banners are weird like that
	if obj:IsKindOf("Banner") then
		clone:ChangeEntity(obj:GetEntity())
	end

	-- we're already cheating by cloning, so fill 'er up
	if clone:IsKindOf("SubsurfaceDeposit") then
		if clone.CheatRefill then
			clone:CheatRefill()
		end
	end

	-- make sure it's hex worthy
	local pos = GetCursorWorldPos()
	if flat == true or flat.flatten_to_ground == true then
		clone:SetPos(pos:SetTerrainZ())
	else
		clone:SetPos(pos)
	end

end

function ChoGGi.MenuFuncs.BuildableHexGridSettings(action)
	local setting = action.setting_mask

	local item_list = {
		{text = 5, value = 5},
		{text = 10, value = 10},
		{text = 15, value = 15},
		{text = 20, value = 20},
		{text = 25, value = 25},
		{text = 35, value = 35},
		{text = 50, value = 50},
		{text = 60, value = 60},
		{text = 70, value = 70},
		{text = 80, value = 80},
		{text = 90, value = 90},
		{text = 100, value = 100},
	}

	local name
	if setting == "DebugGridSize" then
		table.insert(item_list, 1, {text = 1, value = 1})
		local hint = Strings[302535920000419--[[125 = 47251 hex spots.]]]
		local c = #item_list+1
		item_list[c] = {text = 125, value = 125, hint = hint}
		c = c + 1
		item_list[c] = {text = 150, value = 150, hint = hint}
		c = c + 1
		item_list[c] = {text = 200, value = 200, hint = hint}
		c = c + 1
--~ 		197377
		item_list[c] = {text = 256, value = 256, hint = hint}

		name = Strings[302535920001417--[[Follow Mouse Grid Size]]]
	elseif setting == "DebugGridOpacity" then
		table.insert(item_list, 1, {text = 0, value = 0})

		name = Strings[302535920001419--[[Follow Mouse Grid Translate]]]
	elseif setting == "DebugGridPosition" then
		item_list = {
			{text = Strings[302535920001638--[[Relative]]], value = 0},
			{text = Strings[302535920001637--[[Absolute]]], value = 1},
		}
		name = Strings[302535920000680--[[Follow Mouse Grid Position]]]
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if type(value) == "number" then
			ChoGGi.UserSettings[setting] = value

			-- update grid
			if IsValidThread(ChoGGi.Temp.grid_thread) and setting ~= "DebugGridPosition" then
				-- twice to toggle
				ChoGGi.ComFuncs.BuildableHexGrid(false)
				ChoGGi.ComFuncs.BuildableHexGrid(true)
			end
			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				tostring(value),
				name
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = name,
		skip_sort = true,
	}
end

ChoGGi.Temp.PathMarkers_new_objs_loop = true
function ChoGGi.MenuFuncs.SetPathMarkers()
	local Pathing_SetMarkers = ChoGGi.ComFuncs.Pathing_SetMarkers
	local Pathing_CleanDupes = ChoGGi.ComFuncs.Pathing_CleanDupes
	local Pathing_StopAndRemoveAll = ChoGGi.ComFuncs.Pathing_StopAndRemoveAll
	ChoGGi.Temp.UnitPathingHandles = ChoGGi.Temp.UnitPathingHandles or {}
	local randcolours = {}
	local colourcount = 0

	local item_list = {
		{text = Strings[302535920000413--[[Delay]]], value = 0, path_type = "Delay", hint = Strings[302535920000415--[[Delay in ms between updating paths (0 to update every other render).]]]},
		{text = Translate(4493--[[All]]), value = "All"},

		{text = Translate(547--[[Colonists]]), value = "Colonist"},
		{text = Translate(517--[[Drones]]), value = "Drone"},
		{text = Translate(5438--[[Rovers]]), value = "BaseRover", icon = RCTransport and RCTransport.display_icon or "UI/Icons/Buildings/rover_transport.tga"},
		{text = Translate(745--[[Shuttles]]), value = "CargoShuttle", hint = Strings[302535920000873--[[Doesn't work that well.]]]},
	}
	if rawget(_G, "ChoGGi_Alien") then
		aliens = true
		item_list[#item_list+1] = {text = "Alien Visitors", value = "ChoGGi_Alien"}
	end

	local function CallBackFunc(choices)
		local temp = ChoGGi.Temp
		local choice1 = choices[1]
		local remove = choice1.check1
		if choices[1].nothing_selected and remove ~= true then
			return
		end

--~ ex(choices)
		local choice, delay
		for i = 1, #choices do
			local choice_item = choices[i]
			if choice_item.list_selected then
				choice = choice_item
			elseif choice_item.path_type == "Delay" then
				delay = choice_item.value
			end
		end

		local value = choice.value

		if remove then
			-- remove wp/lines and reset colours
			Pathing_StopAndRemoveAll()

		-- naughty user
		elseif value == "Delay" then
			MsgPopup(
				Strings[302535920000416--[[Delay isn't a valid class.]]],
				Strings[302535920000872--[[Pathing]]]
			)
			return

		-- add waypoints
		elseif value then

			if value == "All" then
--~ 					local labels = UICity.labels

--~ 					local table1 = labels.Unit or ""
--~ 					local table2 = labels.CargoShuttle or ""
--~ 					local table3 = labels.Colonist or ""

--~ 					colourcount = colourcount + #table1
--~ 					colourcount = colourcount + #table2
--~ 					colourcount = colourcount + #table3
--~ 					randcolours = RandomColour(colourcount + 1)
--~ 					Pathing_SetMarkers(table1, choice1.check2, delay)
--~ 					Pathing_SetMarkers(table2, choice1.check2, delay)
--~ 					Pathing_SetMarkers(table3, choice1.check2, delay)
--~ 					Pathing_CleanDupes()

				CreateGameTimeThread(function()
					local labels = UICity.labels
					local table1 = labels.Unit or ""
					local table2 = labels.CargoShuttle or ""
					local table3 = labels.Colonist or ""
					-- +1 to make it fire the first time
					local current = #table1+#table2+#table3+1

					while temp.PathMarkers_new_objs_loop do
						table1 = labels.Unit or ""
						table2 = labels.CargoShuttle or ""
						table3 = labels.Colonist or ""
						local count = #table1+#table2+#table3
						if current ~= count then
							-- update list when
							Pathing_StopAndRemoveAll(true)

							current = count
							colourcount = colourcount + #table1
							colourcount = colourcount + #table2
							colourcount = colourcount + #table3
							randcolours = RandomColour(colourcount + 1)
							Pathing_SetMarkers(table1, choice1.check2, delay)
							Pathing_SetMarkers(table2, choice1.check2, delay)
							Pathing_SetMarkers(table3, choice1.check2, delay)

							Pathing_CleanDupes()
						end
						Sleep(2500)
					end
					temp.PathMarkers_new_objs_loop = true
				end)

			-- skip any non-cls objects (or mapget returns all)
			elseif g_Classes[value] then
				CreateGameTimeThread(function()
					local labels = UICity.labels
					local table1 = labels[value] or MapGet("map", value)
					-- +1 to make it fire the first time
					local current = #table1+1

					while temp.PathMarkers_new_objs_loop do
						table1 = labels[value] or MapGet("map", value)
						if current ~= #table1 then
							-- update list when
							Pathing_StopAndRemoveAll(true)

							current = #table1
							colourcount = colourcount + current
							randcolours = RandomColour(colourcount + 1)
							Pathing_SetMarkers(table1, choice1.check2, delay)
							Pathing_CleanDupes()
						end
						Sleep(2500)
					end
					temp.PathMarkers_new_objs_loop = true
				end)
			end


		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000467--[[Path Markers]]],
		skip_sort = true,
		custom_type = 4,
		checkboxes = {
			{
				title = Strings[302535920000876--[[Remove Waypoints]]],
				hint = Strings[302535920000877--[[Remove waypoints from the map and reset colours (select any object type to remove them all).]]],
			},
			{
				title = Strings[302535920001382--[[Game time]]],
				hint = Strings[302535920000462--[[Maps paths in real time]]],
				checked = true,
			},
		},
	}
end

--little bit of painting
--~ local terrain_type = "Grass_01"
--~ local terrain_type_idx = GetTerrainTextureIndex(terrain_type)
--~ CreateRealTimeThread(function()
--~	 while true do
--~		 ActiveGameMap.terrain:SetTypeCircle(GetCursorWorldPos(), 2500, terrain_type_idx)
--~		 						WaitMsg("OnRender")

--~	 end
--~ end)
do -- FlightGrid_Toggle
	-- this is also somewhat from Lua\Flight.lua: Flight_DbgRasterArea()
	-- also sped up to work with being attached to the mouse pos
	local MulDivRound = MulDivRound
	local InterpolateRGB = InterpolateRGB
	local Clamp = Clamp
	local point = point
	local AveragePoint2D = AveragePoint2D
	local FindPassable = FindPassable
	local DoneObject = DoneObject

	local grid_thread = false
	local Flight_Height_temp = false
	local type_tile = const.TerrainTypeTileSize or terrain.TypeTileSize()
	local work_step = 16 * type_tile
	local dbg_step = work_step / 4 -- 400
	local dbg_stepm1 = dbg_step - 1
	local max_diff = 5 * guim
	local white = white
	local green = green
	local flight_lines = {}
	local points, colours = {}, {}
	local OPolyline

	local function RasterLine(pos1, pos0, zoffset, line_num)
		pos1 = pos1 or GetCursorWorldPos()
		pos0 = pos0 or FindPassable(GetCursorWorldPos())
		local steps = 1 + ((pos1 - pos0):Len2D() + dbg_stepm1) / dbg_step

		for i = 1, steps do
			local pos = pos0 + MulDivRound(pos1 - pos0, i - 1, steps - 1)
			local height = Flight_Height_temp:GetBilinear(pos, work_step, 0, 1) + zoffset

			points[i] = pos:SetZ(height)
			colours[i] = InterpolateRGB(
				white,
				green,
				Clamp(height - zoffset - ActiveGameMap.terrain:GetHeight(pos), 0, max_diff),
				max_diff
			)
		end
		local line = flight_lines[line_num]
		-- just in case it was deleted
		if not IsValid(line) then
			line = OPolyline:new()
			flight_lines[line_num] = line
		end
		line:SetMesh(points, colours)
		line:SetPos(AveragePoint2D(points))
	end

	local function DeleteLines()
		SuspendPassEdits("ChoGGi.MenuFuncs.FlightGrid_Toggle.DeleteLines")
		for i = 0, #flight_lines+1 do
			local o = flight_lines[i]
			if IsValid(o) then
				DoneObject(o)
			end
		end
		table.iclear(flight_lines)
		flight_lines[0] = nil
		ResumePassEdits("ChoGGi.MenuFuncs.FlightGrid_Toggle.DeleteLines")
	end
	-- If grid is left on when map changes it gets real laggy
	function OnMsg.ChangeMap()
		if IsValidThread(grid_thread) then
			DeleteThread(grid_thread)
		end
		grid_thread = false
		if UICity then
			DeleteLines()
		end
	end

	local function GridFunc(size, zoffset)
		local WaitMsg = WaitMsg

		local steps = 1 + (size + dbg_step - 1) / dbg_step
		size = steps * dbg_step
		local size_pt = point(size, size) / 2

		-- we spawn lines once then re-use them
		SuspendPassEdits("ChoGGi.MenuFuncs.FlightGrid_Toggle.GridFunc")
		for i = 0, (steps + steps) do
			flight_lines[i] = OPolyline:new()
		end
		ResumePassEdits("ChoGGi.MenuFuncs.FlightGrid_Toggle.GridFunc")

		local plus1 = steps+1
		local pos_old, pos_new, pos
		while grid_thread do
			-- we only update when cursor moves
			pos_new = GetCursorWorldPos()
			if pos_old ~= pos_new then
				pos_old = pos_new

				pos = pos_new - size_pt
				-- Flight_DbgRasterArea
				for y = 0, steps do
					RasterLine(pos + point(0, y*dbg_step), pos + point(size, y*dbg_step), zoffset, y)
				end
				for x = 0, steps do
					RasterLine(pos + point(x*dbg_step, 0), pos + point(x*dbg_step, size), zoffset, plus1+x)
				end
			end
			WaitMsg("OnRender")
		end
	end

	function ChoGGi.MenuFuncs.FlightGrid_Toggle(size, zoffset)
		if not Flight_Height then
			return
		end

		if IsValidThread(grid_thread) then
			DeleteThread(grid_thread)
			grid_thread = false
			DeleteLines()
			return
		end

		local u = ChoGGi.UserSettings
		local grid_size = u.DebugGridSize

		if type(grid_size) == "number" then
			grid_size = (grid_size * 10) * guim
		else
			grid_size = 256 * guim
		end

		-- If fired from action menu
		if IsKindOf(size, "XAction") then
			size = grid_size
			zoffset = 0
		else
			size = size or grid_size
			zoffset = zoffset or 0
		end

		Flight_Height_temp = Flight_Height

		OPolyline = OPolyline or ChoGGi_OPolyline
		table.iclear(points)
		table.iclear(colours)
		grid_thread = CreateRealTimeThread(GridFunc, size, zoffset)
	end
end -- do
