-- See LICENSE for terms

function OnMsg.ClassesGenerate()

	local MsgPopup = ChoGGi.ComFuncs.MsgPopup
	local RetName = ChoGGi.ComFuncs.RetName
	local Trans = ChoGGi.ComFuncs.Translate
	local S = ChoGGi.Strings

	local pairs,print,type,tonumber,tostring,table = pairs,print,type,tonumber,tostring,table
	local StringFormat = string.format

	--~ local TerrainTextures = TerrainTextures

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
			if #choice < 1 then
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
				302535920001314--[[Toggle Render--]]
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920001314--[[Toggle Render--]],
			skip_sort = true,
			custom_type = 1,
			custom_func = CallBackFunc,
		}
	end

	function ChoGGi.MenuFuncs.DTMSlotsDlg_Toggle()
		if GetDialog("DTMSlotsDlg") then
			CloseDialog("DTMSlotsDlg")
		else
			OpenDialog("DTMSlotsDlg")
		end
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
			print(S[302535920000242--[[%s is blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have Über access.--]]]:format("DeleteSavedGames"))
			return
		end
		local SavegamesList = SavegamesList
		local ItemList = {}
		for i = 1, #SavegamesList do
			local data = SavegamesList[i]

			-- build played time
			local playtime = T{77, "Unknown"}
			if data.playtime then
				local h, m, _ = FormatElapsedTime(data.playtime, "hms")
				local hours = StringFormat("%02d", h)
				local minutes = StringFormat("%02d", m)
				playtime = Trans(T{7549, "<hours>:<minutes>", hours = hours, minutes = minutes})
			end
			-- and last saved
			local save_date = 0
			if data.timestamp then
				save_date = os.date("%H:%M - %d / %m / %Y", data.timestamp)
			end

			ItemList[i] = {
				text = data.displayname,
				value = data.savename,
				hint = StringFormat("%s\n%s\n\n%s",
					S[4274--[[Playtime : %s--]]]:format(playtime),
					S[4273--[[Saved on : %s--]]]:format(save_date),
					S[302535920001274--[[This is permanent!--]]]
				),
			}
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value

			if not choice[1].check1 then
				MsgPopup(
					302535920000038--[[Pick a checkbox next time...--]],
					302535920000146--[[Delete Saved Games--]]
				)
				return
			end
			local save_folder = GetPCSaveFolder()

			for i = 1, #choice do
				value = choice[i].value
				if type(value) == "string" then
					AsyncFileDelete(StringFormat("%s%s",save_folder,value))
				end
			end

			-- remove any saves we deleted
			local games_amt = #SavegamesList
			for i = #SavegamesList, 1, -1 do
				if not ChoGGi.ComFuncs.FileExists(StringFormat("%s%s",save_folder,SavegamesList[i].savename)) then
					SavegamesList[i] = nil
					table.remove(SavegamesList,i)
				end
			end

			games_amt = games_amt - #SavegamesList
			if games_amt > 0 then
				MsgPopup(
					S[302535920001275--[[Deleted %s saved games.--]]]:format(games_amt),
					302535920000146--[[Delete Saved Games--]]
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = StringFormat("%s: %s",S[302535920000146--[[Delete Saved Games--]]],#ItemList),
			hint = StringFormat("%s: %s",S[6779--[[Warning--]]],S[302535920001274--[[This is permanent!--]]]),
			multisel = true,
			skip_sort = true,
			check = {
				{
					title = 1000009--[[Confirmation--]],
					hint = 302535920001276--[[Nothing is deleted unless you check this.--]],
				},
			},
		}
	end

	do --export colonist data
		local ChoGGi_Tables = ChoGGi.Tables
		--build list of traits to skip (added as columns, we don't want dupes)
		local skipped_traits = {}
		local function AddSkipped(traits,list)
			for i = 1, #traits do
				list[traits[i]] = true
			end
			return list
		end
		skipped_traits = AddSkipped(ChoGGi_Tables.ColonistAges,skipped_traits)
		skipped_traits = AddSkipped(ChoGGi_Tables.ColonistGenders,skipped_traits)
		skipped_traits = AddSkipped(ChoGGi_Tables.ColonistSpecializations,skipped_traits)

		local ColonistsCSVColumns = {
			{"name",S[1000037--[[Name--]]]},
			{"age",S[302535920001222--[[Age--]]]},
			{"age_trait",StringFormat("%s %s",S[302535920001222--[[Age--]]],S[3720--[[Trait--]]])},
			{"death_age",S[4284--[[Age of death--]]]},
			{"birthplace",S[4357--[[Birthplace--]]]},
			{"gender",S[4356--[[Sex--]]]},
			{"race",S[302535920000741--[[Race--]]]},
			{"specialist",S[240--[[Specialization--]]]},
			{"performance",S[4283--[[Worker performance--]]]},
			{"health",S[4291--[[Health--]]]},
			{"comfort",S[4295--[[Comfort--]]]},
			{"morale",S[4297--[[Morale--]]]},
			{"sanity",S[4293--[[Sanity--]]]},
			{"handle",S[302535920000955--[[Handle--]]]},
			{"last_meal",S[302535920001229--[[Last Meal--]]]},
			{"last_rest",S[302535920001235--[[Last Rest--]]]},
			{"dome_name",StringFormat("%s %s",S[1234--[[Dome--]]],S[1000037--[[Name--]]])},
			{"dome_pos",StringFormat("%s %s",S[1234--[[Dome--]]],S[302535920001237--[[Position--]]])},
			{"dome_handle",StringFormat("%s %s",S[1234--[[Dome--]]],S[302535920000955--[[Handle--]]])},
			{"residence_name",StringFormat("%s %s",S[4809--[[Residence--]]],S[1000037--[[Name--]]])},
			{"residence_pos",StringFormat("%s %s",S[4809--[[Residence--]]],S[302535920001237--[[Position--]]])},
			{"residence_dome",StringFormat("%s %s",S[4809--[[Residence--]]],S[1234--[[Dome--]]])},
			{"workplace_name",StringFormat("%s %s",S[4801--[[Workplace--]]],S[1000037--[[Name--]]])},
			{"workplace_pos",StringFormat("%s %s",S[4801--[[Workplace--]]],S[302535920001237--[[Position--]]])},
			{"workplace_dome",StringFormat("%s %s",S[4801--[[Workplace--]]],S[1234--[[Dome--]]])},
		}
		local function AddTraits(traits,list)
			for i = 1, #traits do
				list[#list+1] = {
					StringFormat("trait_%s",traits[i]),
					StringFormat("Trait %s",traits[i]),
				}
			end
			return list
		end
		ColonistsCSVColumns = AddTraits(ChoGGi_Tables.NegativeTraits,ColonistsCSVColumns)
		ColonistsCSVColumns = AddTraits(ChoGGi_Tables.PositiveTraits,ColonistsCSVColumns)

		function ChoGGi.MenuFuncs.ExportColonistDataToCSV()
			local export_data = {}
			local colonists = UICity.labels.Colonist or ""

			for i = 1, #colonists do
				local c = colonists[i]

				export_data[i] = {
					name = StringFormat("%s %s",Trans(c.name[1]),Trans(c.name[3])),
					age = c.age,
					age_trait = c.age_trait,
					birthplace = c.birthplace,
					gender = c.gender,
					death_age = c.death_age,
					race = c.race,
					health = c.stat_health,
					comfort = c.stat_comfort,
					morale = c.stat_morale,
					sanity = c.stat_sanity,
					performance = c.performance,
					handle = c.handle,
					specialist = c.specialist,
					last_meal = c.last_meal,
					last_rest = c.last_rest,
				}
				-- dome
				if c.dome then
					export_data[i].dome_name = RetName(c.dome)
					export_data[i].dome_pos = c.dome:GetVisualPos()
					export_data[i].dome_handle = c.dome.handle
				end
				-- residence
				if c.residence then
					export_data[i].residence_name = RetName(c.residence)
					export_data[i].residence_pos = c.residence:GetVisualPos()
					export_data[i].residence_dome = RetName(c.residence.parent_dome)
				end
				-- workplace
				if c.workplace then
					export_data[i].workplace_name = RetName(c.workplace)
					export_data[i].workplace_pos = c.workplace:GetVisualPos()
					export_data[i].workplace_dome = RetName(c.workplace.parent_dome)
				end
				-- traits
				for trait_id, _ in pairs(c.traits) do
					if trait_id and trait_id ~= "" and not skipped_traits[trait_id] then
						export_data[i][StringFormat("trait_%s",trait_id)] = true
					end
				end
			end
			-- and now we can save it to disk
			SaveCSV("AppData/Colonists.csv", export_data, table.map(ColonistsCSVColumns, 1), table.map(ColonistsCSVColumns, 2))
		end
	end

	function ChoGGi.MenuFuncs.DebugFX_Toggle(name,trans_id)
		_G[name] = not _G[name]

		MsgPopup(
			ChoGGi.ComFuncs.SettingState(tostring(_G[name]),trans_id),
			1000113--[[Debug--]]
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
		force_load_build = true
		ReloadLua()
		force_load_build = false
		MsgPopup(
			302535920000453--[[Reload Lua--]],
			1000113--[[Debug--]]
		)
	end

	function ChoGGi.MenuFuncs.DeleteAllSelectedObjects(obj)
		local ChoGGi = ChoGGi
		obj = obj or ChoGGi.ComFuncs.SelObject()

		-- domes with shit in them = crashy
		if IsKindOf(obj,"Dome") then
			return
		end

		local function CallBackFunc(answer)
			if answer then
				SuspendPassEdits("DeleteAllSelectedObjects")
				MapDelete("map",obj.class)
				ResumePassEdits("DeleteAllSelectedObjects")
			end
		end

		local count = MapCount("map",obj.class)
		ChoGGi.ComFuncs.QuestionBox(
			StringFormat("%s!\n%s\n\n%s",S[6779--[[Warning--]]],S[302535920000852--[[This will delete all %s of %s--]]]:format(count,obj.class),S[302535920000854--[[Takes about thirty seconds for 12 000 objects.--]]]),
			CallBackFunc,
			StringFormat("%s: %s",S[6779--[[Warning--]]],S[302535920000855--[[Last chance before deletion!--]]]),
			S[302535920000856--[[Yes, I want to delete all: %s--]]]:format(obj.class),
			302535920000857--[["No, I need to backup my save first (like I should've done before clicking something called ""Delete All"")."--]]
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
		new:SetPos(ChoGGi.ComFuncs.CursorNearestHex())
		if type(new.CheatRefill) == "function" then
			new:CheatRefill()
		end
	end

	function ChoGGi.MenuFuncs.SetAnimState(sel)
		local ChoGGi = ChoGGi
		sel = sel or ChoGGi.ComFuncs.SelObject()
		if not sel then
			return
		end

		local ItemList = {}

		for id,state in pairs(sel:GetStates() or {}) do
			ItemList[#ItemList+1] = {
				text = StringFormat("%s: %s %s: %s",S[1000037--[[Name--]]],state,S[302535920000858--[[Index--]]],id),
				value = state,
			}
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end

			local value = choice[1].value
			sel:SetStateText(value)
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice[1].text,3722--[[State--]]),
				302535920000859--[[Anim State--]]
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000860--[[Set Anim State--]],
			hint = S[302535920000861--[[Current State: %s--]]]:format(sel:GetState()),
			custom_type = 7,
			custom_func = CallBackFunc,
		}
	end

	do -- debug_build_grid
		local grid_objs = {}
		local grid_thread = false
		local function HideGrid()
			-- kill off thread
			DeleteThread(grid_thread)
			-- just in case
			grid_thread = false
			-- we hide hexes instead of deleting them
			for i = 1, #grid_objs do
				grid_objs[i]:SetVisible()
			end
		end
		-- if grid is left on when map changes it gets real laggy
		function OnMsg.ChangeMap()
			HideGrid()
		end

		-- geysers mostly
		local HexSize = const.HexSize
		local MapGet = MapGet
		local function DontBuildHere(pt)
			local g_DontBuildHere = g_DontBuildHere
			return g_DontBuildHere and g_DontBuildHere:Check(pt)
		end
		local function IsRockOrDeposit(pt)
			local objs = MapGet(pt,HexSize,function(o)
				return o:IsKindOfClasses("DoesNotObstructConstruction","SurfaceDeposit","StoneSmall")
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
			local IsValid = IsValid
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
			local ChoGGi_HexSpot = ChoGGi_HexSpot
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
						grid_objs[i] = ChoGGi_HexSpot:new()
						grid_objs[i]:SetOpacity(grid_opacity)
					end
					-- turning off the grid is just stopping thread and making hexes invis, so we restore vis here
					grid_objs[i]:SetVisible(true)
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

	do --path markers
		local randcolours = {}
		local colourcount = 0
		local dupewppos = {}
		--default height of waypoints (maybe flag_height isn't the best name as no more flags)
		local flag_height = 50
		local terrain_HeightTileSize = terrain.HeightTileSize()

		local function ShowWaypoints(waypoints, colour, obj, skipheight)
			colour = tonumber(colour) or ChoGGi.ComFuncs.RandomColour()
			--also used for line height
			if not skipheight then
				flag_height = flag_height + 4
			end
			local height = flag_height
			local Objpos = obj:GetVisualPos()
			local Objterr = terrain.GetHeight(Objpos)
			local Objheight = obj:GetObjectBBox():sizez() / 2
			local shuttle
			if obj:IsKindOf("CargoShuttle") then
				shuttle = obj:GetPos():z()
			end
			--some objects don't have pos as waypoint
			local cwp = #waypoints
			if waypoints[cwp] ~= Objpos then
				waypoints[cwp+1] = Objpos
			end

			--build a list of points that aren't high in the sky
			local points = {}
			local mapw, maph = terrain.GetMapSize()
			for i = 1, #waypoints do
				local x, y, z = waypoints[i]:xy()
				x = Clamp(x, 0, mapw - terrain_HeightTileSize)
				y = Clamp(y, 0, maph - terrain_HeightTileSize)
				z = terrain.GetHeight(x, y) + (shuttle and shuttle - Objterr or Objheight) + height --shuttle z always puts it too high?
				points[#points + 1] = point(x, y, z)
			end
			local last_pos = points[#points]
			--and spawn the line
			local spawnline = ChoGGi_Polyline:new{max_vertices = #waypoints}
			spawnline:SetMesh(points, colour)
			spawnline:SetPos(last_pos)

			obj.ChoGGi_Stored_Waypoints[#obj.ChoGGi_Stored_Waypoints+1] = spawnline
		end --end of ShowWaypoints

		function ChoGGi.MenuFuncs.SetWaypoint(obj,setcolour,skipheight)
			local path

			--we need to build a path for shuttles (and figure out a way to get their dest properly...)
			if obj:IsKindOf("CargoShuttle") then

				path = {}
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
					print(S[6779--[[Warning--]]],": ",S[302535920000869--[[This %s doesn't have GetPath function, something is probably borked.--]]]:format(RetName(obj)))
				end
			end

			-- we have a path so add some colours, and build the waypoints
			if path then
				local colour
				if setcolour then
					colour = setcolour
				else
					local randomcolour = ChoGGi.ComFuncs.RandomColour()
					if #randcolours < 1 then
						colour = randomcolour
					else
						--we want to make sure all grouped waypoints are a different colour (or at least slightly diff)
						colour = table.remove(randcolours)
					end
				end

				if type(obj.ChoGGi_Stored_Waypoints) ~= "table" then
					obj.ChoGGi_Stored_Waypoints = {}
				end

				if not obj.ChoGGi_WaypointPathAdded then
					--used to reset the colour later on
					obj.ChoGGi_WaypointPathAdded = obj:GetColorModifier()
				end
				--colour it up
				obj:SetColorModifier(colour)
				--send path off to make wp
				ShowWaypoints(
					path,
					colour,
					obj,
					skipheight
				)
			end
		end

		function ChoGGi.MenuFuncs.SetPathMarkersGameTime(obj,single)
			local ChoGGi = ChoGGi
			obj = obj or ChoGGi.ComFuncs.SelObject()

			if obj and obj:IsKindOfClasses("Movable", "CargoShuttle") then
				if not ChoGGi.Temp.UnitPathingHandles then
					ChoGGi.Temp.UnitPathingHandles = {}
				end

				if ChoGGi.Temp.UnitPathingHandles[obj.handle] then
					--already exists so remove thread
					ChoGGi.Temp.UnitPathingHandles[obj.handle] = nil
				elseif IsValid(obj) and (obj.GetPath or obj:IsKindOf("CargoShuttle")) then

					--continous loooop of object for pathing it
					ChoGGi.Temp.UnitPathingHandles[obj.handle] = CreateGameTimeThread(function()
						local colour = ChoGGi.ComFuncs.RandomColour()
						if type(obj.ChoGGi_Stored_Waypoints) ~= "table" then
							obj.ChoGGi_Stored_Waypoints = {}
						end

						local sleepidx = 0
						repeat
							--shuttles don't have paths
							if obj.class ~= "CargoShuttle" and not obj:GetPath() then
								Sleep(500)
								sleepidx = sleepidx + 1
								if sleepidx == 250 then
									DeleteThread(ChoGGi.Temp.UnitPathingHandles[obj.handle])
								end
							end
							sleepidx = 0

							ChoGGi.MenuFuncs.SetWaypoint(obj,colour,true)
							Sleep(750)

							-- remove old wps
							if type(obj.ChoGGi_Stored_Waypoints) == "table" then
								for i = #obj.ChoGGi_Stored_Waypoints, 1, -1 do
									obj.ChoGGi_Stored_Waypoints[i]:delete()
								end
							end
							obj.ChoGGi_Stored_Waypoints = {}

							--break thread when obj isn't valid
							if not IsValid(obj) or not obj:IsValidPos() then
								ChoGGi.Temp.UnitPathingHandles[obj.handle] = nil
							end
						until not ChoGGi.Temp.UnitPathingHandles[obj.handle]
					end)

				end
			elseif single then
				MsgPopup(
					302535920000871--[[Doesn't seem to be an object that moves.--]],
					302535920000872--[[Pathing--]],
					nil,
					nil,
					obj
				)
			end
		end

		local function RemoveWPDupePos(cls,obj)
			--remove dupe pos
			if type(obj.ChoGGi_Stored_Waypoints) == "table" then
				for i = 1, #obj.ChoGGi_Stored_Waypoints do
					local wp = obj.ChoGGi_Stored_Waypoints[i]
					if wp:IsKindOf(cls) then
						local pos = tostring(wp:GetPos())
						if dupewppos[pos] then
							dupewppos[pos]:SetColorModifier(6579300)
							wp:delete()
						else
							dupewppos[pos] = obj.ChoGGi_Stored_Waypoints[i]
						end
					end
				end
				--remove removed
				for i = #obj.ChoGGi_Stored_Waypoints, 1, -1 do
					if not IsValid(obj.ChoGGi_Stored_Waypoints[i]) then
						table.remove(obj.ChoGGi_Stored_Waypoints,i)
					end
				end
			end
		end

		local function ClearColourAndWP(cls)
			local ChoGGi = ChoGGi
			--remove all thread refs so they stop
			ChoGGi.Temp.UnitPathingHandles = {}
			--and waypoints/colour
			local objs = UICity.labels[cls] or ""
			for i = 1, #objs do

				if objs[i].ChoGGi_WaypointPathAdded then
					objs[i]:SetColorModifier(objs[i].ChoGGi_WaypointPathAdded)
					objs[i].ChoGGi_WaypointPathAdded = nil
				end

				if type(objs[i].ChoGGi_Stored_Waypoints) == "table" then
					for j = #objs[i].ChoGGi_Stored_Waypoints, 1, -1 do
						objs[i].ChoGGi_Stored_Waypoints[j]:delete()
					end
					objs[i].ChoGGi_Stored_Waypoints = nil
				end

			end
		end

		function ChoGGi.MenuFuncs.SetPathMarkersVisible()
			local ChoGGi = ChoGGi
			local sel = SelectedObj
			if sel then
				randcolours = ChoGGi.ComFuncs.RandomColour(#randcolours + 1)
				ChoGGi.MenuFuncs.SetWaypoint(sel)
				return
			end

			local ItemList = {
				{text = S[4493--[[All--]]],value = "All"},
				{text = S[547--[[Colonists--]]],value = "Colonist"},
				{text = S[517--[[Drones--]]],value = "Drone"},
				{text = S[5438--[[Rovers--]]],value = "BaseRover"},
				{text = S[745--[[Shuttles--]]],value = "CargoShuttle",hint = 302535920000873--[[Doesn't work that well.--]]},
			}

			local function CallBackFunc(choice)
				if #choice < 1 then
					return
				end
				local value = choice[1].value
				local UICity = UICity
				-- remove wp/lines and reset colours
				if choice[1].check1 then

					-- reset all the base colours/waypoints
					ClearColourAndWP("CargoShuttle")
					ClearColourAndWP("Unit")
					ClearColourAndWP("Colonist")

					-- remove any extra lines
					MapDelete("map", "ChoGGi_Polyline")

					-- reset stuff
					flag_height = 50
					randcolours = {}
					colourcount = 0
					dupewppos = {}

				elseif value then -- add waypoints

					local function swp(list)
						if choice[1].check2 then
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
						local table1 = ChoGGi.ComFuncs.FilterFromTableFunc(UICity.labels.Unit,"IsValid",nil,true)
						local table2 = ChoGGi.ComFuncs.FilterFromTableFunc(UICity.labels.CargoShuttle,"IsValid",nil,true)
						local table3 = ChoGGi.ComFuncs.FilterFromTableFunc(UICity.labels.Colonist,"IsValid",nil,true)
						colourcount = colourcount + #table1
						colourcount = colourcount + #table2
						colourcount = colourcount + #table3
						randcolours = ChoGGi.ComFuncs.RandomColour(colourcount + 1)
						swp(table1)
						swp(table2)
						swp(table3)
					else
						local table1 = GetObjects{
							area = "map",
							class = value,
							filter = function(o)
								if IsValid(o) then
									return o
								end
							end,
						}
						colourcount = colourcount + #table1
						randcolours = ChoGGi.ComFuncs.RandomColour(colourcount + 1)
						swp(table1)
					end

					--remove any waypoints in the same pos
					local function ClearAllDupeWP(cls)
						local objs = UICity.labels[cls] or ""
						for i = 1, #objs do
							if objs[i] and objs[i].ChoGGi_Stored_Waypoints then
								RemoveWPDupePos("WayPoint",objs[i])
								RemoveWPDupePos("Sphere",objs[i])
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
				title = 302535920000467--[[Path Markers--]],
				check = {
					{
						title = 302535920000876--[[Remove Waypoints--]],
						hint = 302535920000877--[[Remove waypoints from the map and reset colours (select any object type to remove them all).--]],
					},
					{
						title = 302535920001382--[[Real time--]],
						hint = StringFormat("%s.",S[302535920000462--[[Maps paths in real time--]]]),
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
