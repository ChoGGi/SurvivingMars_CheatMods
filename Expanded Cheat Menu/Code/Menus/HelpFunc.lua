-- See LICENSE for terms

local print = print
local table = table

local TranslationTable = TranslationTable
local Translate = ChoGGi.ComFuncs.Translate
local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local blacklist = ChoGGi.blacklist
local testing = ChoGGi.testing

local g_env, debug
function OnMsg.ChoGGi_UpdateBlacklistFuncs(env)
	blacklist = false
	g_env, debug = env, env.debug
end

do -- ModUpload
	-- refactor this someday...

	-- boost timeout for busy server (default 10000)
--~ 	PopsAsyncOpTimeout = 20000

	-- Since paradox uses the title as the folder name you can't use the same name as other mods, or mods that got blocked and I'm supposed to re-upload
	-- If you delete a mod, the name of it is stuck in the paradox ether
	-- CopyToClipboard([[	"pops_any_uuid", "]] .. GetUUID() .. [[",]])
	local diff_mod_titles_paradox = {
		-- extra spaces intentional (thank you paradox mods)
		[ChoGGi.id_lib] = "ChoGGi's Library ",
		[ChoGGi.id] = "Expanded Cheat Menu ",
		ChoGGi_DeepResourcesNeverRunOut = "Deep Resources Never Run Out (upload 2)",
		ChoGGi_DronesCarryAmountFix = "Drones Carry Amount (upload 2)",
		ChoGGi_FixMirrorGraphics = "Fix Mirror Graphics (upload 2)",
		ChoGGi_IncreaseRanchStorage = "Increase Ranch Storage (upload 2)",
		ChoGGi_MartianCarwash = "Martian Carwash (upload 2)",
		ChoGGi_PodNoBounce = "Pod No Bounce (upload 2)",
		ChoGGi_RCBulldozer = "RC Bulldozer (upload 2)",
		ChoGGi_RocketProgradeOrbit = "Rocket Prograde Orbit (upload 2)",
		ChoGGi_RocketsAutoLand = "Rockets Auto Land (upload 2)",
		ChoGGi_SelectableCables = "Selectable Cables Pipes (upload 2)",
		ChoGGi_StopColonistDeathFailure = "Stop Death Failure (upload 2)",
		ChoGGi_UnitThoughts = "Unit Thoughts (upload 2)",
		ChoGGi_WideAreaForestation = "Wide Area Forestation (upload 2)",
	}
	-- What? I like coloured titles...
	local diff_mod_titles_steam = {
		-- extra spaces intentional (thank you paradox mods)
		[ChoGGi.id_lib] = "ChoGGi's Library",
		[ChoGGi.id] = "Expanded Cheat Menu",
	}
	-- mods I have with diff authors (only matters for me)
	local ignore_authors = {
		-- Canadian Space Agency 2
		faN8Rlm = true,
		-- A Tubular Glass House 2
		ChoGGi_ATubularGlassHouse = true,
		-- Distributed Drone Assembly 2
		ChoGGi_DistributedDroneAssembly2 = true,
		-- Psychiatric Hospital
		ChoGGi_PsychiatricHospital = true,
	}
