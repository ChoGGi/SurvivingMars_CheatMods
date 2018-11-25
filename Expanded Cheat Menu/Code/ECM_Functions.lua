-- See LICENSE for terms

local StringFormat = string.format
local TableFind = table.find
local TableClear = table.clear
local TableSort = table.sort
local Sleep = Sleep

local getinfo
local debug = rawget(_G,"debug")
if debug then
	getinfo = debug.getinfo
end

function OnMsg.ClassesGenerate()
	local S = ChoGGi.Strings
	local blacklist = ChoGGi.blacklist
	local MsgPopup = ChoGGi.ComFuncs.MsgPopup
	local RetName = ChoGGi.ComFuncs.RetName
	local Trans = ChoGGi.ComFuncs.Translate

	-- if ECM is running without the bl, then we use the _G from ECM instead of the Library mod (since it's limited to per mod)
	if not blacklist then
		-- "some.some.some.etc" = returns etc as object
		function ChoGGi.ComFuncs.DotNameToObject(str,root,create)
			-- there's always one
			if str == "_G" then
				return _G
			end
			-- always start with _G
			local obj = root or _G
			-- https://www.lua.org/pil/14.1.html
			for name,match in str:gmatch("([%w_]+)(.?)") do
				-- . means we're not at the end yet
				if match == "." then
					-- create is for adding new settings in non-existent tables
					if not obj[name] and not create then
						-- our treasure hunt is cut short, so return nadda
						return
					end
					-- change the parent to the child (create table if absent, this'll only fire when create)
					obj = obj[name] or {}
				else
					-- no more . so we return as conquering heroes with the obj
					return obj[name]
				end
			end
		end
	end

	function ChoGGi.ComFuncs.Dump(obj,mode,file,ext,skip_msg)
		if blacklist then
			print(S[302535920000242--[[%s is blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have Über access.--]]]:format("Dump"))
			return
		end

		if mode == "w" or mode == "w+" then
			mode = nil
		else
			mode = "-1"
		end
		local filename = StringFormat("AppData/logs/%s.%s",file or "DumpedText",ext or "txt")

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
		ChoGGi.ComFuncs.Dump(StringFormat("\r\n%s",ValueToLuaCode(obj)),nil,"DumpedLua","lua")
	end

	do -- DumpTableFunc
		local output_string
		local function RetTextForDump(obj,funcs)
			local obj_type = type(obj)
			if obj_type == "userdata" then
				return Trans(obj)
			elseif funcs and obj_type == "function" then
				return StringFormat("Func: \r\n\r\n%s\r\n\r\n",obj:dump())
			elseif obj_type == "table" then
				return StringFormat("%s len: %s",tostring(obj),#obj)
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
					output_string = StringFormat("%s\n-----------------obj.id: %s :",output_string,obj.id)
				end
				for k,v in pairs(obj) do
					if type(v) == "table" then
						DumpTableFunc(v, hierarchyLevel+1)
					else
						if k ~= nil then
							output_string = StringFormat("%s\n%s = ",output_string,k)
						end
						if v ~= nil then
							output_string = StringFormat("%s%s",output_string,RetTextForDump(v,funcs))
						end
						output_string = StringFormat("%s\n",output_string)
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
				print(S[302535920000242--[[%s is blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have Über access.--]]]:format("DumpTable"))
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
			--make sure it's empty
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
		local TableConcat = ChoGGi.ComFuncs.TableConcat
		local SaveOrigFunc = ChoGGi.ComFuncs.SaveOrigFunc
		local TableIClear = table.iclear
		local pack_params = pack_params
		local tostring = tostring

		-- every 5s check buffer and print if anything
		local timer = ChoGGi.testing and 2500 or 5000
		-- we always start off with a newline so the first line or so isn't merged
		local buffer_table = {"\r\n"}
		local buffer_cnt = 1

		if rawget(_G,"ChoGGi_print_buffer_thread") then
			DeleteThread(ChoGGi_print_buffer_thread)
		end
		ChoGGi_print_buffer_thread = CreateRealTimeThread(function()
			while true do
				Sleep(timer)
				if buffer_cnt > 1 then
					Dump(TableConcat(buffer_table,"\r\n"),nil,"Console","log",true)
					TableIClear(buffer_table)
					buffer_table[1] = "\r\n"
					buffer_cnt = 1
				end
			end
		end)

		local function ReplaceFunc(funcname)
			SaveOrigFunc(funcname)
			-- we want to local this after SaveOrigFunc just in case
			local ChoGGi_OrigFuncs = ChoGGi.OrigFuncs
			local name = StringFormat("%s: %s",funcname,"%s")
			_G[funcname] = function(...)

				-- table.concat don't work with non strings/numbers
				local str = pack_params(...) or ""
				for i = 1, #str do
					str[i] = tostring(str[i])
				end
				str = TableConcat(str, " ")

				if buffer_table[buffer_cnt] ~= str then
					buffer_cnt = buffer_cnt + 1
					buffer_table[buffer_cnt] = name:format(str)
				end

				-- fire off orig func...
				ChoGGi_OrigFuncs[funcname](...)
			end

		end

		local function ResetFunc(funcname)
			local ChoGGi = ChoGGi
			if ChoGGi.OrigFuncs[funcname] then
				_G[funcname] = ChoGGi.OrigFuncs[funcname]
			end
		end

		function ChoGGi.ComFuncs.WriteLogs_Toggle(which)
			if blacklist then
				print(S[302535920000242--[[%s is blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have Über access.--]]]:format("WriteLogs_Toggle"))
				return
			end

			if which then
				-- move old log to previous and add a blank log
				AsyncCopyFile("AppData/logs/Console.log","AppData/logs/Console.previous.log","raw")
				AsyncStringToFile("AppData/logs/Console.log"," ")

				-- redirect functions
				ReplaceFunc("dlc_print")
				ReplaceFunc("DebugPrintNL")
				ReplaceFunc("OutputDebugString")
				ReplaceFunc("AddConsoleLog")
				ReplaceFunc("assert")
				ReplaceFunc("printf")
				ReplaceFunc("error")
				-- AddConsoleLog also does print(), no need for two copies
--~ 				ReplaceFunc("print")
				-- causes an error and stops games from loading
				-- ReplaceFunc("DebugPrint")
			else
				ResetFunc("dlc_print")
				ResetFunc("DebugPrintNL")
				ResetFunc("OutputDebugString")
				ResetFunc("AddConsoleLog")
				ResetFunc("assert")
				ResetFunc("printf")
				ResetFunc("error")
--~ 				ResetFunc("print")
			end
		end
	end -- do

	-- returns table with list of files without path or ext and path, or exclude ext to return all files
	function ChoGGi.ComFuncs.RetFilesInFolder(folder,ext)
		local err, files = AsyncListFiles(folder,ext and StringFormat("*%s",ext) or "*")
		if not err and #files > 0 then
			local table_path = {}
			local path = StringFormat("%s/",folder)
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
			local temp_path = StringFormat("%s/",folder)
			for i = 1, #folders do
				table_path[i] = {
					path = folders[i],
					name = folders[i]:gsub(temp_path,""),
				}
			end
			return table_path
		end
	end

	do -- OpenInExamineDlg
		local function OpenInExamineDlg(obj,parent,title)
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

	function ChoGGi.ComFuncs.OpenInObjectManipulatorDlg(obj,parent)
		if not obj then
			obj = ChoGGi.ComFuncs.SelObject()
		end
		if not obj then
			return
		end

		return ChoGGi_ObjectManipulatorDlg:new({}, terminal.desktop,{
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

	function ChoGGi.ComFuncs.RemoveOldDialogs(dlg)
		local desktop = terminal.desktop
		while TableFind(desktop,"class",dlg) do
			for i = #desktop, 1, -1 do
				if desktop[i]:IsKindOf(dlg) then
					desktop[i]:Done()
				end
			end
		end
	end

	function ChoGGi.ComFuncs.CloseDialogsECM(menu)
		if menu or ChoGGi.UserSettings.CloseDialogsECM then
			local RemoveOldDialogs = ChoGGi.ComFuncs.RemoveOldDialogs
			RemoveOldDialogs("Examine")
			RemoveOldDialogs("ChoGGi_ObjectManipulatorDlg")
			RemoveOldDialogs("ChoGGi_ListChoiceDlg")
			RemoveOldDialogs("ChoGGi_MonitorInfoDlg")
			RemoveOldDialogs("ChoGGi_ExecCodeDlg")
			RemoveOldDialogs("ChoGGi_MultiLineTextDlg")
			RemoveOldDialogs("ChoGGi_FindValueDlg")
		end
	end
	function ChoGGi.ComFuncs.ObjectSpawner(obj,skip_msg,list_type)
		local ChoGGi = ChoGGi
		local g_Classes = g_Classes
		local EntityData = EntityData or {}
		local ObjectSpawner_ItemList = {}
		local c = 0
		for Key,_ in pairs(EntityData) do
			c = c + 1
			ObjectSpawner_ItemList[c] = {
				text = Key,
				value = Key
			}
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if g_Classes[value] then

				if not obj then
					obj = PlaceObj("ChoGGi_BuildingEntityClass",{
						"Pos",ChoGGi.ComFuncs.CursorNearestHex()
					})
				end
				obj:SetState("idle")
				obj:ChangeEntity(value)

				if not skip_msg then
					MsgPopup(
						StringFormat("%s: %s %s",choice[1].text,S[302535920000014--[[Spawned--]]],S[298035641454--[[Object--]]]),
						302535920000014--[[Spawned--]]
					)
				end
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ObjectSpawner_ItemList,
			title = 302535920000862--[[Object Spawner (EntityData list)--]],
			hint = StringFormat("%s: %s",S[6779--[[Warning--]]],S[302535920000863--[[Objects are unselectable with mouse cursor (hover mouse over and use Delete Object).--]]]),
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
				text = StringFormat("%s: %s, %s: %s",S[302535920000858--[[Index--]]],i,S[1000037--[[Name--]]],states[i]),
				value = states[i],
			}
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
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
			print(S[302535920000242--[[%s is blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have Ü¢er access.--]]]:format("MonitorThreads"))
			return
		end

		local table_list = {}
		local dlg = ChoGGi.ComFuncs.OpenInExamineDlg(table_list)
		dlg.idAutoRefresh:SetCheck(true)
		dlg:idAutoRefreshToggle()

		CreateRealTimeThread(function()
			local table_str = "%s(%s) %s"
			local pairs = pairs
			-- stop when dialog is closed
			while dlg and dlg.window_state ~= "destroying" do
				TableClear(table_list)
				for thread in pairs(ThreadsRegister) do
					local info = getinfo(thread, 1, "Slfun")
					if info then
						table_list[table_str:format(info.short_src,info.linedefined,thread)] = thread
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
		dlg.idAutoRefresh:SetCheck(true)
		dlg:idAutoRefreshToggle()
		local table_str = "%s %s"
		local type,pairs,next = type,pairs,next
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
								table_list[table_str:format(PadNumWithZeros(length,pad_to),key)] = value
							elseif sortby == 1 then
								table_list[table_str:format(key,length)] = value
							end
						end

					end
				end

				Sleep(1000)
			end
		end)
	end

	do -- SetParticles
		local PlayFX = PlayFX
		local ItemList
		function ChoGGi.ComFuncs.SetParticles(sel)
			local name = StringFormat("%s %s",S[302535920000129--[[Set--]]],S[302535920001184--[[Particles--]]])
			sel = sel or ChoGGi.ComFuncs.SelObject()
			if not sel or sel and not sel:IsKindOf("FXObject") then
				MsgPopup(
					StringFormat("%s: %s",S[302535920000027--[[Nothing selected--]]],"FXObject"),
					name
				)
				return
			end

			-- make a list of spot names for the obj, so we skip particles that need that spot
			local spots = {}
			local start_id, end_id = sel:GetAllSpots(sel:GetState())
			for i = start_id, end_id do
				spots[sel:GetSpotName(i)] = true
			end

			local name_str = "%s, %s: %s"
			local ItemList = {{text = S[1000121--[[Default--]]],value = S[1000121--[[Default--]]]}}
			local c = 1
			local particles = FXLists.ActionFXParticles
			for i = 1, #particles do
				local p = particles[i]
				if spots[p.Spot] or p.Spot == "" then
					c = c + 1
					ItemList[c] = {
						text = name_str:format(p.Actor,p.Action,p.Moment),
						value = p.Actor,
						action = p.Action,
						moment = p.Moment,
					}
				end
			end

			local function CallBackFunc(choice)
				if #choice < 1 then
					return
				end
				local actor = choice[1].value
				local action = choice[1].action
				local moment = choice[1].moment

				-- if there's one playing then stop it
				if sel.ChoGGi_playing_fx then
					PlayFX(sel.ChoGGi_playing_fx, "end", sel)
				end
				sel.ChoGGi_playing_fx = action

				if type(sel.fx_actor_class_ChoGGi_Orig) == "nil" then
					sel.fx_actor_class_ChoGGi_Orig = sel.fx_actor_class
				end

				sel.fx_actor_class = actor
				PlayFX(action, moment, sel)

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
	end -- do

	function ChoGGi.ComFuncs.ToggleConsole(show)
		local dlgConsole = dlgConsole
		if dlgConsole then
			ShowConsole(show or not dlgConsole:GetVisible())
			dlgConsole.idEdit:SetFocus()
		end
	end

end
