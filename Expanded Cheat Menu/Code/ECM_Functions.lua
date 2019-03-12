-- See LICENSE for terms

local table_find = table.find
local table_clear = table.clear
local table_iclear = table.iclear
local table_sort = table.sort
local type,pairs,next,print = type,pairs,next,print
local tostring,tonumber,rawget = tostring,tonumber,rawget
local AveragePoint2D = AveragePoint2D
local PlaceObject = PlaceObject
local Sleep = Sleep
local IsValid = IsValid
local IsKindOf = IsKindOf
local IsValidEntity = IsValidEntity

local debug_getinfo,debug_getlocal,debug_getupvalue,debug_gethook
local debug = rawget(_G,"debug")
if debug then
	debug_getinfo = debug.getinfo
	debug_getlocal = debug.getlocal
	debug_getupvalue = debug.getupvalue
	debug_gethook = debug.gethook
end

function OnMsg.ClassesGenerate()
	local MsgPopup = ChoGGi.ComFuncs.MsgPopup
	local RetName = ChoGGi.ComFuncs.RetName
	local Translate = ChoGGi.ComFuncs.Translate
	local TableConcat = ChoGGi.ComFuncs.TableConcat
	local RandomColourLimited = ChoGGi.ComFuncs.RandomColourLimited
	local Strings = ChoGGi.Strings
	local blacklist = ChoGGi.blacklist
	local testing = ChoGGi.testing

	local function PlacePolyline(points, colours)
		local line = ChoGGi_OPolyline:new{
			max_vertices = #points
		}
		line:SetMesh(points, colours)
		return line
	end
	ChoGGi.ComFuncs.PlacePolyline = PlacePolyline

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
			ChoGGi.ComFuncs.BlacklistMsg("ChoGGi.ComFuncs.Dump")
			return
		end

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
				Strings[302535920000002--[[Dumped: %s--]]]:format(RetName(obj)),
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
		local CmpLower = CmpLower

		local output_list = {}
		local c
		local level_limit

		local function SortTableFunc(a,b)
			if a.key and b.key then
				return CmpLower(
					RetName(a.key),
					RetName(b.key)
				)
			end
			return a.key and true or b.key and true
		end

		local function DumpTableFunc(obj,level, parent_name)
			if level == level_limit then
				return 0
			end

			if type(obj) == "table" then

				local obj_name = RetName(obj)

				c = c + 1
				output_list[c] = "\n\n------------------------- "
				if parent_name then
					c = c + 1
					output_list[c] = parent_name
					c = c + 1
					output_list[c] = " "
				end
				c = c + 1
				output_list[c] = obj_name
				c = c + 1
				output_list[c] = ":"
				c = c + 1
				output_list[c] = "\n"

				-- get all the key/values then sort the table
				local temp_list = {}
				local t_c = 0

				-- get all key/value pairs in the table
				for key,value in pairs(obj) do
					t_c = t_c + 1
					temp_list[t_c] = {
						key = key,
						value = value,
					}
				end
				table_sort(temp_list,SortTableFunc)

				-- now we can return an ordered list
				for i = 1, t_c do
					local item = temp_list[i]
					c = c + 1
					output_list[c] = "\n"
					c = c + 1
					output_list[c] = RetName(item.key)
					c = c + 1
					output_list[c] = ": "
					c = c + 1
					output_list[c] = RetName(item.value)
				end

				c = c + 1
				output_list[c] = "\n"

				-- go through once and dump any tables in the table
				for i = 1, t_c do
					local item = temp_list[i]
					if type(item.key) == "table" then
						DumpTableFunc(item.key, level+1, RetName(item.value))
					end
					if type(item.value) == "table" then
						DumpTableFunc(item.value, level+1, RetName(item.key))
					end
				end

			end
		end

		--[[
		mode = -1 to append or nil to overwrite (default: append)
		limit = how far down the rabbit hole (default 3)
		--]]
		function ChoGGi.ComFuncs.DumpTable(obj,mode,limit)
			if blacklist then
				ChoGGi.ComFuncs.BlacklistMsg("ChoGGi.ComFuncs.DumpTable")
				return
			end
			if type(obj) ~= "table" then
				MsgPopup(
					Strings[302535920000003--[[Can't dump nothing--]]],
					Strings[302535920000004--[[Dump--]]]
				)
				return
			end
			local name = RetName(obj)

			level_limit = limit or 3

			-- make sure it's empty
			table_iclear(output_list)
			c = 0
			DumpTableFunc(obj,0)

			if #output_list > 0 then
				AsyncStringToFile("AppData/logs/DumpedTable.txt",TableConcat(output_list),mode or "-1")

				local msg = Strings[302535920000002--[[Dumped: %s--]]]:format(name)
				print(msg)
				MsgPopup(
					msg,
					"AppData/logs/DumpedText.txt",
					nil,
					nil,
					obj
				)
				return
			end

			local msg = Strings[302535920000003--[[Can't dump nothing--]]] .. ": " .. name .. "\n" .. ValueToLuaCode(obj)
			print(msg)
			MsgPopup(
				msg,
				Strings[302535920000004--[[Dump--]]]
			)

		end
	end --do

	-- write logs funcs
	do -- WriteLogs_Toggle
		local Dump = ChoGGi.ComFuncs.Dump
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
		local timer = testing and 2500 or 5000
		-- we always start off with a newline so the first line or so isn't merged
		local buffer_table = {newline}
		local buffer_cnt = 1

		if rawget(_G,"ChoGGi_print_buffer_thread") then
			DeleteThread(ChoGGi_print_buffer_thread)
		end
		ChoGGi_print_buffer_thread = CreateRealTimeThread(function()
			while true do
				Sleep(timer)
				if buffer_cnt > 1 then
					Dump(TableConcat(buffer_table,newline),nil,"Console","log",true)
					table_iclear(buffer_table)
					buffer_table[1] = newline
					buffer_cnt = 1
				end
			end
		end)

		local function ReplaceFunc(funcname,mask)
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

				-- i have no idea why the devs consider this an error?
				if mask == 1 and ... == "Attempt to use an undefined global '" then
					return
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
				ChoGGi.ComFuncs.BlacklistMsg("ChoGGi.ComFuncs.WriteLogs_Toggle")
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
				ReplaceFunc("error",1)
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
			title:SetBackground(red)
			Sleep(500)
			title:SetBackground(ChoGGi_MoveControl.Background)
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

			if parent ~= "str" and not IsKindOf(parent,"XWindow") then
				parent = nil
			end
			if type(title) ~= "string" then
				title = nil
			end

			return Examine:new({}, terminal.desktop,{
				obj = obj,
				parent = parent,
				title = title,
			})
		end

		-- what i access with ECM/Lib
		ChoGGi.ComFuncs.OpenInExamineDlg = OpenInExamineDlg
		-- legacy (and used for console rules, so we can get around it spamming the log)
		function OpenExamine(...)
			OpenInExamineDlg(...)
		end
		-- short n sweet
		ex = OpenExamine
	end -- do

	function ChoGGi.ComFuncs.OpenInMonitorInfoDlg(list,parent)
		if type(list) ~= "table" then
			return
		end

		if not IsKindOf(parent,"XWindow") then
			parent = nil
		end

		return ChoGGi_MonitorInfoDlg:new({}, terminal.desktop,{
			obj = list,
			parent = parent,
			tables = list.tables,
			values = list.values,
		})
	end

	function ChoGGi.ComFuncs.OpenInObjectEditorDlg(obj,parent)
		-- if fired from action menu
		if IsKindOf(obj,"XAction") then
			obj = ChoGGi.ComFuncs.SelObject()
			parent = nil
		else
			obj = obj or ChoGGi.ComFuncs.SelObject()
		end

		if not obj then
			return
		end

		if not IsKindOf(parent,"XWindow") then
			parent = nil
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

		if not IsKindOf(parent,"XWindow") then
			parent = nil
		end

		return ChoGGi_3DManipulatorDlg:new({}, terminal.desktop,{
			obj = obj,
			parent = parent,
		})
	end

	function ChoGGi.ComFuncs.OpenInExecCodeDlg(context,parent)
		if not IsKindOf(parent,"XWindow") then
			parent = nil
		end

		return ChoGGi_ExecCodeDlg:new({}, terminal.desktop,{
			obj = context,
			parent = parent,
		})
	end

	function ChoGGi.ComFuncs.OpenInFindValueDlg(context,parent)
		if not context then
			return
		end

		if not IsKindOf(parent,"XWindow") then
			parent = nil
		end

		return ChoGGi_FindValueDlg:new({}, terminal.desktop,{
			obj = context,
			parent = parent,
		})
	end

	do -- OpenInImageViewerDlg
		local function OpenInImageViewerDlg(obj,parent)
			if not obj then
				return
			end

			if not IsKindOf(parent,"XWindow") then
				parent = nil
			end

			return ChoGGi_ImageViewerDlg:new({}, terminal.desktop,{
				obj = obj,
				parent = parent,
			})
		end
		ChoGGi.ComFuncs.OpenInImageViewerDlg = OpenInImageViewerDlg

		-- used for console rules, so we can get around it spamming the log
		function ChoGGi.Temp.OpenInImageViewer(...)
			OpenInImageViewerDlg(...)
		end

	end -- do

	function ChoGGi.ComFuncs.OpenInDTMSlotsDlg(parent)
		-- if fired from action menu
		if parent and (IsKindOf(parent,"XAction") or not IsKindOf(parent,"XWindow")) then
			parent = nil
		end

		return ChoGGi_DTMSlotsDlg:new({}, terminal.desktop,{
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
		-- if fired from action menu
		if IsKindOf(obj,"XAction") then
			if obj.setting_planning then
				planning = true
			else
				planning = nil
			end
			obj = nil
			skip_msg = nil
			list_type = nil
		end

		local const = const

		local title = planning and Strings[302535920000862--[[Object Planner--]]] or Strings[302535920000475--[[Entity Spawner--]]]
		local hint = planning and Strings[302535920000863--[[Places fake construction site objects at mouse cursor (collision disabled).--]]] or Strings[302535920000476--[["Shows list of objects, and spawns at mouse cursor."--]]]

		local default
		local item_list = {}
		local c = 0

		if IsValid(obj) and IsValidEntity(obj.ChoGGi_orig_entity) then
			default = Translate(1000121--[[Default--]])
			item_list[1] = {
				text = " " .. default,
				value = default,
			}
			c = #item_list
		end

		if planning then
			local BuildingTemplates = BuildingTemplates
			for key,value in pairs(BuildingTemplates) do
				c = c + 1
				item_list[c] = {
					text = key,
					value = value.entity,
				}
			end
		else
			local all_entities = GetAllEntities()
			for key in pairs(all_entities) do
				c = c + 1
				item_list[c] = {
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
					choice[1].text .. ": " .. Strings[302535920000014--[[Spawned--]]],
					title
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = title,
			hint = hint,
			custom_type = list_type or 0,
		}
	end

	function ChoGGi.ComFuncs.SetAnimState(obj)
		-- if fired from action menu
		if IsKindOf(obj,"XAction") then
			obj = ChoGGi.ComFuncs.SelObject()
		else
			obj = obj or ChoGGi.ComFuncs.SelObject()
		end

		if not IsValid(obj) then
			return
		end

		local item_list = {}
		local states_str = obj:GetStates()
		local states_num = EnumValidStates(obj)

		if testing and #states_str ~= #states_num then
			print("SetAnimState: Different state amounts")
		end

		for i = 1, #states_str do
			local state = states_str[i]
			local idx = states_num[i]
			item_list[i] = {
				text = Translate(1000037--[[Name--]]) .. ": " .. state .. ", " .. Strings[302535920000858--[[Index--]]] .. ": " .. idx,
				value = state,
			}
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end

			local value = choice[1].value
			-- if user wants to play it again we'll need to have it set to another state and everything has idle
			obj:SetState("idle")

			if value ~= "idle" then
				obj:SetState(value)
				MsgPopup(
					ChoGGi.ComFuncs.SettingState(choice[1].text),
					Strings[302535920000859--[[Anim State--]]]
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = Strings[302535920000860--[[Set Anim State--]]],
			hint = Strings[302535920000861--[[Current State: %s--]]]:format(obj:GetState()),
			custom_type = 7,
		}
	end

	function ChoGGi.ComFuncs.MonitorThreads()
		if blacklist then
			ChoGGi.ComFuncs.BlacklistMsg("ChoGGi.ComFuncs.MonitorThreads")
			return
		end

		local table_list = {}
		local dlg = ChoGGi.ComFuncs.OpenInExamineDlg(table_list,nil,Strings[302535920000853--[[Monitor--]]] .. ": ThreadsRegister")
		dlg:EnableAutoRefresh()

		CreateRealTimeThread(function()
			-- stop when dialog is closed
			local ThreadsRegister = ThreadsRegister
			while dlg and dlg.window_state ~= "destroying" do
				table_clear(table_list)
				local c = 0
				for thread in pairs(ThreadsRegister) do
					local info = debug_getinfo(thread, 1, "S")
					if info then
						-- we use <tags *num*> as a way to hide the num but still have it there for a unique string
						c = c + 1
						table_list[info.source .. "(" .. info.linedefined .. ")<tags " .. c .. ">"] = thread
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
		local PadNumWithZeros = ChoGGi.ComFuncs.PadNumWithZeros

		CreateRealTimeThread(function()
			-- stop when dialog is closed
			while dlg and dlg.window_state ~= "destroying" do
				table_clear(table_list)

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

	function ChoGGi.ComFuncs.SetParticles(obj)
		-- if fired from action menu
		if IsKindOf(obj,"XAction") then
			obj = ChoGGi.ComFuncs.SelObject()
		else
			obj = obj or ChoGGi.ComFuncs.SelObject()
		end

		local name = Strings[302535920000129--[[Set--]]] .. " " .. Strings[302535920001184--[[Particles--]]]
		if not obj or obj and not obj:IsKindOf("FXObject") then
			MsgPopup(
				Strings[302535920000027--[[Nothing selected--]]] .. ": " .. "FXObject",
				name
			)
			return
		end

		local PlayFX = PlayFX
		-- make a list of spot names for the obj, so we skip particles that need that spot
		local spots = {}
		local id_start, id_end = obj:GetAllSpots(obj:GetState())
		for i = id_start, id_end do
			spots[obj:GetSpotName(i)] = true
		end

		local default = Translate(1000121--[[Default--]])

		local item_list = {
			{text = " " .. default,value = default},
		}
		local c = #item_list

		local dupes = {}

		local particles = FXLists.ActionFXParticles
		for i = 1, #particles do
			local p = particles[i]
			local name = p.Actor .. ", " .. p.Action .. ", " .. p.Moment
			if not dupes[name] then
				dupes[name] = true
				if spots[p.Spot] or p.Spot == "" then
					c = c + 1
					item_list[c] = {
						text = name,
						value = p.Actor,
						action = p.Action,
						moment = p.Moment,
						handle = p.handle,
						index = i,
						hint = "Actor: " .. p.Actor .. ", Action: " .. p.Action .. ", Moment: " .. p.Moment,
					}
				end
			end
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			choice = choice[1]
			local actor = choice.value
			local action = choice.action
			local moment = choice.moment

			-- if there's one playing then stop it
			if obj.ChoGGi_playing_fx then
				PlayFX(obj.ChoGGi_playing_fx, "end", obj)
				if obj.DestroyFX then
					obj:DestroyFX(obj,obj.ChoGGi_playing_fx)
				end
				obj.ChoGGi_playing_fx = nil
			end
			-- save fx id so we can stop it
			obj.ChoGGi_playing_fx = action

			if obj.fx_actor_class_ChoGGi_Orig == nil then
				obj.fx_actor_class_ChoGGi_Orig = obj.fx_actor_class
			end

			obj.fx_actor_class = actor

			particles[choice.index].Actor = "any"

			if actor == default then
				if obj.fx_actor_class_ChoGGi_Orig then
					obj.fx_actor_class = obj.fx_actor_class_ChoGGi_Orig
					obj.fx_actor_class_ChoGGi_Orig = nil
				end
				obj.ChoGGi_playing_fx = nil
			else
				PlayFX(action, moment, obj)
			end

			MsgPopup(
				action,
				name
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = name,
			hint = Strings[302535920001421--[[Shows list of particles to quickly test out on objects.--]]],
			custom_type = 7,
			skip_icons = true,
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
			print(Strings[302535920000692--[[Log is blank (well not anymore).--]]])
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

			-- size n position
			local size = ChoGGi.UserSettings.ConsoleLogWin_Size
			local pos = ChoGGi.UserSettings.ConsoleLogWin_Pos
			-- make sure dlg is within screensize
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
			ChoGGi.ComFuncs.BlacklistMsg("ChoGGi.ComFuncs.ConvertImagesToLogoFiles")
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
						print("ShowMessage",Translate(title),Translate(msg))
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
--~ 			cmdline = [["]] .. ConvertToOSPath(g_HgimgcvtPath) .. [[" "]] .. texture_output .. [[" "]] .. ui_output .. [["]]
--~ 			err = AsyncExec(cmdline, "", true, false)
--~ 			if err then
--~ 				return err
--~ 			end

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
				ChoGGi.ComFuncs.BlacklistMsg("ChoGGi.ComFuncs.ConvertImagesToResEntities")
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
		local spots_str = [[		<attach name="%s" spot_note="%s" bone="%s" spot_pos="%s,%s,%s" spot_scale="%s" spot_rot="%s,%s,%s,%s"/>]]

--~ local list = ChoGGi.ComFuncs.ExamineEntSpots(s,true)
--~ list = ChoGGi.ComFuncs.TableConcat(list,"\n")
--~ ChoGGi.ComFuncs.Dump(list,nil,nil,"ent")
		function ChoGGi.ComFuncs.ExamineEntSpots(obj,parent_or_ret)
			-- if fired from action menu
			if IsKindOf(obj,"XAction") then
				obj = ChoGGi.ComFuncs.SelObject()
				parent_or_ret = nil
			else
				obj = obj or ChoGGi.ComFuncs.SelObject()
			end

			local entity = obj and obj.GetEntity and obj:GetEntity()
			if not IsValidEntity(entity) then
				return
			end

			local origin = obj:GetSpotBeginIndex("Origin")
			local origin_pos_x, origin_pos_y, origin_pos_z = obj:GetSpotLocPosXYZ(origin)
			local id_start, id_end = obj:GetAllSpots(EntityStates.idle)

			CreateGameTimeThread(function()

			local list = {}
			local c = #list

			-- loop through each state and add sections for them
			local states_str = obj:GetStates()
			local states_num = EnumValidStates(obj)
			for i = 1, #states_str do
				local state_str = states_str[i]
				local state_num = states_num[i]
				obj:SetState(state_str)
				-- till i find something where the channel isn't 1
				while obj:GetAnim(1) ~= state_num do
					WaitMsg("OnRender")
				end

				-- this is our bonus eh
				local bbox = obj:GetEntityBBox()
				local x1,y1,z1 = bbox:minxyz()
				local x2,y2,z2 = bbox:maxxyz()
				local pos_x, pos_y, pos_z, radius = obj:GetBSphere(state_str, true)
--~ Basketball_idle.hga
				c = c + 1
				list[c] = [[	<state id="]] .. state_str .. [[">
		<mesh_ref ref="mesh"/>
		<anim file="]] .. entity .. "_" .. state_str .. [[.hga" duration="]] .. obj:GetAnimDuration(state_str) .. [["/>
		<bsphere value="]] .. (pos_x - origin_pos_x) .. ","
					.. (pos_y - origin_pos_y) .. "," .. (pos_z - origin_pos_z) .. ","
					.. radius .. [["/>
		<box min="]] .. x1 .. "," .. y1 .. "," .. z1
					.. [[" max="]] .. x2 .. "," .. y2 .. "," .. z2 .. [["/>
	</state>]]
			end -- for states

			local mat = GetStateMaterial(entity,0,0)
			-- add the rest of the entity info
			c = c + 1
			list[c] = [[	<mesh_description id="mesh">
		<mesh file="]] .. mat:sub(1,-4) .. [[m.hgm"/>
		<material file="]] .. mat .. [["/>]]
			-- eh, close enough

			-- stick with idle i guess?
			obj:SetState("idle")
			while obj:GetAnim(1) ~= 0 do
				WaitMsg("OnRender")
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

				-- axis,scale
				local _,_,_,_,axis_x,axis_y,axis_z = obj:GetSpotLocXYZ(i)

				-- 100 is default
				local scale = obj:GetSpotVisualScale(i)
				if scale == 100 then
					spots_str_t = spots_str_t:gsub([[ spot_scale="%%s"]],"%%s")
					scale = ""
				end

				local angle = obj:GetSpotVisualRotation(i)
				-- means nadda for spot_rot
				if angle == 0 and axis_x == 0 and axis_y == 0 and axis_z == 4096 then
					spots_str_t = spots_str_t:gsub([[ spot_rot="%%s,%%s,%%s,%%s"]],"%%s%%s%%s%%s")
					angle,axis_x,axis_y,axis_z = "","","",""
				else
					axis_x = (axis_x + 0.0) / 100
					axis_y = (axis_y + 0.0) / 100
					axis_z = (axis_z + 0.0) / 100
					angle = (angle) / 60
--~ 					if angle > 360 then
--~ 						printC("ExamineEntSpots: angle > 360: ",angle)
--~ 						-- just gotta figure out how to turn 18000 or 3600 into 60 (21600)
--~ 						angle = 360 - angle
--~ 					end
				end

				local pos_x,pos_y,pos_z = obj:GetSpotPosXYZ(i)

				c = c + 1
				list[c] = spots_str_t:format(
					name,annot,bone,
					pos_x - origin_pos_x,pos_y - origin_pos_y,pos_z - origin_pos_z,
					scale,axis_x,axis_y,axis_z,angle
				)
			end -- for spots

			-- opener
			table.insert(list,1,Strings[302535920001068--[["The func I use for spot_rot rounds to two decimal points... (let me know if you find a better one).
Attachment bspheres are off (x and y are; z and rotate aren't).
Some of the file names are guesses. This also doesn't include any surf/surf_hash entries."--]]]
				.. [[


<?xml version="1.0" encoding="UTF-8"?>
<entity path="">]])
			-- and the closer
			list[#list+1] = [[	</mesh_description>
</entity>]]

			if parent_or_ret == true then
				return TableConcat(list,"\n")
			else
				ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
					parent = parent_or_ret,
					text = TableConcat(list,"\n"),
					title = Strings[302535920000235--[[Entity Spots--]]] .. ": " .. RetName(obj),
				}
			end

			end)
		end
	end -- do

	do -- RetHexSurfaces
		local GetStates = GetStates
		local GetStateIdx = GetStateIdx
		local GetSurfaceHexShapes = GetSurfaceHexShapes
		local EntitySurfaces = EntitySurfaces

		local function AddToList(filter,list,c,shape,name,key,value,state,hash)
			if shape and (not filter or filter and #shape > 0) then
				c = c + 1
				list[c] = {
					name = name,
					shape = shape,
					id = key,
					mask = value,
					state = state,
					hash = hash,
				}
			end
			return c
		end

		function ChoGGi.ComFuncs.RetHexSurfaces(entity,filter,parent_or_ret)
			local list = {}
			local c = 0

			local all_states = GetStates(entity)
			for i = 1, #all_states do
				local state = GetStateIdx(all_states[i])
				for key,value in pairs(EntitySurfaces) do
					local outline, interior, hash = GetSurfaceHexShapes(entity, state, value)
					c = AddToList(filter,list,c,outline,"outline",key,value,state,hash)
					c = AddToList(filter,list,c,interior,"interior",key,value,state,hash)
				end
			end

			if parent_or_ret == true then
				return list
			else
				ChoGGi.ComFuncs.OpenInExamineDlg(list,nil,"RetHexSurfaces")
			end
		end
	end -- do

	do -- ObjFlagsList
--~ 		local IsFlagSet = IsFlagSet
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
		local function CheckFlags(flags,obj,func_name)
			local get = "Get" .. func_name
			local set = "Set" .. func_name
			local clear = "Clear" .. func_name
			local us = ChoGGi.UserSettings

			for i = 1, #flags do
				local f = flags[i]
				local mask = const[f]
				local flagged = obj[get](obj,mask) == mask
				if func_name == "ClassFlags" then
					flags_table[f .. " (" .. mask .. ")"] = flagged
				else
					flags_table[f .. " (" .. mask .. ")"] = {
						ChoGGi_AddHyperLink = true,
						hint = Strings[302535920001069--[[Toggle Boolean--]]],
						name = tostring(flagged),
						colour = flagged and us.ExamineColourBool or us.ExamineColourBoolFalse,
						func = function(ex_dlg,_,list_obj)
							-- if flag is true
							if obj[get](obj,mask) == mask then
								obj[clear](obj,mask)
								list_obj.name = "false"
								list_obj.colour = us.ExamineColourBoolFalse
							else
								obj[set](obj,mask)
								list_obj.name = "true"
								list_obj.colour = us.ExamineColourBool
							end
							ex_dlg:RefreshExamine()
						end,
					}
				end
			end
		end

		function ChoGGi.ComFuncs.ObjFlagsList_TR(obj,parent_or_ret)
			if not obj or obj.__name ~= "HGE.TaskRequest" then
				return
			end
			flags_table = {}

			for flag,value in pairs(rf_flags) do
				flags_table[flag .. " (" .. value .. ")"] = obj:IsAnyFlagSet(value)
			end

			if parent_or_ret == true then
				return flags_table
			else
				ChoGGi.ComFuncs.OpenInExamineDlg(flags_table,parent_or_ret,RetName(obj))
			end
		end

		function ChoGGi.ComFuncs.ObjFlagsList(obj,parent_or_ret)
			-- if fired from action menu
			if IsKindOf(obj,"XAction") then
				obj = ChoGGi.ComFuncs.SelObject()
				parent_or_ret = nil
			else
				obj = obj or ChoGGi.ComFuncs.SelObject()
			end

			if not IsValid(obj) then
				return
			end

			flags_table = {}

			local Flags = Flags
			CheckFlags(Flags.Enum,obj,"EnumFlags")
			CheckFlags(Flags.Game,obj,"GameFlags")
			CheckFlags(Flags.Class,obj,"ClassFlags")

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

		local channel_list = {
			RM = true,
			BaseColor = true,
			Dust = true,
			AO = true,
			Normal = true,
			Colorization = true,
			SI = true,
			RoughnessMetallic = true,
			Emissive = true,
		}
		local mtl_lookup = {
			AO = [[		<AmbientOcclusionMap Name="%s" mc="%s"/>]],
			BaseColor = [[		<BaseColorMap Name="%s" mc="%s"/>]],
			Colorization = [[		<ColorizationMap Name="%s" mc="%s"/>]],
			Dust = [[		<DustMap Name="%s" mc="%s"/>]],
			Emissive = [[		<EmissiveMap Name="%s" mc="%s"/>]],
			Normal = [[		<NormalMap Name="%s" mc="%s"/>]],
			RM = [[		<RMMap Name="%s" mc="%s"/>]],
			RoughnessMetallic = [[		<RoughnessMetallicMap Name="%s" mc="%s"/>]],
			SI = [[		<SIMap Name="%s" mc="%s"/>]],

			alphatest = [[		<Property AlphaTest="%s"/>]],
			animation_frames_x = [[		<Property AnimationFramesX="%s"/>]],
			animation_frames_y = [[		<Property AnimationFramesY="%s"/>]],
			animation_time = [[		<Property AnimationTime="%s"/>]],
			blend = [[		<Property AlphaBlend="%s"/>]],
			castshadow = [[		<Property CastShadow="%s"/>]],
			deposition = [[		<Property Deposition="%s"/>]],
			depthsmooth = [[		<Property DepthSmooth="%s"/>]],
			depthwrite = [[		<Property DepthWrite="%s"/>]],
			distortion = [[		<Property Distortion="%s"/>]],
			opacity = [[		<Property Opacity="%s"/>]],
			special = [[		<Property Special="%s"/>]],
			terraindistorted = [[		<Property TerrainDistortedMesh="%s"/>]],
			transparentdecal = [[		<Property TransparentDecal="%s"/>]],
			twosidedshading = [[		<Property TwoSidedShading="%s"/>]],
			wind = [[		<Property Wind="%s"/>]],

--~ 			XX = [[		<Property Anisotropic="%s"/>]],
--~ 			XX = [[		<Property DtmDisable="%s"/>]],
--~ 			XX = [[		<Property EnvMapped="%s"/>]],
--~ 			XX = [[		<Property GlossColor="%s"/>]],
--~ 			XX = [[		<Property MarkVolume="%s"/>]],
--~ 			XX = [[		<Property MaskedCM="%s"/>]],
--~ 			XX = [[		<Property NoDiffuse="%s"/>]],
--~ 			XX = [[		<Property NumInstances="%s"/>]],
--~ 			XX = [[		<Property SelfIllum="%s"/>]],
--~ 			XX = [[		<Property ShadowBlob="%s"/>]],
--~ 			XX = [[		<Property SpecularPower="%s"/>]],
--~ 			XX = [[		<Property SpecularPowerRGB="%s"/>]],
--~ 			XX = [[		<Property StretchFactor1="%s"/>]],
--~ 			XX = [[		<Property StretchFactor2="%s"/>]],
--~ 			XX = [[		<Property SunFacingShading="%s"/>]],
--~ 			XX = [[		<Property TexScrollTime="%s"/>]],
--~ 			XX = [[		<Property Translucency="%s"/>]],
--~ 			XX = [[		<Property TwoSided="%s"/>]],
--~ 			XX = [[		<Property UnitLighting="%s"/>]],
--~ 			XX = [[		<Property UOffset="%s"/>]],
--~ 			XX = [[		<Property USize="%s"/>]],
--~ 			XX = [[		<Property ViewDependentOpacity="%s"/>]],
--~ 			XX = [[		<Property VOffset="%s"/>]],
--~ 			XX = [[		<Property VSize="%s"/>]],
		}

		local function CleanupMTL(mat,list,c)
			list = list or {}
			c = c or #list

			for key,value in pairs(mat) do
				if value == true then
					value = 1
				elseif value == false then
					value = 0
				end

				local mtl = mtl_lookup[key]
				if mtl then
					if channel_list[key] then
						if value ~= "" then
							c = c + 1
							list[c] = mtl:format(value,mat[key .. "Channel"])
						end
					else
						c = c + 1
						list[c] = mtl:format(value)
					end
				end

			end
			return list,c
		end

		local function RetEntityMTLFile(mat)
			local list = {[[<?xml version="1.0" encoding="UTF-8"?>
<Materials>
	<Material>]]}
			local c = #list

			-- build main first
			list,c = CleanupMTL(mat,list,c)
			c = c + 1
			list[c] = [[	</Material>]]

			-- add any sub materials
			for key,sub_mat in pairs(mat) do
				if type(key) == "string" and key:sub(1,19) == "_sub_material_index" then
					c = c + 1
					list[c] = [[	<Material>]]
					list,c = CleanupMTL(sub_mat,list,c)
					c = c + 1
					list[c] = [[	</Material>]]
				end
			end

			c = c + 1
			list[c] = [[</Materials>]]

			return TableConcat(list,"\n")
		end
		ChoGGi.ComFuncs.RetEntityMTLFile = RetEntityMTLFile

		local function ExamineExportMat(ex_dlg,mat)
			ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
				parent = ex_dlg,
				text = RetEntityMTLFile(mat),
				title = Strings[302535920001458--[[Material Properties--]]] .. ": " .. mat.__mtl,
			}
		end

		local function RetEntityMats(entity,skip)
			-- some of these funcs can crash sm, so lets make sure it's valid
			if not skip and not IsValidEntity(entity) then
				return
			end

			local mats = {}
			local states = GetStates(entity) or ""
			for si = 1, #states do
				local state_str = states[si]
				local state = GetStateIdx(state_str)
				local num_lods = GetStateLODCount(entity, state) or 0
				for li = 1, num_lods do
					local num_mats = GetStateNumMaterials(entity, state, li - 1) or 0
					for mi = 1, num_mats do
						local mat_name = GetStateMaterial(entity,state,mi - 1,li - 1)
						local mat = GetMaterialProperties(mat_name,0)

						-- add any sub materials
						local c = 1
						while true do
							local extra = GetMaterialProperties(mat_name,c)
							if not extra then
								break
							end
							mat["_sub_material_index" .. c] = extra
							c = c + 1
						end

						mat.__mtl = mat_name
						mat.__lod = li
						mat.__state = li
						mat[1] = {
							ChoGGi_AddHyperLink = true,
							hint = Strings[302535920001174--[[Show an example .mtl file for this material (not complete).--]]],
							name = Strings[302535920001177--[[Generate .mtl--]]],
							func = function(ex_dlg)
								ExamineExportMat(ex_dlg,mat)
							end,
						}

						mats[mat_name .. ", Mat: " .. mi .. ", LOD: " .. li .. ", State: " .. state_str .. " (" .. state .. ")"] = mat
					end
				end
			end

			return mats
		end
		ChoGGi.ComFuncs.RetEntityMats = RetEntityMats

		function ChoGGi.ComFuncs.GetMaterialProperties(obj,parent_or_ret)
			if not UICity then
				return
			end

			-- if fired from action menu
			if IsKindOf(obj,"XAction") then
				obj = ChoGGi.ComFuncs.SelObject()
				parent_or_ret = nil
			else
				obj = obj or ChoGGi.ComFuncs.SelObject()
			end

			local materials

			if IsValidEntity(obj) then
				materials = RetEntityMats(obj,true)
			else
				local entity = obj and obj.GetEntity and obj:GetEntity()
				if IsValidEntity(entity) then
					materials = RetEntityMats(entity,true)
				else
					materials = {}
					local all_entities = GetAllEntities()
					for entity in pairs(all_entities) do
						materials[entity] = RetEntityMats(entity,true)
					end
				end
			end


			if parent_or_ret == true then
				return materials
			else
				ChoGGi.ComFuncs.OpenInExamineDlg(materials,parent_or_ret,Strings[302535920001458--[[Material Properties--]]])
			end

		end
	end -- do

	do -- DisplayObjectImages
		local CmpLower = CmpLower
		local getmetatable = getmetatable
		local images_table
		local ImageExts = ChoGGi.ComFuncs.ImageExts

		-- grab any strings with the correct ext
		local function AddToList(c,key,value)
			if type(value) == "string" and ImageExts()[value:sub(-3):lower()] then
				local dupe_test = key .. value

				if not images_table.dupes[dupe_test] then
					c = c + 1
					images_table[c] = {
						name = key,
						path = value,
					}
					images_table.dupes[dupe_test] = true
				end
			end
			return c
		end

		function ChoGGi.ComFuncs.DisplayObjectImages(obj,parent,images)
			images_table = images or {
				dupes = {},
			}
			if type(obj) ~= "table" then
				return #images_table > 0
			end
			local c = #images_table

			-- and images
			for key,value in pairs(obj) do
				c = AddToList(c,key,value)
			end
			-- any meta images
			local meta = getmetatable(obj)
			while meta do
				for key,value in pairs(meta) do
					c = AddToList(c,key,obj[key] or value)
				end
				meta = getmetatable(meta)
			end

			-- and sort
			if #images_table > 0 then
				ChoGGi.ComFuncs.TableCleanDupes(images_table)
				table_sort(images_table, function(a, b)
					return CmpLower(a.name, b.name)
				end)
				ChoGGi.ComFuncs.OpenInImageViewerDlg(images_table,parent)
				return true
			end
			return false

		end
	end -- do

	do -- CleanInfoAttachDupes
		local DoneObject = DoneObject
		local dupe_list = {}

		function ChoGGi.ComFuncs.CleanInfoAttachDupes(list,cls)
			table_clear(dupe_list)

			-- clean up dupes in order of older
			for i = 1, #list do
				local mark = list[i]
				if not cls or cls and mark:IsKindOf(cls) then

					local pos = tostring(mark:GetVisualPos())
					local dupe = dupe_list[pos]
					if dupe then
						DoneObject(dupe)
						dupe_list[pos] = mark
					else
						dupe_list[pos] = mark
					end

				end
			end

			-- remove removed items
			list:Validate()
		end
	end -- do

	do -- BBoxLines_Toggle
		local point = point
		local objlist = objlist
		local IsBox = IsBox

		-- stores objlist of line objects
		local bbox_lines

		local function SpawnBoxLine(bbox, list, depth_test, colour)
			local line = PlacePolyline(list, colour)
			if depth_test then
				line:SetDepthTest(true)
			end
			line:SetPos(bbox:Center())
			bbox_lines[#bbox_lines+1] = line
		end
		local pillar_table = objlist:new()
		local function SpawnPillarLine(pt, z, obj_height, depth_test, colour)
			pillar_table:Destroy()
			pillar_table[1] = pt:SetZ(z)
			pillar_table[2] = pt:SetZ(z + obj_height)
			local line = PlacePolyline(pillar_table, colour)
			if depth_test then
				line:SetDepthTest(true)
			end
			line:SetPos(AveragePoint2D(line.vertices):SetZ(z))
			bbox_lines[#bbox_lines+1] = line
		end

		local function PlaceTerrainBox(bbox, pos, depth_test, colour)
			local obj_height = bbox:sizez() or 1500
			local z = pos:z()
			-- stores all line objs for deletion later
			bbox_lines = objlist:new()

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
					SpawnPillarLine(edge, z, obj_height, depth_test, colour)
				end
				local x,y = edge:xy()
				points_top[#points_top + 1] = point(x, y, z + obj_height)
				points_bot[#points_bot + 1] = point(x, y, z)
			end
			SpawnBoxLine(bbox, points_top, depth_test, colour)
			SpawnBoxLine(bbox, points_bot, depth_test, colour)

			--[[
			-- make bbox follow ground height
			for i = 1, #edges - 1 do

				local pt1 = edges[i]
				local pt2 = edges[i + 1]
				local diff = pt2 - pt1
				local steps = Max(2, 1 + diff:Len2D() / step)

				for j = 1, steps do
					local pos = pt1 + MulDivRound(diff, j - 1, steps - 1)
					points_top[#points_top + 1] = pos:SetTerrainZ(offset + obj_height)
					points_bot[#points_bot + 1] = pos:SetTerrainZ(offset)
				end

				-- ... extra lines?
				-- this is what i get for not commenting it the first time.
				points_bot[#points_bot] = nil
				points_top[#points_top] = nil
			end

			SpawnBoxLine(bbox_lines, bbox, points_top, colour)
			SpawnBoxLine(bbox_lines, bbox, points_bot, colour)
			--]]

			return bbox_lines
		end
		local function BBoxLines_Clear(obj,is_box)
			if not is_box and obj.ChoGGi_bboxobj then
				obj.ChoGGi_bboxobj:Destroy()
				obj.ChoGGi_bboxobj = nil
				return true
			end
		end
		ChoGGi.ComFuncs.BBoxLines_Clear = BBoxLines_Clear

		function ChoGGi.ComFuncs.BBoxLines_Toggle(obj,params)
			params = params or {}
			obj = obj or ChoGGi.ComFuncs.SelObject()
			local is_box = IsBox(obj)

			if not (IsValid(obj) or is_box) or (BBoxLines_Clear(obj,is_box) and not params.skip_return) then
				return
			end

			-- go forth
			local bbox
			if is_box then
				bbox = obj
			else
				local func = params.func
				local args = params.args
				if func then
					-- check for func in _G or g_CObjectFuncs
					local func_obj
					if rawget(_G,func) then
						func_obj = _G[func]
					elseif g_CObjectFuncs[func] then
						func_obj = g_CObjectFuncs[func]
					end
					-- if it didn't find a global func then we'll try a obj:func()
					if func_obj then
						bbox = func_obj(obj,args)
					else
						bbox = obj[func] and obj[func](obj,args)
					end
				end

				-- fallback
				if not bbox then
					bbox = ObjectHierarchyBBox(obj,const.efCollision)
					if not bbox:sizez() then
						bbox = obj:GetObjectBBox()
					end
				end
			end

			if bbox then
				local box = PlaceTerrainBox(
					bbox,
					bbox:Center():SetTerrainZ(),
					params.depth_test,
					params.colour or RandomColourLimited()
				)
				if not is_box then
					obj.ChoGGi_bboxobj = box
				end
				return box
			end
		end
	end -- do

	do -- SurfaceLines_Toggle
		local GetRelativeSurfaces = GetRelativeSurfaces

		local function BuildLines(obj,params)
			local surfs = params.surfs or GetRelativeSurfaces(obj,params.surface_mask or 0)
			local c = #obj.ChoGGi_surfacelinesobj

			for i = 1, #surfs do
				local group = surfs[i]
				-- connect the lines
				group[#group+1] = group[1]

				local line = PlacePolyline(group, params.colour)
				if params.depth_test then
					line:SetDepthTest(true)
				end
				line:SetPos(AveragePoint2D(line.vertices):SetZ(group[1]:z()+params.offset))
				c = c + 1
				obj.ChoGGi_surfacelinesobj[c] = line
			end

			return obj.ChoGGi_surfacelinesobj
		end

		local function SurfaceLines_Clear(obj)
			if obj.ChoGGi_surfacelinesobj then
				obj.ChoGGi_surfacelinesobj:Destroy()
				obj.ChoGGi_surfacelinesobj = nil
				return true
			end
		end
		ChoGGi.ComFuncs.SurfaceLines_Clear = SurfaceLines_Clear

		function ChoGGi.ComFuncs.SurfaceLines_Toggle(obj,params)

			params = params or {}
			local is_valid = IsValid(obj)
			if not is_valid or is_valid and not IsValidEntity(obj:GetEntity()) or not params.skip_return then
				return
			end
			if not params.skip_clear then
				if (SurfaceLines_Clear(obj) and not params.skip_return) then
					return
				end
			end

			obj.ChoGGi_surfacelinesobj = obj.ChoGGi_surfacelinesobj or objlist:new()

			params.colour = params.colour or RandomColourLimited()
			params.offset = params.offset or 1

			BuildLines(obj,params)

			ChoGGi.ComFuncs.CleanInfoAttachDupes(obj.ChoGGi_surfacelinesobj)
			return obj.ChoGGi_surfacelinesobj
		end
	end -- do

	function ChoGGi.ComFuncs.MoveObjToGround(obj)
		obj:SetZ(obj:GetVisualPos():SetTerrainZ())
	end

	function ChoGGi.ComFuncs.GetDesktopWindow(class)
		local desktop = terminal.desktop
		return desktop[table_find(desktop,"class",class)]
	end

	do -- RetThreadInfo/FindThreadFunc
		local GedInspectorFormatObject = GedInspectorFormatObject
		local function DbgGetlocal(thread,level)
			local list = {}
			local idx = 1
			while true do
				local name, value = debug_getlocal(thread, level, idx)
				if name == nil then
					break
				end
				list[idx] = {
					name = name ~= "" and name or Strings[302535920000723--[[Lua--]]],
					value = value,
					level = level,
				}
				idx = idx + 1
			end
			if next(list) then
				return list
			end
		end
		local function DbgGetupvalue(info)
			local list = {}
			local idx = 1
			while true do
				local name, value = debug_getupvalue(info.func, idx)
				if name == nil then
					break
				end
				list[idx] = {
					name = name ~= "" and name or Strings[302535920000723--[[Lua--]]],
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
			local funcs = {}

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
							temp.name = n ~= "unknown name" and n or Strings[302535920000723--[[Lua--]]]
						end
					end

					funcs[i] = temp
				end

			else
				funcs.gethook = debug_gethook(thread)

				local info = debug_getinfo(thread,0,"Slfunt")
				if info then
					local nups = info.nups
					if nups > 0 then
						-- we start info at 0, nups starts at 1
						nups = nups + 1

						for i = 0, nups do
							local info_got = debug_getinfo(thread,i)
							if info_got then
								local name = info_got.name or info_got.what or Strings[302535920000723--[[Lua--]]]
								funcs[i] = {
									name = name,
									func = info_got.func,
									level = i,
									getlocal = DbgGetlocal(thread,i),
									getupvalue = DbgGetupvalue(info_got),
								}
							end
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
				local info = debug_getinfo(obj)
				-- sub(2): removes @, Mars is ingame files, mods is mods...
				local src = info.source ~= "" and info.source or info.short_src
				return src:sub(2):gsub("Mars/",""):gsub("AppData/Mods/","")
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
				ChoGGi.ComFuncs.BlacklistMsg("ChoGGi.ComFuncs.RetSourceFile")
				return
			end
--[[
source: '@CommonLua/PropertyObject.lua'
~PropertyObject.Clone
source: '@Mars/Lua/LifeSupportGrid.lua'
~WaterGrid.RemoveElement
source: '@Mars/Dlc/gagarin/Code/RCConstructor.lua'
~RCConstructor.CanInteractWithObject

~ChoGGi.ComFuncs.RetSourceFile
~ModConfig.Set
--]]
			-- remove @
			local at = path:sub(1,1)
			if at == "@" then
				path = path:sub(2)
			end

			local err,code
			-- mods (we need to skip CommonLua else it'll open the luac file)
			local comlua = path:sub(1,10)
			if comlua ~= "CommonLua/" and FileExists(path) then
				err,code = AsyncFileToString(path)
				if not err then
					return code,path
				end
			end

			-- might as well return commonlua/dlc files...
			if path:sub(1,5) == "Mars/" then
				path = source_path .. path:sub(6)
				err,code = AsyncFileToString(path)
				if not err then
					return code,path
				end
			elseif comlua == "CommonLua/" then
				path = source_path .. path
				err,code = AsyncFileToString(path)
				if not err then
					return code,path
				end
			end

			return nil,(err and err .. "\n" or "") .. path

		end
	end -- do

	do -- ObjHexShape_Toggle
		local HexRotate = HexRotate
		local RotateRadius = RotateRadius
		local HexToWorld = HexToWorld
		local point = point

		local FallbackOutline = FallbackOutline
		local line_points = objlist:new()
		local radius = const.HexSize / 2

		-- function Dome:GenerateWalkablePoints() (mostly)
		local function BuildShape(obj,shape,depth_test,hex_pos,colour,offset)
			local dir = HexAngleToDirection(obj:GetAngle())
			local cq, cr = WorldToHex(obj)
			local z = obj:GetVisualPos():z() + offset

			local c = #obj.ChoGGi_shape_obj
			for i = 1, #shape do
				local sq, sr = shape[i]:xy()
				local q, r = HexRotate(sq, sr, dir)
				local center = point(HexToWorld(cq + q, cr + r)):SetZ(z)

				line_points:Destroy()
				for j = 1,6 do
					local x, y = RotateRadius(radius, j * 60 * 60, center, true)
					line_points[j] = point(x, y, z)
				end
				-- complete the hex
				line_points[7] = line_points[1]
				local line = PlacePolyline(line_points, colour)
				-- wall hax off
				if depth_test then
					line:SetDepthTest(true)
				end
				-- pos text
				if hex_pos then
					local text_obj = PlaceObject("ChoGGi_OText")
					if depth_test then
						text_obj:SetDepthTest(true)
					end
					text_obj:SetText(sq .. "," .. sr)
					text_obj:SetColor1(colour)
					-- slightly larger
					text_obj:SetScaleInterpolation(110)

					line:Attach(text_obj)
				end
				line:SetPos(center)

				c = c + 1
				obj.ChoGGi_shape_obj[c] = line
			end
		end
		local function ObjHexShape_Clear(obj)
			if obj.ChoGGi_shape_obj then
				obj.ChoGGi_shape_obj:Destroy()
				obj.ChoGGi_shape_obj = nil
				return true
			end
		end
		ChoGGi.ComFuncs.ObjHexShape_Clear = ObjHexShape_Clear

		function ChoGGi.ComFuncs.ObjHexShape_Toggle(obj,params)
			params = params or {shape = FallbackOutline}
			if not IsValid(obj) or not params.skip_return then
				return
			end
			if not params.skip_clear then
				if (ObjHexShape_Clear(obj) and not params.skip_return) then
					return
				end
			end

			obj.ChoGGi_shape_obj = obj.ChoGGi_shape_obj or objlist:new()
			params.colour = params.colour or RandomColourLimited()
			params.offset = params.offset or 1

			BuildShape(
				obj,
				params.shape,
				params.depth_test,
				params.hex_pos,
				params.colour,
				params.offset
			)
			ChoGGi.ComFuncs.CleanInfoAttachDupes(obj.ChoGGi_shape_obj,"ChoGGi_OText")
			ChoGGi.ComFuncs.CleanInfoAttachDupes(obj.ChoGGi_shape_obj,"ChoGGi_OPolyline")

			return obj.ChoGGi_shape_obj
		end
	end -- do

	function ChoGGi.ComFuncs.RetSurfaceMasks(obj)

		if not IsValid(obj) then
			return
		end

		local list = {}

		local entity = obj:GetEntity()
		if not IsValidEntity(entity) then
			return list
		end

		local GetEntityNumSurfaces = GetEntityNumSurfaces

		local EntitySurfaces = EntitySurfaces
		for key,value in pairs(EntitySurfaces) do
			local surfs = GetEntityNumSurfaces(entity, value)
			local surf_bool = obj:HasAnySurfaces(value)

			if surfs > 0 then
				list[key .. " (mask: " .. value .. ", surfaces count: " .. surfs .. ")"] = surf_bool
			else
				list[key .. " (mask: " .. value .. ")"] = surf_bool
			end
		end
		return list
	end

	do -- ReturnTechAmount/GetResearchedTechValue
		--[[
		ReturnTechAmount(tech,prop)
		returns number from Object (so you know how much it changes)
		see: Data/Object.lua, or ex(Object)

		ReturnTechAmount("GeneralTraining","NonSpecialistPerformancePenalty")
		^returns 10
		ReturnTechAmount("SupportiveCommunity","LowSanityNegativeTraitChance")
		^ returns 0.7

		it returns percentages in decimal for ease of mathing (SM has no math. funcs)
		ie: SupportiveCommunity is -70 this returns it as 0.7
		it also returns negative amounts as positive (I prefer num - Amt, not num + NegAmt)
		--]]
		local function ReturnTechAmount(tech,prop)
			local techdef = TechDef[tech]
			local idx = table.find(techdef,"Prop",prop)
			if idx then
				tech = techdef[idx]
				local number

				-- With enemies you know where they stand but with Neutrals, who knows?
				-- defaults for the objects have both percent/amount, so whoever isn't 0 means something
				if tech.Percent == 0 then
					if tech.Amount < 0 then
						number = tech.Amount * -1 -- always gotta be positive
					else
						number = tech.Amount
					end
				-- probably just have an else here instead...
				elseif tech.Amount == 0 then
					if tech.Percent < 0 then
						tech.Percent = tech.Percent * -1 -- -50 > 50
					end
					number = (tech.Percent + 0.0) / 100 -- (50 > 50.0) > 0.50
				end

				return number
			end
		end
		ChoGGi.ComFuncs.ReturnTechAmount = ReturnTechAmount

		function ChoGGi.ComFuncs.GetResearchedTechValue(name,cls)
			local ChoGGi = ChoGGi
			local UICity = UICity

			if name == "SpeedDrone" then
				local move_speed = ChoGGi.Consts.SpeedDrone

				if UICity:IsTechResearched("LowGDrive") then
					local p = ReturnTechAmount("LowGDrive","move_speed")
					move_speed = move_speed + (move_speed * p)
				end
				if UICity:IsTechResearched("AdvancedDroneDrive") then
					local p = ReturnTechAmount("AdvancedDroneDrive","move_speed")
					move_speed = move_speed + (move_speed * p)
				end
				return move_speed
			end
			--
			if name == "MaxColonistsPerRocket" then
				local per_rocket = ChoGGi.Consts.MaxColonistsPerRocket
				if UICity:IsTechResearched("CompactPassengerModule") then
					local a = ReturnTechAmount("CompactPassengerModule","MaxColonistsPerRocket")
					per_rocket = per_rocket + a
				end
				if UICity:IsTechResearched("CryoSleep") then
					local a = ReturnTechAmount("CryoSleep","MaxColonistsPerRocket")
					per_rocket = per_rocket + a
				end
				return per_rocket
			end
			--
			if name == "FuelRocket" then
				if UICity:IsTechResearched("AdvancedMartianEngines") then
					local a = ReturnTechAmount("AdvancedMartianEngines","launch_fuel")
					return ChoGGi.Consts.LaunchFuelPerRocket - (a * ChoGGi.Consts.ResourceScale)
				end
				return ChoGGi.Consts.LaunchFuelPerRocket
			end
			--
			if name == "SpeedRC" then
				if UICity:IsTechResearched("LowGDrive") then
					local p = ReturnTechAmount("LowGDrive","move_speed")
					return ChoGGi.Consts.SpeedRC + ChoGGi.Consts.SpeedRC * p
				end
				return ChoGGi.Consts.SpeedRC
			end
			--
			if name == "CargoCapacity" then
				if UICity:IsTechResearched("FuelCompression") then
					local a = ReturnTechAmount("FuelCompression","CargoCapacity")
					return ChoGGi.Consts.CargoCapacity + a
				end
				return ChoGGi.Consts.CargoCapacity
			end
			--
			if name == "CommandCenterMaxDrones" then
				if UICity:IsTechResearched("DroneSwarm") then
					local a = ReturnTechAmount("DroneSwarm","CommandCenterMaxDrones")
					return ChoGGi.Consts.CommandCenterMaxDrones + a
				end
				return ChoGGi.Consts.CommandCenterMaxDrones
			end
			--
			if name == "DroneResourceCarryAmount" then
				if UICity:IsTechResearched("ArtificialMuscles") then
					local a = ReturnTechAmount("ArtificialMuscles","DroneResourceCarryAmount")
					return ChoGGi.Consts.DroneResourceCarryAmount + a
				end
				return ChoGGi.Consts.DroneResourceCarryAmount
			end
			--
			if name == "LowSanityNegativeTraitChance" then
				if UICity:IsTechResearched("SupportiveCommunity") then
					local p = ReturnTechAmount("SupportiveCommunity","LowSanityNegativeTraitChance")
					--[[
					LowSanityNegativeTraitChance = 30%
					SupportiveCommunity = -70%
					--]]
					local LowSan = ChoGGi.Consts.LowSanityNegativeTraitChance + 0.0 --SM has no math.funcs so + 0.0
					return p*LowSan/100*100
				end
				return ChoGGi.Consts.LowSanityNegativeTraitChance
			end
			--
			if name == "NonSpecialistPerformancePenalty" then
				if UICity:IsTechResearched("GeneralTraining") then
					local a = ReturnTechAmount("GeneralTraining","NonSpecialistPerformancePenalty")
					return ChoGGi.Consts.NonSpecialistPerformancePenalty - a
				end
				return ChoGGi.Consts.NonSpecialistPerformancePenalty
			end
			--
			if name == "RCRoverMaxDrones" then
				if UICity:IsTechResearched("RoverCommandAI") then
					local a = ReturnTechAmount("RoverCommandAI","RCRoverMaxDrones")
					return ChoGGi.Consts.RCRoverMaxDrones + a
				end
				return ChoGGi.Consts.RCRoverMaxDrones
			end
			--
			if name == "RCTransportGatherResourceWorkTime" then
				if UICity:IsTechResearched("TransportOptimization") then
					local p = ReturnTechAmount("TransportOptimization","RCTransportGatherResourceWorkTime")
					return ChoGGi.Consts.RCTransportGatherResourceWorkTime * p
				end
				return ChoGGi.Consts.RCTransportGatherResourceWorkTime
			end
			--
			if name == "RCTransportStorageCapacity" then
				local amount = cls == "RCConstructor" and ChoGGi.Consts.RCConstructorStorageCapacity or ChoGGi.Consts.RCTransportStorageCapacity

				if UICity:IsTechResearched("TransportOptimization") then
					local a = ReturnTechAmount("TransportOptimization","max_shared_storage")
					return amount + (a * ChoGGi.Consts.ResourceScale)
				end
				return amount
			end
			--
			if name == "TravelTimeEarthMars" then
				if UICity:IsTechResearched("PlasmaRocket") then
					local p = ReturnTechAmount("PlasmaRocket","TravelTimeEarthMars")
					return ChoGGi.Consts.TravelTimeEarthMars * p
				end
				return ChoGGi.Consts.TravelTimeEarthMars
			end
			--
			if name == "TravelTimeMarsEarth" then
				if UICity:IsTechResearched("PlasmaRocket") then
					local p = ReturnTechAmount("PlasmaRocket","TravelTimeMarsEarth")
					return ChoGGi.Consts.TravelTimeMarsEarth * p
				end
				return ChoGGi.Consts.TravelTimeMarsEarth
			end

		end
	end -- do

	function ChoGGi.ComFuncs.RetBuildingPermissions(traits,settings)
		settings.restricttraits = settings.restricttraits or {}
		settings.blocktraits = settings.blocktraits or {}
		traits = traits or {}
		local block,restrict

		local rtotal = 0
		for _ in pairs(settings.restricttraits) do
			rtotal = rtotal + 1
		end

		local rcount = 0
		for trait in pairs(traits) do
			if settings.restricttraits[trait] then
				rcount = rcount + 1
			end
			if settings.blocktraits[trait] then
				block = true
			end
		end

		-- restrict is empty so allow all or since we're restricting then they need to be the same
		if not next(settings.restricttraits) or rcount == rtotal then
			restrict = true
		end

		return block,restrict
	end

	do -- EntitySpots_Toggle
		local GetSpotNameByType = GetSpotNameByType
		local old_remove_table = {"ChoGGi_OText","ChoGGi_OOrientation"}

		local function EntitySpots_Clear(obj)
			-- just in case (old way of doing it)
			if obj.ChoGGi_ShowAttachSpots == true then
				local DoneObject = DoneObject
				obj:DestroyAttaches(old_remove_table,function(a)
					if a.ChoGGi_ShowAttachSpots then
						DoneObject(a)
					end
				end)
				obj.ChoGGi_ShowAttachSpots = nil
				return true
			elseif obj.ChoGGi_ShowAttachSpots then
				obj.ChoGGi_ShowAttachSpots:Destroy()
				obj.ChoGGi_ShowAttachSpots = nil
				return true
			end
		end
		ChoGGi.ComFuncs.EntitySpots_Clear = EntitySpots_Clear

		local function EntitySpots_Add(obj,spot_type,annot,depth_test,show_pos,colour)
			local c = #obj.ChoGGi_ShowAttachSpots
			local obj_pos = obj:GetVisualPos()
			local start_id, id_end = obj:GetAllSpots(obj:GetState())
			for i = start_id, id_end do
				local spot_name = GetSpotNameByType(obj:GetSpotsType(i)) or ""
				if not spot_type or spot_name == spot_type then
					local spot_annot = obj:GetSpotAnnotation(i) or ""
					-- if it's a chain then we need to check for "annot," so chain=2 doesn't include chain=20
					local chain
					if annot then
						chain = annot:sub(1,5) == "chain"
					end
--~ 					print(spot_type,"|",spot_annot,"|",annot,"|",chain,"|",spot_annot:sub(1,#annot+1) == annot .. ",")
					if not annot or annot and (chain and spot_annot:sub(1,#annot+1) == annot .. ","
							or not chain and spot_annot:sub(1,#annot) == annot) then

						local text_str = obj:GetSpotName(i)
						text_str = i .. "." .. text_str
						if spot_annot ~= "" then
							text_str = text_str .. ";" .. spot_annot
						end
						if show_pos then
							text_str = text_str .. " " .. tostring(obj:GetSpotPos(i) - obj_pos)
						end

						local text_obj = PlaceObject("ChoGGi_OText")
						if depth_test then
							text_obj:SetDepthTest(true)
						end
						text_obj:SetText(text_str)
						text_obj:SetColor1(colour)
						obj:Attach(text_obj, i)
						c = c + 1
						obj.ChoGGi_ShowAttachSpots[c] = text_obj

						-- append waypoint num for chains later on
						-- need to reverse string so it finds the last =, since find looks ltr
						local equal = spot_annot:reverse():find("=")
						if equal then
							-- we need a neg number for sub + 1 to remove the slash
							text_obj.order = tonumber(spot_annot:sub((equal * -1) + 1))
						end

					end
				end
			end -- for
			return c
		end

		local function EntitySpots_Add_Annot(obj,depth_test,colour)
			local chain_c = 0
			local points = {}
			for i = 1, #obj.ChoGGi_ShowAttachSpots do
				local text = obj.ChoGGi_ShowAttachSpots[i]
				-- use order from above to sort by waypoint number
				if text.order then
					chain_c = chain_c + 1
					points[text.order] = text:GetPos()
				end
			end
			-- some stuff has order nums in another spotname?, (the door path for the diner)
			for i = 1, chain_c do
				if not points[i] then
					if points[i+1] then
						points[i] = points[i+1]
					elseif points[i-1] then
						points[i] = points[i-1]
					end
				end
			end
			if chain_c > 0 then
				local line_obj = PlaceObject("ChoGGi_OPolyline")
				if depth_test then
					line_obj:SetDepthTest(true)
				end
				line_obj.max_vertices = #points
				line_obj:SetMesh(points, colour)
				line_obj:SetPos(AveragePoint2D(points))

				obj.ChoGGi_ShowAttachSpots[#obj.ChoGGi_ShowAttachSpots + 1] = line_obj
			end

		end

		function ChoGGi.ComFuncs.EntitySpots_Toggle(obj,params)
			-- if fired from action menu
			if IsKindOf(obj,"XAction") then
				obj = ChoGGi.ComFuncs.SelObject()
				params = {}
			else
				obj = obj or ChoGGi.ComFuncs.SelObject()
			end

			params = params or {}
			local is_valid = IsValid(obj)
			local entity = obj and obj.GetEntity and obj:GetEntity()
			if not (is_valid or IsValidEntity(entity) or params.skip_return) then
				return
			end
			if not params.skip_clear then
				if EntitySpots_Clear(obj) and not params.skip_return then
					return
				end
			end

			obj.ChoGGi_ShowAttachSpots = obj.ChoGGi_ShowAttachSpots or objlist:new()

			params.colour = params.colour or RandomColourLimited()

			EntitySpots_Add(obj,
				params.spot_type,
				params.annotation,
				params.depth_test,
				params.show_pos,
				params.colour
			)

			ChoGGi.ComFuncs.CleanInfoAttachDupes(obj.ChoGGi_ShowAttachSpots,"ChoGGi_OText")

			-- play connect the dots if there's chains
			if #obj.ChoGGi_ShowAttachSpots > 1 and params.annotation and params.annotation:find("chain") then
				EntitySpots_Add_Annot(obj,params.depth_test,RandomColourLimited())
			end

			ChoGGi.ComFuncs.CleanInfoAttachDupes(obj.ChoGGi_ShowAttachSpots,"ChoGGi_OPolyline")

			return obj.ChoGGi_ShowAttachSpots

		end
	end -- do

	do -- ShowAnimDebug_Toggle
		local function AnimDebug_Show(obj,colour)
			local text = PlaceObject("ChoGGi_OText")
			text:SetColor1(colour)

			-- so we can delete them easy
			text.ChoGGi_AnimDebug = true
			obj:Attach(text, 0)

			local obj_bbox = ObjectHierarchyBBox(obj,const.efCollision)
			if not obj_bbox:sizez() then
				obj_bbox = obj:GetObjectBBox()
			end

			text:SetAttachOffset(point(0,0,obj_bbox:sizez() + 100))
			CreateGameTimeThread(function()
				while IsValid(text) do
					text:SetText(obj:GetAnimDebug())
					WaitNextFrame()
				end
			end)
		end

		local function AnimDebug_Hide(obj)
			obj:ForEachAttach("ChoGGi_OText",function(a)
				if a.ChoGGi_AnimDebug then
					a:delete()
				end
			end)
		end

		local function AnimDebug_ShowAll(cls,colour)
			local objs = ChoGGi.ComFuncs.RetAllOfClass(cls)
			for i = 1, #objs do
				AnimDebug_Show(objs[i],colour)
			end
		end

		local function AnimDebug_HideAll(cls)
			local objs = ChoGGi.ComFuncs.RetAllOfClass(cls)
			for i = 1, #objs do
				AnimDebug_Hide(objs[i])
			end
		end

		function ChoGGi.ComFuncs.ShowAnimDebug_Toggle(obj,params)
			-- if fired from action menu
			if IsKindOf(obj,"XAction") then
				obj = ChoGGi.ComFuncs.SelObject()
			else
				obj = obj or ChoGGi.ComFuncs.SelObject()
			end
			params = params or {}
			params.colour = params.colour or RandomColourLimited()

			if IsValid(obj) then
				if not obj:GetAnimDebug() then
					return
				end

				if obj.ChoGGi_ShowAnimDebug then
					obj.ChoGGi_ShowAnimDebug = nil
					AnimDebug_Hide(obj)
				else
					obj.ChoGGi_ShowAnimDebug = true
					AnimDebug_Show(obj,params.colour)
				end
			else
				local ChoGGi = ChoGGi
				ChoGGi.Temp.ShowAnimDebug = not ChoGGi.Temp.ShowAnimDebug
				if ChoGGi.Temp.ShowAnimDebug then
					AnimDebug_ShowAll("Building",params.colour)
					AnimDebug_ShowAll("Unit",params.colour)
					AnimDebug_ShowAll("CargoShuttle",params.colour)
				else
					AnimDebug_HideAll("Building")
					AnimDebug_HideAll("Unit")
					AnimDebug_HideAll("CargoShuttle")
				end
			end
		end
	end -- do

	do -- ChangeSurfaceSignsToMaterials
		local function ChangeEntity(cls,entity,random)
			SuspendPassEdits("ChoGGi.ComFuncs.ChangeSurfaceSignsToMaterials.ChangeEntity")
			MapForEach("map",cls,function(o)
				if random then
					o:ChangeEntity(entity .. Random(1,random))
				else
					o:ChangeEntity(entity)
				end
			end)
			ResumePassEdits("ChoGGi.ComFuncs.ChangeSurfaceSignsToMaterials.ChangeEntity")
		end
		local function ResetEntity(cls)
			SuspendPassEdits("ChoGGi.ComFuncs.ChangeSurfaceSignsToMaterials.ResetEntity")
			local entity = g_Classes[cls]:GetDefaultPropertyValue("entity")
			MapForEach("map",cls,function(o)
				o:ChangeEntity(entity)
			end)
			ResumePassEdits("ChoGGi.ComFuncs.ChangeSurfaceSignsToMaterials.ResetEntity")
		end

		function ChoGGi.ComFuncs.ChangeSurfaceSignsToMaterials()

			local item_list = {
				{text = Translate(754117323318--[[Enable--]]),value = true,hint = Strings[302535920001081--[[Changes signs to materials.--]]]},
				{text = Translate(251103844022--[[Disable--]]),value = false,hint = Strings[302535920001082--[[Changes materials to signs.--]]]},
			}

			local function CallBackFunc(choice)
				if choice.nothing_selected then
					return
				end
				if choice[1].value then
					ChangeEntity("SubsurfaceDepositWater","DecSpider_01")
					ChangeEntity("SubsurfaceDepositMetals","DecDebris_01")
					ChangeEntity("SubsurfaceDepositPreciousMetals","DecSurfaceDepositConcrete_01")
					ChangeEntity("TerrainDepositConcrete","DecDustDevils_0",5)
					ChangeEntity("SubsurfaceAnomaly","DebrisConcrete")
					ChangeEntity("SubsurfaceAnomaly_unlock","DebrisMetal")
					ChangeEntity("SubsurfaceAnomaly_breakthrough","DebrisPolymer")
				else
					ResetEntity("SubsurfaceDepositWater")
					ResetEntity("SubsurfaceDepositMetals")
					ResetEntity("SubsurfaceDepositPreciousMetals")
					ResetEntity("TerrainDepositConcrete")
					ResetEntity("SubsurfaceAnomaly")
					ResetEntity("SubsurfaceAnomaly_unlock")
					ResetEntity("SubsurfaceAnomaly_breakthrough")
					ResetEntity("SubsurfaceAnomaly_aliens")
					ResetEntity("SubsurfaceAnomaly_complete")
				end
			end

			ChoGGi.ComFuncs.OpenInListChoice{
				callback = CallBackFunc,
				items = item_list,
				title = Strings[302535920001083--[[Change Surface Signs--]]],
			}
		end
	end -- do

	function ChoGGi.ComFuncs.UpdateServiceComfortBld(obj,service_stats)
		if not obj or not service_stats then
			return
		end

		-- check for type as some are boolean
		if type(service_stats.health_change) ~= "nil" then
			obj:SetBase("health_change", service_stats.health_change)
		end
		if type(service_stats.sanity_change) ~= "nil" then
			obj:SetBase("sanity_change", service_stats.sanity_change)
		end
		if type(service_stats.service_comfort) ~= "nil" then
			obj:SetBase("service_comfort", service_stats.service_comfort)
		end
		if type(service_stats.comfort_increase) ~= "nil" then
			obj:SetBase("comfort_increase", service_stats.comfort_increase)
		end

		if obj:IsKindOf("Service") then
			if type(service_stats.visit_duration) ~= "nil" then
				obj:SetBase("visit_duration", service_stats.visit_duration)
			end
			if type(service_stats.usable_by_children) ~= "nil" then
				obj.usable_by_children = service_stats.usable_by_children
			end
			if type(service_stats.children_only) ~= "nil" then
				obj.children_only = service_stats.children_only
			end
			for i = 1, 11 do
				local name = "interest" .. i
				if service_stats[name] ~= "" and type(service_stats[name]) ~= "nil" then
					obj[name] = service_stats[name]
				end
			end
		end

	end

	function ChoGGi.ComFuncs.BlacklistMsg(msg)
		msg = Strings[302535920000242--[[%s is blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have Über access.--]]]:format(msg)
		MsgPopup(
			msg,
			Strings[302535920000000--[[Expanded Cheat Menu--]]]
		)
		print(msg)
	end

	do -- ToggleFuncHook
		-- counts funcs calls, and keeps a table of func|line num
		local func_table = {}
		function ChoGGi.ComFuncs.ToggleFuncHook(path,line,mask,count)
			if blacklist then
				ChoGGi.ComFuncs.BlacklistMsg("ChoGGi.ComFuncs.ToggleFuncHook")
				return
			end

			if not ChoGGi.Temp.FunctionsHooked then
				ChoGGi.Temp.FunctionsHooked = true
				-- always start fresh
				table_clear(func_table)
				-- setup path
				path = path or "@AppData/Mods/"
				local str_len = #path

				print(Strings[302535920000497--[[Hook Started--]]],path,line,mask,count)
				MsgPopup(Strings[302535920000497--[[Hook Started--]]],Translate(1000113--[[Debug--]]))

				collectgarbage()
				local function hook_func(event)

					local i
					if event == "call" then
						i = debug_getinfo(2,"Sf")
					else
						i = debug_getinfo(2,"S")
					end

					if i.source:sub(1,str_len) == path and (not line or line and i.linedefined == line) then

						local lua_obj
						if event == "call" then
							lua_obj = i.func
						else
							lua_obj = i.source .. "|" .. i.linedefined
						end

						local c = func_table[lua_obj] or 1
						func_table[lua_obj] = c + 1
					end
				end
				-- start capture (c = func call, r = func ret, l = enters new line of code)
				debug.sethook(hook_func,mask or "c", count)
			else
				print(Strings[302535920000498--[[Hook Stopped--]]],path,line,mask,count)
				MsgPopup(Strings[302535920000498--[[Hook Stopped--]]],Translate(1000113--[[Debug--]]))
				ChoGGi.Temp.FunctionsHooked = false

				-- stop capture
				debug.sethook()
				-- view the results
				ChoGGi.ComFuncs.OpenInExamineDlg(func_table,nil,"Func call count (" .. #func_table .. ")")
			end
		end
	end -- do

	do -- PrintToFunc_Add/PrintToFunc_Remove
		local ValueToLuaCode = ValueToLuaCode
		local rawset = rawset

		function ChoGGi.ComFuncs.PrintToFunc_Remove(name,parent)
			name = tostring(name)
			local saved_name = name .. "_ChoGGi_savedfunc"

			local saved = parent[saved_name]
			if saved then
				parent[name] = parent[saved_name]
				parent[saved_name] = nil
			end

		end

		function ChoGGi.ComFuncs.PrintToFunc_Add(func,name,parent,func_name,params)
			name = tostring(name)
			local saved_name = name .. "_ChoGGi_savedfunc"

			-- move orig to saved name (if it hasn't already been)
			local saved
			if parent == ChoGGi.Temp._G then
				-- SM error spams console if you have the affront to try _G.NonExistingKey... (thanks autorun.lua)
				-- it works prefectly fine of course, but i like a clean log.
				-- in other words a workaround for "Attempt to use an undefined global '"
				saved = rawget(parent,saved_name)
				if not saved then
					rawset(parent,saved_name,func)
					saved = func
				end
			else
				saved = parent[saved_name]
				if not saved then
					parent[saved_name] = func
					saved = func
				end
			end

			local text_table = {}
			-- probably a better way to test if it's a class obj, but this works...
			local cls_obj = type(parent.IsKindOf) == "function"

			-- and replace the func reference
			parent[name] = function(...)
				if params then
					table_iclear(text_table)
					local c = 0

					local varargs = {...}
					for i = 1, #varargs do
						c = c + 1
						text_table[c] = "arg "
						c = c + 1
						text_table[c] = i
						c = c + 1
						text_table[c] = ": "

						if cls_obj and i == 1 then
							c = c + 1
							text_table[c] = tostring(varargs[i])
							c = c + 1
							text_table[c] = " ("
							c = c + 1
							text_table[c] = RetName(varargs[i])
							c = c + 1
							text_table[c] = ")"
						else
							c = c + 1
							text_table[c] = ValueToLuaCode(varargs[i])
						end

						c = c + 1
						text_table[c] = "\n"
					end
					print(func_name,"\n",TableConcat(text_table))
				else
					-- no params
					print(func_name)
				end
				return saved(...)
			end

		end

	end -- do

	do -- TestLocaleFile
--~ 	ChoGGi.ComFuncs.TestLocaleFile(
--~ 		Mods["bMPAkJP"].env.CurrentModPath .. "Locale/TraduzioneItaliano.csv",
--~ 		5
--~ 	)
		local my_locale = ChoGGi.library_path .. "Locales/English.csv"
		local csv_load_fields = {
			"id",
			"text",
			"translated",
			"translated_new",
			"gender"
		}

		local strings_failed,csv_failed
		local strings_count,csv_count

		local function ProcessLoadedTables(loaded_csv, language, out_table, out_gendertable)
			local order
			if language == "English" then
				order = {"translated_new","text","translated"}
			else
				order = {"translated_new","translated","text"}
			end

			local prev_str = Translate(1000231--[[Previous--]])
			local next_str = Translate(1000232--[[Next--]])
			local cur_str = Strings[302535920000106--[[Current--]]]

			for i = 1, #loaded_csv do
				local entry = loaded_csv[i]

				local translation
				local ord1,ord2 = entry[order[1]],entry[order[2]]
				if ord1 and ord1 ~= "" then
					translation = ord1
				elseif ord2 and ord2 ~= "" then
					translation = ord2
				else
					translation = entry[order[3]]
				end

				local id = tonumber(entry.id)

				if id and translation then
					out_table[id] = translation
					if out_gendertable then
						out_gendertable[id] = entry.gender
					end
				else
					strings_count = strings_count + 1
					strings_failed[strings_count] = {
						name = "index: " .. i,
						[cur_str .. " id"] = entry.id,
						[cur_str .. " text"] = entry.text,
						[cur_str .. " translated_new"] = entry.translated_new,
						[cur_str .. " translated"] = entry.translated,
					}
					-- add some context
					local eprev = loaded_csv[i-1]
					local enext = loaded_csv[i+1]
					local str = strings_failed[strings_count]
					if eprev then
						str[prev_str .. " id"] = eprev.id
						str[prev_str .. " text"] = eprev.text
						str[prev_str .. " translated_new"] = eprev.translated_new
						str[prev_str .. " translated"] = eprev.translated
					end
					if enext then
						str[next_str .. " id"] = enext.id
						str[next_str .. " text"] = enext.text
						str[next_str .. " translated_new"] = enext.translated_new
						str[next_str .. " translated"] = enext.translated
					end

				end
			end
		end

		local function TestCSV(filepath,column_limit)
			column_limit = filepath == my_locale and 4 or column_limit

			-- this is the LoadCSV func from CommonLua/Core/ParseCSV.lua with some DebugPrint added
			local omit_captions = "omit_captions"
			local err, str = AsyncFileToString(filepath)
			if err then
				print(Strings[302535920001125--[[Test Locale File--]]],"ERROR:",err,"FILEPATH:",filepath)
				return
			end

			local rows, pos = {}, 1
			local rows_c = 0
			local Q = lpeg.P("\"")
			local quoted_value = Q * lpeg.Cs((1 - Q + Q * Q / "\"") ^ 0) * Q
			local raw_value = lpeg.C((1 - lpeg.S(",\t\r\n\"")) ^ 0)
			local field = (lpeg.P(" ") ^ 0 * quoted_value * lpeg.P(" ") ^ 0 + raw_value) * lpeg.Cp()
			local RemoveTrailingSpaces = RemoveTrailingSpaces

			-- remove any carr returns
			str = str:gsub("\r\n","\n")
			local str_len = #str

			-- mostly LoadCSV()
			while pos < str_len do
				local row, col = {}, 1
				local lf = str:sub(pos, pos) == "\n"

				while pos < str_len and not lf do

					local value, nextv = field:match(str, pos)
					value = RemoveTrailingSpaces(value)
					local f_remap_col = csv_load_fields[col]
					if f_remap_col then
						row[f_remap_col] = value
					end
					col = col + 1
					lf = str:sub(nextv, nextv) == "\n"
					pos = nextv + 1

					-- only seems to happen on bad things
					if col > column_limit then
						csv_count = csv_count + 1
						csv_failed[csv_count] = {
							name = "ERROR row: " .. row.id,
							value = value,
							string_pos = pos,
							column = col,
							general_area = str:sub(pos-50,pos+50),
							row_gender = row.gender,
							row_text = row.text,
							row_id = row.id,
							row_translated = row.translated,
							row_translated_new = row.translated_new,
						}
					end

					if pos >= str_len then
						break
					end
				end -- while inner

				if lf then
					pos = pos + 1
				end

				if not omit_captions then
					rows_c = rows_c + 1
					rows[rows_c] = row
				end
				omit_captions = false

				if pos >= str_len and not lf then
					break
				end

			end -- while outer

			return csv_failed,rows
		end

		function ChoGGi.ComFuncs.TestLocaleFile(filepath,test_csv,language)
			if not filepath then
				if testing then
					local locale_path = ChoGGi.library_path .. "Locales/" .. ChoGGi.lang .. ".csv"
					if ChoGGi.ComFuncs.FileExists(locale_path) then
						filepath = locale_path
					else
						filepath = my_locale
					end
				else
					print(Strings[302535920001125--[[Test Locale File--]]],"FILEPATH ERROR:",filepath)
					return
				end
			end

			-- always reset to 0 for reporting (csv_count > 0)
			local loaded_csv
			if test_csv or testing then
				if blacklist then
					ChoGGi.ComFuncs.BlacklistMsg("ChoGGi.ComFuncs.TestLocaleFile(test_csv)")
				else
					csv_failed = {}
					csv_count = 0
					test_csv,loaded_csv = TestCSV(filepath,test_csv)
				end
			end

			-- my TestCSV is the same as LoadCSV, but without an inf loop if it's a malformed csv file
			-- so we skip it for test_csv
			if not loaded_csv then
				loaded_csv = {}
				LoadCSV(
					filepath,
					loaded_csv,
					csv_load_fields,
					"omit_captions"
				)
			end

			local out_table, out_gendertable = {},{}

			strings_failed = {}
			strings_count = 0
			pcall(function()
				ProcessLoadedTables(
					loaded_csv,
					language,
					out_table,
					out_gendertable
				)
			end)

			local title
			if strings_count > 0 or (csv_count > 0 and not (csv_count == 2 and testing )) then
				title = Strings[302535920001125--[[Test Locale File--]]] .. ": " .. Translate(951--[[Failed to complete operation.--]])
			else
				title = Strings[302535920001125--[[Test Locale File--]]] .. ": " .. Translate(1000015--[[Success--]])
			end
			local results = {
				loaded_csv = loaded_csv,
				strings_failed = strings_failed,
				out_table = out_table,
				out_gendertable = out_gendertable,
			}
			if test_csv then
				results.csv_failed = csv_failed
			end

			ChoGGi.ComFuncs.OpenInExamineDlg(results,nil,title)
		end
	end -- do

	do -- ValueToStr
		local getmetatable = getmetatable
		local IsPoint = IsPoint
		local IsBox = IsBox

		function ChoGGi.ComFuncs.ValueToStr(obj,obj_type)
			obj_type = obj_type or type(obj)

			if obj_type == "string" then
				-- strings with (object) don't work well with Translate
				if obj:find("%(") then
					return obj,obj_type
				-- if there's any <image, <color, etc tags
				elseif obj:find("[<>]") then
					return Translate(obj),obj_type
				else
					return obj,obj_type
				end
			end
			--
			if obj_type == "number" then
				-- faster than tostring()
				return obj .. "",obj_type
			end
--~ 			--
--~ 			if obj_type == "boolean" then
--~ 				return tostring(obj),obj_type
--~ 			end
			--
			if obj_type == "table" then
				return RetName(obj),obj_type
			end
			--
			if obj_type == "userdata" then
				if IsPoint(obj) then
					return "point" .. tostring(obj),obj_type
				elseif IsBox(obj) then
					return "box" .. tostring(obj),obj_type
				end
				-- show translated text if possible and return a clickable link
				local trans_str = Translate(obj)
				if trans_str == "Missing text" or #trans_str > 16 and trans_str:sub(-16) == " *bad string id?" then
					local meta = getmetatable(obj).__name
					return tostring(obj) .. (meta and " " .. meta or ""),obj_type
				end
				return trans_str,obj_type
			end
			--
			if obj_type == "function" then
				return RetName(obj),obj_type
			end
	--~ 		--
	--~ 		if obj_type == "thread" then
	--~ 			return tostring(obj),obj_type
	--~ 		end
			--
			if obj_type == "nil" then
				return "nil",obj_type
			end

			-- just in case
			return tostring(obj),obj_type
		end
	end -- do

	do -- ToggleObjLines
		local table_remove = table.remove
		local IsPoint = IsPoint
		local IsBox = IsBox
		local InvalidPos = ChoGGi.Consts.InvalidPos

		local function ObjListLines_Clear(obj)
			if IsValid(obj.ChoGGi_ObjListLine) then
				DoneObject(obj.ChoGGi_ObjListLine)
			end
			obj.ChoGGi_ObjListLine = nil
		end
		ChoGGi.ComFuncs.ObjListLines_Clear = ObjListLines_Clear

		local function ObjListLines_Add(list,obj,colour)
			local vertices = {}
			local c = 0

			-- add any obj pos points of box centres
			for i = 1, #list do
				local o = list[i]
				if IsPoint(o) then
					if o:z() then
						c = c + 1
						vertices[c] = o
					else
						c = c + 1
						vertices[c] = o:SetTerrainZ()
					end
				elseif IsValid(o) then
					c = c + 1
					vertices[c] = o:GetVisualPos()
				elseif IsBox(o) then
					c = c + 1
					vertices[c] = o:Center()
				end
			end
			-- remove any invalid pos
			for i = #vertices, 1, -1 do
				if vertices[i] == InvalidPos then
					table_remove(vertices,i)
				end
			end

			local line = PlacePolyline(vertices, colour)
			line:SetPos(AveragePoint2D(line.vertices))

			obj.ChoGGi_ObjListLine = line
		end

		function ChoGGi.ComFuncs.ObjListLines_Toggle(objs_list,params)
			params = params or {}
			params.obj = params.obj or objs_list

			if ObjListLines_Clear(params.obj) and not params.skip_return then
				return
			end

			ObjListLines_Add(objs_list,
				params.obj,
				params.colour or RandomColourLimited()
			)
		end
	end

end
