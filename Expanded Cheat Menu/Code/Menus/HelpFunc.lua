-- See LICENSE for terms

local print = print

local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local TableConcat = ChoGGi.ComFuncs.TableConcat
local FileExists = ChoGGi.ComFuncs.FileExists
local Translate = ChoGGi.ComFuncs.Translate
local Strings = ChoGGi.Strings
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

			hint = Translate(4274--[[Playtime : <playtime>--]]):gsub("<playtime>", Translate(playtime)) .. "\n"
				.. Translate(4273--[[Saved on : <save_date>--]]):gsub("<save_date>", save_date) .. "\n\n"
				.. Strings[302535920001274--[[This is permanent!--]]],
		}
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value

		if not choice[1].check1 then
			MsgPopup(
				Strings[302535920000038--[[Pick a checkbox next time...--]]],
				Strings[302535920000146--[[Delete Saved Games--]]]
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
				table_remove(SavegamesList, i)
			end
		end

		games_amt = games_amt - #SavegamesList
		if games_amt > 0 then
			MsgPopup(
				Strings[302535920001275--[[Deleted %s saved games.--]]]:format(games_amt),
				Strings[302535920000146--[[Delete Saved Games--]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000146--[[Delete Saved Games--]]] .. ": " .. #item_list,
		hint = Translate(6779--[[Warning--]]) .. ": " .. Strings[302535920001274--[[This is permanent!--]]],
		multisel = true,
		skip_sort = true,
		checkboxes = {
			{
				title = Translate(1000009--[[Confirmation--]]),
				hint = Strings[302535920001276--[[Nothing is deleted unless you check this.--]]],
			},
		},
	}
end

function ChoGGi.MenuFuncs.StartupTicks_Toggle()
	ChoGGi.UserSettings.ShowStartupTicks = not ChoGGi.UserSettings.ShowStartupTicks
	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.ShowStartupTicks),
		Strings[302535920001481--[[Show Startup Ticks--]]]
	)
end

