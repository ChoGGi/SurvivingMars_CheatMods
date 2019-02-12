-- See LICENSE for terms

local TableFind = table.find
local TableClear = table.clear
local TableIClear = table.iclear
local type,pairs,next = type,pairs,next
local PropObjGetProperty = PropObjGetProperty
local Sleep = Sleep
local IsValid = IsValid
local IsValidEntity = IsValidEntity
local CreateRealTimeThread = CreateRealTimeThread

local getinfo,getlocal,getupvalue,gethook
local debug = PropObjGetProperty(_G,"debug")
if debug then
	getinfo = debug.getinfo
	getlocal = debug.getlocal
	getupvalue = debug.getupvalue
	gethook = debug.gethook
end

function OnMsg.ClassesGenerate()
	local S = ChoGGi.Strings
	local blacklist = ChoGGi.blacklist
	local MsgPopup = ChoGGi.ComFuncs.MsgPopup
	local RetName = ChoGGi.ComFuncs.RetName
	local Trans = ChoGGi.ComFuncs.Translate
	local TableConcat = ChoGGi.ComFuncs.TableConcat

	do -- AddGridHandles
		local function AddHandles(grid)
			for i = 1, #grid do
				grid[i].ChoGGi_GridHandle = i
			end
		end

		function ChoGGi.ComFuncs.UpdateGridHandles()
			local UICity = UICity
			AddHandles(UICity.air)
			AddHandles(UICity.electricity)
			AddHandles(UICity.water)
		end
	end -- do

	function ChoGGi.ComFuncs.DraggableCheatsMenu(which)
		local XShortcutsTarget = XShortcutsTarget

		if which then
			-- add a bit of spacing above menu
			XShortcutsTarget.idMenuBar:SetPadding(box(0, 6, 0, 0))

			-- add move control to menu
			XShortcutsTarget.idMoveControl = g_Classes.XMoveControl:new({
				Id = "idMoveControl",
				MinHeight = 6,
				VAlign = "top",
			}, XShortcutsTarget)

			-- move the move control to the padding space we created above
			DelayedCall(1, function()
				-- needs a delay (cause we added the control?)
				local height = XShortcutsTarget.idToolbar.box:maxy() * -1
				XShortcutsTarget.idMoveControl:SetMargins(box(0,height,0,0))
			end)
		elseif XShortcutsTarget.idMoveControl then
			-- remove my control and padding
			XShortcutsTarget.idMoveControl:delete()
			XShortcutsTarget.idMenuBar:SetPadding(box(0, 0, 0, 0))
			-- restore to original pos by toggling menu vis
			if ChoGGi.UserSettings.ShowCheatsMenu then
				ChoGGi.ComFuncs.CheatsMenu_Toggle()
				ChoGGi.ComFuncs.CheatsMenu_Toggle()
			end
		end
	end

	function ChoGGi.ComFuncs.SetCommanderBonuses(name)
		local comm = table.find_value(MissionParams.idCommanderProfile.items,"id",g_CurrentMissionParams.idCommanderProfile)
		if not comm then
			return
		end

		local list = Presets.CommanderProfilePreset.Default[name] or ""
		local c = #comm
		for i = 1, #list do
			-- i forgot why i had this in a thread...
			CreateRealTimeThread(function()
				c = c + 1
				comm[c] = list[i]
			end)
		end
	end

	function ChoGGi.ComFuncs.SetSponsorBonuses(name)
		local ChoGGi = ChoGGi

		local sponsor = table.find_value(MissionParams.idMissionSponsor.items,"id",g_CurrentMissionParams.idMissionSponsor)
		if not sponsor then
			return
		end

		local bonus = Presets.MissionSponsorPreset.Default[name]
		-- bonuses multiple sponsors have (CompareAmounts returns equal or larger amount)
		if sponsor.cargo then
			sponsor.cargo = ChoGGi.ComFuncs.CompareAmounts(sponsor.cargo,bonus.cargo)
		end
		if sponsor.additional_research_points then
			sponsor.additional_research_points = ChoGGi.ComFuncs.CompareAmounts(sponsor.additional_research_points,bonus.additional_research_points)
		end

		local c = #sponsor
		if name == "IMM" then
			c = c + 1
			sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
				"Label","Consts",
				"Prop","FoodPerRocketPassenger",
				"Amount",9000
			})
		elseif name == "NASA" then
			c = c + 1
			sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
				"Label","Consts",
				"Prop","SponsorFundingPerInterval",
				"Amount",500
			})
		elseif name == "BlueSun" then
			sponsor.rocket_price = ChoGGi.ComFuncs.CompareAmounts(sponsor.rocket_price,bonus.rocket_price)
			sponsor.applicants_price = ChoGGi.ComFuncs.CompareAmounts(sponsor.applicants_price,bonus.applicants_price)
			c = c + 1
			sponsor[c] = PlaceObj("TechEffect_GrantTech",{
				"Field","Physics",
				"Research","DeepMetalExtraction"
			})
		elseif name == "CNSA" then
			c = c + 1
			sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
				"Label","Consts",
				"Prop","ApplicantGenerationInterval",
				"Percent",-50
			})
			c = c + 1
			sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
				"Label","Consts",
				"Prop","MaxColonistsPerRocket",
				"Amount",10
			})
		elseif name == "ISRO" then
			c = c + 1
			sponsor[c] = PlaceObj("TechEffect_GrantTech",{
				"Field","Engineering",
				"Research","LowGEngineering"
			})
			c = c + 1
			sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
				"Label","Consts",
				"Prop","Concrete_cost_modifier",
				"Percent",-20
			})
			c = c + 1
			sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
				"Label","Consts",
				"Prop","Electronics_cost_modifier",
				"Percent",-20
			})
			c = c + 1
			sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
				"Label","Consts",
				"Prop","MachineParts_cost_modifier",
				"Percent",-20
			})
			c = c + 1
			sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
				"Label","Consts",
				"Prop","ApplicantsPoolStartingSize",
				"Percent",50
			})
			c = c + 1
			sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
				"Label","Consts",
				"Prop","Metals_cost_modifier",
				"Percent",-20
			})
			c = c + 1
			sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
				"Label","Consts",
				"Prop","Polymers_cost_modifier",
				"Percent",-20
			})
			c = c + 1
			sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
				"Label","Consts",
				"Prop","PreciousMetals_cost_modifier",
				"Percent",-20
			})
		elseif name == "ESA" then
			sponsor.funding_per_tech = ChoGGi.ComFuncs.CompareAmounts(sponsor.funding_per_tech,bonus.funding_per_tech)
			sponsor.funding_per_breakthrough = ChoGGi.ComFuncs.CompareAmounts(sponsor.funding_per_breakthrough,bonus.funding_per_breakthrough)
		elseif name == "SpaceY" then
			sponsor.modifier_name1 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_name1,bonus.modifier_name1)
			sponsor.modifier_value1 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_value1,bonus.modifier_value1)
			sponsor.modifier_name2 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_name2,bonus.bonusmodifier_name2)
			sponsor.modifier_value2 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_value2,bonus.modifier_value2)
			sponsor.modifier_name3 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_name3,bonus.modifier_name3)
			sponsor.modifier_value3 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_value3,bonus.modifier_value3)
			c = c + 1
			sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
				"Label","Consts",
				"Prop","CommandCenterMaxDrones",
				"Percent",20
			})
			c = c + 1
			sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
				"Label","Consts",
				"Prop","starting_drones",
				"Percent",4
			})
		elseif name == "NewArk" then
			c = c + 1
			sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
				"Label","Consts",
				"Prop","BirthThreshold",
				"Percent",-50
			})
		elseif name == "Roscosmos" then
			sponsor.modifier_name1 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_name1,bonus.modifier_name1)
			sponsor.modifier_value1 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_value1,bonus.modifier_value1)
			c = c + 1
			sponsor[c] = PlaceObj("TechEffect_GrantTech",{
				"Field","Robotics",
				"Research","FueledExtractors"
			})
		elseif name == "Paradox" then
			sponsor.applicants_per_breakthrough = ChoGGi.ComFuncs.CompareAmounts(sponsor.applicants_per_breakthrough,bonus.applicants_per_breakthrough)
			sponsor.anomaly_bonus_breakthrough = ChoGGi.ComFuncs.CompareAmounts(sponsor.anomaly_bonus_breakthrough,bonus.anomaly_bonus_breakthrough)
		end
	end

	do -- flightgrids
		local Flight_DbgLines = {}
		local Flight_DbgLines_c = 0
		local type_tile = terrain.TypeTileSize()
		local work_step = 16 * type_tile
		local dbg_step = work_step / 4 -- 400
		local PlacePolyline = PlacePolyline
		local MulDivRound = MulDivRound
		local InterpolateRGB = InterpolateRGB
		local Clamp = Clamp
		local AveragePoint2D = AveragePoint2D
		local terrain_GetHeight = terrain.GetHeight

		local function Flight_DbgRasterLine(pos1, pos0, zoffset)
			pos1 = pos1 or GetTerrainCursor()
			pos0 = pos0 or FindPassable(GetTerrainCursor())
			zoffset = zoffset or 0
			if not pos0 or not Flight_Height then
				return
			end
			local diff = pos1 - pos0
			local dist = diff:Len2D()
			local steps = 1 + (dist + dbg_step - 1) / dbg_step
			local points,colors,pointsc,colorsc = {},{},0,0
			local max_diff = 10 * guim
			for i = 1,steps do
				local pos = pos0 + MulDivRound(pos1 - pos0, i - 1, steps - 1)
				local height = Flight_Height:GetBilinear(pos, work_step, 0, 1) + zoffset
				pointsc = pointsc + 1
				colorsc = colorsc + 1
				points[pointsc] = pos:SetZ(height)
				colors[colorsc] = InterpolateRGB(
					-1, -- white
					-16711936, -- green
					Clamp(height - zoffset - terrain_GetHeight(pos), 0, max_diff),
					max_diff
				)
			end
			local line = PlacePolyline(points, colors)
			line:SetPos(AveragePoint2D(points))
			Flight_DbgLines_c = Flight_DbgLines_c + 1
			Flight_DbgLines[Flight_DbgLines_c] = line
		end

		local function Flight_DbgClear()
			SuspendPassEdits("ChoGGi_Flight_DbgClear")
			for i = 1, #Flight_DbgLines do
				Flight_DbgLines[i]:delete()
			end
			ResumePassEdits("ChoGGi_Flight_DbgClear")
			table.iclear(Flight_DbgLines)
			Flight_DbgLines_c = 0
		end

		local grid_thread
		function ChoGGi.ComFuncs.FlightGrid_Update(size,zoffset)
			if grid_thread then
				DeleteThread(grid_thread)
				grid_thread = nil
				Flight_DbgClear()
			end
			ChoGGi.ComFuncs.FlightGrid_Toggle(size,zoffset)
		end
		function ChoGGi.ComFuncs.FlightGrid_Toggle(size,zoffset)
			if grid_thread then
				DeleteThread(grid_thread)
				grid_thread = nil
				Flight_DbgClear()
				return
			end
			grid_thread = CreateMapRealTimeThread(function()
				local Sleep = Sleep
				local orig_size = size or 256 * guim
				local pos_c,pos_t,pos
				while true do
					pos_t = GetTerrainCursor()
					if pos_c ~= pos_t then
						pos_c = pos_t
						pos = pos_t
						Flight_DbgClear()
						-- Flight_DbgRasterArea
						size = orig_size
						local steps = 1 + (size + dbg_step - 1) / dbg_step
						size = steps * dbg_step
						pos = pos - point(size, size) / 2
						for y = 0,steps do
							Flight_DbgRasterLine(pos + point(0, y*dbg_step), pos + point(size, y*dbg_step), zoffset)
						end
						for x = 0,steps do
							Flight_DbgRasterLine(pos + point(x*dbg_step, 0), pos + point(x*dbg_step, size), zoffset)
						end

						Sleep(10)
					end
					Sleep(50)
				end
			end)
		end
	end -- do

	function ChoGGi.ComFuncs.GenerateScreenshotFilename(prefix, folder, ext, just_name)
		local match = string.match
		local Max = Max

		prefix = prefix or ""
		ext = ext or "png"
		folder = folder or "AppData/"
		if not match(folder, "/$") and #folder > 0 then
			folder = folder .. "/"
		end
		local existing_files = io.listfiles(folder, prefix .. "*." .. ext)
		local index = 0
		for i = 1, #existing_files do
			index = Max(index, tonumber(match(existing_files[i], prefix .. "(%d+)" or 0)))
		end
		if just_name then
			return string.format("%s%04d", prefix, index + 1)
		end
		return string.format("%s%s%04d.%s", folder, prefix, index + 1, ext)
	end
	local GenerateScreenshotFilename = ChoGGi.ComFuncs.GenerateScreenshotFilename

	function ChoGGi.ComFuncs.Dump(obj,mode,file,ext,skip_msg,gen_name)
		if blacklist then
			print(S[302535920000242--[[%s is blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have Über access.--]]]:format("ChoGGi.ComFuncs.Dump"))
			return
		end

