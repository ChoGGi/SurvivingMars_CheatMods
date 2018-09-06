-- See LICENSE for terms

-- nope not hacky at all
local is_loaded
function OnMsg.ChoGGi_Library_Loaded(mod_id)
	if is_loaded or mod_id and mod_id ~= "ChoGGi_CheatMenu" then
		return
	end
	is_loaded = true

	local TableConcat = ChoGGi.ComFuncs.TableConcat -- added in Init.lua
	local S = ChoGGi.Strings
	local blacklist = ChoGGi.blacklist

	local string = string
	local AsyncStringToFile = _G.AsyncStringToFile

	function ChoGGi.ComFuncs.Dump(obj,mode,file,ext,skip_msg)
		if blacklist then
			print(302535920000242--[[Blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have Über access.--]])
			return
		end

		if mode == "w" or mode == "w+" then
			mode = nil
		else
			mode = "-1"
		end
		local filename = string.format("AppData/logs/%s.%s",file or "DumpedText",ext or "txt")

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
		ChoGGi.ComFuncs.Dump(string.format("\r\n%s",ValueToLuaCode(obj)),nil,"DumpedLua","lua")
	end

	do -- DumpTableFunc
		local output_string
		local function RetTextForDump(obj,funcs)
			local obj_type = type(obj)
			if obj_type == "userdata" then
				return Trans(obj)
			elseif funcs and obj_type == "function" then
				return string.format("Func: \r\n\r\n%s\r\n\r\n",obj:dump())
			elseif obj_type == "table" then
				return string.format("%s len: %s",tostring(obj),#obj)
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
					output_string = string.format("%s\n-----------------obj.id: %s :",output_string,obj.id)
				end
				for k,v in pairs(obj) do
					if type(v) == "table" then
						DumpTableFunc(v, hierarchyLevel+1)
					else
						if k ~= nil then
							output_string = string.format("%s\n%s = ",output_string,k)
						end
						if v ~= nil then
							output_string = string.format("%s%s",output_string,RetTextForDump(v,funcs))
						end
						output_string = string.format("%s\n",output_string)
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
				print(302535920000242--[[Blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have Über access.--]])
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

		local function ReplaceFunc(funcname,filename)
			local ChoGGi = ChoGGi
			ChoGGi.ComFuncs.SaveOrigFunc(funcname)

			_G[funcname] = function(...)
				local arg2 = select(2,...)
				if arg2 and type(arg2) == "boolean" then
					Dump(string.format("%s\r\n",select(1,...)),nil,filename,"log",true)
				else
					Dump(string.format("%s\r\n",... or ""),nil,filename,"log",true)
				end
				if type(ChoGGi.OrigFuncs[funcname]) == "function" then
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
				print(S[302535920000242--[[Blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have Über access.--]]])
				return
			end

			local ChoGGi = ChoGGi
			if which then
				-- remove old logs
				local console = "AppData/logs/ConsoleLog.log"
				AsyncCopyFile(console, "AppData/logs/ConsoleLog.previous.log")
				AsyncStringToFile(console,"")

				-- redirect functions
				if ChoGGi.testing then
					ReplaceFunc("dlc_print","ConsoleLog")
	--~				 ReplaceFunc("printf","DebugLog",ChoGGi)
	--~				 ReplaceFunc("DebugPrint","DebugLog",ChoGGi)
	--~				 ReplaceFunc("OutputDebugString","DebugLog",ChoGGi)
				end
				ReplaceFunc("AddConsoleLog","ConsoleLog")
				ReplaceFunc("print","ConsoleLog")
			else
				if ChoGGi.testing then
					ResetFunc("dlc_print")
	--~				 ResetFunc("printf",ChoGGi)
	--~				 ResetFunc("DebugPrint",ChoGGi)
	--~				 ResetFunc("OutputDebugString",ChoGGi)
				end
				ResetFunc("AddConsoleLog")
				ResetFunc("print","ConsoleLog")
			end
		end
	end -- do

	do -- RetFilesInFolder/RetFoldersInFolder
		local AsyncListFiles = _G.AsyncListFiles
		-- returns table with list of files without path or ext and path, or exclude ext to return all files
		function ChoGGi.ComFuncs.RetFilesInFolder(folder,ext)
			local err, files = AsyncListFiles(folder,ext and string.format("*%s",ext) or "*")
			if not err and #files > 0 then
				local table_path = {}
				local path = string.format("%s/",folder)
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
			--local err, folders = AsyncListFiles(Folder, "*", "recursive,folders")
			local err, folders = AsyncListFiles(folder,"*","folders")
			if not err and #folders > 0 then
				local table_path = {}
				local temp_path = string.format("%s/",folder)
				for i = 1, #folders do
					table_path[i] = {
						path = folders[i],
						name = folders[i]:gsub(temp_path,""),
					}
				end
				return table_path
			end
		end
	end -- do

end
