-- See LICENSE for terms

function OnMsg.ClassesGenerate()
	local S = ChoGGi.Strings
	local blacklist = ChoGGi.blacklist
	local MsgPopup = ChoGGi.ComFuncs.MsgPopup
	local RetName = ChoGGi.ComFuncs.RetName
	local Trans = ChoGGi.ComFuncs.Translate

	local StringFormat = string.format
	local TableFind = table.find

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
		do -- RetName
			-- we use this table to display names of (some) tables
			local g = _G
			local lookup_table = {
				[_G] = "_G",
				[_G.ChoGGi] = "ChoGGi",
				[_G.ClassTemplates] = "ClassTemplates",
				[_G.const] = "const",
				[_G.Consts] = "Consts",
				[_G.DataInstances] = "DataInstances",
				[_G.Dialogs] = "Dialogs",
				[_G.EntityData] = "EntityData",
				[_G.Flags] = "Flags",
				[_G.FXRules] = "FXRules",
				[_G.g_Classes] = "g_Classes",
				[_G.Presets] = "Presets",
				[_G.s_SeqListPlayers] = "s_SeqListPlayers",
				[_G.TaskRequesters] = "TaskRequesters",
				[_G.terminal.desktop] = "terminal.desktop",
				[_G.ThreadsMessageToThreads] = "ThreadsMessageToThreads",
				[_G.ThreadsRegister] = "ThreadsRegister",
				[_G.ThreadsThreadToMessage] = "ThreadsThreadToMessage",
				[_G.XTemplates] = "XTemplates",
			}
			for _,value in pairs(PresetDefs) do
				if value.DefGlobalMap ~= "" then
					lookup_table[value] = value
				end
			end
			-- have to wait for these to be created
			function OnMsg.LoadGame()
				lookup_table[_G.UICity] = "UICity"
				lookup_table[_G.UICity.labels] = "UICity.labels"
				lookup_table[_G.UICity.tech_status] = "UICity.tech_status"
				lookup_table[_G.g_Consts] = "g_Consts"
				lookup_table[_G.g_ApplicantPool] = "g_ApplicantPool"
			end
			function OnMsg.CityStart()
				lookup_table[_G.UICity] = "UICity"
				lookup_table[_G.UICity.labels] = "UICity.labels"
				lookup_table[_G.UICity.tech_status] = "UICity.tech_status"
				lookup_table[_G.g_Consts] = "g_Consts"
				lookup_table[_G.g_ApplicantPool] = "g_ApplicantPool"
			end

			local IsObjlist,type,tostring = IsObjlist,type,tostring
			local DebugGetInfo = ChoGGi.ComFuncs.DebugGetInfo
			-- try to return a decent name for the obj, failing that return a string
			function ChoGGi.ComFuncs.RetName(obj)
				if lookup_table[obj] then
					return lookup_table[obj]
				end

				local obj_type = type(obj)

				if obj_type == "table" then

					local name_type = type(obj.name)
					-- custom name from user (probably)
					if name_type == "string" and obj.name ~= "" then
						return obj.name
					-- colonist names
					elseif name_type == "table" and #obj.name == 3 then
						return StringFormat("%s %s",Trans(obj.name[1]),Trans(obj.name[3]))

					-- translated name
					elseif obj.display_name and obj.display_name ~= "" then
						return Trans(obj.display_name)

					-- encyclopedia_id
					elseif obj.encyclopedia_id and obj.encyclopedia_id ~= "" then
						return obj.encyclopedia_id
					-- plain old id
					elseif obj.id and obj.id ~= "" then
						return obj.id
					elseif obj.Id and obj.Id ~= "" then
						return obj.Id

					-- class template name
					elseif obj.template_name and obj.template_name ~= "" then
						return obj.template_name
					-- class
					elseif obj.class and obj.class ~= "" then
						return obj.class

					-- added this here as doing tostring lags the shit outta kansas if this is a large objlist (could also be from just having a large string for something?)
					elseif IsObjlist(obj) then
						return "objlist"
					end

				elseif obj_type == "function" then
					return DebugGetInfo(obj)

				end

				-- falling back baby
				return tostring(obj)
			end
		end -- do
		RetName = ChoGGi.ComFuncs.RetName
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

		local buffer_table = {}
		local buffer_cnt = 0
		-- every 5s check buffer and print if anything
		CreateRealTimeThread(function()
			while true do
				Sleep(5000)
				if #buffer_table > 1 then
					Dump(TableConcat(buffer_table,"\r\n"),nil,"ConsoleLog","log",true)
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
			_G[funcname] = function(...)

				-- table.concat don't work with non-strings/numbers
				local str = tostring(...)
				if buffer_table[buffer_cnt] ~= str then
					buffer_cnt = buffer_cnt + 1
					buffer_table[buffer_cnt] = str
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

			local ChoGGi = ChoGGi
			if which then
				-- move old log to previous and add a blank log
				AsyncCopyFile("AppData/logs/ConsoleLog.log","AppData/logs/ConsoleLog.previous.log","raw")
				AsyncStringToFile("AppData/logs/ConsoleLog.log"," ")

				-- redirect functions
				if ChoGGi.testing then
					ReplaceFunc("dlc_print")
					ReplaceFunc("assert")
	--~				 ReplaceFunc("printf")
	--~				 ReplaceFunc("DebugPrint")
	--~				 ReplaceFunc("OutputDebugString")
				end
				ReplaceFunc("AddConsoleLog")
				ReplaceFunc("print")
			else
				if ChoGGi.testing then
					ResetFunc("dlc_print")
					ResetFunc("assert")
	--~				 ResetFunc("printf")
	--~				 ResetFunc("DebugPrint")
	--~				 ResetFunc("OutputDebugString")
				end
				ResetFunc("AddConsoleLog")
				ResetFunc("print","ConsoleLog")
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
	function ChoGGi.ComFuncs.ObjectSpawner(obj)
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
				obj:ChangeEntity(value)

				MsgPopup(
					StringFormat("%s: %s %s",choice[1].text,S[302535920000014--[[Spawned--]]],S[298035641454--[[Object--]]]),
					302535920000014--[[Spawned--]]
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ObjectSpawner_ItemList,
			title = 302535920000862--[[Object Spawner (EntityData list)--]],
			hint = StringFormat("%s: %s",S[6779--[[Warning--]]],S[302535920000863--[[Objects are unselectable with mouse cursor (hover mouse over and use Delete Object).--]]]),
		}
	end

end