--~ 		if mode == "w" or mode == "w+" then
		if mode then
			mode = nil
		else
			mode = "-1"
		end

		local filename
		if gen_name then
			filename = GenerateScreenshotFilename(file or "DumpedText","AppData/logs/",ext or "txt")
		else
			filename = "AppData/logs/" .. (file or "DumpedText") .. "." .. (ext or "txt")
		end

		ThreadLockKey(filename)
		AsyncStringToFile(filename,obj,mode)
		ThreadUnlockKey(filename)

		-- let user know
		if not skip_msg then
			MsgPopup(
				S[302535920000002--[[Dumped: %s--]]]:format(RetName(obj)),
				filename,
				"UI/Icons/Upgrades/magnetic_filtering_04.tga",
				nil,
				obj
			)
		end
	end

	function ChoGGi.ComFuncs.DumpLua(obj)
		ChoGGi.ComFuncs.Dump(ChoGGi.newline .. ValueToLuaCode(obj),nil,"DumpedLua","lua")
	end

	do -- DumpTableFunc
		local output_string
		local function RetTextForDump(obj,funcs)
			local obj_type = type(obj)
			if obj_type == "userdata" then
				return Trans(obj)
			elseif funcs and obj_type == "function" then
				local n = ChoGGi.newline
				return "Func: " .. n .. n .. obj:dump() .. n .. n
			elseif obj_type == "table" then
				return tostring(obj) .. " len: " .. #obj
			else
				return tostring(obj)
			end
		end

		local function DumpTableFunc(obj,hierarchyLevel,funcs)
			if (hierarchyLevel == nil) then
				hierarchyLevel = 0
			elseif (hierarchyLevel == 4) then
				return 0
			end

			if type(obj) == "table" then
				if obj.id then
					output_string = output_string .. "\n-----------------obj.id: " .. obj.id .. " :"
				end
				for k,v in pairs(obj) do
					if type(v) == "table" then
						DumpTableFunc(v, hierarchyLevel+1)
					else
						if k ~= nil then
							output_string = output_string .. "\n" .. k .. " = "
						end
						if v ~= nil then
							output_string = output_string .. RetTextForDump(v,funcs)
						end
						output_string = output_string .. "\n"
					end
				end
			end
		end

		--[[
		Mode = -1 to append or nil to overwrite (default: -1)
		Funcs = true to dump functions as well (default: false)
		ChoGGi.ComFuncs.DumpTable(Object)
		--]]
		function ChoGGi.ComFuncs.DumpTable(obj,mode,funcs)
			if blacklist then
				print(S[302535920000242--[[%s is blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have Über access.--]]]:format("ChoGGi.ComFuncs.DumpTable"))
				return
			end
			if not obj then
				MsgPopup(
					302535920000003--[[Can't dump nothing--]],
					302535920000004--[[Dump--]]
				)
				return
			end
			mode = mode or "-1"
			-- make sure it's empty
			output_string = ""
			DumpTableFunc(obj,nil,funcs)
			AsyncStringToFile("AppData/logs/DumpedTable.txt",output_string,mode)

			MsgPopup(
				S[302535920000002--[[Dumped: %s--]]]:format(RetName(obj)),
				"AppData/logs/DumpedText.txt",
				nil,
				nil,
				obj
			)
		end
	end --do

	-- write logs funcs
	do -- WriteLogs_Toggle
		local Dump = ChoGGi.ComFuncs.Dump
		local tostring = tostring
		local newline = ChoGGi.newline
		local SaveOrigFunc = ChoGGi.ComFuncs.SaveOrigFunc
		SaveOrigFunc("DebugPrintNL")
		SaveOrigFunc("OutputDebugString")
		SaveOrigFunc("AddConsoleLog") -- also does print()
		SaveOrigFunc("assert")
		SaveOrigFunc("printf")
		SaveOrigFunc("error")
		local ChoGGi_OrigFuncs = ChoGGi.OrigFuncs

		-- every 5s check buffer and print if anything
		local timer = ChoGGi.testing and 2500 or 5000
		-- we always start off with a newline so the first line or so isn't merged
		local buffer_table = {newline}
		local buffer_cnt = 1

		if PropObjGetProperty(_G,"ChoGGi_print_buffer_thread") then
			DeleteThread(ChoGGi_print_buffer_thread)
		end
		ChoGGi_print_buffer_thread = CreateRealTimeThread(function()
			while true do
				Sleep(timer)
				if buffer_cnt > 1 then
					Dump(TableConcat(buffer_table,newline),nil,"Console","log",true)
					TableIClear(buffer_table)
					buffer_table[1] = newline
					buffer_cnt = 1
				end
			end
		end)

		local function ReplaceFunc(funcname)
			_G[funcname] = function(...)

				-- table.concat don't work with non strings/numbers
				local args = {...}
				for i = 1, #args do
					local arg_type = type(args[i])
					if arg_type ~= "string" and arg_type ~= "number" then
						args[i] = tostring(args[i])
					end
				end
				args = TableConcat(args," ")

				if buffer_table[buffer_cnt] ~= args then
					buffer_cnt = buffer_cnt + 1
					buffer_table[buffer_cnt] = funcname .. ": " .. args
				end

				-- fire off orig func...
				ChoGGi_OrigFuncs[funcname](...)
			end

		end

		local function ResetFunc(funcname)
			if ChoGGi_OrigFuncs[funcname] then
				_G[funcname] = ChoGGi_OrigFuncs[funcname]
			end
		end

		function ChoGGi.ComFuncs.WriteLogs_Toggle(which)
			if blacklist then
				print(S[302535920000242--[[%s is blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have Über access.--]]]:format("ChoGGi.ComFuncs.WriteLogs_Toggle"))
				return
			end

			if which then
				-- move old log to previous and add a blank log
				AsyncCopyFile("AppData/logs/Console.log","AppData/logs/Console.previous.log","raw")
				AsyncStringToFile("AppData/logs/Console.log"," ")

				-- redirect functions
				ReplaceFunc("DebugPrintNL")
				ReplaceFunc("OutputDebugString")
				ReplaceFunc("AddConsoleLog") -- also does print()
				ReplaceFunc("assert")
				ReplaceFunc("printf")
				ReplaceFunc("error")
				-- causes an error and stops games from loading
				-- ReplaceFunc("DebugPrint")
			else
				ResetFunc("DebugPrintNL")
				ResetFunc("OutputDebugString")
				ResetFunc("AddConsoleLog")
				ResetFunc("assert")
				ResetFunc("printf")
				ResetFunc("error")
			end
		end
	end -- do

	-- returns table with list of files without path or ext and path, or exclude ext to return all files
	function ChoGGi.ComFuncs.RetFilesInFolder(folder,ext)
		local err, files = AsyncListFiles(folder,ext and "*" .. ext or "*")
		if not err and #files > 0 then
			local table_path = {}
			local path = folder .. "/"
			for i = 1, #files do
				local name
				if ext then
					name = files[i]:gsub(path,""):gsub(ext,"")
				else
					name = files[i]:gsub(path,"")
				end
				table_path[i] = {
					path = files[i],
					name = name,
				}
			end
			return table_path
		end
	end

	function ChoGGi.ComFuncs.RetFoldersInFolder(folder)
		local err, folders = AsyncListFiles(folder,"*","folders")
		if not err and #folders > 0 then
			local table_path = {}
			local path = folder .. "/"
			for i = 1, #folders do
				table_path[i] = {
					path = folders[i],
					name = folders[i]:gsub(path,""),
				}
			end
			return table_path
		end
	end

	do -- OpenInExamineDlg
		local red = red
		local function FlashTitlebar(title)
			-- we don't need to worry about storing colour
			local bg = title.Background
			title:SetBackground(red)
			Sleep(500)
			title:SetBackground(bg)
		end
		local function OpenInExamineDlg(obj,parent,title)

			-- workaround for g_ExamineDlgs
			if type(obj) == "nil" then
				obj = "nil"
			end

			-- already examining, so focus and return ( :new() doesn't return the opened dialog).
			local opened = g_ExamineDlgs[obj]
			if opened then
				-- hit refresh, cause i'm that kinda guy
				opened:RefreshExamine()
				-- and flash the titlebar
				CreateRealTimeThread(FlashTitlebar,opened.idMoveControl)
				return opened
			end

			return Examine:new({}, terminal.desktop,{
				obj = obj,
				parent = parent,
				title = title,
			})
		end

		ChoGGi.ComFuncs.OpenInExamineDlg = OpenInExamineDlg
		function OpenExamine(obj,parent,title)
			OpenInExamineDlg(obj,parent,title)
		end
		ex = OpenExamine
	end -- do

	function ChoGGi.ComFuncs.OpenInMonitorInfoDlg(list,parent)
		if type(list) ~= "table" then
			return
		end

		return ChoGGi_MonitorInfoDlg:new({}, terminal.desktop,{
			obj = list,
			parent = parent,
			tables = list.tables,
			values = list.values,
		})
	end

	function ChoGGi.ComFuncs.OpenInObjectEditorDlg(obj,parent)
		obj = obj or ChoGGi.ComFuncs.SelObject()
		if not obj then
			return
		end

		return ChoGGi_ObjectEditorDlg:new({}, terminal.desktop,{
			obj = obj,
			parent = parent,
		})
	end

	function ChoGGi.ComFuncs.OpenIn3DManipulatorDlg(obj,parent)
		obj = IsValid(obj) and obj or ChoGGi.ComFuncs.SelObject()
		if not obj then
			return
		end

		return ChoGGi_3DManipulatorDlg:new({}, terminal.desktop,{
			obj = obj,
			parent = parent,
		})
	end

	function ChoGGi.ComFuncs.OpenInExecCodeDlg(context,parent)
		return ChoGGi_ExecCodeDlg:new({}, terminal.desktop,{
			obj = context,
			parent = parent,
		})
	end

	function ChoGGi.ComFuncs.OpenInFindValueDlg(context,parent)
		if not context then
			return
		end

		return ChoGGi_FindValueDlg:new({}, terminal.desktop,{
			obj = context,
			parent = parent,
		})
	end

	function ChoGGi.ComFuncs.OpenInImageViewerDlg(context,parent)
		if not context then
			return
		end

		return ChoGGi_ImageViewerDlg:new({}, terminal.desktop,{
			obj = context,
			parent = parent,
		})
	end
	function ChoGGi.ComFuncs.OpenInDTMSlotsDlg(context,parent)
		return ChoGGi_DTMSlotsDlg:new({}, terminal.desktop,{
--~ 			obj = context,
			parent = parent,
		})
	end

	function ChoGGi.ComFuncs.CloseDialogsECM()
		local desktop = terminal.desktop
		for i = #desktop, 1, -1 do
			local dlg = desktop[i]
			if dlg:IsKindOf("ChoGGi_Window") then
				dlg:Done()
			end
		end
	end

	function ChoGGi.ComFuncs.EntitySpawner(obj,skip_msg,list_type,planning)
		local ChoGGi = ChoGGi
		local const = const

		local title = planning and 302535920000862--[[Object Planner--]] or 302535920000475--[[Entity Spawner--]]
		local hint = planning and 302535920000863--[[Places fake construction site objects at mouse cursor (collision disabled).--]] or 302535920000476--[["Shows list of objects, and spawns at mouse cursor."--]]

		local default
		local ItemList = {}
		local c = 0

		if IsValid(obj) and IsValidEntity(obj.ChoGGi_orig_entity) then
			default = S[1000121--[[Default--]]]
			ItemList[1] = {
				text = " " .. default,
				value = default,
			}
			c = 1
		end

		if planning then
			local BuildingTemplates = BuildingTemplates
			for key,obj in pairs(BuildingTemplates) do
				c = c + 1
				ItemList[c] = {
					text = key,
					value = obj.entity,
				}
			end
		else
			local all_entities = GetAllEntities()
			for key in pairs(all_entities) do
				c = c + 1
				ItemList[c] = {
					text = key,
					value = key,
				}
			end
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local value = choice[1].value

			if not obj then
				obj = PlaceObj("ChoGGi_BuildingEntityClass",{
					"Pos",ChoGGi.ComFuncs.CursorNearestHex()
				})
				if planning then
					obj.planning = true
					obj:SetGameFlags(const.gofUnderConstruction)
				end
			end

			-- backup orig entity
			if not IsValidEntity(obj.ChoGGi_orig_entity) then
				obj.ChoGGi_orig_entity = obj:GetEntity()
			end

			-- if it's playing certain anims on certains objs, then crash if we don't idle it
			obj:SetState("idle")

			if value == default and IsValidEntity(obj.ChoGGi_orig_entity) then
				obj:ChangeEntity(obj.ChoGGi_orig_entity)
			else
				obj:ChangeEntity(value)
			end

			if SelectedObj == obj then
				SelectionRemove(obj)
				SelectObj(obj)
			end

			-- needs to fire whenever entity changes
			obj:ClearEnumFlags(const.efCollision + const.efApplyToGrids)

			if not skip_msg then
				MsgPopup(
					choice[1].text .. ": " .. S[302535920000014--[[Spawned--]]],
					title
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = title,
			hint = hint,
			custom_type = list_type or 0,
			custom_func = CallBackFunc,
		}
	end

	function ChoGGi.ComFuncs.SetAnimState(sel)
		local ChoGGi = ChoGGi
		sel = sel or ChoGGi.ComFuncs.SelObject()
		if not sel then
			return
		end

		local ItemList = {}

		local states = sel:GetStates() or ""
		for i = 1, #states do
			ItemList[i] = {
				text = S[302535920000858--[[Index--]]] .. ": " .. i .. ", " .. S[1000037--[[Name--]]] .. ": " .. states[i],
				value = states[i],
			}
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end

			local value = choice[1].value
			-- if user wants to play it again we'll need to have it set to another state and everything has idle
			sel:SetState("idle")
			sel:SetState(value)
			if value ~= "idle" then
				MsgPopup(
					ChoGGi.ComFuncs.SettingState(choice[1].text,3722--[[State--]]),
					302535920000859--[[Anim State--]]
				)
			end
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

	function ChoGGi.ComFuncs.MonitorThreads()
		if blacklist then
			print(S[302535920000242--[[%s is blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have Ü¢er access.--]]]:format("ChoGGi.ComFuncs.MonitorThreads"))
			return
		end

		local table_list = {}
		local dlg = ChoGGi.ComFuncs.OpenInExamineDlg(table_list)
		dlg:EnableAutoRefresh()

		CreateRealTimeThread(function()
			-- stop when dialog is closed
			while dlg and dlg.window_state ~= "destroying" do
				TableClear(table_list)
				local ThreadsRegister = ThreadsRegister
				for thread in pairs(ThreadsRegister) do
					local info = getinfo(thread, 1, "Slfun")
					if info then
						table_list[info.source .. "(" .. info.linedefined .. ") " .. tostring(thread)] = thread
					end
				end
				Sleep(1000)
			end
		end)
	end

	-- sortby: nil = table length, 1 = table names
	-- skip_under: don't show any tables under this length
	-- pad_to: needed for sorting in examine (prefixes zeros to length)
--~ 	ChoGGi.ComFuncs.MonitorTableLength(_G)
	function ChoGGi.ComFuncs.MonitorTableLength(obj,skip_under,pad_to,sortby,name)
		name = name or RetName(obj)
		skip_under = skip_under or 25
		local table_list = {}
		local dlg = ChoGGi.ComFuncs.OpenInExamineDlg(table_list,nil,name)
		dlg:EnableAutoRefresh()
		local table_str = "%s %s"
		local PadNumWithZeros = ChoGGi.ComFuncs.PadNumWithZeros

		CreateRealTimeThread(function()
			-- stop when dialog is closed
			while dlg and dlg.window_state ~= "destroying" do
				TableClear(table_list)

				for key,value in pairs(obj) do
					if type(value) == "table" then
						-- tables can be index or associative or a mix
						local length = 0
						for _ in pairs(value) do
							length = length + 1
						end
						-- skip the tiny tables
						if length > skip_under then
							if not sortby then
								table_list[PadNumWithZeros(length,pad_to) .. " " .. key] = value
							elseif sortby == 1 then
								table_list[key .. " " .. length] = value
							end
						end

					end
				end

				Sleep(1000)
			end
		end)
	end

	function ChoGGi.ComFuncs.SetParticles(sel)
		local name = S[302535920000129--[[Set--]]] .. " " .. S[302535920001184--[[Particles--]]]
		sel = sel or ChoGGi.ComFuncs.SelObject()
		if not sel or sel and not sel:IsKindOf("FXObject") then
			MsgPopup(
				S[302535920000027--[[Nothing selected--]]] .. ": " .. "FXObject",
				name
			)
			return
		end

		local PlayFX = PlayFX
		-- make a list of spot names for the obj, so we skip particles that need that spot
		local spots = {}
		local id_start, id_end = sel:GetAllSpots(sel:GetState())
		for i = id_start, id_end do
			spots[sel:GetSpotName(i)] = true
		end

		local default = S[1000121--[[Default--]]]

		local ItemList = {{text = " " .. default,value = default}}
		local c = 1
		local particles = FXLists.ActionFXParticles
		for i = 1, #particles do
			local p = particles[i]
			if spots[p.Spot] or p.Spot == "" then
				c = c + 1
				ItemList[c] = {
					text = p.Actor .. ", " .. p.Action .. ", " .. p.Moment,
					value = p.Actor,
					action = p.Action,
					moment = p.Moment,
					hint = "Actor: " .. p.Actor .. ", Action: " .. p.Action .. ", Moment: " .. p.Moment,
				}
			end
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local actor = choice[1].value
			local action = choice[1].action
			local moment = choice[1].moment

			-- if there's one playing then stop it
			if sel.ChoGGi_playing_fx then
				PlayFX(sel.ChoGGi_playing_fx, "end", sel)
			end
			-- so we can stop it
			sel.ChoGGi_playing_fx = action

			if type(sel.fx_actor_class_ChoGGi_Orig) == "nil" then
				sel.fx_actor_class_ChoGGi_Orig = sel.fx_actor_class
			end

			sel.fx_actor_class = actor

			if actor == default then
				if sel.fx_actor_class_ChoGGi_Orig then
					sel.fx_actor_class = sel.fx_actor_class_ChoGGi_Orig
				end
				sel.ChoGGi_playing_fx = nil
			else
				PlayFX(action, moment, sel)
			end

			MsgPopup(
				action,
				name
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = name,
			hint = 302535920001421--[[Shows list of particles to quickly test out on objects.--]],
			custom_type = 7,
			custom_func = CallBackFunc,
		}
	end

	function ChoGGi.ComFuncs.ToggleConsole(show)
		local dlgConsole = dlgConsole
		if dlgConsole then
			ShowConsole(show or not dlgConsole:GetVisible())
			dlgConsole.idEdit:SetFocus()
		end
	end

	-- toggle visiblity of console log
	function ChoGGi.ComFuncs.ToggleConsoleLog()
		local log = dlgConsoleLog
		if log then
			if log:GetVisible() then
				log:SetVisible(false)
			else
				log:SetVisible(true)
			end
		else
			dlgConsoleLog = ConsoleLog:new({}, terminal.desktop)
		end
	end

	function ChoGGi.ComFuncs.SelectConsoleLogText()
		local dlgConsoleLog = dlgConsoleLog
		if not dlgConsoleLog then
			return
		end
		local text = dlgConsoleLog.idText:GetText()
		if #text < 1 then
			print(S[302535920000692--[[Log is blank (well not anymore).--]]])
			return
		end

		ChoGGi.ComFuncs.OpenInMultiLineTextDlg{text = text}
	end

	function ChoGGi.ComFuncs.ShowConsoleLogWin(visible)
		if visible and not dlgChoGGi_ConsoleLogWin then
			dlgChoGGi_ConsoleLogWin = ChoGGi_ConsoleLogWin:new({}, terminal.desktop,{})
			local _,text = ReadLog()
			dlgChoGGi_ConsoleLogWin:UpdateText(text)
		end

		local dlg = dlgChoGGi_ConsoleLogWin
		if dlg then
			dlg:SetVisible(visible)

			--size n position
			local size = ChoGGi.UserSettings.ConsoleLogWin_Size
			local pos = ChoGGi.UserSettings.ConsoleLogWin_Pos
			--make sure dlg is within screensize
			if size then
				dlg:SetSize(size)
			end
			if pos then
				dlg:SetPos(pos)
			else
				dlg:SetPos(point(100,100))
			end

		end
	end

	-- Any png files in AppData/Logos folder will be added to mod as converted logo files.
	-- They have to be min of 8bit, and will be resized to power of 2.
	-- This doesn't add anything to metadata/items, it only converts files.
--~ 	ChoGGi.ComFuncs.ConvertImagesToLogoFiles("MOD_ID")
--~ 	ChoGGi.ComFuncs.ConvertImagesToLogoFiles(Mods.MOD_ID,".tga")
--~ ChoGGi.ComFuncs.ConvertImagesToLogoFiles(Mods.ChoGGi_XXXXXXXXXX)
	function ChoGGi.ComFuncs.ConvertImagesToLogoFiles(mod,ext)
		if blacklist then
			print(S[302535920000242--[[%s is blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have Ãœber access.--]]]:format("ChoGGi.ComFuncs.ConvertImagesToLogoFiles"))
			return
		end
		if type(mod) == "string" then
			mod = Mods[mod]
		end
		local images = ChoGGi.ComFuncs.RetFilesInFolder("AppData/Logos",ext or ".png")
		if images then
			-- returns error msgs and prints in console
			local TGetID = TGetID
			local fake_ged_socket = {
				ShowMessage = function(title,msg)
					if TGetID(title) == 12061 then
						print("ShowMessage",Trans(title),Trans(msg))
					end
				end,
			}

			local ModItemDecalEntity = ModItemDecalEntity
			local Import = ModItemDecalEntity.Import
			local ConvertToOSPath = ConvertToOSPath
			for i = 1, #images do
				local filename = ConvertToOSPath(images[i].path)
				Import(nil,
					ModItemDecalEntity:new{
						entity_name = images[i].name,
						name = images[i].name,
						filename = filename:gsub("\\","/"),
						mod = mod,
					},
					nil,
					fake_ged_socket
				)
				print(filename)
			end
		end
	end

	do -- ConvertImagesToResEntities
		-- converts png images (512x512) to an entity you can use to replace deposit signs.
		local ConvertToOSPath = ConvertToOSPath
		local RetFilesInFolder = ChoGGi.ComFuncs.RetFilesInFolder
	--~ 	ModItemDecalEntity:Import
		local function ModItemDecalEntityImport(name,filename,mod)
			local output_dir = ConvertToOSPath(mod.content_path)

			local ent_dir = output_dir .. "Entities/"
			local ent_file = name .. ".ent"
			local ent_output = ent_dir .. ent_file

			local mtl_dir = output_dir .. "Entities/Materials/"
			local mtl_file = name .. "_mesh.mtl"
			local mtl_output = mtl_dir .. mtl_file

			local texture_dir = output_dir .. "Entities/Textures/"
			local texture_output = texture_dir .. name .. ".dds"

			local fallback_dir = texture_dir .. "Fallbacks/"
			local fallback_output = fallback_dir .. name .. ".dds"

			local err = AsyncCreatePath(ent_dir)
			if err then
				return err
			end
			err = AsyncCreatePath(mtl_dir)
			if err then
				return err
			end
			err = AsyncCreatePath(texture_dir)
			if err then
				return err
			end
			err = AsyncCreatePath(fallback_dir)
			if err then
				return err
			end

			err = AsyncStringToFile(ent_output, [[<?xml version="1.0" encoding="UTF-8"?>
<entity path="">
	<state id="idle">
		<mesh_ref ref="mesh"/>
	</state>
	<mesh_description id="mesh">
		<src file=""/>
		<mesh file="SignConcreteDeposit_mesh.hgm"/>
		<material file="]] .. mtl_file .. [["/>
		<bsphere value="0,0,50,1301"/>
		<box min="-920,-920,50" max="920,920,50"/>
	</mesh_description>
</entity>
]])

			if err then
				return
			end

			local cmdline = [["]] .. ConvertToOSPath(g_HgnvCompressPath) .. [[" -dds10 -24 bc1 -32 bc3 -srgb "]] .. filename .. [[" "]] .. texture_output .. [["]]
			err = AsyncExec(cmdline, "", true, false)
			if err then
				return err
			end
			cmdline = [["]] .. ConvertToOSPath(g_DdsTruncPath) .. [[" "]] .. texture_output .. [[" "]] .. fallback_output .. [[" "]] .. const.FallbackSize .. [["]]
			err = AsyncExec(cmdline, "", true, false)
			if err then
				return err
			end
			cmdline = [["]] .. ConvertToOSPath(g_HgimgcvtPath) .. [[" "]] .. texture_output .. [[" "]] .. ui_output .. [["]]
			err = AsyncExec(cmdline, "", true, false)
			if err then
				return err
			end

			err = AsyncStringToFile(mtl_output,[[<?xml version="1.0" encoding="UTF-8"?>
<Materials>
	<Material>
		<BaseColorMap Name="]] .. name .. [[.dds" mc="0"/>
		<SIMap Name="BackLight.dds" mc="0"/>
		<Property Special="None"/>
		<Property AlphaBlend="Blend"/>
	</Material>
</Materials>]])

			if err then
				return err
			end
		end

--~ 	ChoGGi.ComFuncs.ConvertImagesToResEntities("ChoGGi_ExampleNewResIcon")
--~ 	ChoGGi.ComFuncs.ConvertImagesToResEntities("MOD_ID")
--~ 	ChoGGi.ComFuncs.ConvertImagesToResEntities(Mods.MOD_ID,".tga")
		function ChoGGi.ComFuncs.ConvertImagesToResEntities(mod,ext)
			if blacklist then
				print(S[302535920000242--[[%s is blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have Ãœber access.--]]]:format("ChoGGi.ComFuncs.ConvertImagesToResEntities"))
				return
			end
			if type(mod) == "string" then
				mod = Mods[mod]
			end
			local images = RetFilesInFolder("AppData/Logos",ext or ".png")
			if images then
				for i = 1, #images do
					local filename = ConvertToOSPath(images[i].path)
					ModItemDecalEntityImport(
						images[i].name,
						filename:gsub("\\","/"),
						mod
					)
					print(filename)
				end
			end

		end
	end -- do

	do -- ExamineEntSpots
		local spots_str = [[<attach name="%s" spot_note="%s" bone="%s" spot_pos="%s,%s,%s" spot_scale="%s" spot_rot="%s,%s,%s,%s"/>]]
		local bsphere_str = [[<bsphere value="%s,%s,%s,%s"/>]]
		local box_str = [[<box min="%s,%s,%s" max="%s,%s,%s"/>]]
		local readme_str = [[Readme:
See bottom for box/bsphere.
The func I use for spot_rot rounds to two decimal points...

]]

--~ local list = ChoGGi.ComFuncs.ExamineEntSpots(s,true)
--~ list = ChoGGi.ComFuncs.TableConcat(list,"\n")
--~ ChoGGi.ComFuncs.Dump(list)
		function ChoGGi.ComFuncs.ExamineEntSpots(obj,parent_or_ret)
			obj = obj or ChoGGi.ComFuncs.SelObject()
			if not IsValid(obj) then
				return
			end

			local spots_table = {[-1] = readme_str}

			local origin = obj:GetSpotBeginIndex("Origin")
			local origin_pos_x, origin_pos_y, origin_pos_z = obj:GetSpotLocPosXYZ(origin)

			local id_start, id_end = obj:GetAllSpots(EntityStates.idle)
			if not id_end then
				return
			end
			for i = id_start, id_end do
				local name = obj:GetSpotName(i)

				-- make a copy to edit
				local spots_str_t = spots_str

				-- we don't want to fill the list with stuff we don't use
				local annot = obj:GetSpotAnnotation(i)
				if not annot then
					annot = ""
					spots_str_t = spots_str_t:gsub([[ spot_note="%%s"]],"%%s")
				end

				local bone = obj:GetSpotBone(i)
				if bone == "" then
					spots_str_t = spots_str_t:gsub([[ bone="%%s"]],"%%s")
				end

				-- scale angle,axis (position numbers are off-by-one for negative numbers)
				local _,_,_,angle,axis_x,axis_y,axis_z,scale = obj:GetSpotLocXYZ(i)

				-- 100 is default
				if scale == 100 then
					spots_str_t = spots_str_t:gsub([[ spot_scale="%%s"]],"%%s")
					scale = ""
				end

				-- means nadda for spot_rot
				if angle == 0 and axis_x == 0 and axis_y == 0 and axis_z == 4096 then
					spots_str_t = spots_str_t:gsub([[ spot_rot="%%s,%%s,%%s,%%s"]],"%%s%%s%%s%%s")
					angle,axis_x,axis_y,axis_z = "","","",""
				else
					axis_x = (axis_x + 0.0) / 100
					axis_y = (axis_y + 0.0) / 100
					axis_z = (axis_z + 0.0) / 100
					angle = DivRound(angle, const.Scale.degrees) + 0.0
				end

				local pos_x,pos_y,pos_z = obj:GetSpotPosXYZ(i)

				spots_table[i] = spots_str_t:format(
					name,annot,bone,
					pos_x - origin_pos_x,pos_y - origin_pos_y,pos_z - origin_pos_z,
					scale,axis_x,axis_y,axis_z,angle
				)
			end

			-- this is our bonus eh
			local bbox = obj:GetEntityBBox()
			local x1,y1,z1 = bbox:minxyz()
			local x2,y2,z2 = bbox:maxxyz()
			spots_table.box = box_str:format(x1,y1,z1,x2,y2,z2)

			local pos_x, pos_y, pos_z, rad = obj:GetBSphere("idle", true)
			spots_table.bsphere = bsphere_str:format(pos_x - origin_pos_x, pos_y - origin_pos_y, pos_z - origin_pos_z, rad)

			if parent_or_ret == true then
				return spots_table
			else
				ChoGGi.ComFuncs.OpenInExamineDlg(
					spots_table,
					parent_or_ret,
					string.format("%s: %s",S[302535920000235--[[Attach Spots List--]]],RetName(obj))
				)
			end
		end
	end -- do

--~ 	ChoGGi.ComFuncs.ProcessHexSurfaces(s.entity)
	-- not in a working state as yet (trying to re-create .ent/mtl files)
	function ChoGGi.ComFuncs.ProcessHexSurfaces(entity,parent_or_ret)
		local hexes = {}
		local EntitySurfaces = EntitySurfaces
		for name,surface_num in pairs(EntitySurfaces) do
			if HasAnySurfaces(entity, surface_num) then
				local all_states = GetStates(entity)
				for _,state in ipairs(all_states) do
					local state_idx = GetStateIdx(state)
					local outline, interior, hash = GetSurfaceHexShapes(entity, state_idx, surface_num)
--~ 					if #outline > 0 or #interior > 0 then
						hexes[name] = {outline = outline, interior = interior, hash = hash}
--~ 					end
				end
			end
		end

		if parent_or_ret == true then
			return hexes
		else
			ChoGGi.ComFuncs.OpenInExamineDlg(hexes)
		end
	end

	do -- ObjFlagsList
		local IsFlagSet = IsFlagSet
		local const = const

		-- get list of const.rf* flags
		local rf_flags = {}
		local int_flags = {}
		for flag,value in pairs(const) do
			if flag:sub(1,2) == "rf" and type(value) == "number" then
				rf_flags[flag] = value
			elseif flag:sub(1,3) == "int" and type(value) == "number" then
				int_flags[flag] = value
			end
		end

		local flags_table
		local function CheckFlags(flags,list)
			for i = 1, #list do
				local f = list[i]
				flags_table[f] = IsFlagSet(flags, const[f])
			end
		end

--~ 		function ChoGGi.ComFuncs.ObjFlagsList_XWin(flags)
--~ 			if not flags then
--~ 				return
--~ 			end
--~ 			flags_table = {}

--~ 			for flag,value in pairs(int_flags) do
--~ 				flags_table[flag] = IsFlagSet(flags,value)
--~ 			end

--~ 			if parent_or_ret == true then
--~ 				return flags_table
--~ 			else
--~ 				ChoGGi.ComFuncs.OpenInExamineDlg(flags_table,parent_or_ret)
--~ 			end
--~ 		end

		function ChoGGi.ComFuncs.ObjFlagsList_TR(obj,parent_or_ret)
			if not obj or obj.__name ~= "HGE.TaskRequest" then
				return
			end
			flags_table = {}

			for flag,value in pairs(rf_flags) do
				flags_table[flag] = obj:IsAnyFlagSet(value)
			end

			if parent_or_ret == true then
				return flags_table
			else
				ChoGGi.ComFuncs.OpenInExamineDlg(flags_table,parent_or_ret,RetName(obj))
			end
		end

		function ChoGGi.ComFuncs.ObjFlagsList(obj,parent_or_ret)
			obj = obj or ChoGGi.ComFuncs.SelObject()
			if not IsValid(obj) then
				return
			end

			flags_table = {}

			local class = obj:GetClassFlags()
			local enum = obj:GetEnumFlags()
			local game = obj:GetGameFlags()

			local Flags = Flags
			CheckFlags(class,Flags.Class)
			CheckFlags(enum,Flags.Enum)
			CheckFlags(game,Flags.Game)

			if parent_or_ret == true then
				return flags_table
			else
				ChoGGi.ComFuncs.OpenInExamineDlg(flags_table,parent_or_ret,RetName(obj))
			end

		end
	end -- do

	do -- GetMaterialProperties
		local GetMaterialProperties = GetMaterialProperties
		local GetStateNumMaterials = GetStateNumMaterials
		local GetStateMaterial = GetStateMaterial
		local GetStateIdx = GetStateIdx
		local GetStateLODCount = GetStateLODCount
		local GetStates = GetStates
		local TableIsEqual = ChoGGi.ComFuncs.TableIsEqual
		local mat_table_str = S[302535920001477--[["%s, Mat: %s, LOD: %s, State: %s"--]]]

		local function EntityMats(entity)
			local mats = {}
			local c = 0
			local states = GetStates(entity) or ""
			for si = 1, #states do
				local state = GetStateIdx(states[si])
				local num_lods = GetStateLODCount(entity, state) or 0
				for li = 1, num_lods do
					local num_mats = GetStateNumMaterials(entity, state, li - 1) or 0
					for mi = 1, num_mats do
						local mat_name = GetStateMaterial(entity,state,mi - 1,li - 1)
						local mat = GetMaterialProperties(mat_name)
						mat.__mtl = mat_name
						mat.__lod = li
						mat.__state = li
						mats[mat_table_str:format(mat_name,mi,li,si)] = mat
					end
				end
			end
			if #mats == 1 then
				return mats[1]
			end

--~ 			for i = #mats, 1, -1 do
--~ 				if i == 1 then
--~ 					break
--~ 				end
--~ 				local t1,t2 = mats[i],mats[1]
--~ 				if type(t1) == "table" and type(t2) == "table" and TableIsEqual(t1,t2) then
--~ 					table.remove(mats,i)
--~ 				end
--~ 			end

--~ 			if #mats == 1 then
--~ 				return mats[1]
--~ 			end

			return mats
		end

		local function EntityMatsORIG(entity)
			local mats = {}
			local c = 0
			local states = GetStates(entity) or ""
			for si = 1, #states do
				local state = GetStateIdx(states[si])
				local num_lods = GetStateLODCount(entity, state) or 0
				for li = 1, num_lods do
					local num_mats = GetStateNumMaterials(entity, state, li - 1) or 0
					for mi = 1, num_mats do
						local mat_name = GetStateMaterial(entity,state,mi - 1,li - 1)
						local mat = GetMaterialProperties(mat_name)
						mat.__mtl = mat_name
						mat.__lod = li
						local t1 = mats[c]
						local t1_type = type(t1) == "table"
						if not t1_type or t1_type and not TableIsEqual(t1,mat) then
							c = c + 1
							mats[c] = mat
						end
					end
				end
			end
			if #mats == 1 then
				return mats[1]
			end

			for i = #mats, 1, -1 do
				if i == 1 then
					break
				end
				local t1,t2 = mats[i],mats[1]
				if type(t1) == "table" and type(t2) == "table" and TableIsEqual(t1,t2) then
					table.remove(mats,i)
				end
			end

			if #mats == 1 then
				return mats[1]
			end

			return mats
		end

		function ChoGGi.ComFuncs.GetMaterialProperties(obj,parent_or_ret)
			if not UICity then
				return
			end
			obj = obj or ChoGGi.ComFuncs.SelObject()
			if IsValid(obj) then
				obj = obj:GetEntity()
			end

			if IsValidEntity(obj) then
				if parent_or_ret == true then
					return EntityMats(obj)
				else
					ChoGGi.ComFuncs.OpenInExamineDlg(EntityMats(obj),parent_or_ret,S[302535920001458--[[Material Properties--]]])
				end
			else
				local materials = {}
				local all_entities = GetAllEntities()
				for entity in pairs(all_entities) do
					materials[entity] = EntityMats(entity)
--~ 					if entity:find("AlienDiggerBig") then
--~ 						break
--~ 					end
				end
				ChoGGi.ComFuncs.OpenInExamineDlg(materials,parent,S[302535920001458--[[Material Properties--]]])
			end
		end
	end -- do

	do -- DisplayObjectImages
		local ext_list = {
			[".dds"] = true,
			[".tga"] = true,
			[".png"] = true,
		}

		function ChoGGi.ComFuncs.DisplayObjectImages(obj,parent,images)
			images = images or {}
			if type(obj) ~= "table" then
				return
			end
			local c = #images

			-- grab any strings with the correct ext
			for _,value in pairs(obj) do
				if type(value) =="string" and ext_list[value:sub(-4)] then
					c = c + 1
					images[c] = value
				end
			end

			local meta = getmetatable(obj)
			while meta do
				for _,value in pairs(meta) do
					if type(value) =="string" and ext_list[value:sub(-4)] then
						c = c + 1
						images[c] = value
					end
				end
				meta = getmetatable(meta)
			end

			if #images > 0 then
				images = ChoGGi.ComFuncs.RetTableNoDupes(images)
				table.sort(images)
				ChoGGi.ComFuncs.OpenInImageViewerDlg(images,parent)
				return true
			end
		end
	end -- do

	do -- BBoxLines_Toggle
		local MulDivRound = MulDivRound
		local Max = Max
		local point = point
		local PlacePolyline = PlacePolyline
		local guim = guim
		local objlist = objlist
		local IsBox = IsBox
--~ 		local GetHeight = terrain.GetHeight

		-- stores objlist of line objects
		local lines

		local function SpawnBoxLine(bbox, list, colour)
			local line = PlacePolyline(list, colour)
			line:SetPos(bbox:Center())
			lines[#lines+1] = line
		end
		local function SpawnPillarLine(pt, z, obj_height, colour)
			local line = PlacePolyline({pt:SetZ(z),pt:SetZ(z + obj_height)}, colour)
			line:SetPos(AveragePoint2D(line.vertices))
			lines[#lines+1] = line
		end

		local function PlaceTerrainBox(bbox, pos, colour, step, offset)
			local obj_height = bbox:sizez() or 1500
			local z = pos:z()
			step = step or guim
			offset = offset or 0
			-- stores all line objs for deletion later
			lines = objlist:new()

			local edges = {bbox:ToPoints2D()}
			-- needed to complete the square (else there's a short blank space of a chunk of a line)
			edges[5] = edges[1]
			edges[6] = edges[2]

			-- we need a list of top/bottom box points
			local points_top,points_bot = {},{}
			for i = 1, #edges - 1 do
				local edge = edges[i]
				if i < 5 then
					-- the four "pillars"
					SpawnPillarLine(edge, z, obj_height, colour)
				end
				local x,y = edge:xy()
				points_top[#points_top + 1] = point(x, y, z + obj_height)
				points_bot[#points_bot + 1] = point(x, y, z)
			end
			SpawnBoxLine(bbox, points_top, colour)
			SpawnBoxLine(bbox, points_bot, colour)

			--[[
			-- make bbox follow ground height
			for i = 1, #edges - 1 do

				local pt1 = edges[i]
				local pt2 = edges[i + 1]
				local diff = pt2 - pt1
				local steps = Max(2, 1 + diff:Len2D() / step)

				for j = 1, steps do
					local pos = pt1 + MulDivRound(diff, j - 1, steps - 1)
					local x,y = pos:xy()
					local z = GetHeight(x, y)
					z = z + offset

					points_top[#points_top + 1] = point(x, y, z + obj_height)
					points_bot[#points_bot + 1] = point(x, y, z)
				end

				-- ... extra lines?
				-- this is what i get for not commenting it the first time.
				points_bot[#points_bot] = nil
				points_top[#points_top] = nil
			end

			SpawnBoxLine(lines, bbox, points_top, colour)
			SpawnBoxLine(lines, bbox, points_bot, colour)
			--]]

			return lines
		end

		function ChoGGi.ComFuncs.BBoxLines_Toggle(obj,func,args,colour,step,offset)
			obj = obj or ChoGGi.ComFuncs.SelObject()
			local is_box = IsBox(obj)
			if not (IsValid(obj) or is_box) then
				return
			end

			-- check if bbox showing
			if not is_box and obj.ChoGGi_bboxobj then
				obj.ChoGGi_bboxobj:Destroy()
				obj.ChoGGi_bboxobj = nil
				return
			end

			-- go forth
			local bbox
			if is_box then
				bbox = obj
			else
				if func then
					local g = _G[func]
					if g then
						bbox = g(obj,args)
					else
						bbox = obj[func] and obj[func](obj,args)
					end
				end
				if not bbox then
					bbox = obj.GetObjectBBox and obj:GetObjectBBox(args)
				end
			end
			if bbox then
				obj.ChoGGi_bboxobj = PlaceTerrainBox(
					bbox,
--~ 						obj:GetPos(),
					bbox:Center():SetTerrainZ(),
					colour,step,offset
				)
			end
		end
	end -- do

	do -- MoveObjToGround
--~ 		local GetHeight = terrain.GetHeight
		function ChoGGi.ComFuncs.MoveObjToGround(obj)
--~ 			local t_height = GetHeight(obj:GetVisualPos())
--~ 			obj:SetPos(obj:GetPos():SetZ(t_height))
			obj:SetPos(obj:GetPos():SetTerrainZ())
		end
	end -- do

	function ChoGGi.ComFuncs.GetDesktopWindow(class)
		local desktop = terminal.desktop
		return desktop[TableFind(desktop,"class",class)]
	end

	do -- RetThreadInfo/FindThreadFunc
		local GedInspectorFormatObject = GedInspectorFormatObject
		local IsValidThread = IsValidThread
		local funcs

		local function DbgGetlocal(thread,info,level)
			local list = {}
			local idx = 1
			while true do
				local name, value = getlocal(thread, level, idx)
				if name == nil then
					break
				end
				list[idx] = {
					name = name ~= "" and name or S[302535920000723--[[Lua--]]],
					value = value,
					level = level,
				}
				idx = idx + 1
			end
			if next(list) then
				return list
			end
		end
		local function DbgGetupvalue(thread,info)
			local list = {}
			local idx = 1
			while true do
				local name, value = getupvalue(info.func, idx)
				if name == nil then
					break
				end
				list[idx] = {
					name = name ~= "" and name or S[302535920000723--[[Lua--]]],
					value = value,
				}
				idx = idx + 1
			end
			if next(list) then
				return list
			end
		end

		-- returns some info if blacklist enabled
		function ChoGGi.ComFuncs.RetThreadInfo(thread)
			if type(thread) ~= "thread" then
				return empty_table
			end
			funcs = {}

			if blacklist then
				-- func expects an empty table
				GedInspectedObjects[thread] = {}
				-- returns a table of the funcs in the thread
				local threads = GedInspectorFormatObject(thread).members
				-- build a list of func name / level
				for i = 1, #threads do
					-- why'd i add the "= false"?
					local temp = {level = false,func = false,name = false}

					local t = threads[i]
					for key,value in pairs(t) do
						if key == "key" then
							temp.level = value
						elseif key == "value" then
							-- split "func(line num) name" into two
							local space = value:find(") ",1,true)
							temp.func = value:sub(2,space - 1)
							-- change unknown to Lua
							local n = value:sub(space + 2,-2)
							temp.name = n ~= "unknown name" and n or S[302535920000723--[[Lua--]]]
						end
					end

					funcs[i] = temp
				end

			else
				funcs.gethook = gethook(thread)

				local info = getinfo(thread,0,"SLlfunt")
				local nups = info.nups
				if info and nups > 0 then
					-- we start info at 0, nups starts at 1
					nups = nups + 1

					for i = 0, nups do
						local info_got = getinfo(thread,i)
						if info_got then
							local name = info_got.name or info_got.what or S[302535920000723--[[Lua--]]]
							funcs[i] = {
								name = name,
								func = info_got.func,
								level = i,
								getlocal = DbgGetlocal(thread,info_got,i),
								getupvalue = DbgGetupvalue(thread,info_got),
							}
						end
					end
				end
			end

			return funcs
		end

		-- find/return func if str in func name
		function ChoGGi.ComFuncs.FindThreadFunc(thread,str)
			-- needs an empty table to work it's magic
			GedInspectedObjects[thread] = {}
			-- returns a table of the funcs in the thread
			local threads = GedInspectorFormatObject(thread).members
			for i = 1, #threads do
				for key,value in pairs(threads[i]) do
					if key == "value" and value:find_lower(str,1,true) then
						return value
					end
				end
			end
		end

	end -- do

	do -- DebugGetInfo
		local format_value = format_value

		-- this replaces the func added in my library mod (which is just a straight format_value)
		function ChoGGi.ComFuncs.DebugGetInfo(obj)
			if blacklist then
				return format_value(obj)
			else
				local info = getinfo(obj)
				-- sub(2): removes @, Mars is ingame files, mods is mods...
				return info.source:sub(2):gsub("Mars/",""):gsub("AppData/Mods/","")
					.. "(" .. info.linedefined .. ")"
			end
		end
	end -- do

	do -- RetSourceFile
		local FileExists = ChoGGi.ComFuncs.FileExists
		local AsyncFileToString = AsyncFileToString
		local source_path = "AppData/Source/"

		function ChoGGi.ComFuncs.RetSourceFile(path)
			if blacklist then
				print(S[302535920000242--[[%s is blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have Ãœber access.--]]]:format("ChoGGi.ComFuncs.RetSourceFile"))
				return
			end

--~ source: '@CommonLua/PropertyObject.lua'
--~ ~PropertyObject.Clone
--~ source: '@Mars/Lua/LifeSupportGrid.lua'
--~ ~WaterGrid.RemoveElement
--~ source: '@Mars/Dlc/gagarin/Code/RCConstructor.lua'
--~ ~RCConstructor.CanInteractWithObject

			-- mods
			if FileExists(path) then
				return select(2,AsyncFileToString(path)),path
			end
			-- might as well return bugged commonlua/dlc files...
			if path:find("@Mars/") then
				path = source_path .. path:sub(6)
				return select(2,AsyncFileToString(path)),path
			elseif path:find("@CommonLua/") then
				path = source_path .. path:sub(2)
				return select(2,AsyncFileToString(path)),path
			end

		end
	end -- do

	do -- ObjShape_Toggle
		local HexRotate = HexRotate
		local RotateRadius = RotateRadius
		local HexToWorld = HexToWorld
		local point = point
		local PlacePolyline = PlacePolyline

		local FallbackOutline = FallbackOutline
		local line_points = objlist:new()
		local radius = const.HexSize / 2

		-- function Dome:GenerateWalkablePoints() (mostly)
		local function BuildShape(obj,shape,colour,offset)
			local dir = HexAngleToDirection(obj:GetAngle())
			local cq, cr = WorldToHex(obj)
			local z = obj:GetPos():z()

			if offset then
				offset = point(0,0,offset)
			end

			local line_list = objlist:new()
			for i = 1, #shape do
				local hex = shape[i]
				local sq, sr = hex:xy()
				local q, r = HexRotate(sq, sr, dir)
				local center = point(HexToWorld(cq + q, cr + r)):SetZ(z)

				line_points:Destroy()
				for j=1,6 do
					local x, y = RotateRadius(radius, j * 60 * 60, center, true)
					line_points[j] = point(x, y, z)
				end
				-- complete the hex
				line_points[7] = line_points[1]
				local line = PlacePolyline(line_points, colour)
				if offset then
					line:SetPos(center + offset)
				else
					line:SetPos(center)
				end

				line_list[i] = line
			end

			return line_list
		end

		function ChoGGi.ComFuncs.ObjHexShape_Toggle(obj,shape,colour,offset)
			-- fallback is just a point(0,0), so nothing to do here
			if not IsValid(obj) or shape == FallbackOutline or #shape < 2 then
				return
			end

			if obj.ChoGGi_shape_obj then
				obj.ChoGGi_shape_obj:Destroy()
				obj.ChoGGi_shape_obj = nil
				return
			end

			obj.ChoGGi_shape_obj = BuildShape(
				obj,
				shape,
				colour,offset
			)

		end
	end -- do

end