--~ 	-- green ecm/lib so I don't accidentally upload them
--~ 	local coloured_titles = {
--~ 		[ChoGGi.id_lib] = true,
--~ 		[ChoGGi.id] = true,
--~ 	}

	-- true = desktop, false = desktop/console
	local upload_to_whichplatform = false

	local ConvertToOSPath = ConvertToOSPath
	local MatchWildcard = MatchWildcard
	local SplitPath = SplitPath
	local Sleep = Sleep

	local mod_params = {}

	-- don't add these mods to upload list
	local skip_mods = {
		ChoGGi_ = true,
		ChoGGi_testing = true,
		TESTING = true,
	}
	local mods_path = "AppData/Mods/"
	local mod_upload_path = "AppData/ModUpload"
	local pack_path = mod_upload_path .. "/Pack/"
	local dest_path = mod_upload_path .. "/"
	local hpk_path = "AppData/hpk.exe"
	if not Platform.pc then
		hpk_path = "AppData/hpk"
	end
	local hpk_path_working

	-- It's fine...
	local blank_mod, clipboard, test, steam_upload, para_upload, para_platform
	local mod, mod_path, upload_image, diff_author, result, choices_len, uploading, msg_popup_id
	local result_msg, result_title, upload_msg = {}, {}, {}
	local image_steam = "UI/Common/mod_steam_workshop.tga"
	local image_paradox = "UI/ParadoxLogo.tga"

	local function UploadMod(answer, batch)
		if not answer or not mod or mod and not mod.steam_id then
			return
		end

		if testing and mod.author ~= "ChoGGi" and not ignore_authors[mod.id] then
			print("<color 255 100 100>MOD UPLOADING DIFF NAME! Abortion!</color>")
			return
		end

		local orig_title

		msg_popup_id = MsgPopup(
			TranslationTable[5452--[[START]]],
			TranslationTable[302535920000367--[[Mod Upload]]]
		)

		-- always start with fresh table
		table.clear(mod_params)

		-- add new mod
		local err, steam_item_id, para_item_id, prepare_worked, prepare_results, existing_mod
		if steam_upload then
			local steam_title = diff_mod_titles_steam[mod.id]
			if steam_title then
				orig_title = mod.title
				mod.title = steam_title
			end

			if mod.steam_id ~= 0 then
				existing_mod = true
			end
			-- get needed info for mod
			prepare_worked, prepare_results = g_env.Steam_PrepareForUpload(nil, mod, mod_params)
			-- mod id for clipboard
			steam_item_id = mod.steam_id
		end -- steam upload

		-- para upload
		if para_upload then
			-- paradox has some annoyances when it comes to mod titles
			local paradox_title = diff_mod_titles_paradox[mod.id]
			if paradox_title then
				orig_title = mod.title
				mod.title = paradox_title
			end

			-- we override the Platform checkbox if a uuid is in metadata.lua
			-- If both are "" then it's probably a new mod, otherwise check for a uuid and use that prop
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

			ChoGGi.ComFuncs.WaitForParadoxLogin()

			prepare_worked, prepare_results = g_env.PDX_PrepareForUpload(nil, mod, mod_params)

			para_item_id = mod[mod_params.uuid_property]
		end -- para upload

		-- Issue with mod platform (workshop/paradox mods)
		if not prepare_worked then
			local msg = TranslationTable[1000013--[[Mod <ModLabel> was not uploaded! Error: <err>]]]:gsub("<ModLabel>", mod.title):gsub("<err>", Translate(prepare_results))
			if batch then
				print(msg)
			else
				ChoGGi.ComFuncs.MsgWait(
					msg,
					TranslationTable[1000592--[[Error]]] .. ": " .. mod.title,
					upload_image
				)
			end

			-- abort upload
			return
		end

		-- update mod, and copy files to ModUpload
		if not blank_mod and not err then
			mod:SaveItems()
			g_env.AsyncDeletePath(dest_path)
			g_env.AsyncCreatePath(dest_path)

			local err, all_files = g_env.AsyncListFiles(mod_path, "*", "recursive, relative")
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
					g_env.AsyncCreatePath(dir)
					err = g_env.AsyncCopyFile(mod_path .. file, dest_file, "raw")
				end
			end

		end

		do -- screenshots
			local shots_path = mod_upload_path .. "/Screenshots/"
			g_env.AsyncCreatePath(shots_path)
			mod_params.screenshots = {}
			for i = 1, 5 do
				local screenshot = mod["screenshot" .. i]
				if ChoGGi.ComFuncs.FileExists(screenshot) then
					local _, name, ext = SplitPath(screenshot)
					local new_name = ModsScreenshotPrefix .. name .. ext
					local new_path = shots_path .. new_name
					local err = g_env.AsyncCopyFile(screenshot, new_path)
					if not err then
						local os_path = ConvertToOSPath(new_path)
						table.insert(mod_params.screenshots, os_path)
					end
				end
			end
		end

		-- pack files in .hpk archive
		local files_to_pack = {}
		local substring_begin = #dest_path + 1
    local all_files
		err, all_files = g_env.AsyncListFiles(dest_path, nil, "recursive")
		if err then
			err = T{1000753--[[Failed creating content package file (<err>)]], err = err}
		else
			-- do this after listfiles so it doesn't include it
			g_env.AsyncCreatePath(pack_path)

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

			-- try to use hpk exe instead of buggy ass AsyncPack
			if hpk_path_working then
				-- not sure if it matters, but delete ModContent.hpk first
				local output = mods_path .. g_env.ModsPackFileName
				g_env.AsyncFileDelete(output)
				local exec = hpk_path_working .. [[ create --cripple-lua-files "]]
					.. ConvertToOSPath(mod_upload_path) .. [[" ]] .. g_env.ModsPackFileName
				-- AsyncExec(cmd, working_dir, hidden, capture_output, priority)
				if not g_env.AsyncExec(exec, ConvertToOSPath(mods_path), true, false) then
					-- hpk.exe is a little limited in where it places the output, so we need to move it over
					g_env.AsyncCopyFile(output, pack_path .. g_env.ModsPackFileName, "raw")
					g_env.AsyncFileDelete(output)
				end
			else
				err = g_env.AsyncPack(pack_path .. g_env.ModsPackFileName, dest_path, files_to_pack)
			end

		end

		-- update mod on workshop
		if not err or blank_mod then

			-- check if .hpk exists, and use it if so
			local os_dest = dest_path .. "Pack/ModContent.hpk"
			if ChoGGi.ComFuncs.FileExists(os_dest) then
				os_dest = ConvertToOSPath(os_dest)
			else
				os_dest = ConvertToOSPath(dest_path)
			end

			mod_params.os_pack_path = os_dest


			if orig_title then
				mod.title = orig_title
				orig_title = nil
			end

			-- If no last_changes then use version num
			if not mod.last_changes or mod.last_changes == "" then
				local version = mod.version_major .. "." .. mod.version_minor
				if testing then
					mod.last_changes = "https://github.com/ChoGGi/SurvivingMars_CheatMods/tree/master/Mods%20ChoGGi/"
						.. (orig_title or mod.title):gsub(" ","%%20") .. "/changes.txt"
				else
					mod.last_changes = version
				end
			end

			-- needed for paradox upload? (or both?)
			if not mod.saved then
				mod.saved = 0
			end

			-- skip it for testing
			if not test then
				if steam_upload then
					result, err = g_env.Steam_Upload(nil, mod, mod_params)
					print("<color ChoGGi_yellow>Steam uploaded</color>", mod.title)
				end

				local org_mod_description = mod.description
				if para_upload then

					-- DESC FOR PARA
					-- tell paradox users if it needs my library
					local needs_lib = table.find(mod.dependencies, "id", ChoGGi.id_lib)
						and TranslationTable[302535920001634--[["This mod requires my library mod (ChoGGi's Library) < use space on the end when searching for it."]]] .. "\n\n"
						or ""

					-- add some text to ECM description to hopefully reduce people reporting the mod.
					if testing then

						if mod.id == ChoGGi.id then
							mod.description = TranslationTable[302535920000990--[["You need to have a mouse to use this mod."]]] .. "\n"
								.. needs_lib .. TranslationTable[302535920000887--[["If you get a disabled content restrictions error: Please let me know and I'll tell Paradox (can take a few days).

If you have any issues with this mod then please send me a bug report instead of reporting the mod.
https://github.com/ChoGGi/SurvivingMars_CheatMods
Discord: https://discord.gg/ZXXYaExThy
https://steamcommunity.com/id/ChoGGi/
SurvivingMarsMods@choggi.org"]]] .. "\n\n\n" .. mod.description
						else
							mod.description = needs_lib .. TranslationTable[302535920000887--[["If you get a disabled content restrictions error: Please let me know and I'll tell Paradox (can take a few days).

If you have any issues with this mod then please send me a bug report instead of reporting the mod.
https://github.com/ChoGGi/SurvivingMars_CheatMods
Discord: https://discord.gg/ZXXYaExThy
https://steamcommunity.com/id/ChoGGi/
SurvivingMarsMods@choggi.org"]]] .. "\n\n\n" .. mod.description
						end
					end
					-- DESC FOR PARA

					-- thanks LukeH (line breaks needed for paradox)
					-- not bold (what's bold on paradox?)
					mod.description = mod.description:gsub("\n", "<br>"):gsub("%[b%]", ""):gsub("%[%/b%]", "")

					result, err = g_env.PDX_Upload(nil, mod, mod_params)
					print("<color ChoGGi_yellow>Paradox uploaded</color>", mod.title)
				end -- para upload
				mod.description = org_mod_description
			end -- not test
		end

		-- uploaded or failed?
		if err and not blank_mod then
			local msg = T{1000013--[[Mod <ModLabel> was not uploaded! Error: <err>]],
				ModLabel = mod.title, err = err,
			}
			result_msg[#result_msg+1] = msg
			if choices_len == 1 then
				result_title[#result_title+1] = TranslationTable[1000592--[[Error]]]
			else
				result_title[#result_title+1] = mod.title
			end
			-- grab tail from log and show the actual error msg
			local log_error = ChoGGi.ComFuncs.RetLastLineFromStr(LoadLogfile(), "Received errorMessage")
				-- remove any ' and :
				:gsub("'",""):gsub(":","")
			-- print away
			if batch then
				print(Translate("<color ChoGGi_red>" .. msg .. "\n" .. tostring(log_error) .. "</color>"))
			end
			if log_error then
				result_title[#result_title+1] = "\n<color ChoGGi_red>" .. TranslationTable[1000592--[[Error]]] .. "</color>"
				result_msg[#result_msg+1] = log_error
			end
		else
			if batch then
				print(Translate("<color ChoGGi_green>" .. TranslationTable[1000015--[[Success]]] .. " " .. mod.title .. "</color>"))
			end
			if choices_len == 1 then
				result_msg[#result_msg+1] = T{1000014--[[Mod <ModLabel> was successfully uploaded!]],
					ModLabel = mod.title,
				}
				result_title[#result_title+1] = Translate("<color ChoGGi_green>" .. TranslationTable[1000015--[[Success]]] .. "</color>")
			else
				result_title[#result_title+1] = mod.title
			end
		end

		-- show id in console/copy to clipboard
		if not test and (steam_item_id or para_item_id) then
			-- don't copy to clipboard if existing mod or not steam or failed
			if not existing_mod and steam_upload and clipboard and not err then
				CopyToClipboard("	\"steam_id\", \"" .. steam_item_id .. "\",")
			end

			local id_str = 1000021--[[Steam ID]]

			if para_upload then
				if para_platform then
					id_str = 1000772--[[Paradox Desktop UUID]]
				else
					id_str = 1000773--[[Paradox All UUID]]
				end
			end

			-- both displayed
			if steam_upload and para_upload then
				print(mod.title, ":\n<color ChoGGi_orange>",
					TranslationTable[1000021--[[Steam ID]]], "</color>:", steam_item_id,
					"\n<color ChoGGi_orange>", Translate(id_str), "</color>:", para_item_id
				)
			else
				-- singular display
				print(mod.title, ":<color ChoGGi_orange>", Translate(id_str), "</color>:", steam_upload and steam_item_id or para_item_id)
			end

		end

		if not test and not err then
			-- remove upload folder
			g_env.AsyncDeletePath(dest_path)
		end

		if choices_len == 1 then
			uploading = false
		end

		if orig_title then
			mod.title = orig_title
			orig_title = nil
		end
	end

	local function CallBackFunc(choices)
		if choices.nothing_selected then
			return
		end

		-- we update this now, so the tooltip doesn't show nil
		if ChoGGi.ComFuncs.FileExists(hpk_path) then
			hpk_path_working = ConvertToOSPath(hpk_path)
		else
			hpk_path_working = nil
		end
		--
		CreateRealTimeThread(function()
			local UserSettings = ChoGGi.UserSettings

			local choice = choices[1]
			blank_mod = choice.check1
			clipboard = choice.check2
			test = choice.check3
			steam_upload = choice.check4
			para_upload = choice.check5
			para_platform = choice.check6

			choices_len = #choices

			local asked_batch
--~ ex(choices)
			uploading = true
			for i = 1, choices_len do
				choice = choices[i]
				-- select all means the fake item is also selected
				if choice.value then

					mod = choice.mod
					mod_path = choice.path

					-- pick logo for upload msg boxes
					-- merged for dual upload?
					if steam_upload and para_upload then
						upload_image = nil
					elseif steam_upload then
						upload_image = image_steam
					elseif para_upload then
						upload_image = image_paradox
					end

					diff_author = mod.author ~= g_env.SteamGetPersonaName()
					result = nil

					-- remove blacklist warning from title (added in helpermod)
					mod.title = mod.title:gsub(" %(Warning%)$", "")

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

						if steam_upload and para_upload then
							upload_msg[m_c] = T{302535920001381--[[Mod <ModLabel> will be uploaded to Steam/Paradox]],
								ModLabel = mod.title,
							}
						elseif steam_upload then
							upload_msg[m_c] = T{1000012--[[Mod <ModLabel> will be uploaded to Steam]],
								ModLabel = mod.title,
							}
						elseif para_upload then
							upload_msg[m_c] = T{1000771--[[Mod <ModLabel> will be uploaded to Paradox]],
								ModLabel = mod.title,
							}
						end

						m_c = m_c + 1
						upload_msg[m_c] = "\n\n"
						m_c = m_c + 1
						upload_msg[m_c] = Translate(302535920001572--[["<color ChoGGi_red>Pack Warning</color>: Will instantly crash SM when calling it a second time, pack the mod manually to workaround it.
You can also stick the executable in the profile folder to use it instead (<green>no crashing</green>):
<yellow>%s</yellow>."]]):format(ConvertToOSPath(hpk_path))

						-- show diff author warning unless it's me
						if diff_author and not testing then
							m_c = m_c + 1
							upload_msg[m_c] = "\n\n"
							m_c = m_c + 1
							upload_msg[m_c] = TranslationTable[302535920001263--[["%s is different from your name, do you have permission to upload it?"]]]:format(mod.author)
						end
					end

					-- clear out and create upload folder
					g_env.AsyncDeletePath(dest_path)
					g_env.AsyncCreatePath(dest_path)

					if choices_len == 1 then
						if not UserSettings.SkipModUploadConfirmDoneMsgs then
							if ChoGGi.ComFuncs.QuestionBox(
								table.concat(upload_msg),
								UploadMod,
								mod.title,
								nil,
								nil,
								upload_image
							) == "cancel" then
								return
							end
						else
							UploadMod(true)
						end
					elseif asked_batch then
						-- no more need to ask
						UploadMod(true, "batch")
					else
						-- always ask for first mod when batching
						local function CallBackFunc_BQ(answer)
							if answer then
								UploadMod(true, "batch")
							else
								DeleteThread(CurrentThread())
							end
						end
						-- build list of titles for msg
						local titles = {}
						local titles_c = 0
						for j = 1, choices_len do
							choice = choices[j]
							local temp_mod = choice.mod
							if temp_mod then
								titles_c = titles_c + 1
								titles[titles_c] = temp_mod.title
									-- remove blacklist warning from title (added in helpermod)
									:gsub(" %(Warning%)$", "")
							end
						end
						-- and show msg
						if not UserSettings.SkipModUploadConfirmDoneMsgs then
							if ChoGGi.ComFuncs.QuestionBox(
								TranslationTable[302535920000221--[[Batch Upload mods?]]] .. "\n\n"
									.. table.concat(titles, ", "),
								CallBackFunc_BQ,
								TranslationTable[302535920000221--[[Batch Upload!]]],
								nil,
								nil,
								upload_image,
								nil, nil, nil,
								CurrentThread()
							) == "cancel" then
								return
							end
						else
							CallBackFunc_BQ(true)
						end
						asked_batch = true
					end

				end -- If mod
			end -- for

			-- QuestionBox creates a thread, so we set this to false in UploadMod for it
			if choices_len > 1 then
				uploading = false
			end
			-- Wait for it
			while uploading do
				Sleep(1000)
			end

			-- Update popup msg if it's still opened
			local popups = ChoGGi.Temp.MsgPopups
			local idx = table.find(popups, "notification_id", msg_popup_id)
			if idx and ChoGGi.ComFuncs.IsValidXWin(popups[idx]) then
				popups[idx].idText:SetText(TranslationTable[302535920001453--[[Completed]]])
			end

			-- Build list of errors
			local error_msgs = {}
			local c = 0
			for i = 1, #result_msg do
				c = c + 1
				error_msgs[c] = result_title[i] .. ": " .. result_msg[i]
			end
			error_msgs = table.concat(error_msgs)


			local error_text = TranslationTable[302535920000221--[[See log for any batch errors.]]]
			-- Only add error msg if single mod
			if choices_len == 1 then
				error_text = error_text .. "\n\n" .. error_msgs
			end

			-- Let user know if we're good or not
			print(Translate(error_msgs))
			--
			if not UserSettings.SkipModUploadConfirmDoneMsgs then
				ChoGGi.ComFuncs.MsgWait(
					error_text,
					TranslationTable[302535920001586--[[All Done!]]],
					upload_image
				)
			end
			--
		end)
		--
	end

	function ChoGGi.MenuFuncs.ModUpload()
		if blacklist then
			ChoGGi.ComFuncs.BlacklistMsg("ChoGGi.MenuFuncs.ModUpload")
			return
		end
		if not (Platform.steam or Platform.pops) then
			local msg = TranslationTable[1000760--[[Not Steam]]] .. "/"
				.. TranslationTable[1000759--[[Not Paradox]]]
			print(TranslationTable[302535920000367--[[Mod Upload]]], ":", msg)
			MsgPopup(
				msg,
				TranslationTable[302535920000367--[[Mod Upload]]]
			)
			return
		end

		-- If user copied a mod over after game started
		print("ECM ModUpload ModsReloadDefs():")
		g_env.ModsReloadDefs()

		local item_list = {}
		local c = 0
		local Mods = Mods
		local ValidateImage = ChoGGi.ComFuncs.ValidateImage
		for id, mod in pairs(Mods) do
			-- skip some mods and all packed mods
			if not skip_mods[id] and mod.content_path:sub(1,11) ~= "PackedMods/" then
				local image = ""
				-- can't use <image> tags unless there's no spaces in the path...
				if ValidateImage(mod.image) and not mod.image:find(" ") then
					image = "<image " .. mod.image .. ">\n\n"
				end
				-- colour mine so I don't clicky
				local title = mod.title
--~ 				if coloured_titles[id] then
--~ 					title = "<color ChoGGi_green>" .. title .. "</color>"
--~ 				end
				c = c + 1
				item_list[c] = {
					text = title,
					value = id,
					hint = image .. mod.description,
					mod = mod,
					path = mod.env.CurrentModPath or mod.content_path or mod.path,
				}
			end
		end

--~ 		local _, image_steam_y = MeasureImage(image_steam)
--~ 		local _, image_paradox_y = MeasureImage(image_paradox)

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = TranslationTable[302535920000367--[[Mod Upload]]],
			hint = Translate(302535920001511--[["AsyncPack will CTD the second time you call it, you can use hpk to pack mods ahead of time.

https://github.com/nickelc/hpk
<green>hpk create ""Mod folder"" ModContent.hpk</green>
Move archive to ""Mod folder/Pack/ModContent.hpk"""]]) .. "\n\n" .. Translate(302535920001572--[[<color ChoGGi_red>Pack Warning</color>: Will instantly crash SM when calling it a second time, pa]]):format(ConvertToOSPath(hpk_path)),
			height = 800.0,
			multisel = true,
			checkboxes = {
				{title = TranslationTable[302535920001260--[[Blank]]],
					hint = TranslationTable[302535920001261--[["Uploads a blank mod, and prints id in log."]]],
				},
				{title = TranslationTable[302535920000664--[[Clipboard]]],
					hint = TranslationTable[302535920000665--[[If uploading a mod this copies the mod's steam id clipboard.]]],
					checked = true,
				},
				{title = TranslationTable[186760604064--[[Test]]],
					hint = TranslationTable[302535920001485--[[Does everything other than uploading mod to workshop (see AppData/ModUpload).]]],
				},
				--
				{title = TranslationTable[302535920001506--[[Steam]]],
					level = 2,
					hint = TranslationTable[302535920001507--[[Upload to Steam Workshop.]]],
					checked = true,
				},

				{title = TranslationTable[5482--[[Paradox]]],
					level = 2,
					hint = TranslationTable[302535920001662--[[Upload to Paradox Mods.]]],
					checked = true,
				},


				{title = TranslationTable[302535920001509--[[Platform]]],
					level = 2,
					hint = TranslationTable[302535920001510--[["Paradox mods platform: Leave checked to upload to Desktop only or uncheck to upload to Desktop and Console.
If you have a uuid in your metadata.lua this checkbox is ignored and it'll try the any uuid then the desktop uuid."]]],
					checked = upload_to_whichplatform,
					func = function(_, check)
						upload_to_whichplatform = check
					end,
				},
			},
		}
	end
end -- do

function ChoGGi.MenuFuncs.RetHardwareInfo()
	local mem = {}
	local cm = 0

	local memory_info = GetMemoryInfo()
	for key, value in pairs(memory_info) do
		cm = cm + 1
		mem[cm] = key .. ": " .. value .. "\n"
	end

	local hw = {}
	local chw = 0
	local hardware_info = GetHardwareInfo(0)
	for key, value in pairs(hardware_info) do
		if key == "gpu" then
			chw = chw + 1
			hw[chw] = key .. ": " .. GetGpuDescription() .. "\n"
		else
			chw = chw + 1
			hw[chw] = key .. ": " .. value .. "\n"
		end
	end
	table.sort(hw)
	chw = chw + 1
	hw[chw] = "\n"

	return string.format([[%s:
GetHardwareInfo(0): %s

GetMemoryInfo(): %s
AdapterMode(0): %s
GetMachineID(): %s
GetSupportedMSAAModes(): %s
GetSupportedShaderModel(): %s
GetMaxStrIDMemoryStats(): %s

GameObjectStats(): %s

GetCWD(): %s
GetExecDirectory(): %s
GetExecName(): %s
GetDate(): %s
GetOSName(): %s
GetOSVersion(): %s
GetUsername(): %s
GetSystemDPI(): %s
GetComputerName(): %s


]],
		TranslationTable[5568--[[Stats]]],
		table.concat(hw),
		table.concat(mem),
		table.concat({GetAdapterMode(0)}, " "),
		GetMachineID(),
		table.concat(GetSupportedMSAAModes(), " "):gsub("HR::", ""),
		GetSupportedShaderModel(),
		GetMaxStrIDMemoryStats(),
		GameObjectStats(),
		GetCWD(),
		GetExecDirectory(),
		GetExecName(),
		GetDate(),
		GetOSName(),
		GetOSVersion(),
		GetUsername(),
		GetSystemDPI(),
		GetComputerName()
	)
end

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
		local playtime = TranslationTable[77--[[Unknown]]]
		if data.playtime then
			local h, m, _ = FormatElapsedTime(data.playtime, "hms")
			playtime = T{7549--[[<hours>:<minutes>]],
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

			hint = TranslationTable[4274--[[Playtime : <playtime>]]]:gsub("<playtime>", Translate(playtime)) .. "\n"
				.. TranslationTable[4273--[[Saved on : <save_date>]]]:gsub("<save_date>", save_date) .. "\n\n"
				.. TranslationTable[302535920001274--[[This is permanent!]]],
		}
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value

		if not choice[1].check1 then
			MsgPopup(
				TranslationTable[302535920000038--[[Pick a checkbox next time...]]],
				TranslationTable[302535920000146--[[Delete Saved Games]]]
			)
			return
		end
		local save_folder = GetPCSaveFolder()

		for i = 1, #choice do
			value = choice[i].value
			if type(value) == "string" then
				g_env.AsyncFileDelete(save_folder .. value)
			end
		end

		-- remove any saves we deleted
		local games_amt = #SavegamesList
		for i = #SavegamesList, 1, -1 do
			if not ChoGGi.ComFuncs.FileExists(save_folder .. SavegamesList[i].savename) then
				table.remove(SavegamesList, i)
			end
		end

		games_amt = games_amt - #SavegamesList
		if games_amt > 0 then
			MsgPopup(
				TranslationTable[302535920001275--[[Deleted %s saved games.]]]:format(games_amt),
				TranslationTable[302535920000146--[[Delete Saved Games]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = TranslationTable[302535920000146--[[Delete Saved Games]]] .. ": " .. #item_list,
		hint = T(6779--[[Warning]]) .. ": " .. TranslationTable[302535920001274--[[This is permanent!]]],
		multisel = true,
		skip_sort = true,
		checkboxes = {
			{
				title = T(1000009--[[Confirmation]]),
				hint = TranslationTable[302535920001276--[[Nothing is deleted unless you check this.]]],
			},
		},
	}
end

function ChoGGi.MenuFuncs.StartupTicks_Toggle()
	ChoGGi.UserSettings.ShowStartupTicks = not ChoGGi.UserSettings.ShowStartupTicks
	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.ShowStartupTicks),
		TranslationTable[302535920001481--[[Show Startup Ticks]]]
	)
end

function ChoGGi.MenuFuncs.ToolTips_Toggle()
	ChoGGi.UserSettings.EnableToolTips = not ChoGGi.UserSettings.EnableToolTips
	ChoGGi.ComFuncs.SetLibraryToolTips()

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.EnableToolTips),
		TranslationTable[302535920001014--[[Toggle ToolTips]]]
	)
end

function ChoGGi.MenuFuncs.ChangeWindowTitle_Toggle()
	ChoGGi.UserSettings.ChangeWindowTitle = not ChoGGi.UserSettings.ChangeWindowTitle

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.ChangeWindowTitle),
		TranslationTable[302535920001647--[[Window Title]]]
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

		-- If user installed mod while game is running
		print("ECM ExtractHPKs ModsReloadDefs():")
		g_env.ModsReloadDefs()

		if Platform.steam and IsSteamAvailable() then
			table.iappend(mod_folders, g_env.SteamWorkshopItems())
		end
		if Platform.pops then
			table.iappend(mod_folders, g_env.io.listfiles(g_env.PopsModsDownloadPath, "*", "folders, non recursive"))
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
			local id = folder:sub(-slash + 1)

			local hpk = folder:gsub("\\", "/") .. "/ModContent.hpk"
			-- skip any mods that aren't packed (uploaded by ECM, or just old)
			local mod = mod_table[id]
			if mod and ChoGGi.ComFuncs.FileExists(hpk) then
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
						.. TranslationTable[302535920001364--[[Don't be an asshole to %s... Always ask permission before using other people's hard work.]]]:format(mod.author)
						.. mod.image,
					id = id,
				}
			end
		end

	else
		MsgPopup(
			TranslationTable[1000760--[[Not Steam]]] .. "/" .. TranslationTable[1000759--[[Not Paradox]]],
			TranslationTable[302535920001362--[[Extract HPKs]]]
		)
		return
	end

	if #item_list == 0 then
		-- good enough msg, probably...
		MsgPopup(
			TranslationTable[302535920000004--[[Dump]]] .. ": " .. #item_list,
			TranslationTable[302535920001362--[[Extract HPKs]]]
		)
		return
	end

	local function CallBackFunc(choices)
		if choices.nothing_selected then
			return
		end
		for i = 1, #choices do
			local choice = choices[i]
			local path
			if testing then
				path = "AppData/Mods/" .. choice.text
				print(choice.value, path)
				g_env.AsyncUnpack(choice.value, path)
			else
				path = "AppData/Mods/" .. choice.id
				g_env.AsyncUnpack(choice.value, path)
			end
			-- add a note telling people not to be assholes
			g_env.AsyncStringToFile(
				path .. "/This is not your mod.txt",
				TranslationTable[302535920001364--[[Don't be an asshole to %s... Always ask permission before using other people's hard work.]]]:format(choice.author)
			)
		end
		MsgPopup(
			TranslationTable[302535920000004--[[Dump]]] .. ": " .. #choices,
			TranslationTable[302535920001362--[[Extract HPKs]]]
		)
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = TranslationTable[302535920001362--[[Extract HPKs]]],
		hint = TranslationTable[302535920001365--[[HPK files will be unpacked into AppData/Mods/ModSteamId]]],
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

			local short = a.ActionShortcut or ""

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
		title = TranslationTable[302535920000504--[[List All Menu Items]]],
		custom_type = 7,
		height = 800.0,
	}
end

function ChoGGi.MenuFuncs.RetMapInfo()
	if not MainCity then
		return
	end
	local data = HashLogToTable()
	data[1] = data[1]:gsub("\n\n", "")
	ChoGGi.ComFuncs.OpenInExamineDlg(table.concat(data, "\n"), nil, T(283142739680--[[Game]]) .. " & " .. TranslationTable[302535920001355--[[Map]]] .. " " .. T(126095410863--[[Info]]))
end

function ChoGGi.MenuFuncs.EditECMSettings()
	local UserSettings = ChoGGi.UserSettings
	-- load up settings file in the editor
	ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
		code = true,
		title = TranslationTable[302535920001242--[[Edit ECM Settings]]],
		text = TableToLuaCode(UserSettings),
		hint_ok = TranslationTable[302535920001244--[["Saves settings to file, and applies any changes."]]],
		hint_cancel = TranslationTable[302535920001245--[[Abort without touching anything.]]],
		update_func = function()
			return TableToLuaCode(UserSettings)
		end,
		custom_func = function(_, obj)
			-- get text and update settings file
			local err, settings = LuaCodeToTuple(obj.idEdit:GetText())
			if not err then
				settings = ChoGGi.SettingFuncs.WriteSettings(settings)
				for key, value in pairs(settings) do
					UserSettings[key] = value
				end

				-- for now just updates console examine list
				Msg("ChoGGi_SettingsUpdated", settings)
				local d, m, h = FormatElapsedTime(os.time(), "dhm")
				local msg = TranslationTable[4273--[[Saved on <save_date>]]]:gsub("<save_date>", ": " .. d .. ":" .. m .. ":" .. h)
				MsgPopup(
					msg,
					TranslationTable[302535920001242--[[Edit ECM Settings]]]
				)
			end
		end,
	}
end

function ChoGGi.MenuFuncs.DisableECM()
	local title = T(251103844022--[[Disable]]) .. " " .. TranslationTable[302535920000002--[[ECM]]]
	local function CallBackFunc(answer)
		if answer then
			ChoGGi.UserSettings.DisableECM = not ChoGGi.UserSettings.DisableECM
			ChoGGi.SettingFuncs.WriteSettings()

			MsgPopup(
				TranslationTable[302535920001070--[[Restart to take effect.]]],
				title
			)
		end
	end
	ChoGGi.ComFuncs.QuestionBox(
		TranslationTable[302535920000466--[["This will disable the cheats menu, cheats panel, and all hotkeys.
Change DisableECM to false in settings file to re-enable them."]]] .. "\n\n" .. TranslationTable[302535920001070--[[Restart to take effect.]]],
		CallBackFunc,
		title
	)
end

function ChoGGi.MenuFuncs.ResetECMSettings()
--~ 	local file = ChoGGi.settings_file
--~ 	local old = file .. ".old"

	local function CallBackFunc(answer)
		if answer then
--~ 			if blacklist then
				ChoGGi.UserSettings = ChoGGi.Defaults
--~ 			else
--~ 				ThreadLockKey(old)
--~ 				g_env.AsyncCopyFile(file, old)
--~ 				ThreadUnlockKey(old)

--~ 				ThreadLockKey(file)
--~ 				g_env.AsyncFileDelete(ChoGGi.settings_file)
--~ 				ThreadUnlockKey(file)
--~ 			end

			ChoGGi.Temp.ResetECMSettings = true
			ChoGGi.SettingFuncs.WriteSettings()

			MsgPopup(
				TranslationTable[302535920001070--[[Restart to take effect.]]],
				TranslationTable[302535920000676--[[Reset ECM Settings]]]
			)
		end
	end

	ChoGGi.ComFuncs.QuestionBox(
		TranslationTable[302535920001072--[[Are you sure you want to reset ECM settings?
Old settings are saved as %s (or not saved if you don't use the HelperMod)]]]:format(old) .. "\n\n" .. TranslationTable[302535920001070--[[Restart to take effect.]]],
		CallBackFunc,
		TranslationTable[302535920001084--[[Reset]]] .. "!"
	)
end

function ChoGGi.MenuFuncs.ReportBugDlg()
	-- was in orig func, i guess there's never any bugs when modding ;)
	if Platform.ged or ChoGGi.ComFuncs.ModEditorActive() then
		return
	end
	CreateRealTimeThread(function()
		Sleep(50)
		CreateBugReportDlg()
	end)
end

function ChoGGi.MenuFuncs.AboutECM()
	ChoGGi.ComFuncs.MsgWait(
		TranslationTable[302535920001078--[["Hover mouse over menu item to get description and enabled status
If there isn't a status then it's likely a list of options to choose from

For any issues; please report them to my Github/Steam/NexusMods page, or email %s"]]]:format(ChoGGi.email),
		T(487939677892--[[Help]])
	)
end
