-- See LICENSE for terms

function OnMsg.ClassesGenerate()

	local S = ChoGGi.Strings
	local blacklist = ChoGGi.blacklist
	local MsgPopup = ChoGGi.ComFuncs.MsgPopup
	local RetName = ChoGGi.ComFuncs.RetName
	local Trans = ChoGGi.ComFuncs.Translate

	local StringFormat = string.format

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
		local select,type = select,type
		local StringFormat = StringFormat

		local function ReplaceFunc(funcname,filename)
			local ChoGGi = ChoGGi
			ChoGGi.ComFuncs.SaveOrigFunc(funcname)

			_G[funcname] = function(...)
				-- i think print sends a succeeded as well?
				local arg2 = select(2,...)
				if arg2 and type(arg2) == "boolean" then
					Dump(StringFormat("%s\r\n",select(1,...)),nil,filename,"log",true)
				else
					Dump(StringFormat("%s\r\n",... or ""),nil,filename,"log",true)
				end
				-- fire off orig func...
				if ChoGGi.OrigFuncs[funcname] then
					ChoGGi.OrigFuncs[funcname](...)
				end
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
				-- remove old logs
				AsyncCopyFile("AppData/logs/ConsoleLog.log","AppData/logs/ConsoleLog.previous.log","raw")
				AsyncStringToFile("AppData/logs/ConsoleLog.log"," ")

				-- redirect functions
				if ChoGGi.testing then
					ReplaceFunc("dlc_print","ConsoleLog")
					ReplaceFunc("assert","ConsoleLog")
	--~				 ReplaceFunc("printf","DebugLog",ChoGGi)
	--~				 ReplaceFunc("DebugPrint","DebugLog",ChoGGi)
	--~				 ReplaceFunc("OutputDebugString","DebugLog",ChoGGi)
				end
				ReplaceFunc("AddConsoleLog","ConsoleLog")
				ReplaceFunc("print","ConsoleLog")
			else
				if ChoGGi.testing then
					ResetFunc("dlc_print")
					ResetFunc("assert")
	--~				 ResetFunc("printf",ChoGGi)
	--~				 ResetFunc("DebugPrint",ChoGGi)
	--~				 ResetFunc("OutputDebugString",ChoGGi)
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

	do -- CloseDialogsECM
		local ChoGGi = ChoGGi
		local term = terminal.desktop
		function ChoGGi.ComFuncs.RemoveOldDialogs(dialog)
			while ChoGGi.ComFuncs.CheckForTypeInList(term,dialog) do
				for i = #term, 1, -1 do
					if term[i]:IsKindOf(dialog) then
						term[i]:Done()
					end
				end
			end
		end

		function ChoGGi.ComFuncs.CloseDialogsECM()
			if ChoGGi.UserSettings.CloseDialogsECM then
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
	end

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

end
