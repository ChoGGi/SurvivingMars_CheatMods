-- See LICENSE for terms

local default_icon = "UI/Icons/Sections/attention.tga"

local print,tostring = print,tostring
local StringFormat = string.format

function OnMsg.ClassesGenerate()
	local MsgPopup = ChoGGi.ComFuncs.MsgPopup
	local TableConcat = ChoGGi.ComFuncs.TableConcat
	local FileExists = ChoGGi.ComFuncs.FileExists
	local Trans = ChoGGi.ComFuncs.Translate
	local S = ChoGGi.Strings
	local blacklist = ChoGGi.blacklist

	function ChoGGi.MenuFuncs.StartupTicks_Toggle()
		ChoGGi.UserSettings.ShowStartupTicks = not ChoGGi.UserSettings.ShowStartupTicks
		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.ShowStartupTicks),
			302535920001481--[[Show Startup Ticks--]]
		)
	end

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

	function ChoGGi.MenuFuncs.CreateBugReportDlg()
		local function CallBackFunc(answer)
			if answer then
				CreateRealTimeThread(function()
					Sleep(100)
					CreateBugReportDlg()
				end)
			end
		end
		ChoGGi.ComFuncs.QuestionBox(
			S[302535920000039--[["Spam in the console log doesn't necessarily mean a problem with SM (it could just a warning).
This report will go to the %s developers not me."--]]]:format(S[1079--[[Surviving Mars--]]]),
			CallBackFunc,
			StringFormat("%s %s",S[1079--[[Surviving Mars--]]],S[302535920001463--[[Bug Report--]]]),
			S[302535920001464--[[Yes, I know what I'm doing. This is a bug.--]]]
		)
	end

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
			local Mods = Mods
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
					-- yeah lets make our image parsing use spaces... I'm sure nobody uses those in file paths.
					local hint_str = "\n%s\n\n\n\n<image %s>"
					if mod_table[id].image:find(" ") or mod_table[id].path:find(" ") then
						mod_table[id].image = ""
						hint_str = "\n%s%s"
					end
					c = c + 1
					ItemList[c] = {
						author = mod_table[id].author,
						text = mod_table[id].title,
						value = hpk,
						hint = hint_str:format(
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
			if choice.nothing_selected then
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
		if hr.RenderUIL == 1 then

			-- retrieve shortcut key to display below
			local options = OptionsCreateAndLoad()
			local key = options["ECM.Help.Interface.Toggle Interface"]
			-- if we don't have a shortcut set then do nothing
			if key then
				key = key[1]
				if not key then
					return
				end
			else
				return
			end

			local function CallBackFunc(answer)
				if answer then
					hr.RenderUIL = 0
				end
			end

			ChoGGi.ComFuncs.QuestionBox(
				StringFormat("%s\n\n%s",S[302535920000244--[[Warning! This will hide everything. Remember the shortcut or have fun restarting.--]]],key),
				CallBackFunc,
				302535920000663--[[Toggle Interface--]]
			)

		else
			hr.RenderUIL = 1
		end

	end

	function ChoGGi.MenuFuncs.RetMapInfo()
		local data = HashLogToTable()
		data[1] = data[1]:gsub("\n\n","")
		ChoGGi.ComFuncs.OpenInExamineDlg(TableConcat(data,"\n"))
	end

	do -- ModUpload

		-- this keeps the check saved per session (true = steam, false = paradox)
		local upload_to_who = true
		-- true = desktop, false = desktop/console
		local upload_to_whichplatform = true

		local mod_upload_thread
		local ConvertToOSPath = ConvertToOSPath
		local MatchWildcard = MatchWildcard
		local SplitPath = SplitPath
		local AsyncCreatePath = AsyncCreatePath
		local AsyncCopyFile = AsyncCopyFile
		local IsValidThread = IsValidThread
		local mod_params = {}

		-- check the copy box for these
		local ChoGGi_copy_files = {
			ChoGGi_CheatMenu = true,
			ChoGGi_Library = true,
		}
		-- and the pack box
		local ChoGGi_pack = {
			ChoGGi_EveryFlagOnWikipedia = true,
			ChoGGi_MapImagesPack = true,
			ChoGGi_CommieMarxLogos = true,
			ChoGGi_Logos_WinnipegJets = true,
			ChoGGi_Logos_Amazon = true,
			ChoGGi_Logos_BorgCollective = true,
			ChoGGi_Logos_CaptainStar = true,
			ChoGGi_Logos_MarsBar = true,
			ChoGGi_Logos_PlanetHollywood = true,
			ChoGGi_Logos_StarshipTroopers = true,
			ChoGGi_Logos_TerranDominion = true,
			ChoGGi_Logos_VeridianDynamics = true,
		}
		local ChoGGi_platform_false = {
			ChoGGi_Library = true,
		}
		local ChoGGi_platform_true = {
			ChoGGi_CheatMenu = true,
		}
		local pack_path = "AppData/ModUpload/Pack/"
		local dest_path = "AppData/ModUpload/"
		local ss_str = "%s%s"

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			choice = choice[1]

			-- abort if upload already happening
			if IsValidThread(mod_upload_thread) then
				ChoGGi.ComFuncs.MsgWait(
					1000011--[[There is an active mod upload--]],
					1000592--[[Error--]],
					"UI/Common/mod_steam_workshop.tga"
				)
				return
			end

			mod_upload_thread = CreateRealTimeThread(function()
				local ChoGGi = ChoGGi
				local mod = choice.mod
				local mod_path = choice.path

				local copy_files = choice.check1
				local blank_mod = choice.check2
				local clipboard = choice.check3
				local pack_mod = choice.check4
				local test = choice.check5
				local steam_upload = choice.check6
				local para_platform = choice.check7

				-- pick logo for upload msg boxes
				local upload_image = "UI/ParadoxLogo.tga"
				if steam_upload then
					upload_image = "UI/Common/mod_steam_workshop.tga"
				else
					-- mods have to be packed for paradox
					pack_mod = true
				end

				local diff_author = mod.author ~= SteamGetPersonaName()
				local result

				-- my mods override
				if ChoGGi_platform_false[mod.id] then
					para_platform = false
				end
				if ChoGGi_platform_true[mod.id] then
					para_platform = true
				end
				if ChoGGi_copy_files[mod.id] then
					copy_files = false
				end
				if ChoGGi_pack[mod.id] then
					pack_mod = true
				end

				-- issue with current (rc1 modding beta) version of sm (this crashes as soon as it creates the archive).
				pack_mod = false

				-- will fail on paradox mods
				if mod.lua_revision == 0 then
					mod.lua_revision = LuaRevision
				end
				if mod.saved_with_revision == 0 then
					mod.saved_with_revision = LuaRevision
				end

				-- build / show confirmation dialog
				local upload_msg = {}

				if steam_upload then
					upload_msg[#upload_msg+1] = S[1000012--[[Mod %s will be uploaded to Steam--]]]:format(mod.title)
				else
					upload_msg[#upload_msg+1] = S[1000771--[[Mod %s will be uploaded to Paradox--]]]:format(mod.title)
				end

				if not pack_mod then
					upload_msg[#upload_msg+1] = "\n\n"
					upload_msg[#upload_msg+1] = S[302535920000051--[[Mod will not be packed in an hpk archive.--]]]
				end

				if not copy_files then
					upload_msg[#upload_msg+1] = "\n\n<color 203 120 30>"
					upload_msg[#upload_msg+1] = S[302535920001262--[[%sModUpload folder is empty and waiting for files.--]]]:format(ConvertToOSPath("AppData/"))
					upload_msg[#upload_msg+1] = "</color>"

					-- clear out and create upload folder
					AsyncDeletePath(dest_path)
					AsyncCreatePath(dest_path)
				end

				-- show diff author warning unless it's me
				if diff_author and not ChoGGi.testing then
					upload_msg[#upload_msg+1] = "\n\n"
					upload_msg[#upload_msg+1] = S[302535920001263--[["%s is different from your name, do you have permission to upload it?"--]]]:format(mod.author)
				end

				local function QuestionBoxCallBackFunc(answer)
					if not answer then
						return
					end

					MsgPopup(
						5452--[[START--]],
						302535920000367--[[Mod Upload--]]
					)

					-- always start with fresh table
					table.clear(mod_params)

					-- add new mod
					local err,item_id,prepare_worked,prepare_results
					if not test then
						if steam_upload then
							-- get needed info for mod
							prepare_worked, prepare_results = Steam_PrepareForUpload(nil, mod, mod_params)
							-- mod id for clipboard
							item_id = mod.steam_id
						-- paradox mods
						else
							-- desktop
							if para_platform then
								mod_params.publish_os = "windows"
								mod_params.uuid_property = "pops_desktop_uuid"
							-- desktop/console
							else
								mod_params.publish_os = "any"
								mod_params.uuid_property = "pops_any_uuid"
							end

							prepare_worked, prepare_results = PDX_PrepareForUpload(nil, mod, mod_params)
							item_id = mod[mod_params.uuid_property]
						end
					end

					-- issue with mod platform (workshop/paradox mods)
					if not prepare_worked then
						-- let user know if we're good or not
						ChoGGi.ComFuncs.MsgWait(
							S[1000013--[[Mod %s was not uploaded! Error: %s--]]]:format(mod.title,Trans(prepare_results)),
							StringFormat("%s: %s",S[1000592--[[Error--]]],mod.title),
							upload_image
						)
						return
					end

					-- update mod, and copy files to ModUpload
					if copy_files and not blank_mod and not err then
						mod:SaveItems()
						AsyncDeletePath(dest_path)
						AsyncCreatePath(dest_path)

						local err, all_files = AsyncListFiles(mod_path, "*", "recursive,relative")
						for i = 1, #all_files do
							local file = all_files[i]
							local ignore
							for j = 1, #mod.ignore_files do
								if MatchWildcard(file, mod.ignore_files[j]) then
									ignore = true
									break
								end
							end
							if not ignore then
								local dest_file = ss_str:format(dest_path,file)
								local dir = SplitPath(dest_file)
								AsyncCreatePath(dir)
								err = AsyncCopyFile(ss_str:format(mod_path,file), dest_file, "raw")
							end
						end

					end

					-- AsyncPack == crash :(
					if pack_mod and not true then
						local files_to_pack = {}
						local substring_begin = #dest_path + 1
						local err, all_files = AsyncListFiles(dest_path, nil, "recursive")
						if err then
							err = T{1000753,"Failed creating content package file (<err>)",err = err}
						else
							-- do this after listfiles so it doesn't include it
							AsyncCreatePath(pack_path)

							for i = 1, #all_files do
								local file = all_files[i]
								local ignore
								for j = 1, #mod.ignore_files do
									if MatchWildcard(file, mod.ignore_files[j]) then
										ignore = true
										break
									end
								end
								if not ignore then
									table.insert(files_to_pack, {
										src = file,
										dst = file:sub(substring_begin),
									})
								end
							end
--~ 							err = AsyncPack(ss_str:format(pack_path,ModsPackFileName), dest_path, files_to_pack)
							err = async.AsyncPack(false,ss_str:format(pack_path,ModsPackFileName), dest_path, files_to_pack)
						end

					end

					-- update mod on workshop
					if not err or blank_mod then

						-- check if .hpk exists, and use it if so
						local os_dest = StringFormat("%sPack/ModContent.hpk",dest_path)
						if FileExists(os_dest) then
							os_dest = ConvertToOSPath(os_dest)
						else
							os_dest = ConvertToOSPath(dest_path)
						end

						mod_params.os_pack_path = os_dest
						-- maybe we'll deal with these buggers one of these days?
						mod_params.screenshots = {}
						mod.last_changes = mod.last_changes ~= "" and mod.last_changes or tostring(mod.version)

						-- CommonLua\SteamWorkshop.lua
						if not test then
							if steam_upload then
								result,err = Steam_Upload(nil, mod, mod_params)
							else
								result,err = PDX_Upload(nil, mod, mod_params)
							end
						end
					end

					local msg, title
					if err and not blank_mod then
						msg = S[1000013--[[Mod %s was not uploaded! Error: %s--]]]:format(mod.title,Trans(err))
						title = S[1000592--[[Error--]]]
					else
						msg = S[1000014--[[Mod %s was successfully uploaded!--]]]:format(mod.title)
						title = S[1000015--[[Success--]]]
					end

					if not test then
						-- update mod log and print it to console log
						ModLog(StringFormat("\n%s: %s",msg,mod.title))
						local ModMessageLog = ModMessageLog
						print(S[302535920001265--[[ModMessageLog--]]],":")
						for i = 1, #ModMessageLog do
							print(ModMessageLog[i])
						end
					end

					-- show id in console/copy to clipb
					if not test and item_id then
						if clipboard then
							if mod_params.uuid_property then
								CopyToClipboard(StringFormat([["%s", "%s",]],mod_params.uuid_property,item_id))
							else
								CopyToClipboard(StringFormat([["steam_id", "%s",]],item_id))
							end
						end

						local id_str = S[1000021--[[Steam ID--]]]
						if not steam_upload then
							if para_platform then
								id_str = S[1000772--[[Paradox Desktop UUID--]]]
							else
								id_str = S[1000773--[[Paradox All UUID--]]]
							end
						end

						print(mod.title,":",S[1000107--[[Mod--]]],id_str,":",item_id)
					end

					-- let user know if we're good or not
					ChoGGi.ComFuncs.MsgWait(
						msg,
						StringFormat("%s: %s",title,mod.title),
						upload_image
					)

					if not test then
						-- remove upload folder
						AsyncDeletePath(dest_path)
					end
				end

				-- add checkbox for paradox asking for desktop/any
				ChoGGi.ComFuncs.QuestionBox(
					TableConcat(upload_msg),
					QuestionBoxCallBackFunc,
					mod.title,
					nil,
					nil,
					upload_image
				)
			end) -- mod_upload_thread
		end

		function ChoGGi.MenuFuncs.ModUpload()
			if blacklist then
				print(S[302535920000242--[[%s is blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have Über access.--]]]:format("ModUpload"))
				return
			end
			if not (Platform.steam or Platform.pops) then
				MsgPopup(
					StringFormat("%s || %s",S[1000760--[[Not Steam--]]],S[1000759--[[Not Paradox--]]]),
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
				local hint_str = "%s%s"
				local image = ""
				-- env_old is from my helpermod
				local path = mod.env and mod.env.CurrentModPath or mod.env_old and mod.env_old.CurrentModPath or mod.content_path or mod.path
				if mod.image ~= "" and not path:find(" ") then
					hint_str = "<image %s>\n%s"
					-- i don't know how to find rtl, so we'll reverse and find it that way. that said what's up with appending the path, can't you just do it when you need to?
					local slash = mod.image:reverse():find("/")
					image = ss_str:format(path,mod.image:sub((slash - 1) * -1))
				end
				c = c + 1
				ItemList[c] = {
					text = mod.title,
					value = id,
					hint = hint_str:format(image,mod.description),
					mod = mod,
					path = path,
				}
			end

			-- need to disable paradox upload choice on kuiper
			local check = {
				{
					title = 302535920001258--[[Copy Files--]],
					hint = S[302535920001259--[["Copies all mod files to %sModUpload, uncheck to copy files manually."--]]]:format(ConvertToOSPath("AppData/")),
					checked = true,
				},
				{
					title = 302535920001260--[[Blank--]],
					hint = 302535920001261--[["Uploads a blank mod, and prints id in log."--]],
				},
				{
					title = 302535920000664--[[Clipboard--]],
					hint = 302535920000665--[[If uploading a new mod this copies id/uuid to clipboard.--]],
					checked = true,
				},
				{
					title = 302535920001427--[[Pack--]],
					hint = 302535920001428--[["Uploads as a packed mod (default for mod editor upload).
This will always apply if uploading to paradox."--]],
					visible = false,
					checked = false,
				},
				{
					title = 186760604064--[[Test--]],
					hint = 302535920001485--[[Does everything other than uploading mod to workshop (see AppData/ModUpload).--]],
				},
				{
					title = 302535920001506--[[Steam--]],
					hint = 302535920001507--[["Uncheck to upload to Paradox mods (instead of Steam).
Mod will always be packed in hpk archive."--]],
					checked = upload_to_who,
					func = function(dlg,check)
						upload_to_who = check
						-- steam
						if check then
							dlg.idCheckBox7:SetVisible()
						-- paradox
						else
							dlg.idCheckBox7:SetVisible(true)
--~ 								dlg.idCheckBox4:SetCheck(true)
						end
					end,
				},
				{
					title = 302535920001509--[[Platform--]],
					hint = 302535920001510--[[Paradox mods platform: Leave checked to upload to Desktop only or uncheck to upload to Desktop and Console.--]],
					checked = upload_to_whichplatform,
					visible = false,
					func = function(_,check)
						upload_to_whichplatform = check
					end,
				},
			}
			-- adjust depending on if we can upload to paradox
			local width = 600.0
			if Platform.pops and not rawget(_G,"PDX_PrepareForUpload") then
				check[6].visible = false
				width = 450.0
			end
			-- it defaults to hidden, so if it's paradox then we change it to visible
			if not upload_to_who then
				check[7].visible = true
			end

			ChoGGi.ComFuncs.OpenInListChoice{
				callback = CallBackFunc,
				items = ItemList,
				title = 302535920000367--[[Mod Upload--]],
				hint = 302535920001511--[["AsyncPack crashes SM, so you'll need to use hpk to pack mod ahead of time.

https://github.com/nickelc/hpk
hpk create --cripple-lua-files ""Mod folder"" ModContent.hpk
Move archive to Mod folder/Pack/ModContent.hpk"--]],
				check = check,
				height = 800.0,
				width = width,
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
		CreateRealTimeThread(function()
			local filename,created
			if boolean == true then
					WaitNextFrame(3)
					LockCamera("Screenshot")
					filename = ChoGGi.ComFuncs.GenerateScreenshotFilename("SSAA","AppData/","tga")
					created = MovieWriteScreenshot(filename, 0, 64, false)
					UnlockCamera("Screenshot")
			else
				filename = ChoGGi.ComFuncs.GenerateScreenshotFilename("SS","AppData/","tga")
				created = WriteScreenshot(filename)
			end

			if created then
				-- slight delay so it doesn't show up in the screenshot
				Sleep(50)
				print("TakeScreenshot:",ConvertToOSPath(filename))
			end
		end)
	end

	function ChoGGi.MenuFuncs.ResetECMSettings()

		local file = ChoGGi.settings_file
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
					AsyncFileDelete(ChoGGi.settings_file)
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
