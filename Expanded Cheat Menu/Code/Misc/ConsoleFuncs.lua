-- See LICENSE for terms

-- menus/buttons added to the Console

local TableSort = table.sort
local TableInsert = table.insert
local TableRemove = table.remove
local TableFind = table.find
local CmpLower = CmpLower
local print = print

-- rebuild list of objects to examine when user changes settings
function OnMsg.ChoGGi_SettingsUpdated()
	ChoGGi.ConsoleFuncs.BuildExamineMenu()
end

function OnMsg.ClassesGenerate()
	local PopupToggle = ChoGGi.ComFuncs.PopupToggle
	local OpenInExamineDlg = ChoGGi.ComFuncs.OpenInExamineDlg
	local DotNameToObject = ChoGGi.ComFuncs.DotNameToObject
	local RetFilesInFolder = ChoGGi.ComFuncs.RetFilesInFolder
	local Trans = ChoGGi.ComFuncs.Translate
	local S = ChoGGi.Strings
	local blacklist = ChoGGi.blacklist
	local testing = ChoGGi.testing

	-- created when we create the controls controls the first time
	local ExamineMenuToggle_list = {}
	-- to add each item
	local function BuildExamineItem(name,title)
		if not name then
			return
		end
		local obj = DotNameToObject(name)
		local func = type(obj) == "function"
		local disp = title or name .. (func and "()" or "")
		return {
			name = disp,
			hint = S[302535920000491--[[Examine Object--]]] .. ": " .. disp,
			clicked = function()
				if func then
					OpenInExamineDlg(obj())
				else
					OpenInExamineDlg(name,"str",disp)
				end
			end,
		}
	end
	--
	function ChoGGi.ConsoleFuncs.AddSubmenu(name,list,title)
		local submenu = TableFind(ExamineMenuToggle_list,"name",name)
		if submenu then
			list = list or ""
			ExamineMenuToggle_list[submenu].hint = nil
			if title then
				ExamineMenuToggle_list[submenu].name = title
			end
			ExamineMenuToggle_list[submenu].submenu = {BuildExamineItem(name)}
			local c = 1
			for i = 1, #list do
				c = c + 1
				ExamineMenuToggle_list[submenu].submenu[c] = BuildExamineItem(list[i])
			end
			return ExamineMenuToggle_list[submenu].submenu
		end
	end

	function ChoGGi.ConsoleFuncs.AddMonitor(name,submenu,idx)
		TableInsert(submenu,idx or 2,{
			name = S[302535920000853--[[Monitor--]]] .. ": " .. name,
			hint = "ChoGGi.ComFuncs.MonitorTableLength(" .. name .. ")",
			clicked = function()
				if name == "_G" then
					ChoGGi.ComFuncs.MonitorTableLength(DotNameToObject(name),nil,nil,nil,name)
				else
					ChoGGi.ComFuncs.MonitorTableLength(DotNameToObject(name),0,nil,nil,name)
				end
			end,
		})
	end

	-- build list of objects to examine
	function ChoGGi.ConsoleFuncs.BuildExamineMenu()
		table.iclear(ExamineMenuToggle_list)

		local AddSubmenu = ChoGGi.ConsoleFuncs.AddSubmenu
		local list = ChoGGi.UserSettings.ConsoleExamineList or ""
		local submenu

		TableSort(list,function(a,b)
			-- damn eunuchs
			return CmpLower(a,b)
		end)

		for i = 0, #list do
			ExamineMenuToggle_list[i] = BuildExamineItem(list[i])
		end

		-- add submenus to certain items
		submenu = TableFind(ExamineMenuToggle_list,"name","Presets")
		if submenu then
			-- remove hint from "submenu" menu
			ExamineMenuToggle_list[submenu].hint = nil

			-- build a list of Descendants of Preset
			local submenu_table = {}
			local c = 0
			-- dupe skipper
			local names_list = {}
			ClassDescendantsList("Preset", function(_, cls)
				if cls.GlobalMap and cls.GlobalMap ~= "" and not names_list[cls.GlobalMap] then
					names_list[cls.GlobalMap] = true
					c = c + 1
					submenu_table[c] = BuildExamineItem(cls.GlobalMap)
				end
			end)

			TableSort(submenu_table,
				function(a,b)
					-- damn eunuchs
					return CmpLower(a.name,b.name)
				end
			)
			-- add orig to the menu (we want it at start so no sorting)
			TableInsert(submenu_table,1,BuildExamineItem("Presets"))
			-- and done
			ExamineMenuToggle_list[submenu].submenu = submenu_table
		end
		--
		submenu = TableFind(ExamineMenuToggle_list,"name","DataInstances")
		if submenu then
			ExamineMenuToggle_list[submenu].hint = nil
			-- we need to build a list
			local submenu_table = {}
			local c = 0
			-- same for DataInstances
			local DataInstances = DataInstances
			for key in pairs(DataInstances) do
				c = c + 1
				submenu_table[c] = BuildExamineItem("DataInstances." .. key,key)
			end

			TableSort(submenu_table,
				function(a,b)
					-- damn eunuchs
					return CmpLower(a.name,b.name)
				end
			)

			-- add orig to the menu (we want it at start so no sorting)
			TableInsert(submenu_table,1,BuildExamineItem("DataInstances"))
			-- and done
			ExamineMenuToggle_list[submenu].submenu = submenu_table
		end
		--
		submenu = AddSubmenu("_G",{"__cobjectToCObject","Flags","HandleToObject","TranslationTable","DeletedCObjects","Flight_MarkedObjs","PropertySetMethod","debug.getregistry"})
		if submenu then
			ChoGGi.ConsoleFuncs.AddMonitor("_G",submenu)
			submenu[#submenu+1] = {
				name = S[302535920001497--[[Show Blacklist--]]],
				hint = "Show blacklisted objects",
				clicked = function()
					if blacklist then
						print(S[302535920000242--[[%s is blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have ܢer access.--]]]:format(S[302535920001497--[[Show Blacklist--]]]))
						return
					end
					-- lib should always have the blacklist enabled
					local _,bl = debug.getupvalue(getmetatable(Mods.ChoGGi_Library.env).__index,1)
					OpenInExamineDlg(bl,nil,"blacklist")
				end,
			}
		end

		submenu = AddSubmenu("ThreadsRegister",{"ThreadsMessageToThreads","ThreadsThreadToMessage","s_SeqListPlayers"})
		if submenu then
			TableInsert(submenu,2,{
				name = S[302535920000853--[[Monitor--]]] .. ": ThreadsRegister",
				hint = "ChoGGi.ComFuncs.MonitorThreads()",
				clicked = function()
					ChoGGi.ComFuncs.MonitorThreads()
				end,
			})
		end
		--
		AddSubmenu("Consts",{"g_Consts","const","ModifiablePropScale","const.TagLookupTable"})
		AddSubmenu("Dialogs",{"terminal.desktop","GetInGameInterface"})
		AddSubmenu("GlobalVars",{"GlobalVarValues","GlobalObjs","GlobalObjClasses","PersistableGlobals","GlobalGameTimeThreads","GlobalGameTimeThreadFuncs","GlobalRealTimeThreads","GlobalRealTimeThreadFuncs"})
		AddSubmenu("EntityData",{"EntityStates","EntitySurfaces","GetAllEntities","HexOutlineShapes","HexInteriorShapes","HexOutlineByHash","HexBuildShapes","HexBuildShapesInversed","HexPeripheralShapes","HexCombinedShapes"})
		AddSubmenu("g_Classes",{"ClassTemplates","Attaches","FXRules","FXLists"})
		AddSubmenu("g_CObjectFuncs",{"hr","pf","terrain","UIL","DTM","lpeg","lfs","srp","camera","camera3p","cameraMax","cameraRTS","string","table","package"})
		AddSubmenu("StoryBits",{"StoryBitCategories","StoryBitTriggersCombo","g_StoryBitStates","g_StoryBitCategoryStates"},S[948928900281--[[Story Bits--]]])
		AddSubmenu("UICity",{"UICity.labels","UICity.tech_status","BuildMenuPrerequisiteOverrides","BuildingTechRequirements","g_ApplicantPool","TaskRequesters","LRManagerInstance"})

		-- bonus addition at the top
		TableInsert(ExamineMenuToggle_list,1,{
			name = 302535920001376--[[Auto Update List--]],
			hint = 302535920001377--[[Update this list when ECM updates it.--]],
			class = "ChoGGi_CheckButtonMenu",
			value = "ChoGGi.UserSettings.ConsoleExamineListUpdate",
			clicked = function()
				ChoGGi.UserSettings.ConsoleExamineListUpdate = not ChoGGi.UserSettings.ConsoleExamineListUpdate
				ChoGGi.SettingFuncs.WriteSettings()
			end,
		})
		-- bonus addition at bottom
		ExamineMenuToggle_list[#ExamineMenuToggle_list+1] = {
			name = 302535920001378--[[XWindow Inspector--]],
			hint = 302535920001379--[[Opens up the window inspector with terminal.desktop.--]],
			clicked = function()
				local target = terminal.desktop:GetMouseTarget(terminal.GetMousePos()) or terminal.desktop
				local ged = ChoGGi.ComFuncs.OpenGedApp("XWindowInspector")
				if ged then
					GedXWindowInspectorSelectWindow(ged, target)
				end
			end,
		}
	end


	do -- ToggleLogErrors
		local select,type = select,type
		local GetStack = GetStack
		local CurrentThread = CurrentThread
		local UserSettings = ChoGGi.UserSettings
		local ChoGGi_OrigFuncs = ChoGGi.OrigFuncs
		local traceback
		if not blacklist then
			traceback = debug.traceback
		end

		local function UpdateLogErrors(name)
			_G[name] = function(...)
				if ... ~= "\n" and ... ~= "\r\n" then
					print("func",name,":",...)
					if blacklist then
						print(GetStack(2, false, "\t"))
					else
