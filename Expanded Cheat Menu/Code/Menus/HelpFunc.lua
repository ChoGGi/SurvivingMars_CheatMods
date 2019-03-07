-- See LICENSE for terms

local print,tostring = print,tostring

function OnMsg.ClassesGenerate()
	local MsgPopup = ChoGGi.ComFuncs.MsgPopup
	local TableConcat = ChoGGi.ComFuncs.TableConcat
	local FileExists = ChoGGi.ComFuncs.FileExists
	local Trans = ChoGGi.ComFuncs.Translate
	local S = ChoGGi.Strings
	local blacklist = ChoGGi.blacklist
	local testing = ChoGGi.testing

	function ChoGGi.MenuFuncs.OpenUrl(action)
		OpenUrl(action.setting_url)
	end

	function ChoGGi.MenuFuncs.DeleteSavedGames()
		if blacklist then
			ChoGGi.ComFuncs.BlacklistMsg("ChoGGi.MenuFuncs.DeleteSavedGames")
			return
		end
		local SavegamesList = SavegamesList
		local item_list = {}
		for i = 1, #SavegamesList do
			local data = SavegamesList[i]

			-- build played time
			local playtime = T(77, "Unknown")
			if data.playtime then
				local h, m, _ = FormatElapsedTime(data.playtime, "hms")
				playtime = T{
					7549, "<hours>:<minutes>",
					hours = string.format("%02d", h),
					minutes = string.format("%02d", m)
				}
			end
			-- and last saved
			local save_date = 0
			if data.timestamp then
				save_date = os.date("%H:%M - %d / %m / %Y", data.timestamp)
			end

			item_list[i] = {
				text = data.displayname,
				value = data.savename,

				hint = Trans(4274--[[Playtime : <playtime>--]]):gsub("<playtime>",Trans(playtime)) .. "\n"
					.. Trans(4273--[[Saved on : <save_date>--]]):gsub("<save_date>",save_date) .. "\n\n"
					.. S[302535920001274--[[This is permanent!--]]],
			}
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local value = choice[1].value

			if not choice[1].check1 then
				MsgPopup(
					S[302535920000038--[[Pick a checkbox next time...--]]],
					S[302535920000146--[[Delete Saved Games--]]]
				)
				return
			end
			local save_folder = GetPCSaveFolder()

			for i = 1, #choice do
				value = choice[i].value
				if type(value) == "string" then
					AsyncFileDelete(save_folder .. value)
				end
			end

			-- remove any saves we deleted
			local FileExists = ChoGGi.ComFuncs.FileExists
			local games_amt = #SavegamesList
			for i = #SavegamesList, 1, -1 do
				if not FileExists(save_folder .. SavegamesList[i].savename) then
					SavegamesList[i] = nil
					table_remove(SavegamesList,i)
				end
			end

			games_amt = games_amt - #SavegamesList
			if games_amt > 0 then
				MsgPopup(
					S[302535920001275--[[Deleted %s saved games.--]]]:format(games_amt),
					S[302535920000146--[[Delete Saved Games--]]]
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = S[302535920000146--[[Delete Saved Games--]]] .. ": " .. #item_list,
			hint = Trans(6779--[[Warning--]]) .. ": " .. S[302535920001274--[[This is permanent!--]]],
			multisel = true,
			skip_sort = true,
			checkboxes = {
				{
					title = Trans(1000009--[[Confirmation--]]),
					hint = S[302535920001276--[[Nothing is deleted unless you check this.--]]],
				},
			},
		}
	end

	function ChoGGi.MenuFuncs.StartupTicks_Toggle()
		ChoGGi.UserSettings.ShowStartupTicks = not ChoGGi.UserSettings.ShowStartupTicks
		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.ShowStartupTicks),
			S[302535920001481--[[Show Startup Ticks--]]]
		)
	end

	function ChoGGi.MenuFuncs.ToolTips_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.UserSettings.EnableToolTips = not ChoGGi.UserSettings.EnableToolTips
		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.EnableToolTips,
				S[302535920001070--[[Restart to take effect.--]]]
			),
			S[302535920001014--[[Toggle ToolTips--]]]
		)
	end

	function ChoGGi.MenuFuncs.CreateBugReportDlg()
		local function CallBackFunc(answer)
			if answer then
				CreateRealTimeThread(function()
					-- delay (automagical) screenshot till after question box is closed
					Sleep(100)
					CreateBugReportDlg()
				end)
			end
		end
		ChoGGi.ComFuncs.QuestionBox(
			S[302535920000039--[["Spam in the console log doesn't necessarily mean a problem with SM (it could just a warning).
This report will go to the %s developers not me."--]]]:format(Trans(1079--[[Surviving Mars--]])),
			CallBackFunc,
			Trans(1079--[[Surviving Mars--]]) .. " " .. S[302535920001463--[[Bug Report--]]],
			S[302535920001464--[[Yes, I know what I'm doing. This is a bug.--]]]
		)
	end

	function ChoGGi.MenuFuncs.ExtractHPKs()
		if blacklist then
			ChoGGi.ComFuncs.BlacklistMsg("ChoGGi.MenuFuncs.ExtractHPKs")
			return
		end
		local item_list = {}
		local c = 0

		-- not much point without steam
		if Platform.steam or Platform.pops then
			local mod_folders = {}

			-- if user installed mod while game is running
			print("ECM ExtractHPKs ModsReloadDefs:")
			ModsReloadDefs()

			if Platform.steam and IsSteamAvailable() then
				table.append(mod_folders, SteamWorkshopItems())
			end
			if Platform.pops then
				table.append(mod_folders, io.listfiles(const.PopsModsDownloadPath, "*", "folders, non recursive"))
			end

			-- loop through each mod and make a table of ids, so we don't have to loop for each mod below
			local mod_table = {}
			local Mods = Mods
			for _,mod in pairs(Mods) do
				mod_table[mod.steam_id] = mod
				mod_table[mod.pops_any_uuid] = mod
				mod_table[mod.pops_desktop_uuid] = mod
			end

			for i = 1, #mod_folders do
				local folder = mod_folders[i]
				-- need to reverse string so it finds the last \, since find looks ltr
				local slash = folder:reverse():find("\\")
				-- we need a neg number for sub + 1 to remove the slash
				local id = folder:sub((slash * -1) + 1)

				local hpk = folder:gsub("\\", "/") .. "/ModContent.hpk"
				-- skip any mods that aren't packed (uploaded by ECM, or just old)
				local mod = mod_table[id]
				if mod and FileExists(hpk) then
					-- yeah lets make our image parsing use spaces... I'm sure nobody uses those in file paths.
					if mod.image:find(" ") or mod.path:find(" ") then
						mod.image = ""
					else
						mod.image = "\n\n\n\n<image " .. mod.image .. ">"
					end
					c = c + 1
					item_list[c] = {
						author = mod.author,
						text = mod.title,
						value = hpk,
						hint = "\n"
							.. S[302535920001364--[[Don't be an asshole to %s... Always ask permission before using other people's hard work.--]]]:format(mod.author)
							.. mod.image,
						id = id,
					}
				end
			end

		else
			MsgPopup(
				Trans(1000760--[[Not Steam--]]) .. "/" .. Trans(1000759--[[Not Paradox--]]),
				S[302535920001362--[[Extract HPKs--]]]
			)
			return
		end

		if #item_list == 0 then
			-- good enough msg, probably...
			MsgPopup(
				S[302535920000004--[[Dump--]]] .. ": " .. #item_list,
				S[302535920001362--[[Extract HPKs--]]]
			)
			return
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			for i = 1, #choice do
				local path = "AppData/Mods/" .. choice[i].id
				printC(choice[i].value,path)
				AsyncUnpack(choice[i].value,path)
				-- add a note telling people not to be assholes
				AsyncStringToFile(
					path .. "/This is not your mod.txt",
					S[302535920001364--[[Don't be an asshole to %s... Always ask permission before using other people's hard work.--]]]:format(choice[i].author)
				)
			end
			MsgPopup(
				S[302535920000004--[[Dump--]]] .. ": " .. #choice,
				S[302535920001362--[[Extract HPKs--]]]
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = S[302535920001362--[[Extract HPKs--]]],
			hint = S[302535920001365--[[HPK files will be unpacked into AppData/Mods/ModSteamId--]]],
			multisel = true,
		}
	end

	function ChoGGi.MenuFuncs.ListAllMenuItems()
		local ChoGGi = ChoGGi
		local item_list = {}
		local c = 0

		local actions = ChoGGi.Temp.Actions
		for i = 1, #actions do
			local a = actions[i]
			-- skip menus
			if a.OnActionEffect ~= "popup" and a.ActionName ~= "" then
				c = c + 1
				local hint_text = type(a.RolloverText) == "function" and a.RolloverText() or a.RolloverText
				local icon_str
				if a.ActionIcon and a.ActionIcon ~= "" then
					icon_str = "<image " .. a.ActionIcon .. " 2500>"
				end

				-- bonus for list all items
				local icon_scale
				if a.ActionId:sub(1,9) == "ECM.Keys." then
					icon_str = ChoGGi.library_path .. "UI/bmc_incal_resources.png"
					icon_scale = 650
				end

				local short = a.ActionShortcut

				item_list[c] = {
					text = a.ActionName,
					value = a.ActionName,
					icon = icon_str,
					icon_scale = icon_scale,
					func = a.OnAction,
					hint = (hint_text ~= "" and hint_text .. "\n\n" or "")
						.. "<color 200 255 200>" .. a.ActionId .. "</color>"
						.. (short ~= "" and "\n\nActionShortcut: " .. short or ""),
				}
			end
		end

		local function CallBackFunc(choice)
			if #choice < 1 or not choice[1].func then
				return
			end
			choice[1].func()
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = S[302535920000504--[[List All Menu Items--]]],
			custom_type = 7,
			height = 800.0,
		}
	end

	function ChoGGi.MenuFuncs.RetMapInfo()
		if not GameState.gameplay then
			return
		end
		local data = HashLogToTable()
		data[1] = data[1]:gsub("\n\n","")
		ChoGGi.ComFuncs.OpenInExamineDlg(TableConcat(data,"\n"),nil,Trans(283142739680--[[Game--]]) .. " & " .. S[302535920001355--[[Map--]]] .. " " .. Trans(126095410863--[[Info--]]))
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

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			choice = choice[1]

			-- abort if upload already happening
			if IsValidThread(mod_upload_thread) then
				ChoGGi.ComFuncs.MsgWait(
					Trans(1000011--[[There is an active mod upload--]]),
					Trans(1000592--[[Error--]]),
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

				-- remove blacklist warning from title (added in helpermod)
				if testing then
					mod.title = mod.title:gsub(" %(BL%)$","")
				else
					mod.title = mod.title:gsub(" %(Warning%)$","")
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
				local m_c = 0

				m_c = m_c + 1
				if steam_upload then
					upload_msg[m_c] = Trans(1000012--[[Mod <ModLabel> will be uploaded to Steam--]]):gsub("<ModLabel>",mod.title)
				else
					upload_msg[m_c] = Trans(1000771--[[Mod <ModLabel> will be uploaded to Paradox--]]):gsub("<ModLabel>",mod.title)
				end

				if not pack_mod then
					m_c = m_c + 1
					upload_msg[m_c] = "\n\n"
					m_c = m_c + 1
					upload_msg[m_c] = S[302535920000051--[[Mod will not be packed in an hpk archive.--]]]
				end

				if not copy_files then
					m_c = m_c + 1
					upload_msg[m_c] = "\n\n<color 203 120 30>"
					m_c = m_c + 1
					upload_msg[m_c] = S[302535920001262--[[%sModUpload folder is empty and waiting for files.--]]]:format(ConvertToOSPath("AppData/"))
					m_c = m_c + 1
					upload_msg[m_c] = "</color>"

					-- clear out and create upload folder
					AsyncDeletePath(dest_path)
					AsyncCreatePath(dest_path)
				end

				-- show diff author warning unless it's me
				if diff_author and not testing then
					m_c = m_c + 1
					upload_msg[m_c] = "\n\n"
					m_c = m_c + 1
					upload_msg[m_c] = S[302535920001263--[["%s is different from your name, do you have permission to upload it?"--]]]:format(mod.author)
				end

				local function QuestionBoxCallBackFunc(answer)
					if not answer then
						return
					end

					MsgPopup(
						Trans(5452--[[START--]]),
						S[302535920000367--[[Mod Upload--]]]
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
							-- we override the Platform checkbox if a uuid is in metadata.lua
							-- if both are "" then it's probably a new mod, otherwise check for a uuid and use that prop
							if mod.pops_desktop_uuid == "" and mod.pops_any_uuid == "" then
								-- desktop
								if para_platform then
									mod_params.publish_os = "windows"
									mod_params.uuid_property = "pops_desktop_uuid"
								-- desktop/console
								else
									mod_params.publish_os = "any"
									mod_params.uuid_property = "pops_any_uuid"
								end
							elseif mod.pops_any_uuid ~= "" then
								mod_params.publish_os = "any"
								mod_params.uuid_property = "pops_any_uuid"
								para_platform = false
							elseif mod.pops_desktop_uuid ~= "" then
								mod_params.publish_os = "windows"
								mod_params.uuid_property = "pops_desktop_uuid"
								para_platform = true
							end

							prepare_worked, prepare_results = PDX_PrepareForUpload(nil, mod, mod_params)
							item_id = mod[mod_params.uuid_property]
						end
					end

					-- issue with mod platform (workshop/paradox mods)
					if not prepare_worked then
						-- let user know if we're good or not
						ChoGGi.ComFuncs.MsgWait(
							Trans(1000013--[[Mod <ModLabel> was not uploaded! Error: <err>--]]):gsub("<ModLabel>",mod.title):gsub("<err>",Trans(prepare_results)),
							Trans(1000592--[[Error--]]) .. ": " .. mod.title,
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
								local dest_file = dest_path .. file
								local dir = SplitPath(dest_file)
								AsyncCreatePath(dir)
								err = AsyncCopyFile(mod_path .. file, dest_file, "raw")
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
--~ 							err = AsyncPack(pack_path .. ModsPackFileName, dest_path, files_to_pack)
							err = async.AsyncPack(false,pack_path .. ModsPackFileName, dest_path, files_to_pack)
						end

					end

					-- update mod on workshop
					if not err or blank_mod then

						-- check if .hpk exists, and use it if so
						local os_dest = dest_path .. "Pack/ModContent.hpk"
						if FileExists(os_dest) then
							os_dest = ConvertToOSPath(os_dest)
						else
							os_dest = ConvertToOSPath(dest_path)
						end

						mod_params.os_pack_path = os_dest
						-- maybe we'll deal with these buggers one of these days?
						mod_params.screenshots = {}
						-- set last_changes to last_changes or version num
						mod.last_changes = type(mod.last_changes) == "string" and mod.last_changes ~= "" and tostring(mod.last_changes) or tostring(mod.version)

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
						msg = Trans(1000013--[[Mod <ModLabel> was not uploaded! Error: <err>--]]):gsub("<ModLabel>",mod.title):gsub("<err>",Trans(err))
						title = Trans(1000592--[[Error--]])
					else
						msg = Trans(1000014--[[Mod <ModLabel> was successfully uploaded!--]]):gsub("<ModLabel>",mod.title)
						title = Trans(1000015--[[Success--]])
					end

					if not test then
						-- update mod log and print it to console log
						ModLog("\n" .. msg .. ": " .. mod.title)
						local ModMessageLog = ModMessageLog
						print(S[302535920001265--[[ModMessageLog--]]],":")
						for i = 1, #ModMessageLog do
							print(ModMessageLog[i])
						end
					end

					-- show id in console/copy to clipb
					if not test and item_id then

						if clipboard and not err then
							if mod_params.uuid_property then
								CopyToClipboard("	\"" .. mod_params.uuid_property .. "\", \"" .. item_id .. "\",")
							else
								CopyToClipboard("	\"steam_id\", \"" .. item_id .. "\",")
							end
						end

						local id_str = Trans(1000021--[[Steam ID--]])
						if not steam_upload then
							if para_platform then
								id_str = Trans(1000772--[[Paradox Desktop UUID--]])
							else
								id_str = Trans(1000773--[[Paradox All UUID--]])
							end
						end

						print(mod.title,":",Trans(1000107--[[Mod--]]),id_str,":",item_id)
					end

					-- let user know if we're good or not
					ChoGGi.ComFuncs.MsgWait(
						msg,
						title .. ": " .. mod.title,
						upload_image
					)

					if not test and not err then
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
				ChoGGi.ComFuncs.BlacklistMsg("ChoGGi.MenuFuncs.ModUpload")
				return
			end
			if not (Platform.steam or Platform.pops) then
				MsgPopup(
					Trans(1000760--[[Not Steam--]]) .. "/" .. Trans(1000759--[[Not Paradox--]]),
					S[302535920000367--[[Mod Upload--]]]
				)
				return
			end

			-- if user copied a mod over after game started
			print("ECM ModUpload ModsReloadDefs:")
			ModsReloadDefs()

			local item_list = {}
			local c = 0
			local Mods = Mods
			for id,mod in pairs(Mods) do
				local image = ""
				-- env_old is from my helpermod
				local path = mod.env and mod.env.CurrentModPath or mod.env_old and mod.env_old.CurrentModPath or mod.content_path or mod.path
				if mod.image ~= "" and not path:find(" ") then
					-- i don't know how to find rtl, so we'll reverse and find it that way.
					local slash = mod.image:reverse():find("/")
					image = "<image " .. path .. "" .. mod.image:sub((slash - 1) * -1) .. ">\n\n"
				end
				c = c + 1
				item_list[c] = {
					text = mod.title,
					value = id,
					hint = image .. mod.description,
					mod = mod,
					path = path,
				}
			end

			-- hide paradox upload if not on plat.pops
			local checkboxes = {
				{title = S[302535920001258--[[Copy Files--]]],
					hint = S[302535920001259--[["Copies all mod files to %sModUpload, uncheck to copy files manually."--]]]:format(ConvertToOSPath("AppData/")),
					checked = true,
				},
				{title = S[302535920001260--[[Blank--]]],
					hint = S[302535920001261--[["Uploads a blank mod, and prints id in log."--]]],
				},
				{title = S[302535920000664--[[Clipboard--]]],
					hint = S[302535920000665--[[If uploading a mod this copies steam id or uuid to clipboard.--]]],
					checked = true,
				},
				{title = S[302535920001427--[[Pack--]]],
					-- AsyncPack is crashing sm for me
					visible = false,

					hint = S[302535920001428--[["Uploads as a packed mod (default for mod editor upload).
This will always apply if uploading to paradox."--]]],
					checked = false,
				},
				{title = Trans(186760604064--[[Test--]]),
					level = 2,
					hint = S[302535920001485--[[Does everything other than uploading mod to workshop (see AppData/ModUpload).--]]],
				},
				{title = S[302535920001506--[[Steam--]]],
					level = 2,
					hint = S[302535920001507--[[Uncheck to upload to Paradox mods (instead of Steam).--]]],
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
				{title = S[302535920001509--[[Platform--]]],
					level = 2,
					hint = S[302535920001510--[[Paradox mods platform: Leave checked to upload to Desktop only or uncheck to upload to Desktop and Console.--]]],
					checked = upload_to_whichplatform,
					visible = false,
					func = function(_,check)
						upload_to_whichplatform = check
					end,
				},
			}
			-- adjust depending on if we can upload to paradox
			if not Platform.pops then
				checkboxes[6].visible = false
			end
			-- it defaults to hidden, so if it's paradox then we change it to visible
			if not upload_to_who then
				checkboxes[7].visible = true
			end

			ChoGGi.ComFuncs.OpenInListChoice{
				callback = CallBackFunc,
				items = item_list,
				title = S[302535920000367--[[Mod Upload--]]],
				hint = S[302535920001511--[["AsyncPack crashes SM, so you'll need to use hpk to pack mod ahead of time.

https://github.com/nickelc/hpk
hpk create ""Mod folder"" ModContent.hpk
Move archive to Mod folder/Pack/ModContent.hpk"--]]],
				checkboxes = checkboxes,
				height = 800.0,
			}
		end
	end -- do

	function ChoGGi.MenuFuncs.EditECMSettings()
		-- load up settings file in the editor
		ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
			text = TableToLuaCode(ChoGGi.UserSettings),
			hint_ok = S[302535920001244--[["Saves settings to file, and applies any changes."--]]],
			hint_cancel = S[302535920001245--[[Abort without touching anything.--]]],
			custom_func = function(answer,_,obj)
				if answer then
					-- get text and update settings file
					local err,settings = LuaCodeToTuple(obj.idEdit:GetText())
					if not err then
						ChoGGi.UserSettings = ChoGGi.SettingFuncs.WriteSettings(settings)
						-- for now just updates console examine list
						Msg("ChoGGi_SettingsUpdated")
						local d,m,h = FormatElapsedTime(os.time(), "dhm")
						MsgPopup(
							Trans(4273--[[Saved on <save_date>--]]):gsub("<save_date>",": " .. d .. ":" .. m .. ":" .. h),
							S[302535920001242--[[Edit ECM Settings--]]]
						)
					end
				end
			end,
		}
	end

	function ChoGGi.MenuFuncs.DisableECM()
		local title = Trans(251103844022--[[Disable--]]) .. " " .. S[302535920000887--[[ECM--]]]
		local function CallBackFunc(answer)
			if answer then
				local ChoGGi = ChoGGi
				ChoGGi.UserSettings.DisableECM = not ChoGGi.UserSettings.DisableECM
				ChoGGi.SettingFuncs.WriteSettings()

				MsgPopup(
					S[302535920001070--[[Restart to take effect.--]]],
					title
				)
			end
		end
		ChoGGi.ComFuncs.QuestionBox(
			S[302535920000466--[["This will disable the cheats menu, cheats panel, and all hotkeys.
Change DisableECM to false in settings file to re-enable them."--]]] .. "\n\n" .. S[302535920001070--[[Restart to take effect.--]]],
			CallBackFunc,
			title
		)
	end

	function ChoGGi.MenuFuncs.ResetECMSettings()
		local file = ChoGGi.settings_file
		local old = file .. ".old"

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
					S[302535920001070--[[Restart to take effect.--]]],
					S[302535920000676--[[Reset ECM Settings--]]]
				)
			end
		end

		ChoGGi.ComFuncs.QuestionBox(
			S[302535920001072--[[Are you sure you want to reset ECM settings?
	Old settings are saved as %s (or not saved if you don't use the HelperMod)--]]]:format(old) .. "\n\n" .. S[302535920001070--[[Restart to take effect.--]]],
			CallBackFunc,
			S[302535920001084--[[Reset--]]] .. "!"
		)
	end

	function ChoGGi.MenuFuncs.ReportBugDlg()
		-- was in orig func, i guess there's never any bugs when modding :)
		if Platform.ged then
			return
		end
		CreateRealTimeThread(function()
			Sleep(50)
			CreateBugReportDlg()
		end)
	end

	function ChoGGi.MenuFuncs.AboutECM()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.MsgWait(
			S[302535920001078--[["Hover mouse over menu item to get description and enabled status
	If there isn't a status then it's likely a list of options to choose from

	For any issues; please report them to my Github/Steam/NexusMods page, or email %s"--]]]:format(ChoGGi.email),
			Trans(487939677892--[[Help--]])
		)
	end

end
