-- See LICENSE for terms

local pairs,print,type,tonumber,tostring,table = pairs,print,type,tonumber,tostring,table
local TableRemove = table.remove
local TableClear = table.clear
local IsValid = IsValid

function OnMsg.ClassesGenerate()
	local MsgPopup = ChoGGi.ComFuncs.MsgPopup
	local RetName = ChoGGi.ComFuncs.RetName
	local Trans = ChoGGi.ComFuncs.Translate
	local RandomColour = ChoGGi.ComFuncs.RandomColour
	local S = ChoGGi.Strings

	do -- BuildingPathMarkers_Toggle
--~ 		GetEntityWaypointChains(entity)
		-- mostly a copy n paste from Lua\Buildings\BuildingWayPoints.lua: ShowWaypoints()
		local DoneObject = DoneObject
		local PlaceObject = PlaceObject
		local AveragePoint2D = AveragePoint2D

		local objlist = objlist

		local points, colors = objlist:new(),objlist:new()

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
				local t = PlaceObject("ChoGGi_OText")
				t:SetPos(w:SetZ(w:z() or w:SetTerrainZ(10 * guic)))
				t:SetColor(c)
				t:SetText(i .. "")
				lines[i] = t
			end
			local line = PlaceObject("ChoGGi_OPolyline")
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
				S[302535920001527--[[Building Path Markers--]]]
			)
		end
	end -- do

	function ChoGGi.MenuFuncs.ExaminePersistErrors_Toggle()
		ChoGGi.UserSettings.DebugPersistSaves = not ChoGGi.UserSettings.DebugPersistSaves
		ChoGGi.SettingFuncs.WriteSettings()

		MsgPopup(
			ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.DebugPersistSaves),
			S[302535920001498--[[Examine Persist Errors--]]]
		)
	end

	function ChoGGi.MenuFuncs.ViewAllEntities()
		local function CallBackFunc(answer)
			if not answer then
				return
			end
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
				WaitMsg("RocketLaunchFromEarth")
				while not Dialogs.PopupNotification do
					Sleep(500)
				end
				-- close welcome to mars msg
				Dialogs.PopupNotification:Close()
				-- remove all notifications
				local dlg = GetDialog("OnScreenNotificationsDlg")
				if dlg then
					local notes = g_ActiveOnScreenNotifications
					for i = #notes, 1, -1 do
						dlg:RemoveNotification(notes[i][1])
					end
				end
				-- pause it
				SetGameSpeedState("pause")
				-- lightmodel
				LightmodelPresets.TheMartian1_Night.exterior_envmap = nil
				SetLightmodelOverride(1,"TheMartian1_Night")

				local texture = table.find(TerrainTextures,"name","Prefab_Violet")
				terrain.SetTerrainType{type = texture or 1}

				Sleep(1000)

				-- make an index table of ents for placement
				local entity_list = {}
				local c = 0
				local all_entities = GetAllEntities()
				for key in pairs(all_entities) do
					c = c + 1
					entity_list[c] = key
				end
				table.sort(entity_list)
				local entity_count = #entity_list
				c = 0

				local IsBuildableZoneQR = IsBuildableZoneQR
				local WorldToHex = WorldToHex
				local point = point
				local PlaceObj = PlaceObj

				local width,height = ConstructableArea:sizexyz()
				width = width / 1000
				height = height / 1000

				for x = 100, width do
					if c > entity_count then
						break
					end
					for y = 10, height do
						if c > entity_count then
							break
						end

						local xx,yy = x * 1000, y * 1000
						local q, r = WorldToHex(xx,yy)

						local mod = 5
						local plusone = entity_list[c+1]

						-- domes are big
						local sub8 = plusone:sub(1,8)
						local sub5 = plusone:sub(1,5)
						if plusone:find("Dome") and sub8 ~= "DomeRoad" and sub8 ~= "DomeDoor" and not plusone:find("Entrance") then
							mod = 16
						elseif sub5 == "Unit_" or sub5 == "Arrow" or plusone:find("Door") or plusone:find("DecLogo") then
							mod = 1
						elseif plusone:find("Cliff") then
							mod = 8
						end

						if q % mod == 0 and r % mod == 0 and IsBuildableZoneQR(q,r) then
							local obj = PlaceObj("ChoGGi_BuildingEntityClass",{
								"Pos",point(xx,yy)
							})

							c = c + 1
							obj:ChangeEntity(entity_list[c])
						end

					end
				end

			end)
		end

		ChoGGi.ComFuncs.QuestionBox(
			Trans(6779--[[Warning--]]) .. ": " .. S[302535920001493--[["This will change to a new map, anything unsaved will be lost!"--]]],
			CallBackFunc,
			S[302535920001491--[[View All Entities--]]]
		)

	end

	function ChoGGi.MenuFuncs.ForceStoryBits()
