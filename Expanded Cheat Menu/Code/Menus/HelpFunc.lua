-- See LICENSE for terms

function OnMsg.ClassesGenerate()
	local MsgPopup = ChoGGi.ComFuncs.MsgPopup
	local TableConcat = ChoGGi.ComFuncs.TableConcat
	local FileExists = ChoGGi.ComFuncs.FileExists
	local Trans = ChoGGi.ComFuncs.Translate
	local S = ChoGGi.Strings
	local blacklist = ChoGGi.blacklist

	local default_icon = "UI/Icons/Sections/attention.tga"

	local print,tostring = print,tostring
	local StringFormat = string.format

	function ChoGGi.MenuFuncs.GUIDockSide_Toggle()
		local ChoGGi = ChoGGi
		local XTemplates = XTemplates

		if ChoGGi.UserSettings.GUIDockSide then
			ChoGGi.UserSettings.GUIDockSide = false
			-- command center and such
			XTemplates.NewOverlayDlg[1].Dock = "left"
			-- save/load screens
			XTemplates.SaveLoadContentWindow[1].Dock = "left"
			ChoGGi.ComFuncs.SetTableValue(XTemplates.SaveLoadContentWindow[1],"Dock","right","Dock","left")
			-- photomode
			XTemplates.PhotoMode[1].Dock = "left"
		else
			ChoGGi.UserSettings.GUIDockSide = true
			XTemplates.NewOverlayDlg[1].Dock = "right"
			XTemplates.SaveLoadContentWindow[1].Dock = "right"
			ChoGGi.ComFuncs.SetTableValue(XTemplates.SaveLoadContentWindow[1],"Dock","left","Dock","right")
			XTemplates.PhotoMode[1].Dock = "right"
		end

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.UserSettings.GUIDockSide and S[1000459--[[Right--]]] or S[1000457--[[Left--]]],
			302535920001412--[[GUI Dock Side--]]
		)
	end

	function ChoGGi.MenuFuncs.ToolTips_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.UserSettings.EnableToolTips = not ChoGGi.UserSettings.EnableToolTips
		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.EnableToolTips,
				302535920001070--[[Restart to take effect.--]]
			),
			302535920001014--[[Toggle ToolTips--]]
		)
	end

	do -- CreateBugReportDlg
		local function MissingMantis(name)
			if not rawget(_G,name) then
				_G[name] = empty_table
			end
		end
		MissingMantis("mantis_level_designers")
		MissingMantis("mantis_coders")
		MissingMantis("mantis_artists")
		MissingMantis("mantis_designers")
		MissingMantis("mantis_animators")
		-- I did not hit her!
		LocalStorage.dlgBugReport.handler = "ECM sez: Oh, hai Mark!"

		local function RetTrue()
			return true
		end
		function ChoGGi.MenuFuncs.CreateBugReportDlg()
			CreateRealTimeThread(function()
				-- muhahaha
				Platform.developer = true
				_ENV.insideHG = RetTrue

				CreateBugReportDlg()
				while GetDialog("BugReport") do
					Sleep(5000)
				end

				-- back to norm
				Platform.developer = false
				_ENV.insideHG = empty_func
			end)
		end
	end -- do

	function ChoGGi.MenuFuncs.ExtractHPKs()
		if blacklist then
			print(S[302535920000242--[[%s is blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have Über access.--]]]:format("ExtractHPKs"))
			return
		end

		local ItemList = {}
		local c = 0
		-- not much point without steam
		if Platform.steam and IsSteamAvailable() then
			-- if user installed mod while game is running
			print("ECM ExtractHPKs ModsReloadDefs:")
			ModsReloadDefs()

			-- loop through each mod and make a table of steam ids, so we don't have to loop for each mod below
			local mod_table = {}
			for _,value in pairs(Mods) do
				-- default id is 0 for non-steam mods (which we don't care about)
				mod_table[value.steam_id] = value
			end

			local steam_folders = SteamWorkshopItems()
			for i = 1, #steam_folders do
				local mod = steam_folders[i]
				-- need to reverse string so it finds the last \, since find looks ltr
				local slash = mod:reverse():find("\\")
				-- we need a neg number for sub + 1 to remove the slash
				local id = mod:sub((slash * -1) + 1)
				local hpk = StringFormat("%s/ModContent.hpk",mod:gsub("\\", "/"))
				-- skip any mods that aren't packed (uploaded by ECM, or just old)
				if mod_table[id] and FileExists(hpk) then
					c = c + 1
					ItemList[c] = {
						author = mod_table[id].author,
						text = mod_table[id].title,
						value = hpk,
						hint = StringFormat("\n%s\n\n\n\n<image %s>",
							S[302535920001364--[[Don't be an asshole to %s... Always ask permission before using other people's hard work.--]]]:format(mod_table[id].author),
							mod_table[id].image
						),
						id = id,
					}
				end
			end
		else
			MsgPopup(
				1000760--[[Not Steam--]],
				302535920001362--[[Extract HPKs--]]
			)
			return
		end

		if #ItemList == 0 then
			-- good enough msg, probably...
			MsgPopup(
				StringFormat("%s: %s",S[302535920000004--[[Dump--]]],#ItemList),
				302535920001362--[[Extract HPKs--]]
			)
			return
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			for i = 1, #choice do
				local path = StringFormat("AppData/Mods/%s",choice[i].id)
				printC(choice[i].value,path)
				AsyncUnpack(choice[i].value,path)
				-- add a note telling people not to be assholes :)
				AsyncStringToFile(
					StringFormat("%s/This is not your mod.txt",path),
					S[302535920001364--[[Don't be an asshole to %s... Always ask permission before using other people's hard work.--]]]:format(choice[i].author)
				)
			end
			MsgPopup(
				StringFormat("%s: %s",S[302535920000004--[[Dump--]]],#choice),
				302535920001362--[[Extract HPKs--]]
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920001362--[[Extract HPKs--]],
			hint = 302535920001365--[[HPK files will be unpacked into AppData/Mods/ModSteamId--]],
			multisel = true,
		}
	end

	function ChoGGi.MenuFuncs.ListAllMenuItems()
		local ChoGGi = ChoGGi
		local ItemList = {}
		local c = 0

		local actions = ChoGGi.Temp.Actions
		local hint = "%s\n\n<color 200 255 200>%s</color>"
		local icon = "<image %s 2500>"
		for i = 1, #actions do
			local a = actions[i]
			-- skip menus
			if a.OnActionEffect ~= "popup" and a.ActionName ~= "" then
				c = c + 1
				local hint_text = type(a.RolloverText) == "function" and a.RolloverText() or a.RolloverText
				local icon_str
				if a.ActionIcon and a.ActionIcon ~= "" then
					icon_str = icon:format(a.ActionIcon)
				end
				ItemList[c] = {
					text = a.ActionName,
					value = a.ActionName,
					icon = icon_str,
					func = a.OnAction,
					hint = hint:format(hint_text,a.ActionId),
				}
			end
		end
	------------------------------LIGHTMODEL CUSTOM SETTING IS OFF
		local function CallBackFunc(choice)
			if #choice < 1 or not choice[1].func then
				return
			end
			choice[1].func()
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000504--[[List All Menu Items--]],
			custom_type = 7,
			custom_func = CallBackFunc,
			height = 800.0,
		}
	end

	function ChoGGi.MenuFuncs.Interface_Toggle()
		rawset(_G, "OrgXRender", rawget(_G, "OrgXRender") or XRender)
		if XRender == OrgXRender then
			function XRender() end
		else
			XRender = OrgXRender
		end
		UIL.Invalidate()
	end

	function ChoGGi.MenuFuncs.RetMapInfo()
		local data = HashLogToTable()
		data[1] = data[1]:gsub("\n\n","")
		ChoGGi.ComFuncs.OpenInExamineDlg(TableConcat(data,"\n"))
	end

	do -- ModUpload
		local mod_upload_thread
		local ConvertToOSPath = ConvertToOSPath

		local function CallBackFunc(choice)
			-- abort if upload already happening
			if IsValidThread(mod_upload_thread) then
				ChoGGi.ComFuncs.MsgWait(
					1000011--[[There is an active Steam upload--]],
					1000592--[[Error--]],
					"UI/Common/mod_steam_workshop.tga"
				)
				return
			end

			mod_upload_thread = CreateRealTimeThread(function()
				local ChoGGi = ChoGGi
				local mod = choice[1].mod
				local copy_files = choice[1].check1
				local blank_mod = choice[1].check2
				local clipboard = choice[1].check3
				local dest = "AppData/ModUpload/"
				local diff_author = choice[1].mod.author ~= SteamGetPersonaName()
				if mod.id == "ChoGGi_CheatMenu" or mod.id == "ChoGGi_Library" then
					copy_files = false
				end

				-- build / show confirmation dialog
				local upload_msg = {
					S[1000012--[[Mod %s will be uploaded to Steam--]]]:format(mod.title),
					"\n",
					S[302535920000051--[[Mod will not be packed in an hpk file like the Mod Editor does for uploading (but you can pack it manually: ModFolder/Pack/ModContent.hpk).--]]],
					"\n\n",
					S[302535920001375--[[<color red>WARNING: Backup your first five workshop images.</color>--]]],
					"\n\n",
				}
				if not copy_files then
					upload_msg[#upload_msg+1] = "\n\n<color 203 120 30>"
					upload_msg[#upload_msg+1] = S[302535920001262--[[%sModUpload folder is empty and waiting for files.--]]]:format(ConvertToOSPath("AppData/"))
					upload_msg[#upload_msg+1] = "</color>"

					-- clear out and create upload folder
					AsyncDeletePath(dest)
					AsyncCreatePath(dest)
				end

				if diff_author then
					upload_msg[#upload_msg+1] = "\n\n"
					upload_msg[#upload_msg+1] = S[302535920001263--[["Mod author name is different from your name, do you have permission to upload this mod?"--]]]
				end

				local function QuestionBoxCallBackFunc(answer)
					if not answer then
						return
					end

					MsgPopup(
						5452--[[START--]],
						302535920000367--[[Mod Upload--]]
					)

					-- add new mod
					local err,item_id,bShowLegalAgreement
					if mod.steam_id ~= 0 then
						local exists
						local appId = SteamGetAppId()
						local userId = SteamGetUserId64()
						err, exists = AsyncSteamWorkshopUserOwnsItem(userId, appId, mod.steam_id)
						if not err and not exists then
							mod.steam_id = 0
						end
					end

					if mod.steam_id == 0 then
						err,item_id,bShowLegalAgreement = AsyncSteamWorkshopCreateItem()
						mod.steam_id = item_id or nil
					end

					-- update mod, and copy files to ModUpload
					if copy_files and not blank_mod and not err then
						local files
--~ 						-- I prefer to update this manually
--~ 						if not ChoGGi.testing then
--~ 							mod:SaveDef()
--~ 						end
						mod:SaveItems()
						AsyncDeletePath(dest)
						AsyncCreatePath(dest)
						err, files = AsyncListFiles(mod.path, "*", "recursive,relative")
						if not err then
							for i = 1, #(files or "") do
								local dest_file = StringFormat("%s%s",dest,files[i])
								local dir = SplitPath(dest_file)
								AsyncCreatePath(dir)
								err = AsyncCopyFile(StringFormat("%s%s",mod.path,files[i]), dest_file, "raw")
							end
						end
					end

					-- update mod on workshop
					if not err or blank_mod then
						-- check if .hpk exists, and use it if so
						local os_dest = StringFormat("%sPack/ModContent.hpk",dest)
						if FileExists(os_dest) then
							os_dest = ConvertToOSPath(os_dest)
						else
							os_dest = ConvertToOSPath(dest)
						end

						local params = {
							os_pack_path = os_dest,
							-- maybe we'll deal with these fuckers one of these days?
							screenshots = {},
						}
						mod.last_changes = mod.last_changes or tostring(mod.version) or ""
						-- CommonLua\SteamWorkshop.lua
						_,err = Steam_Upload(nil, mod, params)

--~ 						if Platform.steam then
--~ 							local path = mod.env and mod.env.CurrentModPath or mod.env_old and mod.env_old.CurrentModPath or mod.content_path or mod.path
--~ 							local screenshots = {}
--~ 							for i = 1, 5 do
--~ 								local location1 = StringFormat("AppData/Mod Images/%s_%s.png",mod.id,i)
--~ 								local location2 = StringFormat("AppData/Mod Images/%s_%s.jpg",mod.id,i)
--~ 								local location3 = mod[StringFormat("screenshot%s",i)]
--~ 								if location3 ~= "" then
--~ 									location3 = StringFormat("%s%s",path,location3)
--~ 								else
--~ 									location3 = nil
--~ 								end

--~ 								if FileExists(location1) then
--~ 									screenshots[#screenshots+1] = ConvertToOSPath(StringFormat("AppData/ModUpload/screenshot%s.png",i))
--~ 									AsyncCopyFile(location1,StringFormat("AppData/ModUpload/screenshot%s.png",i),"raw")
--~ 								elseif FileExists(location2) then
--~ 									screenshots[#screenshots+1] = ConvertToOSPath(StringFormat("AppData/ModUpload/screenshot%s.jpg",i))
--~ 									AsyncCopyFile(location2,StringFormat("AppData/ModUpload/screenshot%s.jpg",i),"raw")
--~ 								elseif location3 and location3 ~= path and FileExists(location3) then
--~ 									screenshots[#screenshots+1] = ConvertToOSPath(location3)
--~ 								end
--~ 							end

--~ 							local image = mod.image ~= "" and ConvertToOSPath(mod.image)
--~ 							if not io.exists(image) then
--~ 								image = ""
--~ 							end

--~ 							err = AsyncSteamWorkshopUpdateItem{
--~ 								item_id = mod.steam_id,
--~ 								title = mod.title or "",
--~ 								description = mod.description or "",
--~ 								tags = mod:GetTags(),
--~ 								content_os_folder = os_dest,
--~ 								image_os_filename = image,
--~ 								change_note = mod.last_changes or tostring(mod.version) or "",
--~ 								add_screenshots = add_screenshots,
--~ 								remove_screenshots = remove_screenshots,
--~ 								update_screenshots = update_screenshots
--~ 							}
--~ 						else
--~ 							err = "no steam"
--~ 						end
					end

					local msg, title
					if err and not blank_mod then
						msg = S[1000013--[[Mod %s was not uploaded to Steam. Error: %s--]]]:format(mod.title,Trans(err))
						title = S[1000592--[[Error--]]]
					else
						msg = S[1000014--[[Mod %s was successfully uploaded to Steam!--]]]:format(mod.title)
						title = S[1000015--[[Success--]]]
					end

					-- update mod log and print it to console log
					ModLog(StringFormat("\n%s: %s",msg,mod.title))
					local ModMessageLog = ModMessageLog
					print(S[302535920001265--[[ModMessageLog--]]],":")
					for i = 1, #ModMessageLog do
						print(ModMessageLog[i])
					end

					-- show id in console (figure out a decent way to add this to metadata.lua?)
					if item_id then
						if clipboard then
							CopyToClipboard(item_id)
						end
						print(mod.title,":",S[1000107--[[Mod--]]],S[1000021--[[Steam ID--]]],":",item_id)
					end

					-- let user know if we're good or not
					ChoGGi.ComFuncs.MsgWait(
						msg,
						StringFormat("%s: %s",title,mod.title),
						"UI/Common/mod_steam_workshop.tga"
					)

					-- remove upload folder
					AsyncDeletePath(dest)
				end

				ChoGGi.ComFuncs.QuestionBox(
					TableConcat(upload_msg),
					QuestionBoxCallBackFunc,
					mod.title,
					nil,
					nil,
					"UI/Common/mod_steam_workshop.tga"
				)
			end) -- mod_upload_thread
		end

		function ChoGGi.MenuFuncs.ModUpload()
			if blacklist then
				print(S[302535920000242--[[%s is blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have Über access.--]]]:format("ModUpload"))
				return
			end
			if not Platform.steam then
				MsgPopup(
					1000760--[[Not Steam--]],
					302535920000367--[[Mod Upload--]]
				)
				return
			end

			-- if user copied a mod over after game started
			print("ECM ModUpload ModsReloadDefs:")
			ModsReloadDefs()

			local ItemList = {}
			local c = 0
			local Mods = Mods
			for id,mod in pairs(Mods) do
				local hint_str = "%s"
				local image = ""
				if mod.image ~= "" then
					hint_str = "<image %s>\n%s"
					-- i don't know how to find rtl, so we'll reverse and find it that way. that said what's up with appending the path, can't you just do it when you need to?
					local slash = string.find(mod.image:reverse(),"/",1,true)
					local path = mod.env and mod.env.CurrentModPath or mod.env_old and mod.env_old.CurrentModPath or mod.content_path or mod.path
					image = StringFormat("%s%s",path,mod.image:sub((slash - 1) * -1))
				end
				c = c + 1
				ItemList[c] = {
					text = mod.title,
					value = id,
					hint = hint_str:format(image,mod.description),
					mod = mod,
				}
			end

			ChoGGi.ComFuncs.OpenInListChoice{
				callback = CallBackFunc,
				items = ItemList,
				title = 302535920000367--[[Mod Upload--]],
				check = {
					{
						title = 302535920001258--[[Copy Files--]],
						hint = S[302535920001259--[["Copies all mod files to %sModUpload, uncheck to copy files manually."--]]]:format(ConvertToOSPath("AppData/")),
						checked = true,
					},
					{
						title = 302535920001260--[[Blank Mod--]],
						hint = 302535920001261--[["Uploads a blank private mod to Steam Workshop, and prints Workshop id in log."--]],
					},
					{
						title = 302535920000664--[[Clipboard--]],
						hint = 302535920000665--[[If uploading a new mod this copies steam_id to clipboard.--]],
						checked = true,
					},
				},
				height = 800.0,
			}
		end
	end -- do

	function ChoGGi.MenuFuncs.EditECMSettings()
		local ChoGGi = ChoGGi
		-- load up settings file in the editor
		ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
			text = TableToLuaCode(ChoGGi.UserSettings),
			hint_ok = 302535920001244--[["Saves settings to file, and applies any changes."--]],
			hint_cancel = 302535920001245--[[Abort without touching anything.--]],
			custom_func = function(answer,_,obj)
				if answer then
					-- get text and update settings file
					local err,settings = LuaCodeToTuple(obj.idEdit:GetText())
					if not err then
						ChoGGi.UserSettings = ChoGGi.SettingFuncs.WriteSettings(settings)
						-- for now just updates console examine list
						Msg("ChoGGi_SettingsUpdated")
						MsgPopup(
							S[4273--[[Saved on %s--]]]:format(StringFormat("%s:%s:%s",FormatElapsedTime(os.time(), "dhm"))),
							302535920001308--[[Settings--]]
						)
					end
				end
			end,
		}
	end

	function ChoGGi.MenuFuncs.DisableECM()
		local function CallBackFunc(answer)
			if answer then
				local ChoGGi = ChoGGi
				ChoGGi.UserSettings.DisableECM = not ChoGGi.UserSettings.DisableECM
				ChoGGi.SettingFuncs.WriteSettings()

				MsgPopup(302535920001070--[[Restart to take effect.--]])
			end
		end
		ChoGGi.ComFuncs.QuestionBox(
			StringFormat("%s\n\n%s",S[302535920000466--[["This will disable the cheats menu, cheats panel, and all hotkeys.
Change DisableECM to false in settings file to re-enable them."--]]],S[302535920001070--[[Restart to take effect.--]]]),
			CallBackFunc,
			302535920000142--[[Disable--]]
		)
	end

	function ChoGGi.MenuFuncs.ShowInterfaceInScreenshots_Toggle()
		local ChoGGi = ChoGGi
		hr.InterfaceInScreenshot = hr.InterfaceInScreenshot ~= 0 and 0 or 1
		-- needs default
		ChoGGi.UserSettings.ShowInterfaceInScreenshots = not ChoGGi.UserSettings.ShowInterfaceInScreenshots

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920001068--[[%s: Interface in screenshots.--]]]:format(ChoGGi.UserSettings.ShowInterfaceInScreenshots),
			302535920001069--[[Interface--]]
		)
	end

	function ChoGGi.MenuFuncs.TakeScreenshot(boolean)
		local filename
		CreateRealTimeThread(function()
			if boolean == true then
					WaitNextFrame(3)
					LockCamera("Screenshot")
					filename = GenerateScreenshotFilename("SSAA","AppData/")
					MovieWriteScreenshot(filename, 0, 64, false)
					UnlockCamera("Screenshot")
			else
				filename = GenerateScreenshotFilename("SS","AppData/")
				WriteScreenshot(filename)
			end
			-- slight delay so it doesn't show up in the screenshot
			Sleep(50)
			print(ConvertToOSPath(filename))
		end)
	end

	function ChoGGi.MenuFuncs.ResetECMSettings()

		local file = ChoGGi.SettingsFile
		local old = StringFormat("%s.old",file)

		local function CallBackFunc(answer)
			if answer then
				if blacklist then
					ChoGGi.UserSettings = ChoGGi.Defaults
				else
					ThreadLockKey(old)
					AsyncCopyFile(file,old)
					ThreadUnlockKey(old)

					ThreadLockKey(file)
					AsyncFileDelete(ChoGGi.SettingsFile)
					ThreadUnlockKey(file)
				end

				ChoGGi.Temp.ResetECMSettings = true
				ChoGGi.SettingFuncs.WriteSettings()

				MsgPopup(
					302535920001070--[[Restart to take effect.--]],
					302535920001084--[[Reset--]],
					default_icon
				)
			end
		end

		ChoGGi.ComFuncs.QuestionBox(
			StringFormat("%s\n\n%s",S[302535920001072--[[Are you sure you want to reset ECM settings?
	Old settings are saved as %s (or not saved if you don't use the HelperMod)--]]]:format(old),S[302535920001070--[[Restart to take effect.--]]]),
			CallBackFunc,
			StringFormat("%s!",S[302535920001084--[[Reset--]]])
		)
	end

	function ChoGGi.MenuFuncs.OnScreenHints_Toggle()
		HintsEnabled = not HintsEnabled
		SetHintNotificationsEnabled(HintsEnabled)
		mapdata.DisableHints = not HintsEnabled
		UpdateOnScreenHintDlg()
		MsgPopup(
			tostring(HintsEnabled),
			4248--[[Hints--]]
		)
	end

	function ChoGGi.MenuFuncs.OnScreenHints_Reset()
		g_ShownOnScreenHints = {}
		UpdateOnScreenHintDlg()
		MsgPopup(
			302535920001076--[[Hints Reset!--]],
			4248--[[Hints--]]
		)
	end

	function ChoGGi.MenuFuncs.NeverShowHints_Toggle()
		local ChoGGi = ChoGGi
		if ChoGGi.UserSettings.DisableHints then
			ChoGGi.UserSettings.DisableHints = nil
			mapdata.DisableHints = false
			HintsEnabled = true
		else
			ChoGGi.UserSettings.DisableHints = true
			mapdata.DisableHints = true
			HintsEnabled = false
		end

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920001077--[[%s: Bye bye hints--]]]:format(ChoGGi.UserSettings.DisableHints),
			4248--[[Hints--]],
			"UI/Icons/Sections/attention.tga"
		)
	end

	function ChoGGi.MenuFuncs.ReportBugDlg()
		--was in orig func, i guess there's never any bugs when modding :)
		if Platform.ged then
			return
		end
		CreateRealTimeThread(function()
			CreateBugReportDlg()
		end)
	end

	function ChoGGi.MenuFuncs.AboutECM()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.MsgWait(
			S[302535920001078--[["Hover mouse over menu item to get description and enabled status
	If there isn't a status then it's likely a list of options to choose from

	For any issues; please report them to my Github/Steam/NexusMods page, or email %s"--]]]:format(ChoGGi.email),
			487939677892--[[Help--]]
		)
	end

end
