-- See LICENSE for terms

if ChoGGi.what_game ~= "Mars" then
	return
end

local ChoGGi_Funcs = ChoGGi_Funcs
local pairs, type, tostring, table = pairs, type, tostring, table
local IsValid = IsValid
local GetCursorWorldPos = GetCursorWorldPos
local T = T
local Translate = ChoGGi_Funcs.Common.Translate
local MsgPopup = ChoGGi_Funcs.Common.MsgPopup
local RetName = ChoGGi_Funcs.Common.RetName
local RandomColour = ChoGGi_Funcs.Common.RandomColour

function ChoGGi_Funcs.Menus.StoryBitLog_Toggle()
	ChoGGi.UserSettings.StoryBitLogPrints = not ChoGGi.UserSettings.StoryBitLogPrints
	config.StoryBitLogPrints = not config.StoryBitLogPrints

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.StoryBitLogPrints),
		T(302535920001743--[[Toggle Story Bit Log]])
	)
end

function ChoGGi_Funcs.Menus.SkipIncompatibleModsMsg_Toggle()
	ChoGGi.UserSettings.SkipIncompatibleModsMsg = not ChoGGi.UserSettings.SkipIncompatibleModsMsg

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.SkipIncompatibleModsMsg),
		T(302535920001728--[[Skip Incompatible Mods]])
	)
end

function ChoGGi_Funcs.Menus.ConsoleErrors_Toggle()
	ChoGGi.UserSettings.ConsoleErrors = not ChoGGi.UserSettings.ConsoleErrors

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.ConsoleErrors),
		T(302535920001735--[[Show Console Errors]])
	)
end

function ChoGGi_Funcs.Menus.SkipMissingMods_Toggle()
	if blacklist then
		ChoGGi_Funcs.Common.BlacklistMsg(T(302535920001205--[[Skip Missing Mods]]))
	end

	ChoGGi.UserSettings.SkipMissingMods = not ChoGGi.UserSettings.SkipMissingMods

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.SkipMissingMods),
		T(302535920001205--[[Skip Missing Mods]])
	)
end

function ChoGGi_Funcs.Menus.SkipMissingDLC_Toggle()
	if blacklist then
		ChoGGi_Funcs.Common.BlacklistMsg(T(302535920001658--[[Skip Missing DLC]]))
	end

	ChoGGi.UserSettings.SkipMissingDLC = not ChoGGi.UserSettings.SkipMissingDLC

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.SkipMissingDLC),
		T(302535920001658--[[Skip Missing DLC]])
	)
end

function ChoGGi_Funcs.Menus.Interface_Toggle()
	hr.RenderUIL = hr.RenderUIL == 0 and 1 or 0
end

function ChoGGi_Funcs.Menus.InfoPanelDlg_Toggle()
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

