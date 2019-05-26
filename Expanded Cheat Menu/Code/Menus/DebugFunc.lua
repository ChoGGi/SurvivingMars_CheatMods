-- See LICENSE for terms

local pairs, print, type, tonumber, tostring, table = pairs, print, type, tonumber, tostring, table
local table_remove = table.remove
local table_clear = table.clear
local table_iclear = table.iclear
local table_sort = table.sort
local table_find = table.find
local IsValid = IsValid

local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local RetName = ChoGGi.ComFuncs.RetName
local Translate = ChoGGi.ComFuncs.Translate
local RandomColour = ChoGGi.ComFuncs.RandomColour
local Strings = ChoGGi.Strings

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
		Strings[302535920000049--[[Loading Screen Log--]]]
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
"--]]]

		local item_list = {
			{
				text = Strings[302535920001137--[[CSV Path--]]],
				value = ChoGGi.library_path .. "Locales/English.csv",
				hint = hint,
			},
			{
				text = Strings[302535920001162--[[Test Columns--]]],
				value = "false",
				hint = Strings[302535920001166--[["Reports any columns above the normal amount (5).
Columns are added by commas (, ). Surround the entire string with """" to use them.

Try to increase or decrease the number if not enough or too many errors show up.
For the value enter either ""true"" (to use 5) or a number.

You need my HelperMod installed to be able to use this."--]]],
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
			title = Strings[302535920001125--[[Test Locale File--]]],
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
		-- if it's a single obj then examine that, otherwise the whole list
		ChoGGi.ComFuncs.OpenInExamineDlg(c == 1 and objs[1] or objs)
		return
	end

	local terminal = terminal

	-- next we check if there's a ui element under the cursor and return that
	local target = terminal.desktop:GetMouseTarget(terminal.GetMousePos())
	-- everywhere is covered in xdialogs so skip them
	if target and not target:IsKindOf("XDialog") then
		return ChoGGi.ComFuncs.OpenInExamineDlg(target)
	end

	-- if in main menu then open examine and console
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
	ChoGGi.ComFuncs.OpenInExamineDlg(visible, nil, Strings[302535920001547--[[Visible Objects--]]])
end

do -- BuildingPathMarkers_Toggle
--~ 		GetEntityWaypointChains(entity)
	-- mostly a copy n paste from Lua\Buildings\BuildingWayPoints.lua: ShowWaypoints()
	local DoneObject = DoneObject
	local AveragePoint2D = AveragePoint2D
	local OText, OPolyline

	local objlist = objlist
	local points, colors = objlist:new(), objlist:new()
	local function ShowWaypoints(waypoints, open)
		points:Clear()
		colors:Clear()

		local color_line = RandomColour()
		local color_door = RandomColour()
		local lines = objlist:new()
		for i = 1, #waypoints do
			local w = waypoints[i]
			local c = i == open and color_door or color_line
			points[i] = w
			colors[i] = c
			local t = OText:new()
			t:SetPos(w:SetZ(w:z() or w:SetTerrainZ(10 * guic)))
			t:SetColor1(c)
			t:SetText(i .. "")
			lines[i] = t
		end
		local line = OPolyline:new()
		line:SetPos(AveragePoint2D(points))
		line:SetMesh(points, colors)
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
		OText = OText or ChoGGi_OText
		OPolyline = OPolyline or ChoGGi_OPolyline
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
			Strings[302535920001527--[[Building Path Markers--]]]
		)
	end
end -- do

function ChoGGi.MenuFuncs.ExaminePersistErrors_Toggle()
	ChoGGi.UserSettings.DebugPersistSaves = not ChoGGi.UserSettings.DebugPersistSaves
	ChoGGi.SettingFuncs.WriteSettings()

	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.DebugPersistSaves),
		Strings[302535920001498--[[Examine Persist Errors--]]]
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

			-- close welcome to mars msg
			local Dialogs = Dialogs
			if Dialogs.PopupNotification then
				Dialogs.PopupNotification:Close()
			end

			-- lightmodel
			LightmodelPresets.TheMartian1_Night.exterior_envmap = nil
			SetLightmodelOverride(1, "TheMartian1_Night")

			local texture = table_find(TerrainTextures, "name", "Prefab_Orange")
			terrain.SetTerrainType{type = texture or 1}

			-- wait a bit till we're sure the map is around
			local GameState = GameState
			while not GameState.gameplay do
				Sleep(500)
			end

			-- make an index table of ents for placement
			local entity_list = {}
			local c = 0
			local EntityData = EntityData
			for key in pairs(EntityData) do
				c = c + 1
				entity_list[c] = key
			end
			table_sort(entity_list)
			local entity_count = #entity_list

			local IsBuildableZoneQR = IsBuildableZoneQR
			local WorldToHex = WorldToHex
			local point = point
			local ChoGGi_OBuildingEntityClass = ChoGGi_OBuildingEntityClass

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
							local obj = ChoGGi_OBuildingEntityClass:new()
							-- 11500 so stuff is floating above the ground
							obj:SetPos(point(x1000, y1000, 11500))

							c = c + 1
							obj:ChangeEntity(entity_list[c])

							-- if it has a working state then set it
							local states_str = obj:GetStates()
							local idx = table_find(states_str, "working")
								or table_find(states_str, "idleOpened")
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

			Sleep(2500)
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

	ChoGGi.ComFuncs.QuestionBox(
		Translate(6779--[[Warning--]]) .. ": " .. Strings[302535920001493--[["This will change to a new map, anything unsaved will be lost!"--]]],
		CallBackFunc,
		Strings[302535920001491--[[View All Entities--]]]
	)

end

function ChoGGi.MenuFuncs.ForceStoryBits()
--~ ~g_StoryBitStates
--~ that'll show all the active story state thingss

	local StoryBits = StoryBits

	local item_list = {}
	local c = 0

	local temp_table = {}
	for id, story_def in pairs(StoryBits) do
		table_clear(temp_table)
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
			voiced = "<color yellow>" .. Translate(6855--[[Voiced Text--]]) .. "</color>: " .. Translate(story_def.VoicedText)
		end

		c = c + 1
		item_list[c] = {
			text = title,
			value = id,
			hint = Strings[302535920001358--[[Group--]]] .. ": "
				.. story_def.group .. "\n\n"
				.. (story_def.Text and Translate(T{story_def.Text, temp_table}) or "")
				.. (voiced and "\n\n" .. voiced or "")
				.. (story_def.Image ~= "" and "\n\n<image " .. story_def.Image .. ">" or "")
		}
	end

	local title = Translate(186760604064--[[Test--]]) .. " " .. Translate(948928900281--[[Story Bits--]])
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

		ForceActivateStoryBit(choice.value, obj, true)

	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = title,
		hint = Strings[302535920001359--[[Test activate a story bit.--]]],
		checkboxes = {
			{
				title = Translate(5426--[[Building--]]),
				hint = Strings[302535920001555--[[Choose a random %s to be the context for this storybit.--]]]:format(Translate(5426--[[Building--]])),
			},
			{
				title = Translate(1234--[[Dome--]]),
				hint = Strings[302535920001555--[[Choose a random %s to be the context for this storybit.--]]]:format(Translate(1234--[[Dome--]])),
			},
			{
				title = Translate(4290--[[Colonist--]]),
				hint = Strings[302535920001555--[[Choose a random %s to be the context for this storybit.--]]]:format(Translate(4290--[[Colonist--]])),
			},
			{
				title = Translate(1681--[[Drone--]]),
				hint = Strings[302535920001555--[[Choose a random %s to be the context for this storybit.--]]]:format(Translate(1681--[[Drone--]])),
				level = 2,
			},
			{
				title = Translate(10147--[[Rover--]]),
				hint = Strings[302535920001555--[[Choose a random %s to be the context for this storybit.--]]]:format(Translate(10147--[[Rover--]])),
				level = 2,
			},
			{
				title = Strings[302535920000769--[[Selected--]]],
				hint = Strings[302535920001556--[[Use the selected object.--]]],
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
		local obj = ChoGGi.ComFuncs.DotNameToObject(value)
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
			Strings[302535920001316--[[Toggled: %s = %s--]]]:format(choice.text, new_value),
			Strings[302535920001314--[[Toggle Render--]]]
		)
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920001314--[[Toggle Render--]]],
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
		Strings[302535920000495--[[Particles Reload--]]]
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
		Strings[302535920000451--[[Measure Tool--]]]
	)
end

function ChoGGi.MenuFuncs.ReloadLua()
	if ChoGGi.blacklist then
		ChoGGi.ComFuncs.BlacklistMsg("ChoGGi.MenuFuncs.ReloadLua")
		return
	end

	force_load_build = true
	ReloadLua()
	force_load_build = false
	MsgPopup(
		"true",
		Strings[302535920000453--[[Reload Lua--]]]
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
		Translate(6779--[[Warning--]]) .. "!\n"
			.. Strings[302535920000852--[[This will delete all %s of %s--]]]:format(MapCount("map", obj.class), obj.class),
		CallBackFunc,
		Translate(6779--[[Warning--]]) .. ": " .. Strings[302535920000855--[[Last chance before deletion!--]]],
		Strings[302535920000856--[[Yes, I want to delete all: %s--]]]:format(obj.class),
		Strings[302535920000857--[["No, I need to backup my save first (like I should've done before clicking something called ""Delete All"")."--]]]
	)
end

function ChoGGi.MenuFuncs.ObjectCloner(flat)
	local obj = ChoGGi.ComFuncs.SelObject()
	if not IsValid(obj) then
		return
	end

	if obj:IsKindOf("Colonist") then
		ChoGGi.ComFuncs.SpawnColonist(obj, nil, GetTerrainCursor())
		return
	end

	local new
	-- clone dome = crashy
	if obj:IsKindOf("Dome") then
		new = g_Classes[obj.class]:new()
		new:CopyProperties(obj)
	else
		new = obj:Clone()
	end

	-- got me banners are weird like that
	if obj:IsKindOf("Banner") then
		new:ChangeEntity(obj:GetEntity())
	end

	local hex = ChoGGi.ComFuncs.CursorNearestHex()
	if flat == true or flat.flatten_to_ground == true then
		new:SetPos(point(
			hex:x(),
			hex:y(),
			new:GetPos():z()
		))
	else
		new:SetPos(hex)
	end

	if new:IsKindOf("SubsurfaceDeposit") then
		if new.CheatRefill then
			new:CheatRefill()
		end
	end
--~ 	if new.CheatFill then
--~ 		new:CheatFill()
--~ 	end

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
		local hint = Strings[302535920000419--[[125 = 47251 hex spots.--]]]
		local c = #item_list+1
		item_list[c] = {text = 125, value = 125, hint = hint}
		c = c + 1
		item_list[c] = {text = 150, value = 150, hint = hint}
		c = c + 1
		item_list[c] = {text = 200, value = 200, hint = hint}
		c = c + 1
--~ 		197377
		item_list[c] = {text = 256, value = 256, hint = hint}

		name = Strings[302535920001417--[[Follow Mouse Grid Size--]]]
	elseif setting == "DebugGridOpacity" then
		table.insert(item_list, 1, {text = 0, value = 0})

		name = Strings[302535920001419--[[Follow Mouse Grid Translate--]]]
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
			if IsValidThread(ChoGGi.Temp.grid_thread) then
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

do -- path markers
	local IsObjlist = ChoGGi.ComFuncs.IsObjlist
	local CreateGameTimeThread = CreateGameTimeThread
	local AveragePoint2D = AveragePoint2D
	local terrain_GetHeight = terrain.GetHeight
	local RetAllOfClass = ChoGGi.ComFuncs.RetAllOfClass
	local SelObjects = ChoGGi.ComFuncs.SelObjects
	local WaitMsg = WaitMsg
	local Sleep = Sleep

	local path_classes = {"Movable", "CargoShuttle"}
	local randcolours = {}
	local colourcount = 0
	local dupewppos = {}
	-- default height of waypoints (maybe flag_height isn't the best name as i stopped using them)
	local flag_height = 50
	local OPolyline

	local function ShowWaypoints(waypoints, colour, obj, skip_height, obj_pos)
		colour = tonumber(colour) or RandomColour()
		-- also used for line height
		if not skip_height then
			flag_height = flag_height + 4
		end

		obj_pos = obj_pos or obj:GetVisualPos()
		local obj_terrain = terrain_GetHeight(obj_pos)
		local obj_height = obj:GetObjectBBox():sizez() / 2
		if obj:IsKindOf("CargoShuttle") then
			obj_height = obj_pos:z() - obj_terrain
		end

		-- some objects don't have pos as waypoint
		local wp_c = #waypoints
		if waypoints[wp_c] ~= obj_pos then
			wp_c = wp_c + 1
			waypoints[wp_c] = obj_pos
		end

		-- build a list of points that aren't high in the sky
		for i = 1, wp_c do
			local wp = waypoints[i]
			local z = wp:z()
			if not z or z and z < obj_terrain then
				waypoints[i] = wp:SetTerrainZ(obj_height + flag_height)
			end
		end
		-- and spawn the line
		local spawnline = OPolyline:new()
		spawnline:SetMesh(waypoints, colour)
		spawnline:SetPos(AveragePoint2D(waypoints))

		obj.ChoGGi_Stored_Waypoints[#obj.ChoGGi_Stored_Waypoints+1] = spawnline
	end -- end of ShowWaypoints

	local function SetWaypoint(obj, setcolour, skip_height)
		local path = {}

		-- we need to build a path for shuttles (and figure out a way to get their dest properly...)
		local is_shuttle = obj:IsKindOf("CargoShuttle")
		if is_shuttle then

			-- going to pickup colonist
			if obj.command == "GoHome" then
				path[1] = obj.hub:GetPos()
			elseif obj.command == "Transport" then
				-- 2 is pickup loc, 3 is drop off
				path[1] = obj.transport_task and ((obj.transport_task[2] and obj.transport_task[2]:GetBuilding():GetPos()) or (obj.transport_task[3] and obj.transport_task[3]:GetBuilding():GetPos()))
			elseif obj.is_colonist_transport_task then
				path[1] = obj.transport_task and (obj.transport_task.dest_pos or obj.transport_task.colonist:GetPos())
			else
				path[1] = obj:GetDestination()
			end

			-- jumper shuttles after first leg
			if type(path[1]) ~= "userdata" then
				path[1] = obj:GetDestination()
			end

			local c = #path

			-- the next four points it's going to after current_spline
			if type(obj.next_spline) == "table" then
				for i = 1, #obj.next_spline do
					c = c + 1
					path[c] = obj.next_spline[i]
				end
			end

			-- where the line starts
			c = c + 1
			path[c] = obj:GetPos()

		else
			-- rovers/drones/colonists
			if obj.GetPath then
				path = obj:GetPath()
			else
				ChoGGi.ComFuncs.OpenInExamineDlg(obj, nil, Strings[302535920000467--[[Path Markers--]]])
				print(Translate(6779--[[Warning--]]), ":", Strings[302535920000869--[[This %s doesn't have GetPath function, something is probably borked.--]]]:format(RetName(obj)))
			end
		end

		-- we have a path so add some colours, and build the waypoints
		if path then
			local colour
			if setcolour then
				colour = setcolour
			else
				if #randcolours < 1 then
					colour = RandomColour()
				else
					-- we want to make sure all grouped waypoints are a different colour (or at least slightly diff)
					colour = table_remove(randcolours)
					-- table.remove(t) removes and returns the last value of the table
				end
			end

			if not IsObjlist(obj.ChoGGi_Stored_Waypoints) then
				obj.ChoGGi_Stored_Waypoints = objlist:new()
			end

			if not obj.ChoGGi_WaypointPathAdded then
				-- used to reset the colour later on
				obj.ChoGGi_WaypointPathAdded = obj:GetColorModifier()
				obj.ChoGGi_WaypointPathAdded_storedcolour = colour
			end

			-- colour it up
			obj:SetColorModifier(obj.ChoGGi_WaypointPathAdded_storedcolour or colour)

			-- and lastly make sure path is sorted correctly
			-- end is where the obj is, and start is where the dest is
			if is_shuttle then
				table_sort(path, function(a, b)
					return obj:GetVisualDist(a) > obj:GetVisualDist(b)
				end)
			end

			-- send path off to make wp
			ShowWaypoints(
				path,
				colour,
				obj,
				skip_height,
				obj.GetVisualPos and obj:GetVisualPos() or obj:GetPos()
			)
		end
	end
	ChoGGi.MenuFuncs.SetWaypoint = SetWaypoint

	local function SetPathMarkersGameTime_Thread(obj, handles, delay)
		local colour = RandomColour()
		if not IsObjlist(obj.ChoGGi_Stored_Waypoints) then
			obj.ChoGGi_Stored_Waypoints = objlist:new()
		end

		while handles[obj.handle] do
			SetWaypoint(obj, colour, true)
			if delay == 0 or delay == -1 then
				-- if we only do one then it'll be invis unless paused
				-- 2+ is too much ficker
				WaitMsg("OnRender")
				WaitMsg("OnRender")
				-- if you like bears then you'd figure the third is just right... ah well twofer
			else
				Sleep(delay)
			end

			-- deletes all wp objs
			obj.ChoGGi_Stored_Waypoints:Destroy()
			-- clears table list
			obj.ChoGGi_Stored_Waypoints:Clear()

			-- break thread when obj isn't valid
			if not IsValid(obj) then
				handles[obj.handle] = nil
				break
			end
		end
	end

	local function AddObjToGameTimeMarkers(obj, handles, delay, skip)
		if skip or obj:IsKindOfClasses(path_classes) then

			if handles[obj.handle] then
				-- already exists so remove thread
				handles[obj.handle] = nil
			elseif IsValid(obj) then
				-- continous loooop of object for pathing it
				handles[obj.handle] = CreateGameTimeThread(SetPathMarkersGameTime_Thread, obj, handles, delay)
			end
		end
	end

	local function SetPathMarkersGameTime(obj, menu_fired, menu_delay)
		OPolyline = OPolyline or ChoGGi_OPolyline

		local delay = 500
		-- if fired from action menu (or shortcut)
		if IsKindOf(obj, "XAction") then
			obj = SelObjects(1500)
			if #obj == 0 then
				obj = nil
			end
			menu_fired = true
		else
			obj = obj or SelObjects(1500)
			delay = type(menu_delay) == "number" and menu_delay or delay
		end

		if obj then
			local handles = ChoGGi.Temp.UnitPathingHandles
			if #obj == 1 then
				-- single obj
				obj = obj[1]
 			elseif #obj > 1 then
				-- multiselect
				for i = 1, #obj do
					AddObjToGameTimeMarkers(obj[i], handles, delay)
				end
				return
			end
			-- single not in a table list (true because we already checked the kindof)
			if obj:IsKindOfClasses(path_classes) then
				return AddObjToGameTimeMarkers(obj, handles, delay, true)
			end
		end

		if menu_fired then
			MsgPopup(
				Strings[302535920000871--[[Doesn't seem to be an object that moves.--]]],
				Strings[302535920000872--[[Pathing--]]],
				nil,
				nil,
				obj
			)
		end
	end
	ChoGGi.MenuFuncs.SetPathMarkersGameTime = SetPathMarkersGameTime

	local function RemoveWPDupePos(cls, obj)
		-- remove dupe pos
		if IsObjlist(obj.ChoGGi_Stored_Waypoints) then
			for i = 1, #obj.ChoGGi_Stored_Waypoints do
				local wp = obj.ChoGGi_Stored_Waypoints[i]

				if wp.class == cls then
					local pos = tostring(wp:GetPos())
					if dupewppos[pos] then
						dupewppos[pos]:SetColorModifier(6579300)
						wp:delete()
					else
						dupewppos[pos] = obj.ChoGGi_Stored_Waypoints[i]
					end
				end
			end
			-- remove removed
			obj.ChoGGi_Stored_Waypoints:Validate()
		end
	end

	local function ClearColourAndWP(cls, skip)
		-- remove all thread refs so they stop
		table_clear(ChoGGi.Temp.UnitPathingHandles)
		-- and waypoints/colour
		local objs = RetAllOfClass(cls)
		for i = 1, #objs do
			local obj = objs[i]

			if not skip and obj.ChoGGi_WaypointPathAdded then
				obj:SetColorModifier(obj.ChoGGi_WaypointPathAdded)
				obj.ChoGGi_WaypointPathAdded = nil
				obj.ChoGGi_WaypointPathAdded_storedcolour = nil
			end

			local stored = obj.ChoGGi_Stored_Waypoints
			if IsObjlist(stored) then
				-- deletes all objs
				stored:Destroy()
				-- clears table list
				stored:Clear()
			end

		end
	end
	local function CleanDupes()
		-- remove any waypoints in the same pos
		local function ClearAllDupeWP(cls)
			local objs = ChoGGi.ComFuncs.RetAllOfClass(cls)
			for i = 1, #objs do
				local obj = objs[i]
				if obj and obj.ChoGGi_Stored_Waypoints then
					RemoveWPDupePos("WayPoint", obj)
					RemoveWPDupePos("Sphere", obj)
				end
			end
		end
		ClearAllDupeWP("CargoShuttle")
		ClearAllDupeWP("Unit")
		ClearAllDupeWP("Colonist")
	end


	local aliens
	local new_objs_loop = true
	local function StopAndRemoveAll(skip)
		if not skip then
			new_objs_loop = false
		end
		-- reset all the base colours/waypoints
		ClearColourAndWP("CargoShuttle", skip)
		ClearColourAndWP("Unit", skip)
		ClearColourAndWP("Colonist", skip)
		if aliens then
			ClearColourAndWP("ChoGGi_Alien", skip)
		end

		-- remove any extra lines
		ChoGGi.ComFuncs.RemoveObjs("ChoGGi_OPolyline")

		-- reset stuff
		flag_height = 50
		randcolours = {}
		colourcount = 0
		dupewppos = {}
	end

	local function SetMarkers(list, check, delay)
		if check then
			for i = 1, #list do
				SetPathMarkersGameTime(list[i], nil, delay)
			end
		else
			for i = 1, #list do
				SetWaypoint(list[i])
			end
		end
	end

	function ChoGGi.MenuFuncs.SetPathMarkers()
		OPolyline = OPolyline or ChoGGi_OPolyline
		ChoGGi.Temp.UnitPathingHandles = ChoGGi.Temp.UnitPathingHandles or {}

		local item_list = {
			{text = Strings[302535920000413--[[Delay--]]], value = 0, path_type = "Delay", hint = Strings[302535920000415--[[Delay in ms between updating paths (0 to update every other render).--]]]},
			{text = Translate(4493--[[All--]]), value = "All"},

			{text = Translate(547--[[Colonists--]]), value = "Colonist"},
			{text = Translate(517--[[Drones--]]), value = "Drone"},
			{text = Translate(5438--[[Rovers--]]), value = "BaseRover", icon = RCTransport and RCTransport.display_icon or "UI/Icons/Buildings/rover_transport.tga"},
			{text = Translate(745--[[Shuttles--]]), value = "CargoShuttle", hint = Strings[302535920000873--[[Doesn't work that well.--]]]},
		}
		if rawget(_G, "ChoGGi_Alien") then
			aliens = true
			item_list[#item_list+1] = {text = "Alien Visitors", value = "ChoGGi_Alien"}
		end

		local function CallBackFunc(choices)
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
				StopAndRemoveAll()

			-- naughty user
			elseif value == "Delay" then
				MsgPopup(
					Strings[302535920000416--[[Delay isn't a valid class.--]]],
					Strings[302535920000872--[[Pathing--]]]
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
--~ 					SetMarkers(table1, choice1.check2, delay)
--~ 					SetMarkers(table2, choice1.check2, delay)
--~ 					SetMarkers(table3, choice1.check2, delay)
--~ 					CleanDupes()

					CreateGameTimeThread(function()
						local labels = UICity.labels
						local table1 = labels.Unit or ""
						local table2 = labels.CargoShuttle or ""
						local table3 = labels.Colonist or ""
						-- +1 to make it fire the first time
						local current = #table1+#table2+#table3+1

						while new_objs_loop do
							table1 = labels.Unit or ""
							table2 = labels.CargoShuttle or ""
							table3 = labels.Colonist or ""
							local count = #table1+#table2+#table3
							if current ~= count then
								-- update list when
								StopAndRemoveAll(true)

								current = count
								colourcount = colourcount + #table1
								colourcount = colourcount + #table2
								colourcount = colourcount + #table3
								randcolours = RandomColour(colourcount + 1)
								SetMarkers(table1, choice1.check2, delay)
								SetMarkers(table2, choice1.check2, delay)
								SetMarkers(table3, choice1.check2, delay)

								CleanDupes()
							end
							Sleep(2500)
						end
						new_objs_loop = true
					end)

				-- skip any non-cls objects (or mapget returns all)
				elseif g_Classes[value] then
					CreateGameTimeThread(function()
						local labels = UICity.labels
						local table1 = labels[value] or MapGet("map", value)
						-- +1 to make it fire the first time
						local current = #table1+1

						while new_objs_loop do
							table1 = labels[value] or MapGet("map", value)
							if current ~= #table1 then
								-- update list when
								StopAndRemoveAll(true)

								current = #table1
								colourcount = colourcount + current
								randcolours = RandomColour(colourcount + 1)
								SetMarkers(table1, choice1.check2, delay)
								CleanDupes()
							end
							Sleep(2500)
						end
						new_objs_loop = true
					end)
				end


			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = Strings[302535920000467--[[Path Markers--]]],
			skip_sort = true,
			custom_type = 4,
			checkboxes = {
				{
					title = Strings[302535920000876--[[Remove Waypoints--]]],
					hint = Strings[302535920000877--[[Remove waypoints from the map and reset colours (select any object type to remove them all).--]]],
				},
				{
					title = Strings[302535920001382--[[Game time--]]],
					hint = Strings[302535920000462--[[Maps paths in real time--]]],
					checked = true,
				},
			},
		}
	end
end

--little bit of painting
--~ local terrain_type = "Grass_01"
--~ local terrain_type_idx = table_find(TerrainTextures, "name", terrain_type)
--~ CreateRealTimeThread(function()
--~	 while true do
--~		 terrain.SetTypeCircle(GetTerrainCursor(), 2500, terrain_type_idx)
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
	local GetTerrainCursor = GetTerrainCursor
	local terrain_GetHeight = terrain.GetHeight
	local DoneObject = DoneObject

	local grid_thread = false
	local Flight_Height_temp = false
	local work_step = 16 * terrain.TypeTileSize()
	local dbg_step = work_step / 4 -- 400
	local dbg_stepm1 = dbg_step - 1
	local max_diff = 5 * guim
	local white = white
	local green = green
	local flight_lines = {}
	local points, colors = {}, {}
	local OPolyline

	local function RasterLine(pos1, pos0, zoffset, line_num)
		pos1 = pos1 or GetTerrainCursor()
		pos0 = pos0 or FindPassable(GetTerrainCursor())
		local steps = 1 + ((pos1 - pos0):Len2D() + dbg_stepm1) / dbg_step

		for i = 1, steps do
			local pos = pos0 + MulDivRound(pos1 - pos0, i - 1, steps - 1)
			local height = Flight_Height_temp:GetBilinear(pos, work_step, 0, 1) + zoffset

			points[i] = pos:SetZ(height)
			colors[i] = InterpolateRGB(
				white,
				green,
				Clamp(height - zoffset - terrain_GetHeight(pos), 0, max_diff),
				max_diff
			)
		end
		local line = flight_lines[line_num]
		-- just in case it was deleted
		if not IsValid(line) then
			line = OPolyline:new()
			flight_lines[line_num] = line
		end
		line:SetMesh(points, colors)
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
		table_iclear(flight_lines)
		flight_lines[0] = nil
		ResumePassEdits("ChoGGi.MenuFuncs.FlightGrid_Toggle.DeleteLines")
	end
	-- if grid is left on when map changes it gets real laggy
	function OnMsg.ChangeMap()
		if IsValidThread(grid_thread) then
			DeleteThread(grid_thread)
		end
		grid_thread = false
		if GameState.gameplay then
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
			pos_new = GetTerrainCursor()
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

		-- if fired from action menu
		if IsKindOf(size, "XAction") then
			size = grid_size
			zoffset = 0
		else
			size = size or grid_size
			zoffset = zoffset or 0
		end

		Flight_Height_temp = Flight_Height

		OPolyline = OPolyline or ChoGGi_OPolyline
		table_iclear(points)
		table_iclear(colors)
		grid_thread = CreateRealTimeThread(GridFunc, size, zoffset)
	end
end -- do