--~ 						print(traceback(CurrentThread(),nil,2))
						print(traceback())
					end
					if UserSettings.ExamineErrors then
						if testing then
							local err_type = type(select(1,...))
							-- not sure if it can ever be a func...?
							if err_type == "thread" or err_type == "function" then
								OpenInExamineDlg{...,"\n\n\n\n",err_type}
							end
						else
							OpenInExamineDlg{...}
						end
					end
				end
			end
		end

		local funcs = {"error","OutputDebugString"}
		function ChoGGi.ConsoleFuncs.ToggleLogErrors(enable)
			for i = 1, #funcs do
				if enable then
					UpdateLogErrors(funcs[i])
				else
					local name = funcs[i]
					_G[name] = ChoGGi_OrigFuncs[name]
				end
			end
		end

		-- print logged errors to console
		if UserSettings.ConsoleErrors then
			ChoGGi.ConsoleFuncs.ToggleLogErrors(true)
		end
	end -- do

	local ConsolePopupToggle_list = {
		{name = 302535920000040--[[Exec Code--]],
			hint = 302535920001287--[[Instead of a single line, you can enter/execute code in a textbox.--]],
			clicked = function()
				ChoGGi.ComFuncs.OpenInExecCodeDlg()
			end,
		},
		{name = 302535920001026--[[Show File Log--]],
			hint = 302535920001091--[[Flushes log to disk and displays in an examine dialog.--]],
			clicked = function()
				OpenInExamineDlg(LoadLogfile())
			end,
		},
		{name = 302535920000071--[[Mods Log--]],
			hint = 302535920000870--[[Shows mod log msgs in an examine dialog.--]],
			clicked = function()
				OpenInExamineDlg(ModMessageLog)
			end,
		},
		{name = " - "},
		{name = 302535920000734--[[Clear Log--]],
			hint = 302535920001152--[[Clear out the console log (F9 also works).--]],
			clicked = cls,
		},
		{name = 302535920000563--[[Copy Log Text--]],
			hint = 302535920001154--[[Displays the log text in a window you can copy sections from.--]],
			clicked = ChoGGi.ComFuncs.SelectConsoleLogText,
		},
		{name = 302535920000473--[[Reload ECM Menu--]],
			hint = 302535920000474--[[Fiddling around in the editor mod can break the menu / shortcuts added by ECM (use this to fix or alt-tab).--]],
			clicked = function()
				Msg("ShortcutsReloaded")
			end,
		},
		{name = " - "},
		{name = 302535920001479--[[Errors In Console--]],
			hint = S[302535920001480--[[Print (some) lua errors in the console (needs %s enabled).--]]]:format(S[302535920001112--[[Console Log--]]]),
			class = "ChoGGi_CheckButtonMenu",
			value = "ChoGGi.UserSettings.ConsoleErrors",
			clicked = function()
				ChoGGi.UserSettings.ConsoleErrors = not ChoGGi.UserSettings.ConsoleErrors
				ChoGGi.SettingFuncs.WriteSettings()
				ChoGGi.ConsoleFuncs.ToggleLogErrors(ChoGGi.UserSettings.ConsoleErrors)
			end,
		},
		{name = 302535920001112--[[Console Log--]],
			hint = 302535920001119--[[Show console log text in-game (probably an annoyance to non-modders).--]],
			class = "ChoGGi_CheckButtonMenu",
			value = "dlgConsoleLog",
			clicked = function()
				ChoGGi.UserSettings.ConsoleToggleHistory = not ChoGGi.UserSettings.ConsoleToggleHistory
				ChoGGi.SettingFuncs.WriteSettings()
				if ChoGGi.UserSettings.ConsoleToggleHistory then
					ShowConsoleLog(true)
					ChoGGi.ComFuncs.UpdateConsoleMargins(true)
					print("ShowConsoleLog",true)
				else
					DestroyConsoleLog()
				end
			end,
		},
		{name = 302535920001120--[[Console Log Window--]],
			hint = 302535920001133--[[Show the console log text in an independant window.--]],
			class = "ChoGGi_CheckButtonMenu",
			value = "dlgChoGGi_ConsoleLogWin",
			clicked = function()
				ChoGGi.UserSettings.ConsoleHistoryWin = not ChoGGi.UserSettings.ConsoleHistoryWin
				ChoGGi.SettingFuncs.WriteSettings()
				ChoGGi.ComFuncs.ShowConsoleLogWin(ChoGGi.UserSettings.ConsoleHistoryWin)
			end,
		},
		{name = 302535920000483--[[Write Console Log--]],
			hint = S[302535920000484--[[Write console log to %slogs/ConsoleLog.log (updated every 5 seconds).--]]]:format(ConvertToOSPath("AppData/")),
			class = "ChoGGi_CheckButtonMenu",
			value = "ChoGGi.UserSettings.WriteLogs",
			clicked = function()
				if ChoGGi.UserSettings.WriteLogs then
					ChoGGi.UserSettings.WriteLogs = false
					ChoGGi.ComFuncs.WriteLogs_Toggle(false)
				else
					ChoGGi.UserSettings.WriteLogs = true
					ChoGGi.ComFuncs.WriteLogs_Toggle(true)
				end
				ChoGGi.SettingFuncs.WriteSettings()
			end,
		},
	}

	function ChoGGi.ConsoleFuncs.HistoryPopup(self)
		local dlgConsole = dlgConsole
		local ConsoleHistoryMenuLength = ChoGGi.UserSettings.ConsoleHistoryMenuLength or 50
		local items = {}
		if #dlgConsole.history_queue > 0 then
			local history = dlgConsole.history_queue
			for i = 1, #history do
				local text = tostring(history[i])
				items[i] = {
					-- these can get long so keep 'em short
					name = text:sub(1,ConsoleHistoryMenuLength),
					hint = S[302535920001138--[[Execute this command in the console.--]]] .. "\n\n" .. text,
					clicked = function()
						dlgConsole:Exec(text)
					end,
				}
			end
		end
		PopupToggle(self,"idHistoryMenuPopup",items)
	end

	function ChoGGi.ConsoleFuncs.ConsoleControls(dlgConsole)
		local g_Classes = g_Classes

		-- make some space for the close button
		dlgConsole.idEdit:SetMargins(box(10, 0, 30, 5))
		ChoGGi.ComFuncs.UpdateConsoleMargins(dlgConsole:GetVisible())

		-- idBottomContainer isn't added when i normally setup the console stuff (ModsReloaded)
		local bottom = XShortcutsTarget.idBottomContainer
		if bottom.HAlign ~= "left" then
			bottom:SetHAlign("left")
		end

		-- add close button
		g_Classes.ChoGGi_CloseButton:new({
			Id = "idClose",
			OnPress = function()
				dlgConsole:Show()
			end,
			Margins = box(0, 0, 0, -26),
			Dock = "bottom",
			VAlign = "bottom",
			HAlign = "right",
		}, dlgConsole)

		-- stick everything in
		dlgConsole.idContainer = g_Classes.XWindow:new({
			Id = "idContainer",
			Margins = box(10, 0, 0, 0),
			HAlign = "left",
			Dock = "bottom",
			LayoutMethod = "HList",
			Image = "CommonAssets/UI/round-frame-20.tga",
		}, dlgConsole)

	--------------------------------Console popup
		dlgConsole.idConsoleMenu = g_Classes.ChoGGi_ConsoleButton:new({
			Id = "idConsoleMenu",
			RolloverText = S[302535920001089--[[Settings & Commands for the console.--]]],
			Text = S[302535920001308--[[Settings--]]],
			OnPress = function()
				PopupToggle(dlgConsole.idConsoleMenu,"idConsoleMenuPopup",ConsolePopupToggle_list)
			end,
		}, dlgConsole.idContainer)

		dlgConsole.idExamineMenu = g_Classes.ChoGGi_ConsoleButton:new({
			Id = "idExamineMenu",
			RolloverText = S[302535920000491--[[Examine Object--]]],
			Text = S[302535920000069--[[Examine--]]],
			OnPress = function()
				PopupToggle(dlgConsole.idExamineMenu,"idExamineMenuPopup",ExamineMenuToggle_list)
			end,
		}, dlgConsole.idContainer)

		dlgConsole.idHistoryMenu = g_Classes.ChoGGi_ConsoleButton:new({
			Id = "idHistoryMenu",
			RolloverText = S[302535920001080--[[Console history items (mouse-over to see code).--]]],
			Text = S[302535920000793--[[History--]]],
			OnPress = ChoGGi.ConsoleFuncs.HistoryPopup,
		}, dlgConsole.idContainer)

		if not blacklist then
			dlgConsole.idScripts = g_Classes.XWindow:new({
				Id = "idScripts",
				LayoutMethod = "HList",
			}, dlgConsole.idContainer)
		end

		-- changed examine list to a saved one instead of one made of .lua files
		ChoGGi.ConsoleFuncs.BuildExamineMenu()
	end

	local function BuildSciptButton(console,folder)
		g_Classes.ChoGGi_ConsoleButton:new({
			RolloverText = folder.RolloverText,
			Text = folder.Text,
			OnPress = function(self)
				-- build list of scripts to show
				local items = {}
				local files = RetFilesInFolder(folder.script_path,".lua")
				if files then
					for i = 1, #files do
						local err, script = AsyncFileToString(files[i].path)
						if not err then
							items[i] = {
								name = files[i].name,
								hint = S[302535920001138--[[Execute this command in the console.--]]] .. "\n\n" ..script,
								clicked = function()
									if script:find("-- rem echo on") then
										console:Exec(script)
									else
										console:Exec(script,true)
									end
								end,
							}
						end
					end
					PopupToggle(self,folder.id,items)
				else
					print(S[591853191640--[[Empty list--]]])
				end
			end,
		}, console.idScripts)
	end

	-- only check for ECM Scripts once per load
	local script_files_added
	-- rebuild menu toolbar buttons
	function ChoGGi.ConsoleFuncs.RebuildConsoleToolbar(dlg)
		if blacklist then
			return
		end

		dlg = dlg or dlgConsole

		if not dlg.idScripts then
			-- we're in the select new map stuff screen
			return
		end

		-- add example script files if folder is missing
		if not script_files_added then
			ChoGGi.ConsoleFuncs.BuildScriptFiles()
			script_files_added = true
		end

		-- clear out old buttons first
		for i = #dlg.idScripts, 1, -1 do
			dlg.idScripts[i]:delete()
			TableRemove(dlg.idScripts,i)
		end

		-- build Scripts button
		if RetFilesInFolder(ChoGGi.scripts,".lua") then
			BuildSciptButton(dlg,{
				Text = S[302535920000353--[[Scripts--]]],
				RolloverText = S[302535920000881--[["Place .lua files in %s to have them show up in the ""Scripts"" list, you can then use the list to execute them (you can also create folders for sorting)."--]]]:format(ChoGGi.scripts),
				id = "idScriptsMenuPopup",
				script_path = ChoGGi.scripts,
			})
		end

		-- check for any folders with lua files in ECM Scripts
		local folders = ChoGGi.ComFuncs.RetFoldersInFolder(ChoGGi.scripts)
		if folders then
			local hint_str = S[302535920001159--[[Any .lua files in %s.--]]]
			for i = 1, #folders do
				if RetFilesInFolder(folders[i].path,".lua") then
					BuildSciptButton(dlg,{
						Text = folders[i].name,
						RolloverText = hint_str:format(folders[i].path),
						id = "id" .. folders[i].name .. "MenuPopup",
						script_path = folders[i].path,
					})
				end
			end
		end
	end

	function ChoGGi.ConsoleFuncs.BuildScriptFiles()
		local script_path = ChoGGi.scripts
		-- create folder and some example scripts if folder doesn't exist
		if not ChoGGi.ComFuncs.FileExists(script_path) then
			AsyncCreatePath(script_path .. "/Functions")
			-- print some info
			print(S[302535920000881--[["Place .lua files in %s to have them show up in the ""Scripts"" list, you can then use the list to execute them (you can also create folders for sorting)."--]]]:format(ConvertToOSPath(script_path)))
			-- add some example files and a readme
			AsyncStringToFile(script_path .. "/readme.txt",S[302535920000888--[[Any .lua files in here will be part of a list that you can execute in-game from the console menu.--]]])
			AsyncStringToFile(script_path .. "/Read Me.lua",[[ChoGGi.ComFuncs.MsgWait(ChoGGi.Strings[302535920000881]:format(ChoGGi.scripts))]])
			AsyncStringToFile(script_path .. "/Functions/Amount of colonists.lua",[[#(UICity.labels.Colonist or "")]])
			AsyncStringToFile(script_path .. "/Functions/Toggle Working SelectedObj.lua",[[SelectedObj:ToggleWorking()]])
		end
	end

end