function ChoGGi_Funcs.Menus.ExamineObjectRadius_Set()
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

	local title = T(302535920000069--[[Examine]]) .. " " .. T(302535920000163--[[Radius]])

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

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = title,
		skip_sort = true,
		hint = Translate(302535920000923--[[Set the radius used for %s examining.]]):format(ChoGGi_Funcs.Common.GetShortcut(".Keys.Examine Objects Shift")),
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

	function ChoGGi_Funcs.Menus.ChangeEntity()
		local obj = ChoGGi_Funcs.Common.SelObject()
		if not obj then
			MsgPopup(
				T(302535920001139--[[You need to select an object.]]),
				T(302535920000682--[[Change Entity]])
			)
			return
		end

		local hint_noanim = T(302535920001140--[[No animation.]])
		local item_list = {
			{text = " " .. T(302535920001141--[[Default Entity]]), value = "Default"},
			{text = " " .. T(302535920001142--[[Kosmonavt]]), value = "Kosmonavt"},
			{text = " " .. T(302535920001143--[[Jama]]), value = "Lama"},
			{text = " " .. T(302535920001144--[[Green Man]]), value = "GreenMan"},
			{text = " " .. T(302535920001145--[[Planet Mars]]), value = "PlanetMars", hint = hint_noanim},
			{text = " " .. T(302535920001146--[[Planet Earth]]), value = "PlanetEarth", hint = hint_noanim},
			{text = " " .. T(302535920001147--[[Rocket Small]]), value = "RocketUI", hint = hint_noanim},
			{text = " " .. T(302535920001148--[[Rocket Regular]]), value = "Rocket", hint = hint_noanim},
			{text = " " .. T(302535920001149--[[Combat Rover]]), value = "CombatRover", hint = hint_noanim},
			{text = " " .. T(302535920001150--[[PumpStation Demo]]), value = "PumpStationDemo", hint = hint_noanim},
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
					T(302535920000682--[[Change Entity]])
				)
			end
		end

		ChoGGi_Funcs.Common.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = T(302535920000682--[[Change Entity]]) .. ": " .. RetName(obj),
			custom_type = 7,
			hint = T(302535920000106--[[Current]]) .. ": "
				.. (obj.ChoGGi_OrigEntity or obj:GetEntity()) .. "\n"
				.. T(302535920001157--[[If you don't pick a checkbox it will change all of selected type.]])
				.. "\n\n"
				.. T(302535920001153--[[Post a request if you want me to add more entities from EntityData (use ex(EntityData) to list).

Not permanent for colonists after they exit buildings (for now).]]),
			checkboxes = {
				only_one = true,
				{
					title = T(302535920000750--[[Dome Only]]),
					hint = T(302535920001255--[[Will only apply to objects in the same dome as selected object.]]),
				},
				{
					title = T(302535920000752--[[Selected Only]]),
					hint = T(302535920001256--[[Will only apply to selected object.]]),
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
				obj:SetBase("move_speed", UserSettings.SpeedDrone or ChoGGi_Funcs.Common.GetResearchedTechValue("SpeedDrone"))
			elseif obj:IsKindOf("CargoShuttle") then
				obj:SetBase("move_speed", UserSettings.SpeedShuttle or ChoGGi.Consts.SpeedShuttle)
			elseif obj:IsKindOf("Colonist") then
				obj:SetBase("move_speed", UserSettings.SpeedColonist or ChoGGi.Consts.SpeedColonist)
			elseif obj:IsKindOf("BaseRover") then
				obj:SetBase("move_speed", UserSettings.SpeedRC or ChoGGi_Funcs.Common.GetResearchedTechValue("SpeedRC"))
			end
		end)
	end

	function ChoGGi_Funcs.Menus.SetEntityScale()
		local obj = ChoGGi_Funcs.Common.SelObject()
		if not obj then
			MsgPopup(
				T(302535920001139--[[You need to select an object.]]),
				T(302535920000684--[[Change Entity Scale]])
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
					T(302535920000684--[[Change Entity Scale]]),
					{objects = obj}
				)
			end
		end

		ChoGGi_Funcs.Common.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = T(302535920000684--[[Change Entity Scale]]) .. ": " .. RetName(obj),
			hint = T(302535920001156--[[Current object]]) .. ": " .. obj:GetScale()
				.. "\n" .. T(302535920001157--[[If you don't pick a checkbox it will change all of selected type.]]),
			skip_sort = true,
			checkboxes = {
				only_one = true,
				{
					title = T(302535920000750--[[Dome Only]]),
					hint = T(302535920000751--[[Will only apply to colonists in the same dome as selected colonist.]]),
				},
				{
					title = T(302535920000752--[[Selected Only]]),
					hint = T(302535920000753--[[Will only apply to selected colonist.]]),
				},
			},
		}
	end
end -- do

function ChoGGi_Funcs.Menus.DTMSlotsDlg_Toggle()
	local dlg = ChoGGi_Funcs.Common.GetDialogECM("ChoGGi_DlgDTMSlots")
	if dlg then
		dlg:Close()
	else
		ChoGGi_Funcs.Common.OpenInDTMSlotsDlg()
	end
end

function ChoGGi_Funcs.Menus.SetFrameCounter()
	local fps = hr.FpsCounter
	fps = fps + 1
	if fps > 2 then
		fps = 0
	end
	hr.FpsCounter = fps
end

function ChoGGi_Funcs.Menus.SetFrameCounterLocation(action)
	if not action then
		return
	end

	local setting = action.setting_mask
	hr.FpsCounterPos = setting

	if setting == 1 then
		ChoGGi.UserSettings.FrameCounterLocation = nil
	else
		ChoGGi.UserSettings.FrameCounterLocation = setting
	end
	ChoGGi_Funcs.Settings.WriteSettings()
end

function ChoGGi_Funcs.Menus.LoadingScreenLog_Toggle()
	ChoGGi.UserSettings.LoadingScreenLog = not ChoGGi.UserSettings.LoadingScreenLog
	ChoGGi_Funcs.Common.SetLoadingScreenLog()

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.LoadingScreenLog),
		T(302535920000049--[[Loading Screen Log]])
	)
end

function ChoGGi_Funcs.Menus.DeleteObject(_, _, input)
	if input == "keyboard" then
		ChoGGi_Funcs.Common.DeleteObject()
	else
		local obj = ChoGGi_Funcs.Common.SelObject()
		if IsValid(obj) then
			ChoGGi_Funcs.Common.DeleteObjectQuestion(obj)
		end
	end
end

do -- TestLocaleFile
	local saved_file_path

	function ChoGGi_Funcs.Menus.TestLocaleFile()
		local hint = T(302535920001155--[["Enter the path to the CSV file you want to test (defaults to mine as an example).
You can edit the CSV then run this again without having to restart the game.
"]])

		local item_list = {
			{
				text = Translate(302535920001137--[[CSV Path]]),
				value = ChoGGi.library_path .. "Locales/English.csv",
				hint = hint,
			},
			{
				text = Translate(302535920001162--[[Test Columns]]),
				value = "false",
				hint = T(302535920001166--[["Reports any columns above the normal amount (5).
Columns are added by commas (, ). Surround the entire string with """" to use them.

Try to increase or decrease the number if not enough or too many errors show up.
For the value enter either ""true"" (to use 5) or a number.

You need my HelperMod installed to be able to use this."]]),
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

			ChoGGi_Funcs.Common.TestLocaleFile(
				path,
				ChoGGi_Funcs.Common.RetProperType(choice.value)
			)
		end

		ChoGGi_Funcs.Common.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = T(302535920001125--[[Test Locale File]]),
			hint = hint,
			custom_type = 9,
			skip_sort = true,
			width = 900,
			height = 250,
		}

	end
end -- do

function ChoGGi_Funcs.Menus.ExamineObject()
	printC("ChoGGi_Funcs.Menus.ExamineObject")

	-- try to get object in-game first
	local objs = ChoGGi_Funcs.Common.SelObjects()
	local c = #objs
	if c > 0 then
		-- If it's a single obj then examine that, otherwise the whole list
		OpenExamine(c == 1 and objs[1] or objs)
		return
	end

--~ 	if UseGamepadUI() then
--~ 		return
--~ 	end

	local terminal = terminal

	-- next we check if there's a ui element under the cursor and return that
	local target = terminal.desktop:GetMouseTarget(terminal.GetMousePos())
	-- everywhere is covered in xdialogs so skip them
	if target and not target:IsKindOf("XDialog") then
		return OpenExamineReturn(target)
	end

	-- If in main menu then open examine and console
	if not Dialogs.HUD then
		local dlg = OpenExamineReturn(terminal.desktop)
		-- off centre of central monitor
		local width = (terminal.desktop.measure_width or 1920) - (dlg.dialog_width_scaled + 100)
		dlg:SetPos(point(width, 100))
		ChoGGi_Funcs.Common.ToggleConsole(true)
	end
end

function ChoGGi_Funcs.Menus.OpenInGedObjectEditor()
	local obj = ChoGGi_Funcs.Common.SelObject()
	if IsValid(obj) then
		GedObjectEditor = false
		OpenGedGameObjectEditor{obj}
	end
end

function ChoGGi_Funcs.Menus.ListVisibleObjects()
	local frame = (GetFrameMark() / 1024 - 1) * 1024
	local visible = MapGet("map", "attached", false, function(obj)
		return obj:GetFrameMark() - frame > 0
	end)
	OpenExamine(visible, nil, T(302535920001547--[[Visible Objects]]))
end

do -- BuildingPathMarkers_Toggle
--~ 		GetEntityWaypointChains(entity)
	-- mostly a copy n paste from Lua\Buildings\BuildingWayPoints.lua: ShowWaypoints()
	local AveragePoint2D = AveragePoint2D
	local OText, OPolyline
--~ 	local XText, OPolyline
--~ 	local parent

	local points, colours = {}, {}
	local function ShowWaypoints(waypoints, open)
		table.iclear(points)
		table.iclear(colours)

		local colour_line = RandomColour()
		local colour_door = RandomColour()
		local lines = {}
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
				data.line:delete()
			end
			data.line = false
			ChoGGi_Funcs.Common.objlist_Destroy(data)
			table.iclear(data)
		end
	end

	local ChoOrig_FollowWaypointPath = FollowWaypointPath
	function ChoGGi_Funcs.Menus.BuildingPathMarkers_Toggle()
		if not OPolyline then
			OPolyline = ChoGGi_OPolyline
		end
		if not OText then
			OText = ChoGGi_OText
		end
		if ChoGGi.Temp.BuildingPathMarkers_Toggle then
			ChoGGi.Temp.BuildingPathMarkers_Toggle = nil
			FollowWaypointPath = ChoOrig_FollowWaypointPath
		else
			ChoGGi.Temp.BuildingPathMarkers_Toggle = true
			function FollowWaypointPath(unit, path, first, last, ...)
				if not path then
					return
				end

				local debugging_line = ShowWaypoints(
					path,
					path.door and (first <= last and path.openInside or path.openOutside)
				)
				ChoOrig_FollowWaypointPath(unit, path, first, last, ...)
				HideWaypoints(debugging_line)
			end
		end

		MsgPopup(
			ChoGGi_Funcs.Common.SettingState(ChoGGi.Temp.BuildingPathMarkers_Toggle),
			T(302535920001527--[[Building Path Markers]])
		)
	end
end -- do

function ChoGGi_Funcs.Menus.ExaminePersistErrors_Toggle()
	ChoGGi.UserSettings.DebugPersistSaves = not ChoGGi.UserSettings.DebugPersistSaves
	ChoGGi_Funcs.Settings.WriteSettings()

	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.DebugPersistSaves),
		T(302535920001498--[[Examine Persist Errors]])
	)
end

function ChoGGi_Funcs.Menus.ViewAllEntities()
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
--~ 			WaitMsg("MessageBoxOpened")
			WaitMsg("MapGenerated")

			-- wait a bit till we're sure the map is around
--~ 			local GameState = GameState
--~ 			while not GameState.gameplay do
--~ 				Sleep(500)
--~ 			end
			local MainCity = MainCity
			while not MainCity do
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
			local OBuildingEntityClass = ChoGGi_OBuildingEntityClass_Perm

			local width, height = ConstructableArea:sizexyz()
			width = width / 1000
			height = height / 1000

			SuspendPassEdits("ChoGGi_Funcs.Menus.ViewAllEntities")

			MapDelete(true, "UndergroundPassage")
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
						elseif plusone:sub(1, 6) == "Wonder" or plusone == "DummyUndergroundWonderRoom_placeholder" then
							mod = 32
						elseif plusone:sub(1, 13) == "AsteroidSkirt" then
							mod = 128
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
			ResumePassEdits("ChoGGi_Funcs.Menus.ViewAllEntities")

			if ChoGGi.testing then
				WaitMsg("OnRender")
				ChoGGi_Funcs.Common.CloseDialogsECM()
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

	ChoGGi_Funcs.Common.QuestionBox(
		T(6779--[[Warning]]) .. ": " .. T(302535920001493--[["This will change to a new map, anything unsaved will be lost!"]]),
		CallBackFunc,
		T(302535920001491--[[View All Entities]])
	)

end

function ChoGGi_Funcs.Menus.OverrideConditionPrereqs_Toggle()
	ChoGGi.UserSettings.OverrideConditionPrereqs = ChoGGi_Funcs.Common.ToggleValue(ChoGGi.UserSettings.OverrideConditionPrereqs)
	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.OverrideConditionPrereqs),
		T(302535920000421--[[Override Condition Prereqs]])
	)
end

function ChoGGi_Funcs.Menus.SkipStoryBitsDialogs_Toggle()
	ChoGGi.UserSettings.SkipStoryBitsDialogs = ChoGGi_Funcs.Common.ToggleValue(ChoGGi.UserSettings.SkipStoryBitsDialogs)
	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.SkipStoryBitsDialogs),
		T(302535920000978--[["Skip Story Bits"]])
	)
end

function ChoGGi_Funcs.Menus.TestStoryBits()
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

		-- Default storybit image
		local image = "\n\n<image UI/Messages/message_picture_01.tga>"
		if story_def.Image ~= "" then
			image = "\n\n<image " .. story_def.Image .. ">"
		end

		c = c + 1
		item_list[c] = {
			text = title,
			value = id,
			hint = T(302535920001358--[[Group]]) .. ": "
				.. story_def.group .. "\n\n"
				.. (story_def.Text and Translate(T{story_def.Text, temp_table}) or "")
				.. (voiced and "\n\n" .. voiced or "")
				.. image
--~ 				.. (story_def.Image ~= "" and "\n\n<image " .. story_def.Image .. ">" or "")
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
			obj = table.rand(UIColony:GetCityLabels("Building"))
		elseif choice.check2 then
			obj = table.rand(UIColony:GetCityLabels("Dome"))
		elseif choice.check3 then
			obj = table.rand(UIColony:GetCityLabels("Colonist"))
		elseif choice.check4 then
			obj = table.rand(UIColony:GetCityLabels("Drone"))
		elseif choice.check5 then
			obj = table.rand(UIColony:GetCityLabels("Rover"))
		elseif choice.check6 then
			obj = SelectedObj
		end

		ForceActivateStoryBit(choice.value, ActiveMapID, obj, true)
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = title,
		hint = T(302535920001359--[[Activate a story bit.]]),
		checkboxes = {
			{
				title = Translate(5426--[[Building]]),
				hint = Translate(302535920001555--[[Choose a random %s to be the context for this storybit.]]):format(Translate(5426--[[Building]])),
			},
			{
				title = Translate(1234--[[Dome]]),
				hint = Translate(302535920001555--[[snipped]]):format(Translate(1234--[[Dome]])),
			},
			{
				title = Translate(4290--[[Colonist]]),
				hint = Translate(302535920001555--[[snipped]]):format(Translate(4290--[[Colonist]])),
			},

			{
				title = Translate(1681--[[Drone]]),
				hint = Translate(302535920001555--[[snipped]]):format(Translate(1681--[[Drone]])),
				level = 2,
			},
			{
				title = Translate(10147--[[Rover]]),
				hint = Translate(302535920001555--[[snipped]]):format(Translate(10147--[[Rover]])),
				level = 2,
			},
			{
				title = T(302535920000769--[[Selected]]),
				hint = T(302535920001556--[[Use the selected object.]]),
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

	function ChoGGi_Funcs.Menus.PostProcGrids(action)
		if not action then
			return
		end

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

function ChoGGi_Funcs.Menus.Render_Toggle()
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
		local obj = ChoGGi_Funcs.Common.DotPathToObject(value)
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
			Translate(302535920001316--[[Toggled: %s = %s]]):format(choice.text, new_value),
			T(302535920001314--[[Toggle Render]])
		)
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920001314--[[Toggle Render]]),
		custom_type = 1,
	}
end

function ChoGGi_Funcs.Menus.DebugFX_Toggle(action)
	if not action then
		return
	end

	local name = action.setting_name
	local trans_str = action.setting_msg

	_G[name] = not _G[name]

	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(_G[name]),
		trans_str
	)
end

function ChoGGi_Funcs.Menus.ParticlesReload()
	LoadStreamParticlesFromDir("Data/Particles")
	ParticlesReload("", true)
	MsgPopup(
		"true",
		T(302535920000495--[[Particles Reload]])
	)
end

function ChoGGi_Funcs.Menus.MeasureTool_Toggle()
	local MeasureTool = MeasureTool
	MeasureTool.Toggle()
	if MeasureTool.enabled then
		MeasureTool.OnMouseButtonDown(nil, "L")
	else
		MeasureTool.OnMouseButtonDown(nil, "R")
	end
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(MeasureTool.enabled),
		T(302535920000451--[[Measure Tool]])
	)
end

function ChoGGi_Funcs.Menus.DeleteAllSelectedObjects()
	local obj = ChoGGi_Funcs.Common.SelObject()
	local is_valid = IsValid(obj)
	-- domes with objs in them = crashy
	if not is_valid or is_valid and obj:IsKindOf("Dome") then
		return
	end

	local function CallBackFunc(answer)
		if not answer then
			return
		end
		SuspendPassEdits("ChoGGi_Funcs.Menus.DeleteAllSelectedObjects")
		MapDelete(true, obj.class)
		ResumePassEdits("ChoGGi_Funcs.Menus.DeleteAllSelectedObjects")
	end

	ChoGGi_Funcs.Common.QuestionBox(
		T(6779--[[Warning]]) .. "!\n"
			.. Translate(302535920000852--[[This will delete all %s of %s]]):format(MapCount("map", obj.class), obj.class),
		CallBackFunc,
		T(6779--[[Warning]]) .. ": " .. T(302535920000855--[[Last chance before deletion!]]),
		Translate(302535920000856--[[Yes, I want to delete all: %s]]):format(obj.class),
		T(302535920000857--[["No, I need to backup my save first (like I should've done before clicking something called ""Delete All"")."]])
	)
end

function ChoGGi_Funcs.Menus.BuildableHexGridSettings(action)
	if not action then
		return
	end

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
		local hint = T(302535920000419--[[125 = 47251 hex spots.]])
		local c = #item_list+1
		item_list[c] = {text = 125, value = 125, hint = hint}
		c = c + 1
		item_list[c] = {text = 150, value = 150, hint = hint}
		c = c + 1
		item_list[c] = {text = 200, value = 200, hint = hint}
		c = c + 1
--~ 		197377
		item_list[c] = {text = 256, value = 256, hint = hint}

		name = T(302535920001417--[[Follow Mouse Grid Size]])
	elseif setting == "DebugGridOpacity" then
		table.insert(item_list, 1, {text = 0, value = 0})

		name = T(302535920001419--[[Follow Mouse Grid Translate]])
	elseif setting == "DebugGridPosition" then
		item_list = {
			{text = Translate(302535920001638--[[Relative]]), value = 0},
			{text = Translate(302535920001637--[[Absolute]]), value = 1},
		}
		name = T(302535920000680--[[Follow Mouse Grid Position]])
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
				ChoGGi_Funcs.Common.BuildableHexGrid(false)
				ChoGGi_Funcs.Common.BuildableHexGrid(true)
			end
			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				tostring(value),
				name
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = name,
		skip_sort = true,
	}
end

ChoGGi.Temp.PathMarkers_new_objs_loop = true
function ChoGGi_Funcs.Menus.SetPathMarkers()
	local Pathing_SetMarkers = ChoGGi_Funcs.Common.Pathing_SetMarkers
	local Pathing_CleanDupes = ChoGGi_Funcs.Common.Pathing_CleanDupes
	local Pathing_StopAndRemoveAll = ChoGGi_Funcs.Common.Pathing_StopAndRemoveAll
	ChoGGi.Temp.UnitPathingHandles = ChoGGi.Temp.UnitPathingHandles or {}
	local randcolours = {}
	local colourcount = 0

	local item_list = {
		{text = Translate(302535920000413--[[Delay]]), value = 0, path_type = "Delay", hint = T(302535920000415--[[Delay in ms between updating paths (0 to update every other render).]])},
		{text = Translate(302535920001691--[[All]]), value = "All"},

		{text = Translate(547--[[Colonists]]), value = "Colonist"},
		{text = Translate(517--[[Drones]]), value = "Drone"},
		{text = Translate(5438--[[Rovers]]), value = "BaseRover", icon = RCTransport and RCTransport.display_icon or "UI/Icons/Buildings/rover_transport.tga"},
		{text = Translate(745--[[Shuttles]]), value = "CargoShuttle", hint = T(302535920000873--[[Doesn't work that well.]])},
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
				T(302535920000416--[[Delay isn't a valid class.]]),
				T(302535920000872--[[Pathing]])
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

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000467--[[Path Markers]]),
		skip_sort = true,
		custom_type = 4,
		checkboxes = {
			{
				title = T(302535920000876--[[Remove Waypoints]]),
				hint = T(302535920000877--[[Remove waypoints from the map and reset colours (select any object type to remove them all).]]),
			},
			{
				title = T(302535920001382--[[Game time]]),
				hint = T(302535920000462--[[Maps paths in real time]]),
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
	-- this is also somewhat from Lua\Flight.lua: Flight_DbgRasterArea() (see older releases, removed in newer)
	-- also sped up to work with being attached to the mouse pos
	local MulDivRound = MulDivRound
	local InterpolateRGB = InterpolateRGB
	local Clamp = Clamp
	local point = point
	local AveragePoint2D = AveragePoint2D
	local FindPassable = FindPassable

	local grid_thread = false
	local Flight_Height_local = false
	-- terrain.TypeTileSize() is from older rev (pre AG?)
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
	local terrain_local

	local function RasterLine(pos1, pos0, zoffset, line_num)
		if not pos1 then
			pos1 = GetCursorWorldPos()
		end
		if not pos0 then
			pos0 = FindPassable(GetCursorWorldPos())
		end

		local steps = 1 + ((pos1 - pos0):Len2D() + dbg_stepm1) / dbg_step

		for i = 1, steps do
			local pos = pos0 + MulDivRound(pos1 - pos0, i - 1, steps - 1)
			local height = Flight_Height_local:GetBilinear(pos, work_step, 0, 1) + zoffset

			points[i] = pos:SetZ(height)
			colours[i] = InterpolateRGB(
				white,
				green,
				Clamp(height - zoffset - terrain_local:GetHeight(pos), 0, max_diff),
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
		SuspendPassEdits("ChoGGi_Funcs.Menus.FlightGrid_Toggle.DeleteLines")
		for i = 0, #flight_lines+1 do
			local o = flight_lines[i]
			if IsValid(o) then
				o:delete()
			end
		end
		table.iclear(flight_lines)
		flight_lines[0] = nil
		ResumePassEdits("ChoGGi_Funcs.Menus.FlightGrid_Toggle.DeleteLines")
	end
	-- If grid is left on when map changes it gets real laggy
	function OnMsg.ChangeMap()
		if IsValidThread(grid_thread) then
			DeleteThread(grid_thread)
		end
		grid_thread = false
		if MainCity then
			DeleteLines()
		end
	end

	local function GridFunc(size, zoffset)
		local WaitMsg = WaitMsg

		local steps = 1 + (size + dbg_step - 1) / dbg_step
		size = steps * dbg_step
		local size_pt = point(size, size) / 2

		-- we spawn lines once then re-use them
		SuspendPassEdits("ChoGGi_Funcs.Menus.FlightGrid_Toggle.GridFunc")
		for i = 0, (steps + steps) do
			flight_lines[i] = OPolyline:new()
		end
		ResumePassEdits("ChoGGi_Funcs.Menus.FlightGrid_Toggle.GridFunc")

		local plus1 = steps + 1
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

	function ChoGGi_Funcs.Menus.FlightGrid_Toggle(size, zoffset)
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

		Flight_Height_local = Flight_Height
		terrain_local = ActiveGameMap.terrain

		if not OPolyline then
			OPolyline = ChoGGi_OPolyline
		end
		table.iclear(points)
		table.iclear(colours)
		grid_thread = CreateRealTimeThread(GridFunc, size, zoffset)
	end
end -- do