function ChoGGi.MenuFuncs.ToolTips_Toggle()
	ChoGGi.UserSettings.EnableToolTips = not ChoGGi.UserSettings.EnableToolTips
	ChoGGi.ComFuncs.SetLibraryToolTips()

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.EnableToolTips),
		Strings[302535920001014--[[Toggle ToolTips--]]]
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
		Strings[302535920000039--[["Spam in the console log doesn't necessarily mean a problem with SM (it could just a warning).
This report will go to the %s developers not me."--]]]:format(Translate(1079--[[Surviving Mars--]])),
		CallBackFunc,
		Translate(1079--[[Surviving Mars--]]) .. " " .. Strings[302535920001463--[[Bug Report--]]],
		Strings[302535920001464--[[Yes, I know what I'm doing. This is a bug.--]]]
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
		print("ECM ExtractHPKs ModsReloadDefs():")
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
		for _, mod in pairs(Mods) do
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
						.. Strings[302535920001364--[[Don't be an asshole to %s... Always ask permission before using other people's hard work.--]]]:format(mod.author)
						.. mod.image,
					id = id,
				}
			end
		end

	else
		MsgPopup(
			Translate(1000760--[[Not Steam--]]) .. "/" .. Translate(1000759--[[Not Paradox--]]),
			Strings[302535920001362--[[Extract HPKs--]]]
		)
		return
	end

	if #item_list == 0 then
		-- good enough msg, probably...
		MsgPopup(
			Strings[302535920000004--[[Dump--]]] .. ": " .. #item_list,
			Strings[302535920001362--[[Extract HPKs--]]]
		)
		return
	end

	local function CallBackFunc(choices)
		if choices.nothing_selected then
			return
		end
		for i = 1, #choices do
			local choice = choices[i]
			local path = "AppData/Mods/" .. choice.id
			printC(choice.value, path)
			AsyncUnpack(choice.value, path)
			-- add a note telling people not to be assholes
			AsyncStringToFile(
				path .. "/This is not your mod.txt",
				Strings[302535920001364--[[Don't be an asshole to %s... Always ask permission before using other people's hard work.--]]]:format(choice.author)
			)
		end
		MsgPopup(
			Strings[302535920000004--[[Dump--]]] .. ": " .. #choices,
			Strings[302535920001362--[[Extract HPKs--]]]
		)
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920001362--[[Extract HPKs--]]],
		hint = Strings[302535920001365--[[HPK files will be unpacked into AppData/Mods/ModSteamId--]]],
		multisel = true,
	}
end

function ChoGGi.MenuFuncs.ListAllMenuItems()
	local item_list = {}
	local c = 0

	local actions = ChoGGi.Temp.Actions
	for i = 1, #actions do
		local a = actions[i]
		-- skip menus
		if a.OnActionEffect ~= "popup" and a.ActionName ~= "" then
			c = c + 1
			local hint_text = type(a.RolloverText) == "function" and a.RolloverText() or a.RolloverText
			local icon
			if a.ActionIcon and a.ActionIcon ~= "" then
				icon = "<image " .. a.ActionIcon .. " 2500>"
			end

			local short = a.ActionShortcut

			item_list[c] = {
				text = a.ActionName,
				value = a.ActionName,
				icon = icon,
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
		title = Strings[302535920000504--[[List All Menu Items--]]],
		custom_type = 7,
		height = 800.0,
	}
end

function ChoGGi.MenuFuncs.RetMapInfo()
	if not GameState.gameplay then
		return
	end
	local data = HashLogToTable()
	data[1] = data[1]:gsub("\n\n", "")
	ChoGGi.ComFuncs.OpenInExamineDlg(TableConcat(data, "\n"), nil, Translate(283142739680--[[Game--]]) .. " & " .. Strings[302535920001355--[[Map--]]] .. " " .. Translate(126095410863--[[Info--]]))
end

do -- ModUpload
	-- this keeps the check saved per session (true = steam, false = paradox)
	local upload_to_who = true
	-- true = desktop, false = desktop/console
	local upload_to_whichplatform = true

	local ConvertToOSPath = ConvertToOSPath
	local MatchWildcard = MatchWildcard
	local SplitPath = SplitPath
	local AsyncCreatePath = AsyncCreatePath
	local AsyncCopyFile = AsyncCopyFile
	local Sleep = Sleep
	local mod_params = {}

	-- check the copy box for these
	local ChoGGi_copy_files = {
		[ChoGGi.id] = true,
		[ChoGGi.id_lib] = true,
	}
	-- and the pack box
	local ChoGGi_pack = {
		ChoGGi_EveryFlagOnWikipedia = true,
		ChoGGi_MapImagesPack = true,
		ChoGGi_CommieMarxLogos = true,
	}
	local pack_path = "AppData/ModUpload/Pack/"
	local dest_path = "AppData/ModUpload/"

	local copy_files
	local blank_mod
	local clipboard
	local pack_mod
	local test
	local steam_upload
	local para_platform
	local mod, mod_path, upload_image, diff_author
	local result
	local choices_len
	local result_msg = {}
	local result_title = {}
	local upload_msg = {}
	local uploading

	local function UploadMod(answer,batch)
		if not answer then
			return
		end

		MsgPopup(
			Translate(5452--[[START--]]),
			Strings[302535920000367--[[Mod Upload--]]]
		)

		-- always start with fresh table
		table.clear(mod_params)

		-- add new mod
		local err, item_id, prepare_worked, prepare_results
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

		-- screenshots
		local shots_path = "AppData/ModUpload/Screenshots/"
		AsyncCreatePath(shots_path)
		mod_params.screenshots = {}
		for i = 1, 5 do
			local screenshot = mod["screenshot" .. i]
			if io.exists(screenshot) then
				local _, name, ext = SplitPath(screenshot)
				local new_name = ModsScreenshotPrefix .. name .. ext
				local new_path = shots_path .. new_name
				local err = AsyncCopyFile(screenshot, new_path)
				if not err then
					local os_path = ConvertToOSPath(new_path)
					table.insert(mod_params.screenshots, os_path)
				end
			end
		end

		-- issue with mod platform (workshop/paradox mods)
		if not prepare_worked then
			local msg = Translate(1000013--[[Mod <ModLabel> was not uploaded! Error: <err>--]]):gsub("<ModLabel>", mod.title):gsub("<err>", Translate(prepare_results))
			if batch then
				print(msg)
			else
				ChoGGi.ComFuncs.MsgWait(
					msg,
					Translate(1000592--[[Error--]]) .. ": " .. mod.title,
					upload_image
				)
			end
			return
		end

		-- update mod, and copy files to ModUpload
		if copy_files and not blank_mod and not err then
			mod:SaveItems()
			AsyncDeletePath(dest_path)
			AsyncCreatePath(dest_path)

			local err, all_files = AsyncListFiles(mod_path, "*", "recursive, relative")
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

		if pack_mod then
			local files_to_pack = {}
			local substring_begin = #dest_path + 1
			local err, all_files = AsyncListFiles(dest_path, nil, "recursive")
			if err then
				err = T{1000753, "Failed creating content package file (<err>)", err = err}
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
				err = AsyncPack(pack_path .. ModsPackFileName, dest_path, files_to_pack)
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
			-- set last_changes to last_changes or version num
			if not mod.last_changes or mod.last_changes == "" then
				mod.last_changes = mod.version_major .. "." .. mod.version_minor
			end

			-- skip it for testing
			if not test then
				if steam_upload then
					result, err = Steam_Upload(nil, mod, mod_params)
				else
					result, err = PDX_Upload(nil, mod, mod_params)
				end
			end
		end

		if err and not blank_mod then
			result_msg[#result_msg+1] = Translate(1000013--[[Mod <ModLabel> was not uploaded! Error: <err>--]]):gsub("<ModLabel>", mod.title):gsub("<err>", Translate(err))
			if choices_len == 1 then
				result_title[#result_title+1] = Translate(1000592--[[Error--]])
			else
				result_title[#result_title+1] = mod.title
			end
		else
			if choices_len == 1 then
				result_msg[#result_msg+1] = Translate(1000014--[[Mod <ModLabel> was successfully uploaded!--]]):gsub("<ModLabel>", mod.title)
				result_title[#result_title+1] = Translate(1000015--[[Success--]])
			else
				result_title[#result_title+1] = mod.title
			end
		end

		-- show id in console/copy to clipb
		if not test and item_id then
			-- don't copy to clipb if batch or failed
			if batch ~= "batch" and clipboard and not err then
				if mod_params.uuid_property then
					CopyToClipboard("	\"" .. mod_params.uuid_property .. "\", \"" .. item_id .. "\",")
				else
					CopyToClipboard("	\"steam_id\", \"" .. item_id .. "\",")
				end
			end

			local id_str = Translate(1000021--[[Steam ID--]])
			if not steam_upload then
				if para_platform then
					id_str = Translate(1000772--[[Paradox Desktop UUID--]])
				else
					id_str = Translate(1000773--[[Paradox All UUID--]])
				end
			end

			print(mod.title, ":", Translate(1000107--[[Mod--]]), id_str, ":", item_id)
		end

		if not test and not err then
			-- remove upload folder
			AsyncDeletePath(dest_path)
		end

		if choices_len == 1 then
			uploading = false
		end
	end

	local function CallBackFunc(choices)
		if choices.nothing_selected then
			return
		end

		CreateRealTimeThread(function()
			local choice = choices[1]
			copy_files = choice.check1
			blank_mod = choice.check2
			clipboard = choice.check3
			pack_mod = choice.check4
			test = choice.check5
			steam_upload = choice.check6
			para_platform = choice.check7

			choices_len = #choices

			uploading = true
			for i = 1, choices_len do
				choice = choices[i]
				mod = choice.mod
				if mod then
					mod_path = choice.path
					-- pick logo for upload msg boxes
					if steam_upload then
						upload_image = "UI/Common/mod_steam_workshop.tga"
					else
						upload_image = "UI/ParadoxLogo.tga"
						-- mods have to be packed for paradox
						pack_mod = true
					end

					diff_author = mod.author ~= SteamGetPersonaName()
					result = nil

					-- my mods override
					if ChoGGi_copy_files[mod.id] then
						copy_files = false
					end
					if ChoGGi_pack[mod.id] or mod.id:find("ChoGGi_Logos_") then
						pack_mod = true
					end

					-- remove blacklist warning from title (added in helpermod)
					mod.title = mod.title:gsub(" %(BL%)$", ""):gsub(" %(Warning%)$", "")

					-- will fail on paradox mods
					if mod.lua_revision == 0 then
						mod.lua_revision = LuaRevision
					end
					if mod.saved_with_revision == 0 then
						mod.saved_with_revision = LuaRevision
					end

					table.iclear(result_msg)
					table.iclear(result_title)

					-- only one mod to upload so we ask questions
					if choices_len == 1 then
						-- build / show confirmation dialog
						table.iclear(upload_msg)
						local m_c = 0

						m_c = m_c + 1
						if steam_upload then
							upload_msg[m_c] = Translate(1000012--[[Mod <ModLabel> will be uploaded to Steam--]]):gsub("<ModLabel>", mod.title)
						else
							upload_msg[m_c] = Translate(1000771--[[Mod <ModLabel> will be uploaded to Paradox--]]):gsub("<ModLabel>", mod.title)
							m_c = m_c + 1
							upload_msg[m_c] = "\n\n"
							m_c = m_c + 1
							upload_msg[m_c] = Strings[302535920001572--[[Warning: May instantly crash SM (not sure why).--]]]
						end

						if not pack_mod then
							m_c = m_c + 1
							upload_msg[m_c] = "\n\n"
							m_c = m_c + 1
							upload_msg[m_c] = Strings[302535920000051--[[Mod will not be (automagically) packed in an hpk archive.--]]]
						end

						if not copy_files then
							m_c = m_c + 1
							upload_msg[m_c] = "\n\n<color 203 120 30>"
							m_c = m_c + 1
							upload_msg[m_c] = Strings[302535920001262--[[%sModUpload folder is empty and waiting for files.--]]]:format(ConvertToOSPath("AppData/"))
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
							upload_msg[m_c] = Strings[302535920001263--[["%s is different from your name, do you have permission to upload it?"--]]]:format(mod.author)
						end
					end

					if choices_len == 1 then
						ChoGGi.ComFuncs.QuestionBox(
							TableConcat(upload_msg),
							UploadMod,
							mod.title,
							nil,
							nil,
							upload_image
						)
					else
						UploadMod(true,"batch")
					end
				end

			end

			-- QuestionBox creates a thread, so we set this to false in UploadMod for it
			if choices_len > 1 then
				uploading = false
			end
			-- wait for it
			while uploading do
				Sleep(1000)
			end

			local error_msgs = {}
			local c = 0
			for i = 1, #result_msg do
				c = c + 1
				error_msgs[c] = result_title[i] .. " " .. result_msg[i]
			end
			error_msgs = TableConcat(error_msgs)

			-- update mod log and print it to console log
			ModLog("\n" .. error_msgs)
			local ModMessageLog = ModMessageLog
			print(Strings[302535920001265--[[ModMessageLog--]]], ":")
			for i = 1, #ModMessageLog do
				print(ModMessageLog[i])
			end

			-- let user know if we're good or not
			ChoGGi.ComFuncs.MsgWait(
				error_msgs,
				Strings[302535920001586--[[All Done!--]]],
				upload_image
			)

		end)

	end

	function ChoGGi.MenuFuncs.ModUpload()
		if blacklist then
			ChoGGi.ComFuncs.BlacklistMsg("ChoGGi.MenuFuncs.ModUpload")
			return
		end
		if not (Platform.steam or Platform.pops) then
			local msg = Translate(1000760--[[Not Steam--]]) .. "/" .. Translate(1000759--[[Not Paradox--]])
			print(Strings[302535920000367--[[Mod Upload--]]], ":", msg)
			MsgPopup(
				msg,
				Strings[302535920000367--[[Mod Upload--]]]
			)
			return
		end

		-- if user copied a mod over after game started
		print("ECM ModUpload ModsReloadDefs():")
		ModsReloadDefs()

		local item_list = {}
		local c = 0
		local Mods = Mods
		local ValidateImage = ChoGGi.ComFuncs.ValidateImage
		for id, mod in pairs(Mods) do
			if id ~= "ChoGGi_testing" and mod.content_path:sub(1,11) ~= "PackedMods/" then
				local image = ""
				-- can't use <image> tags unless there's no spaces in the path...
				if ValidateImage(mod.image) and not mod.image:find(" ") then
					image = "<image " .. mod.image .. ">\n\n"
				end
				c = c + 1
				item_list[c] = {
					text = mod.title,
					value = id,
					hint = image .. mod.description,
					mod = mod,
					path = mod.env.CurrentModPath or mod.content_path or mod.path,
				}
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = Strings[302535920000367--[[Mod Upload--]]],
			hint = Strings[302535920001511--[["AsyncPack will crash SM after calling it once, you can use hpk to pack mods ahead of time.

https://github.com/nickelc/hpk
hpk create ""Mod folder"" ModContent.hpk
Move archive to ""Mod folder/Pack/ModContent.hpk"""--]]],
			height = 800.0,
			multisel = true,
			checkboxes = {
				{title = Strings[302535920001258--[[Copy Files--]]],
					hint = Strings[302535920001259--[["Copies all mod files to %sModUpload, uncheck to copy files manually."--]]]:format(ConvertToOSPath("AppData/")),
					checked = true,
				},
				{title = Strings[302535920001260--[[Blank--]]],
					hint = Strings[302535920001261--[["Uploads a blank mod, and prints id in log."--]]],
				},
				{title = Strings[302535920000664--[[Clipboard--]]],
					hint = Strings[302535920000665--[[If uploading a mod this copies steam id or uuid to clipboard.--]]],
					checked = true,
				},
				{title = Strings[302535920001427--[[Pack--]]],
					hint = Strings[302535920001428--[["Uploads as a packed mod (default for mod editor upload).
This will always apply if uploading to Paradox."--]]] .. "\n\n" .. Strings[302535920001572--[[Warning: Will instantly crash SM when calling it a second time.--]]],
					checked = true,
				},
				{title = Translate(186760604064--[[Test--]]),
					level = 2,
					hint = Strings[302535920001485--[[Does everything other than uploading mod to workshop (see AppData/ModUpload).--]]],
				},
				{title = Strings[302535920001506--[[Steam--]]],
					level = 2,
					hint = Strings[302535920001507--[[Uncheck to upload to Paradox mods (instead of Steam).--]]],
					checked = upload_to_who,
					func = function(dlg, check)
						upload_to_who = check
						-- steam
						if check then
							dlg.idCheckBox7:SetVisible()
						-- paradox
						else
							dlg.idCheckBox7:SetVisible(true)
							-- mark Pack for users
							dlg.idCheckBox4:SetCheck(true)
						end
					end,
					-- no pops means no sense in showing this
					visible = Platform.pops,
				},
				{title = Strings[302535920001509--[[Platform--]]],
					level = 2,
					hint = Strings[302535920001510--[[Paradox mods platform: Leave checked to upload to Desktop only or uncheck to upload to Desktop and Console.--]]],
					checked = upload_to_whichplatform,
					func = function(_, check)
						upload_to_whichplatform = check
					end,
					-- it defaults to hidden, so if it's paradox then we change it to visible
					visible = not upload_to_who,
				},
			},
		}
	end
end -- do

function ChoGGi.MenuFuncs.EditECMSettings()
	-- load up settings file in the editor
	ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
		text = TableToLuaCode(ChoGGi.UserSettings),
		hint_ok = Strings[302535920001244--[["Saves settings to file, and applies any changes."--]]],
		hint_cancel = Strings[302535920001245--[[Abort without touching anything.--]]],
		custom_func = function(answer, _, obj)
			if answer then
				-- get text and update settings file
				local err, settings = LuaCodeToTuple(obj.idEdit:GetText())
				if not err then
					ChoGGi.UserSettings = ChoGGi.SettingFuncs.WriteSettings(settings)
					-- for now just updates console examine list
					Msg("ChoGGi_SettingsUpdated")
					local d, m, h = FormatElapsedTime(os.time(), "dhm")
					MsgPopup(
						Translate(4273--[[Saved on <save_date>--]]):gsub("<save_date>", ": " .. d .. ":" .. m .. ":" .. h),
						Strings[302535920001242--[[Edit ECM Settings--]]]
					)
				end
			end
		end,
	}
end

function ChoGGi.MenuFuncs.DisableECM()
	local title = Translate(251103844022--[[Disable--]]) .. " " .. Strings[302535920000887--[[ECM--]]]
	local function CallBackFunc(answer)
		if answer then
			ChoGGi.UserSettings.DisableECM = not ChoGGi.UserSettings.DisableECM
			ChoGGi.SettingFuncs.WriteSettings()

			MsgPopup(
				Strings[302535920001070--[[Restart to take effect.--]]],
				title
			)
		end
	end
	ChoGGi.ComFuncs.QuestionBox(
		Strings[302535920000466--[["This will disable the cheats menu, cheats panel, and all hotkeys.
Change DisableECM to false in settings file to re-enable them."--]]] .. "\n\n" .. Strings[302535920001070--[[Restart to take effect.--]]],
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
				AsyncCopyFile(file, old)
				ThreadUnlockKey(old)

				ThreadLockKey(file)
				AsyncFileDelete(ChoGGi.settings_file)
				ThreadUnlockKey(file)
			end

			ChoGGi.Temp.ResetECMSettings = true
			ChoGGi.SettingFuncs.WriteSettings()

			MsgPopup(
				Strings[302535920001070--[[Restart to take effect.--]]],
				Strings[302535920000676--[[Reset ECM Settings--]]]
			)
		end
	end

	ChoGGi.ComFuncs.QuestionBox(
		Strings[302535920001072--[[Are you sure you want to reset ECM settings?
Old settings are saved as %s (or not saved if you don't use the HelperMod)--]]]:format(old) .. "\n\n" .. Strings[302535920001070--[[Restart to take effect.--]]],
		CallBackFunc,
		Strings[302535920001084--[[Reset--]]] .. "!"
	)
end

function ChoGGi.MenuFuncs.ReportBugDlg()
	-- was in orig func, i guess there's never any bugs when modding :)
	if Platform.ged or Platform.editor then
		return
	end
	CreateRealTimeThread(function()
		Sleep(50)
		CreateBugReportDlg()
	end)
end

function ChoGGi.MenuFuncs.AboutECM()
	ChoGGi.ComFuncs.MsgWait(
		Strings[302535920001078--[["Hover mouse over menu item to get description and enabled status
If there isn't a status then it's likely a list of options to choose from

For any issues; please report them to my Github/Steam/NexusMods page, or email %s"--]]]:format(ChoGGi.email),
		Translate(487939677892--[[Help--]])
	)
end