--[[
if you do a ~g_StoryBitStates
that'll show all the active story state thingss
then click for example BadPrefab, select a prefab and in tools>Execute code stick:
ChoGGi.CurObj:ActivateStoryBit(s)
that'll activate the BadPrefab on it
--]]
		local StoryBits = StoryBits

		local ItemList = {}
		local c = 0

		local story_table = {}
		local g_StoryBitStates = g_StoryBitStates
		for id,a_story in pairs(g_StoryBitStates) do

			local story = StoryBits[id]
			TableClear(story_table)
			for i = 1, #story do
				if story[i].Name and story[i].Value then
					story_table[story[i].Name] = story[i].Value
				end
			end

			local title = story.Title and Trans(story.Title) or id
			if not (title:find(": ") or title:find(" - ",1,true)) then
				title = story.group .. ": " .. title
			end
			c = c + 1
			ItemList[c] = {
				text = title,
				value = id,
				story = a_story,
				voiced = story.VoicedText,
				hint = S[302535920001358--[[Group--]]] .. ": " .. story.group .. "\n\n"
					.. Trans(T(story.Text,story_table)) .. "\n\n<image " .. story.Image
					.. ">",
			}
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end

			-- have a way to enter a class to use a random? object from
--~ 			choice[1].story:ActivateStoryBit()

			MsgPopup(
				"I said they don't do jack...",
				Trans(948928900281--[[Story Bits--]])
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = Trans(948928900281--[[Story Bits--]]),
			hint = S[302535920001359--[["Just lists them for now, I'll make it force them soonish."--]]],
		}
	end

	do -- PostProcGrids
		local SetPostProcPredicate = SetPostProcPredicate
		function ChoGGi.MenuFuncs.PostProcGrids(grid_type)
			-- always disable other ones
			SetPostProcPredicate("grid45", false)
			SetPostProcPredicate("grid", false)
			SetPostProcPredicate("hexgrid", false)
			if grid_type then
				SetPostProcPredicate(grid_type, true)
			end
		end
	end -- do

	function ChoGGi.MenuFuncs.Render_Toggle()
		local ItemList = {
			{text = "RenderAlwaysRenderableObjects",value = "RenderAlwaysRenderableObjects"},
			{text = "RenderBandOutsideMap",value = "RenderBandOutsideMap"},
			{text = "RenderBandOutsidersMaxZ",value = "RenderBandOutsidersMaxZ"},
			{text = "RenderBandOutsidersMinZ",value = "RenderBandOutsidersMinZ"},
			{text = "RenderBillboards",value = "RenderBillboards"},
			{text = "RenderBillboardShadows",value = "RenderBillboardShadows"},
			{text = "RenderBSpheres",value = "RenderBSpheres"},
			{text = "RenderBuildGrid",value = "RenderBuildGrid"},
			{text = "RenderCodeRenderables",value = "RenderCodeRenderables"},
			{text = "RenderDecals",value = "RenderDecals"},
			{text = "RenderGrass",value = "RenderGrass"},
			{text = "RenderHasBillboards",value = "RenderHasBillboards"},
			{text = "RenderIce",value = "RenderIce"},
			{text = "RenderLights",value = "RenderLights"},
			{text = "RenderMapObjects",value = "RenderMapObjects"},
			{text = "RenderMirage",value = "RenderMirage"},
			{text = "RenderOBBs",value = "RenderOBBs"},
			{text = "RenderOutsiders",value = "RenderOutsiders"},
			{text = "RenderParticles",value = "RenderParticles"},
			{text = "RenderPlanetView",value = "RenderPlanetView"},
			{text = "RenderSkinned",value = "RenderSkinned"},
			{text = "RenderStatsFrameTimeCPU",value = "RenderStatsFrameTimeCPU"},
			{text = "RenderStatsFrameTimeGPU",value = "RenderStatsFrameTimeGPU"},
			{text = "RenderStatsSmoothing",value = "RenderStatsSmoothing"},
			{text = "RenderTerrain",value = "RenderTerrain"},
			{text = "RenderTerrainFirst",value = "RenderTerrainFirst"},
			{text = "RenderTrails",value = "RenderTrails"},
			{text = "RenderTransparent",value = "RenderTransparent"},
	--~ 		{text = "RenderUIL",value = "RenderUIL"},
			{text = "RenderUnskinned",value = "RenderUnskinned"},
			{text = "Shadowmap",value = "Shadowmap"},
			{text = "TerrainAABB",value = "TerrainAABB"},
			{text = "ToggleSafearea",value = "ToggleSafearea"},
		}
		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local value = choice[1].value

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
				S[302535920001316--[[Toggled: %s = %s--]]]:format(choice[1].text,new_value),
				S[302535920001314--[[Toggle Render--]]]
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = S[302535920001314--[[Toggle Render--]]],
			skip_sort = true,
			custom_type = 1,
			custom_func = CallBackFunc,
		}
	end

	function ChoGGi.MenuFuncs.FpsCounterLocation()
		local pos = hr.FpsCounterPos or 0
		pos = pos + 1
		if pos < 4 then
			hr.FpsCounterPos = pos
		else
			hr.FpsCounterPos = 0
		end
	end

	function ChoGGi.MenuFuncs.DeleteSavedGames()
		if blacklist then
			print(S[302535920000242--[[%s is blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have Über access.--]]]:format("ChoGGi.MenuFuncs.DeleteSavedGames"))
			return
		end
		local SavegamesList = SavegamesList
		local ItemList = {}
		for i = 1, #SavegamesList do
			local data = SavegamesList[i]

			-- build played time
			local playtime = T(77, "Unknown")
			if data.playtime then
				local h, m, _ = FormatElapsedTime(data.playtime, "hms")
				playtime = T{
					7549, "<hours>:<minutes>",
					hours = string.format("%02d", h),
					minutes = string.format("%02d", m)
				}
			end
			-- and last saved
			local save_date = 0
			if data.timestamp then
				save_date = os.date("%H:%M - %d / %m / %Y", data.timestamp)
			end

			ItemList[i] = {
				text = data.displayname,
				value = data.savename,

				hint = Trans(T{4274--[[Playtime : <playtime>--]],playtime = Trans(playtime)}) .. "\n"
					.. Trans(T{4273--[[Saved on : <save_date>--]],save_date = save_date}) .. "\n\n"
					.. S[302535920001274--[[This is permanent!--]]],
			}
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local value = choice[1].value

			if not choice[1].check1 then
				MsgPopup(
					S[302535920000038--[[Pick a checkbox next time...--]]],
					S[302535920000146--[[Delete Saved Games--]]]
				)
				return
			end
			local save_folder = GetPCSaveFolder()

			for i = 1, #choice do
				value = choice[i].value
				if type(value) == "string" then
					AsyncFileDelete(save_folder .. value)
				end
			end

			-- remove any saves we deleted
			local FileExists = ChoGGi.ComFuncs.FileExists
			local games_amt = #SavegamesList
			for i = #SavegamesList, 1, -1 do
				if not FileExists(save_folder .. SavegamesList[i].savename) then
					SavegamesList[i] = nil
					TableRemove(SavegamesList,i)
				end
			end

			games_amt = games_amt - #SavegamesList
			if games_amt > 0 then
				MsgPopup(
					S[302535920001275--[[Deleted %s saved games.--]]]:format(games_amt),
					S[302535920000146--[[Delete Saved Games--]]]
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = S[302535920000146--[[Delete Saved Games--]]] .. ": " .. #ItemList,
			hint = Trans(6779--[[Warning--]]) .. ": " .. S[302535920001274--[[This is permanent!--]]],
			multisel = true,
			skip_sort = true,
			check = {
				{
					title = Trans(1000009--[[Confirmation--]]),
					hint = S[302535920001276--[[Nothing is deleted unless you check this.--]]],
				},
			},
		}
	end

	function ChoGGi.MenuFuncs.DebugFX_Toggle(name,trans_id)
		_G[name] = not _G[name]

		MsgPopup(
			ChoGGi.ComFuncs.SettingState(tostring(_G[name]),trans_id),
			Trans(1000113--[[Debug--]])
		)
	end

	function ChoGGi.MenuFuncs.ParticlesReload()
		LoadStreamParticlesFromDir("Data/Particles")
		ParticlesReload("", true)
	end

	function ChoGGi.MenuFuncs.MeasureTool_Toggle()
		local MeasureTool = MeasureTool
		MeasureTool.Toggle()
		if MeasureTool.enabled then
			MeasureTool.OnMouseButtonDown(_,"L")
		else
			MeasureTool.OnMouseButtonDown(_,"R")
		end
	end

	function ChoGGi.MenuFuncs.ReloadLua()
		-- stop "Attempt to create a new global" in log
		local orig_Loading = Loading
		Loading = true
		force_load_build = true
		Loading = orig_Loading

		ReloadLua()
		force_load_build = false
		MsgPopup(
			S[302535920000453--[[Reload Lua--]]],
			Trans(1000113--[[Debug--]])
		)
	end

	function ChoGGi.MenuFuncs.DeleteAllSelectedObjects(obj)
		local ChoGGi = ChoGGi
		obj = obj or ChoGGi.ComFuncs.SelObject()

		-- domes with objs in them = crashy
		if IsKindOf(obj,"Dome") then
			return
		end

		local function CallBackFunc(answer)
			if not answer then
				return
			end
			SuspendPassEdits("DeleteAllSelectedObjects")
			MapDelete(true,obj.class)
			ResumePassEdits("DeleteAllSelectedObjects")
		end

		local count = MapCount("map",obj.class)
		ChoGGi.ComFuncs.QuestionBox(
			Trans(6779--[[Warning--]]) .. "!\n"
				.. S[302535920000852--[[This will delete all %s of %s--]]]:format(count,obj.class)
				.. "\n\n" .. S[302535920000854--[[Takes about thirty seconds for 12 000 objects.--]]],
			CallBackFunc,
			Trans(6779--[[Warning--]]) .. ": " .. S[302535920000855--[[Last chance before deletion!--]]],
			S[302535920000856--[[Yes, I want to delete all: %s--]]]:format(obj.class),
			S[302535920000857--[["No, I need to backup my save first (like I should've done before clicking something called ""Delete All"")."--]]]
		)
	end

	function ChoGGi.MenuFuncs.ObjectCloner(obj)
		obj = obj or ChoGGi.ComFuncs.SelObject()
		if not IsValid(obj) then
			return
		end

		-- clone dome = crashy
		local new
		if obj:IsKindOf("Dome") then
			new = g_Classes[obj.class]:new()
			new:CopyProperties(obj)
		else
			new = obj:Clone()
		end
		-- got me
		if obj:IsKindOf("Banner") then
			new:ChangeEntity(obj:GetEntity())
		end

		new:SetPos(ChoGGi.ComFuncs.CursorNearestHex())
		if type(new.CheatRefill) == "function" then
			new:CheatRefill()
		end
	end

	do -- debug_build_grid
		local IsValid = IsValid
		local grid_objs = {}
		local grid_thread = false
		local function HideGrid()
			local InvalidPos = ChoGGi.Consts.InvalidPos
			-- kill off thread
			DeleteThread(grid_thread)
			-- just in case
			grid_thread = false
			-- store hexes off-map
			for i = 1, #grid_objs do
				grid_objs[i]:SetPos(InvalidPos)
			end
		end

		-- if grid is left on when map changes it gets real laggy
		function OnMsg.ChangeMap()
			HideGrid()
		end

		function ChoGGi.MenuFuncs.debug_build_grid_settings(setting)
			local ChoGGi = ChoGGi
			local UserSettings = ChoGGi.UserSettings
			local ItemList = {
				{text = 10,value = 10},
				{text = 15,value = 15},
				{text = 25,value = 25},
				{text = 50,value = 50},
				{text = 75,value = 75},
				{text = 100,value = 100},
			}
			local name
			if setting == "DebugGridSize" then
				table.insert(ItemList,1,{text = 1,value = 1})
				ItemList[#ItemList+1] = {text = 125,value = 125}
				name = S[302535920001417--[[Follow Mouse Grid Size--]]]
			elseif setting == "DebugGridOpacity" then
				table.insert(ItemList,1,{text = 0,value = 0})
				name = S[302535920001419--[[Follow Mouse Grid Trans--]]]
			end

			local function CallBackFunc(choice)
				if choice.nothing_selected then
					return
				end

				local value = choice[1].value
				if type(value) == "number" then
					UserSettings[setting] = value

					if setting == "DebugGridOpacity" then
						for i = 1, #grid_objs do
							if IsValid(grid_objs[i]) then
								grid_objs[i]:SetOpacity(value)
							end
						end
					end

					-- update grid
					if grid_thread then
						ChoGGi.MenuFuncs.debug_build_grid()
						ChoGGi.MenuFuncs.debug_build_grid()
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
				items = ItemList,
				title = name,
			}
		end

		-- geysers mostly
		local HexSize = const.HexSize
		local MapGet = MapGet
		local skippers = {"DoesNotObstructConstruction","SurfaceDeposit","StoneSmall"}
		local function DontBuildHere(pt)
			local g_DontBuildHere = g_DontBuildHere
			return g_DontBuildHere and g_DontBuildHere:Check(pt)
		end
		local function IsRockOrDeposit(pt)
			local objs = MapGet(pt,HexSize,function(o)
				return o:IsKindOfClasses(skippers)
			end)
			if #objs > 0 then
				return true
			end
		end

		function ChoGGi.MenuFuncs.debug_build_grid()
			-- local all the globals we use more than once for some much needed speed
			--~ local IsSCell = terrain.IsSCell
			local IsPassable = terrain.IsPassable
			local IsTerrainFlatForPlacement = ConstructionController.IsTerrainFlatForPlacement
			local GetTerrainCursor = GetTerrainCursor
			local HexGridGetObject = HexGridGetObject
			local HexToWorld = HexToWorld
			local WorldToHex = WorldToHex
			local point = point
			local Sleep = Sleep

			local red = -65536
			local green = -16711936
			local yellow = -256
			local blue = -16776961
			local pt20t = {point20}
			local PlaceObject = PlaceObject
			local UserSettings = ChoGGi.UserSettings
			local grid_range = type(UserSettings.DebugGridSize) == "number" and UserSettings.DebugGridSize or 10
			local grid_opacity = type(UserSettings.DebugGridOpacity) == "number" and UserSettings.DebugGridOpacity or 15

			-- 125 = 47251 objects (had a crash at 250, and it's not like you need one that big)
			if grid_range > 125 then
				grid_range = 125
			end

			-- already running
			if grid_thread then
				HideGrid()
			else
				-- these two loop sections are just a way of building the table and applying the settings once instead of over n over in the while loop

				-- get the count of grid_range objects
				local grid_count = 0
				local q,r = 1,1
				local z = -q - r
				for q_i = q - grid_range, q + grid_range do
					for r_i = r - grid_range, r + grid_range do
						for z_i = z - grid_range, z + grid_range do
							if q_i + r_i + z_i == 0 then
								grid_count = grid_count + 1
							end
						end
					end
				end
				-- they can be deleted by ctrl-shift-d, so add any missing ones
				local obj_count = #grid_objs
				obj_count = obj_count >= grid_count and obj_count or grid_count >= obj_count and grid_count
				for i = 1, obj_count do
					if not IsValid(grid_objs[i]) then
						grid_objs[i] = PlaceObject("ChoGGi_OHexSpot")
						grid_objs[i]:SetOpacity(grid_opacity)
					end
				end

				-- fire up a new thread and off we go
				grid_thread = CreateRealTimeThread(function()
					local last_q, last_r
					while grid_thread do
						local ObjectGrid = ObjectGrid
						local q, r = WorldToHex(GetTerrainCursor())
						if last_q ~= q or last_r ~= r then
							local z = -q - r
							local idx = 0
							for q_i = q - grid_range, q + grid_range do
								for r_i = r - grid_range, r + grid_range do
									for z_i = z - grid_range, z + grid_range do
										if q_i + r_i + z_i == 0 then
											idx = idx + 1
											local c = grid_objs[idx]
											local pt = point(HexToWorld(q_i, r_i))
											c:SetPos(pt)

											-- green = pass/build, yellow = no pass/build, blue = pass/no build, red = no pass/no build
											if DontBuildHere(pt) then
												c:SetColorModifier(blue)
											elseif IsPassable(pt) then
												if IsTerrainFlatForPlacement(nil, pt20t, pt, 0) and not HexGridGetObject(ObjectGrid, q_i, r_i) then
													c:SetColorModifier(green)
												else
													c:SetColorModifier(blue)
												end
											elseif IsRockOrDeposit(pt) then
												c:SetColorModifier(yellow)
											else
												c:SetColorModifier(red)
											end

										end
									end
								end
							end
							last_q = q
							last_r = r
						else
							Sleep(5)
						end
						-- might as well make it smoother (and suck up some yummy cpu), i assume nobody is going to leave it on
						Sleep(10)
					end
				end) -- grid_thread
			end
		end
	end

	do -- path markers
		local IsObjlist = IsObjlist
		local Clamp = Clamp
		local point = point
		local PlaceObject = PlaceObject
		local CreateGameTimeThread = CreateGameTimeThread
		local terrain = terrain
		local GetHeight = terrain.GetHeight
		local RetAllOfClass = ChoGGi.ComFuncs.RetAllOfClass
		local SelObject = ChoGGi.ComFuncs.SelObject

		local moveable_classes = {"Movable", "CargoShuttle"}
		local randcolours = {}
		local colourcount = 0
		local dupewppos = {}
		-- default height of waypoints (maybe flag_height isn't the best name as no more flags)
		local flag_height = 50
		local mapw, maph

		local ShowWaypoints_points = {}
		local function ShowWaypoints(waypoints, colour, obj, skipheight)
			colour = tonumber(colour) or RandomColour()
			-- also used for line height
			if not skipheight then
				flag_height = flag_height + 4
			end
			local height = flag_height
			local obj_pos = obj:GetVisualPos()
			local obj_terr = GetHeight(obj_pos)
			local obj_height = obj:GetObjectBBox():sizez() / 2
			local shuttle
			if obj:IsKindOf("CargoShuttle") then
				shuttle = obj:GetZ()
			end
			-- some objects don't have pos as waypoint
			local cwp = #waypoints
			if waypoints[cwp] ~= obj_pos then
				waypoints[cwp+1] = obj_pos
			end

			-- build a list of points that aren't high in the sky
			TableClear(ShowWaypoints_points)
			local points = ShowWaypoints_points
			for i = 1, #waypoints do
				local x, y, z = waypoints[i]:xy()
				x = Clamp(x, 0, mapw)
				y = Clamp(y, 0, maph)
				-- shuttle z always puts it too high?
				z = GetHeight(x, y) + (shuttle and shuttle - obj_terr or obj_height) + height
				-- .holder being a building they're inside of
				if not shuttle and obj.holder and obj_pos:z() > obj_terr then
					z = obj_pos:z()
				end
				points[#points + 1] = point(x, y, z)
			end
			local last_pos = points[#points]
			-- and spawn the line
			local spawnline = PlaceObject("ChoGGi_OPolyline")
			spawnline:SetMesh(points, colour)
			spawnline:SetPos(last_pos)

			obj.ChoGGi_Stored_Waypoints[#obj.ChoGGi_Stored_Waypoints+1] = spawnline
		end -- end of ShowWaypoints

		local SetWaypoint_path = {}
		function ChoGGi.MenuFuncs.SetWaypoint(obj,setcolour,skipheight)
			TableClear(SetWaypoint_path)
			local path = SetWaypoint_path

			--we need to build a path for shuttles (and figure out a way to get their dest properly...)
			if obj:IsKindOf("CargoShuttle") then

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

				local c = #path

				-- the next four points it's going to after current_spline
				local list = obj.next_spline
				if list then
					-- :GetPath() has them backwards so we'll do the same
					for i = #list, 1, -1 do
						c = c + 1
						path[c] = list[i]
					end
				end

				-- the next four points it's going to
				list = obj.current_spline
				if list then
					for i = #list, 1, -1 do
						c = c + 1
						path[c] = list[i]
					end
				end
				c = c + 1
				path[c] = obj:GetPos()

			else
				-- rovers/drones/colonists
				if obj.GetPath then
					path = obj:GetPath()
				else
					ChoGGi.ComFuncs.OpenInExamineDlg(obj)
					print(Trans(6779--[[Warning--]]),":",S[302535920000869--[[This %s doesn't have GetPath function, something is probably borked.--]]]:format(RetName(obj)))
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
						colour = TableRemove(randcolours)
						-- table.remove(t) removes and returns the last value of the table
					end
				end

				if not IsObjlist(obj.ChoGGi_Stored_Waypoints) then
					obj.ChoGGi_Stored_Waypoints = objlist:new()
				end

				if not obj.ChoGGi_WaypointPathAdded then
					-- used to reset the colour later on
					obj.ChoGGi_WaypointPathAdded = obj:GetColorModifier()
				end
				-- colour it up
				obj:SetColorModifier(colour)
				-- send path off to make wp
				ShowWaypoints(
					path,
					colour,
					obj,
					skipheight
				)
			end
		end

		local function SetPathMarkersGameTime_Thread(obj,UnitPathingHandles)
			local colour = RandomColour()
			if not IsObjlist(obj.ChoGGi_Stored_Waypoints) then
				obj.ChoGGi_Stored_Waypoints = objlist:new()
			end

			repeat
				ChoGGi.MenuFuncs.SetWaypoint(obj,colour,true)
				Sleep(500)

				-- remove old wps
				local stored = obj.ChoGGi_Stored_Waypoints
				if IsObjlist(stored) then
					-- deletes all objs
					stored:Destroy()
					-- clears table list
					stored:Clear()
				end

				-- break thread when obj isn't valid
				if not IsValid(obj) then
					UnitPathingHandles[obj.handle] = nil
				end
			until not UnitPathingHandles[obj.handle]
		end

		function ChoGGi.MenuFuncs.SetPathMarkersGameTime(obj,single)
			local ChoGGi = ChoGGi
			obj = obj or SelObject()

			if obj and obj:IsKindOfClasses(moveable_classes) then
				local UnitPathingHandles = ChoGGi.Temp.UnitPathingHandles

				if UnitPathingHandles[obj.handle] then
					-- already exists so remove thread
					UnitPathingHandles[obj.handle] = nil
				elseif IsValid(obj) then
					-- continous loooop of object for pathing it
					UnitPathingHandles[obj.handle] = CreateGameTimeThread(SetPathMarkersGameTime_Thread,obj,UnitPathingHandles)
				end

			-- if user used "Ctrl-Numpad ." on an obj that can't path
			elseif single then
				MsgPopup(
					S[302535920000871--[[Doesn't seem to be an object that moves.--]]],
					S[302535920000872--[[Pathing--]]],
					nil,
					nil,
					obj
				)
			end
		end

		local function RemoveWPDupePos(cls,obj)
			-- remove dupe pos
			if IsObjlist(obj.ChoGGi_Stored_Waypoints) then
				for i = 1, #obj.ChoGGi_Stored_Waypoints do
					local wp = obj.ChoGGi_Stored_Waypoints[i]

--~ 					if wp:IsKindOf(cls) then
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

		local function ClearColourAndWP(cls)
			local ChoGGi = ChoGGi
			-- remove all thread refs so they stop
			TableClear(ChoGGi.Temp.UnitPathingHandles)
			-- and waypoints/colour
			local objs = RetAllOfClass(cls)
			for i = 1, #objs do
				local obj = objs[i]

				if obj.ChoGGi_WaypointPathAdded then
					obj:SetColorModifier(obj.ChoGGi_WaypointPathAdded)
					obj.ChoGGi_WaypointPathAdded = nil
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

		function ChoGGi.MenuFuncs.SetPathMarkersVisible()
			local ChoGGi = ChoGGi
			ChoGGi.Temp.UnitPathingHandles = ChoGGi.Temp.UnitPathingHandles or {}

			if not mapw then
				mapw, maph = terrain.GetMapSize()
				mapw = mapw - terrain.HeightTileSize()
				maph = maph - terrain.HeightTileSize()
			end

			local sel = SelectedObj
			if IsValid(sel) and sel:IsKindOfClasses(moveable_classes) then
				randcolours = RandomColour(#randcolours + 1)
				ChoGGi.MenuFuncs.SetWaypoint(sel)
				return
			end

			local ItemList = {
				{text = Trans(4493--[[All--]]),value = "All"},
				{text = Trans(547--[[Colonists--]]),value = "Colonist"},
				{text = Trans(517--[[Drones--]]),value = "Drone"},
				{text = Trans(5438--[[Rovers--]]),value = "BaseRover"},
				{text = Trans(745--[[Shuttles--]]),value = "CargoShuttle",hint = S[302535920000873--[[Doesn't work that well.--]]]},
			}
			local aliens
			if rawget(_G,"ChoGGi_Alien") then
				aliens = true
				ItemList[#ItemList+1] = {text = "Alien Visitors",value = "ChoGGi_Alien"}
			end

			local function CallBackFunc(choice)
				choice = choice[1]
				local remove = choice.check1
				if choice.nothing_selected and remove ~= true then
					return
				end
				local value = choice.value
				local labels = UICity.labels
				-- remove wp/lines and reset colours
				if remove then

					-- reset all the base colours/waypoints
					ClearColourAndWP("CargoShuttle")
					ClearColourAndWP("Unit")
					ClearColourAndWP("Colonist")
					if aliens then
						ClearColourAndWP("ChoGGi_Alien")
					end

					-- remove any extra lines
--~ 					MapDelete(true, "ChoGGi_OPolyline")
					ChoGGi.ComFuncs.RemoveObjs("ChoGGi_OPolyline")

					-- reset stuff
					flag_height = 50
					randcolours = {}
					colourcount = 0
					dupewppos = {}

				elseif value then -- add waypoints

					local function swp(list)
						if choice.check2 then
							for i = 1, #list do
								ChoGGi.MenuFuncs.SetPathMarkersGameTime(list[i])
							end
						else
							for i = 1, #list do
								ChoGGi.MenuFuncs.SetWaypoint(list[i])
							end
						end
					end

					if value == "All" then
						local table1 = MapFilter(labels.Unit or empty_table,IsValid)
						local table2 = MapFilter(labels.CargoShuttle or empty_table,IsValid)
						local table3 = MapFilter(labels.Colonist or empty_table,IsValid)
						colourcount = colourcount + #table1
						colourcount = colourcount + #table2
						colourcount = colourcount + #table3
						randcolours = RandomColour(colourcount + 1)
						swp(table1)
						swp(table2)
						swp(table3)
					else
						local table1 = MapGet(true,value,IsValid)
						colourcount = colourcount + #table1
						randcolours = RandomColour(colourcount + 1)
						swp(table1)
					end

					-- remove any waypoints in the same pos
					local function ClearAllDupeWP(cls)
						local objs = ChoGGi.ComFuncs.RetAllOfClass(cls)
						for i = 1, #objs do
							local obj = objs[i]
							if obj and obj.ChoGGi_Stored_Waypoints then
								RemoveWPDupePos("WayPoint",obj)
								RemoveWPDupePos("Sphere",obj)
							end
						end
					end
					ClearAllDupeWP("CargoShuttle")
					ClearAllDupeWP("Unit")
					ClearAllDupeWP("Colonist")

				end
			end

			ChoGGi.ComFuncs.OpenInListChoice{
				callback = CallBackFunc,
				items = ItemList,
				title = S[302535920000467--[[Path Markers--]]],
				check = {
					{
						title = S[302535920000876--[[Remove Waypoints--]]],
						hint = S[302535920000877--[[Remove waypoints from the map and reset colours (select any object type to remove them all).--]]],
					},
					{
						title = S[302535920001382--[[Real time--]]],
						hint = S[302535920000462--[[Maps paths in real time--]]],
						checked = true,
					},
				},
			}
		end
	end

	--little bit of painting
	--~ local terrain_type = "Grass_01"
	--~ local terrain_type_idx = table.find(TerrainTextures, "name", terrain_type)
	--~ CreateRealTimeThread(function()
	--~	 while true do
	--~		 terrain.SetTypeCircle(GetTerrainCursor(), 2500, terrain_type_idx)
	--~		 Sleep(5)
	--~	 end
	--~ end)

end
