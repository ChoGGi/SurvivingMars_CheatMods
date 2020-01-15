-- See LICENSE for terms

local print = print

local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local TableConcat = ChoGGi.ComFuncs.TableConcat
local FileExists = ChoGGi.ComFuncs.FileExists
local Translate = ChoGGi.ComFuncs.Translate
local Strings = ChoGGi.Strings
local blacklist = ChoGGi.blacklist
local testing = ChoGGi.testing

do -- ModUpload
	local table_iclear = table.iclear

	-- this keeps the check saved per session (true = steam, false = paradox)
	local upload_to_who = true
	-- true = desktop, false = desktop/console
	local upload_to_whichplatform = false

	local ConvertToOSPath = ConvertToOSPath
	local MatchWildcard = MatchWildcard
	local SplitPath = SplitPath
	local AsyncCreatePath = AsyncCreatePath
	local AsyncCopyFile = AsyncCopyFile
	local Sleep = Sleep
	local MeasureImage = UIL.MeasureImage

	local mod_params = {}

	-- check the copy box for these
	local ChoGGi_copy_files = {
		[ChoGGi.id] = true,
		[ChoGGi.id_lib] = true,
	}
	-- don't add these mods to upload list
	local skip_mods = {
		ChoGGi_XDefaultMod = true,
		ChoGGi_testing = true,
	}
	-- hey paradox! renaming things is a thing...
	local paradox_title = {
		ChoGGi_AddMathFunctions = "\"math.\" Functions",
		ChoGGi_AlienVisitors = "Alien Visitors v0.1",
		ChoGGi_AllSponsorBuildings = "All Sponsor Buildings v0.2",
		ChoGGi_AllSponsors = "All Sponsors v0.1",
		ChoGGi_ChangeDroneType = "Change Drone Type v0.3",
		ChoGGi_ChangeObjectColour = "Change Object Colour v1.0",
		ChoGGi_ChangeOtherToRandomGender = "Change Other To Random Gender v0.1",
		ChoGGi_ChangeRocketSkin = "Change Rocket Skin v0.2",
		ChoGGi_CommieMarxLogos = "Commie Mars Logos v0.4",
		ChoGGi_ConstructionExtendLength = "Construction: Extend Length",
		ChoGGi_ConstructionShowDomePassageLine = "Construction: Show Dome Passage Line v0.9",
		ChoGGi_ConstructionShowDroneGrid = "Construction: Show Drone Grid v0.4",
		ChoGGi_ConstructionShowDustGrid = "Construction: Show Dust Grid v0.2",
		ChoGGi_ConstructionShowHexBuildableGrid = "Construction: Show Hex Buildable Grid",
		ChoGGi_ConstructionShowHexGrid = "Construction: Show Hex Grid v0.2",
		ChoGGi_ConstructionShowMapSectors = "Construction: Show Map Sectors v0.2",
		ChoGGi_DomeTeleporters = "Dome Teleporters v0.5",
		ChoGGi_EveryFlagOnWikipedia = "Every Flag On Wikipedia v0.6",
		ChoGGi_FixMissingBuildUpgradeIcons = "Fix: Missing Build/Upgrade Icons",
		ChoGGi_FixRemovedModGameRules = "Fix: Removed Mod Game Rules",
		ChoGGi_GameRulesBreakthroughs = "Game Rules: Breakthroughs",
		ChoGGi_InfobarAddDischargeRates = "Infobar Add Discharge Rates",
		ChoGGi_Library = "ChoGGi's Library v5.1",
		ChoGGi_MakeFirstMartianbornCelebrity = "Make First Martianborn Celebrity v0.2",
		ChoGGi_MapImagesPack = "Map Images Pack v0.1",
		ChoGGi_MapOverviewShowSurfaceResources = "Map Overview: Show Surface Resources",
		ChoGGi_MarkDepositGround = "Mark Deposit Ground v0.4",
		ChoGGi_MarkSelectedBuildingType = "Mark Selected Building Type v0.1",
		ChoGGi_MarsCompanion = "Mars Companion v0.1",
		ChoGGi_MartianCarwash = "Martian Carwash v0.5",
		ChoGGi_Minimap = "Minimap v0.5",
		ChoGGi_MononokeShishiGami = "Mononoke Shishi-Gami",
		ChoGGi_MultiSelect = "Multi-Select v0.1",
		ChoGGi_NurseryLimitBirthingToSpots = "Nursery: Limit Birthing To Spots",
		ChoGGi_OrbitalPrefabDrops = "Orbital Prefab Drops v0.5",
		ChoGGi_OutsideResidence = "Outside Residence",
		ChoGGi_PassengerRocketTweaks = "Passenger Rocket Tweaks v0.2",
		ChoGGi_PatientTransportRoute = "Patient Transport Route v0.2",
		ChoGGi_PauseOnLoad = "Pause On Load v0.1",
		ChoGGi_PermanentPriority = "Permanent Priority v0.2",
		ChoGGi_PersonalShuttles = "Personal Shuttles v0.8",
		ChoGGi_POIAddTooltips = "POI: Add Tooltips",
		ChoGGi_PortableMiner = "RC Miner v1.8",
		ChoGGi_PrefabSafety = "Prefab Safety v0.2",
		ChoGGi_RCBulldozer = "RC Bulldozer v0.7",
		ChoGGi_RCConstructorRoutes = "RC Constructor Routes v0.1",
		ChoGGi_RCGarage = "RC Garage v0.3",
		ChoGGi_RCMechanic = "RC Mechanic v0.7",
		ChoGGi_RCRemote = "RC Remote v0.1",
		ChoGGi_RCTanker = "RC Tanker v0.1",
		ChoGGi_ResearchFilter = "Research Filter v0.2",
		ChoGGi_ResearchSmallCheckMarks = "Research: Small CheckMarks",
		ChoGGi_RocketAlwaysAskBeforeLaunch = "Rocket: Always Ask Before Launch v0.2",
		ChoGGi_RocketPinEnable = "Rocket: Pin Enable",
		ChoGGi_RotateAllBuildings = "Rotate All Buildings v0.1",
		ChoGGi_SaveMissionProfiles = "Save Mission Profiles v0.1",
		ChoGGi_SelectableCables = "Selectable Cables v0.4",
		ChoGGi_ShowLastColonies = "Show Saved Colonies v0.9",
		ChoGGi_ShowMaxRadiusRange = "Construction: Show Max Radius Range v0.4",
		ChoGGi_ShowTransportRouteInfo = "Show Transport Route Info v0.1",
		ChoGGi_ShowTunnelLines = "Show Tunnel Lines v0.2",
		ChoGGi_SolarArrayFollowsSun = "SArray Follows Sun",
		ChoGGi_SolariaTelepresence = "Solaria Telepresence v0.9",
		ChoGGi_SpecialistByExperience = "Specialist By Experience v0.4",
		ChoGGi_SpiceHarvester = "Spice Harvester v0.7",
		ChoGGi_StandingUnlocksSponsorBuildings = "Standing Unlocks Sponsor Buildings v0.2",
		ChoGGi_StopColonistDeathFailure = "Stop Colonist Death Failure v0.1",
		ChoGGi_StopCurrentDisasters = "Stop Current Disasters v0.4",
		ChoGGi_StopTradeCamera = "Stop Trade Camera",
		ChoGGi_UpgradeSlotsVisitorsCapacity = "Upgrade Slots: Visitors/Capacity",
		ChoGGi_ViewColonyMap = "View Colony Map v0.9",
		ChoGGi_LakesToggleVisibility = "Lakes: Toggle Visibility",
	}

	local mods_path = "AppData/Mods/"
	local pack_path = "AppData/ModUpload/Pack/"
	local dest_path = "AppData/ModUpload/"
	local hpk_path = "AppData/hpk.exe"
	if not Platform.pc then
		hpk_path = "AppData/hpk"
	end
	local hpk_path_working

	-- it's fine...
	local copy_files, blank_mod, clipboard, test, steam_upload, para_platform
	local mod, mod_path, upload_image, diff_author, result, choices_len, uploading
	local orig_title, msg_popup_id
	local result_msg, result_title, upload_msg = {}, {}, {}
	local image_steam = "UI/Common/mod_steam_workshop.tga"
	local image_paradox = "UI/ParadoxLogo.tga"


	local function UploadMod(answer, batch)
		if not answer or not mod or mod and not mod.steam_id then
			return
		end

		msg_popup_id = MsgPopup(
			T(5452, "START"),
			Strings[302535920000367--[[Mod Upload]]]
		)

		-- always start with fresh table
		table.clear(mod_params)

		-- add new mod
		local err, item_id, prepare_worked, prepare_results, existing_mod
		if steam_upload then
			if mod.steam_id ~= 0 then
				existing_mod = true
			end
			-- get needed info for mod
			prepare_worked, prepare_results = Steam_PrepareForUpload(nil, mod, mod_params)
			-- mod id for clipboard
			item_id = mod.steam_id
		-- paradox mods
		else
			-- workaround for paradox blocking renaming of titles
			if paradox_title[mod.id] then
				orig_title = mod.title
				mod.title = paradox_title[mod.id]
			end

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

		-- issue with mod platform (workshop/paradox mods)
		if not prepare_worked then
			local msg = Translate(1000013--[[Mod <ModLabel> was not uploaded! Error: <err>]]):gsub("<ModLabel>", mod.title):gsub("<err>", Translate(prepare_results))
			if batch then
				print(msg)
			else
				ChoGGi.ComFuncs.MsgWait(
					msg,
					Translate(1000592--[[Error]]) .. ": " .. mod.title,
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

		do -- screenshots
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
		end

		local files_to_pack = {}
		local substring_begin = #dest_path + 1
    local all_files
		err, all_files = AsyncListFiles(dest_path, nil, "recursive")
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

			-- try to use hpk exe instead of buggy ass AsyncPack
			if hpk_path_working then
				-- not sure if it matters, but delete ModContent.hpk first
				local output = mods_path .. ModsPackFileName
				AsyncFileDelete(output)
				local exec = hpk_path_working .. " create --cripple-lua-files \""
					.. mod.env.CurrentModPath:gsub(mods_path, ""):gsub("/", "") .. "\" " .. ModsPackFileName
				-- AsyncExec(cmd, working_dir, hidden, capture_output, priority)
				if not AsyncExec(exec, ConvertToOSPath(mods_path), true, false) then
					-- hpk.exe is a little limited in where it places the output, so we need to move it over
					AsyncCopyFile(output, pack_path .. ModsPackFileName, "raw")
					AsyncFileDelete(output)
				end
			else
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

			-- if no last_changes then use version num
			if not mod.last_changes or mod.last_changes == "" then
				if testing then
					mod.last_changes = "https://github.com/ChoGGi/SurvivingMars_CheatMods/tree/master/Mods%20ChoGGi/"
						.. (orig_title or mod.title):gsub(" ","%%20") .. "/changes.txt"
				else
					mod.last_changes = mod.version_major .. "." .. mod.version_minor
				end
			end

			-- skip it for testing
			if not test then
				if steam_upload then
					result, err = Steam_Upload(nil, mod, mod_params)
				else
					-- thanks LukeH
					mod.description = mod.description:gsub("\n", "<br>")
					result, err = PDX_Upload(nil, mod, mod_params)
					-- shouldn't actually matter, but maybe some people will use mod editor along with ECM
					mod.description = mod.description:gsub("<br>", "\n")
				end
			end
		end

		-- uploaded or failed?
		if err and not blank_mod then
			local msg = T{1000013, "Mod <ModLabel> was not uploaded! Error: <err>",
				ModLabel = mod.title, err = err,
			}
			result_msg[#result_msg+1] = msg
			if choices_len == 1 then
				result_title[#result_title+1] = Translate(1000592--[[Error]])
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
				result_title[#result_title+1] = "\n" .. T(1000592, "Error")
				result_msg[#result_msg+1] = log_error
			end
		else
			if batch then
				print(Translate("<color ChoGGi_green>" .. T(1000015, "Success") .. " " .. mod.title .. "</color>"))
			end
			if choices_len == 1 then
				result_msg[#result_msg+1] = T{1000014, "Mod <ModLabel> was successfully uploaded!",
					ModLabel = mod.title,
				}
				result_title[#result_title+1] = T(1000015, "Success")
			else
				result_title[#result_title+1] = mod.title
			end
		end

		-- show id in console/copy to clipboard
		if not test and item_id then
			-- don't copy to clipboard if existing mod or not steam or failed
			if not existing_mod and steam_upload and clipboard and not err then
				CopyToClipboard("	\"steam_id\", \"" .. item_id .. "\",")
			end

			local id_str = 1000021--[[Steam ID]]
			if not steam_upload then
				if para_platform then
					id_str = 1000772--[[Paradox Desktop UUID]]
				else
					id_str = 1000773--[[Paradox All UUID]]
				end
			end

			print(mod.title, ":", Translate(id_str), ":", item_id)
		end

		if not test and not err then
			-- remove upload folder
			AsyncDeletePath(dest_path)
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

		CreateRealTimeThread(function()
			local choice = choices[1]
			copy_files = choice.check1
			blank_mod = choice.check2
			clipboard = choice.check3
			test = choice.check4
			steam_upload = choice.check5
			para_platform = choice.check6

			choices_len = #choices

			local ask_batch
--~ ex(choices)
			uploading = true
			for i = 1, choices_len do
				choice = choices[i]
				-- select all means the fake item is also selected
				if choice.value then
					mod = choice.mod
					mod_path = choice.path
					-- pick logo for upload msg boxes
					if steam_upload then
						upload_image = image_steam
					else
						upload_image = image_paradox
					end

					diff_author = mod.author ~= SteamGetPersonaName()
					result = nil

					-- my mods override
					if ChoGGi_copy_files[mod.id] then
						copy_files = false
					end

					-- remove blacklist warning from title (added in helpermod)
					mod.title = mod.title:gsub(" %(Warning%)$", "")

					-- will fail on paradox mods
					if mod.lua_revision == 0 then
						mod.lua_revision = LuaRevision
					end
					if mod.saved_with_revision == 0 then
						mod.saved_with_revision = LuaRevision
					end

					table_iclear(result_msg)
					table_iclear(result_title)

					-- only one mod to upload so we ask questions
					if choices_len == 1 then
						-- build / show confirmation dialog
						table_iclear(upload_msg)
						local m_c = 0

						m_c = m_c + 1
						if steam_upload then
							upload_msg[m_c] = T{1000012,
								"Mod <ModLabel> will be uploaded to Steam",
								ModLabel = mod.title,
							}
						else
							upload_msg[m_c] = T{1000771,
								"Mod <ModLabel> will be uploaded to Paradox",
								ModLabel = mod.title,
							}
						end

						m_c = m_c + 1
						upload_msg[m_c] = "\n\n"
						m_c = m_c + 1
						upload_msg[m_c] = Strings[302535920001572--[["<color ChoGGi_red>Pack Warning</color>: Will instantly crash SM when calling it a second time, pack the mod manually to workaround it.
You can also stick the executable in the profile folder to use it instead (<green>no crashing</green>):
<yellow>%s</yellow>."]]]:format(ConvertToOSPath(hpk_path))

						if not copy_files then
							m_c = m_c + 1
							upload_msg[m_c] = "\n\n<color 203 120 30>"
							m_c = m_c + 1
							upload_msg[m_c] = Strings[302535920001262--[[%sModUpload folder is empty and waiting for files.]]]:format(ConvertToOSPath("AppData/"))
							m_c = m_c + 1
							upload_msg[m_c] = "</color>"
						end

						-- show diff author warning unless it's me
						if diff_author and not testing then
							m_c = m_c + 1
							upload_msg[m_c] = "\n\n"
							m_c = m_c + 1
							upload_msg[m_c] = Strings[302535920001263--[["%s is different from your name, do you have permission to upload it?"]]]:format(mod.author)
						end
					end

					-- clear out and create upload folder
					AsyncDeletePath(dest_path)
					AsyncCreatePath(dest_path)

					if choices_len == 1 then
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
					elseif ask_batch then
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
							mod = choice.mod
							if mod then
								titles_c = titles_c + 1
								titles[titles_c] = mod.title
									-- remove blacklist warning from title (added in helpermod)
									:gsub(" %(Warning%)$", "")
							end
						end
						-- and show msg
						if ChoGGi.ComFuncs.QuestionBox(
							Strings[302535920000221--[[Batch Upload mods?]]] .. "\n\n"
								.. table.concat(titles, ", "),
							CallBackFunc_BQ,
							Strings[302535920000221--[[Batch Upload!]]],
							nil,
							nil,
							upload_image,
							nil, nil, nil,
							CurrentThread()
						) == "cancel" then
							return
						end
						ask_batch = true
					end

				end -- if mod
			end -- for

			-- QuestionBox creates a thread, so we set this to false in UploadMod for it
			if choices_len > 1 then
				uploading = false
			end
			-- wait for it
			while uploading do
				Sleep(1000)
			end

			-- update popup msg if it's still opened
			local popups = ChoGGi.Temp.MsgPopups
			local idx = table.find(popups, "notification_id", msg_popup_id)
			if idx and ChoGGi.ComFuncs.IsValidXWin(popups[idx]) then
				popups[idx].idText:SetText(Strings[302535920001453--[[Completed]]])
			end

			local error_msgs = {}
			local c = 0
			for i = 1, #result_msg do
				c = c + 1
				error_msgs[c] = result_title[i] .. ": " .. result_msg[i]
			end
			error_msgs = table.concat(error_msgs)

			local error_text = Strings[302535920000221--[[See log for any batch errors.]]]
			-- only add error msg if single mod
			if choices_len == 1 then
				error_text = error_text .. "\n\n" .. error_msgs
			end

			-- let user know if we're good or not
			print(Translate(error_msgs))
			ChoGGi.ComFuncs.MsgWait(
				error_text,
				Strings[302535920001586--[[All Done!]]],
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
			local msg = Translate(1000760--[[Not Steam]]) .. "/"
				.. Translate(1000759--[[Not Paradox]])
			print(Strings[302535920000367--[[Mod Upload]]], ":", msg)
			MsgPopup(
				msg,
				Strings[302535920000367--[[Mod Upload]]]
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
			-- skip some mods and all packed mods
			if not skip_mods[id] and mod.content_path:sub(1,11) ~= "PackedMods/" then
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

		local _, image_steam_y = MeasureImage(image_steam)
		local _, image_paradox_y = MeasureImage(image_paradox)

		ChoGGi.ComFuncs.OpenInListChoice{
			background_image = upload_to_who and image_steam or image_paradox,
			callback = CallBackFunc,
			items = item_list,
			title = Strings[302535920000367--[[Mod Upload]]],
			hint = Strings[302535920001511--[["AsyncPack will CTD the second time you call it, you can use hpk to pack mods ahead of time.

https://github.com/nickelc/hpk
<green>hpk create ""Mod folder"" ModContent.hpk</green>
Move archive to ""Mod folder/Pack/ModContent.hpk"""]]] .. "\n\n" .. Strings[302535920001572]:format(ConvertToOSPath(hpk_path)),
			height = 800.0,
			multisel = true,
			checkboxes = {
				{title = Strings[302535920001258--[[Copy Files]]],
					hint = Strings[302535920001259--[["Copies all mod files to %sModUpload, uncheck to copy files manually."]]]:format(ConvertToOSPath("AppData/")),
					checked = true,
				},
				{title = Strings[302535920001260--[[Blank]]],
					hint = Strings[302535920001261--[["Uploads a blank mod, and prints id in log."]]],
				},
				{title = Strings[302535920000664--[[Clipboard]]],
					hint = Strings[302535920000665--[[If uploading a mod this copies steam id or uuid to clipboard.]]],
					checked = true,
				},
				{title = T(186760604064, "Test"),
					level = 2,
					hint = Strings[302535920001485--[[Does everything other than uploading mod to workshop (see AppData/ModUpload).]]],
				},
				{title = upload_to_who and Strings[302535920001506--[[Steam]]] or T(5482, "Paradox"),
					level = 2,
					hint = Strings[302535920001507--[[Uncheck to upload to Paradox mods (instead of Steam).]]],
					checked = upload_to_who,
					func = function(dlg, check)
						upload_to_who = check
						if check then
							dlg.idCheckBox5:SetText(Strings[302535920001506--[[Steam]]])
							dlg.idCheckBox6:SetVisible()
							dlg.idBackgroundFrame:SetImage(image_steam)
							dlg.idBackgroundFrame:SetMinHeight(image_steam_y)
						else
							dlg.idCheckBox5:SetText(T(5482, "Paradox"))
							dlg.idCheckBox6:SetVisible(true)
							dlg.idBackgroundFrame:SetImage(image_paradox)
							dlg.idBackgroundFrame:SetMinHeight(image_paradox_y)
						end
					end,
					-- no pops means no sense in showing this
					visible = Platform.pops,
				},
				{title = Strings[302535920001509--[[Platform]]],
					level = 2,
					hint = Strings[302535920001510--[["Paradox mods platform: Leave checked to upload to Desktop only or uncheck to upload to Desktop and Console.
If you have a uuid in your metadata.lua this checkbox is ignored and it'll try the any uuid then the desktop uuid."]]],
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
	table_sort(hw)
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
		Translate(5568--[[Stats]]),
		TableConcat(hw),
		TableConcat(mem),
		TableConcat({GetAdapterMode(0)}, " "),
		GetMachineID(),
		TableConcat(GetSupportedMSAAModes(), " "):gsub("HR::", ""),
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

			hint = Translate(4274--[[Playtime : <playtime>]]):gsub("<playtime>", Translate(playtime)) .. "\n"
				.. Translate(4273--[[Saved on : <save_date>]]):gsub("<save_date>", save_date) .. "\n\n"
				.. Strings[302535920001274--[[This is permanent!]]],
		}
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value

		if not choice[1].check1 then
			MsgPopup(
				Strings[302535920000038--[[Pick a checkbox next time...]]],
				Strings[302535920000146--[[Delete Saved Games]]]
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
				Strings[302535920001275--[[Deleted %s saved games.]]]:format(games_amt),
				Strings[302535920000146--[[Delete Saved Games]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000146--[[Delete Saved Games]]] .. ": " .. #item_list,
		hint = Translate(6779--[[Warning]]) .. ": " .. Strings[302535920001274--[[This is permanent!]]],
		multisel = true,
		skip_sort = true,
		checkboxes = {
			{
				title = Translate(1000009--[[Confirmation]]),
				hint = Strings[302535920001276--[[Nothing is deleted unless you check this.]]],
			},
		},
	}
end

function ChoGGi.MenuFuncs.StartupTicks_Toggle()
	ChoGGi.UserSettings.ShowStartupTicks = not ChoGGi.UserSettings.ShowStartupTicks
	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.ShowStartupTicks),
		Strings[302535920001481--[[Show Startup Ticks]]]
	)
end

function ChoGGi.MenuFuncs.ToolTips_Toggle()
	ChoGGi.UserSettings.EnableToolTips = not ChoGGi.UserSettings.EnableToolTips
	ChoGGi.ComFuncs.SetLibraryToolTips()

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.EnableToolTips),
		Strings[302535920001014--[[Toggle ToolTips]]]
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
This report will go to the %s developers not me."]]]:format(Translate(1079--[[Surviving Mars]])),
		CallBackFunc,
		Translate(1079--[[Surviving Mars]]) .. " " .. Strings[302535920001463--[[Bug Report]]],
		Strings[302535920001464--[[Yes, I know what I'm doing. This is a bug.]]]
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
			table.append(mod_folders, io.listfiles(PopsModsDownloadPath, "*", "folders, non recursive"))
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
						.. Strings[302535920001364--[[Don't be an asshole to %s... Always ask permission before using other people's hard work.]]]:format(mod.author)
						.. mod.image,
					id = id,
				}
			end
		end

	else
		MsgPopup(
			T(1000760, "Not Steam") .. T(1000543, "/") .. T(1000759, "Not Paradox"),
			Strings[302535920001362--[[Extract HPKs]]]
		)
		return
	end

	if #item_list == 0 then
		-- good enough msg, probably...
		MsgPopup(
			Strings[302535920000004--[[Dump]]] .. ": " .. #item_list,
			Strings[302535920001362--[[Extract HPKs]]]
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
				Strings[302535920001364--[[Don't be an asshole to %s... Always ask permission before using other people's hard work.]]]:format(choice.author)
			)
		end
		MsgPopup(
			Strings[302535920000004--[[Dump]]] .. ": " .. #choices,
			Strings[302535920001362--[[Extract HPKs]]]
		)
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920001362--[[Extract HPKs]]],
		hint = Strings[302535920001365--[[HPK files will be unpacked into AppData/Mods/ModSteamId]]],
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
		title = Strings[302535920000504--[[List All Menu Items]]],
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
	ChoGGi.ComFuncs.OpenInExamineDlg(TableConcat(data, "\n"), nil, Translate(283142739680--[[Game]]) .. " & " .. Strings[302535920001355--[[Map]]] .. " " .. Translate(126095410863--[[Info]]))
end

function ChoGGi.MenuFuncs.EditECMSettings()
	-- load up settings file in the editor
	ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
		text = TableToLuaCode(ChoGGi.UserSettings),
		hint_ok = Strings[302535920001244--[["Saves settings to file, and applies any changes."]]],
		hint_cancel = Strings[302535920001245--[[Abort without touching anything.]]],
		update_func = function()
			return TableToLuaCode(ChoGGi.UserSettings)
		end,
		custom_func = function(answer, _, obj)
			if answer then
				-- get text and update settings file
				local err, settings = LuaCodeToTuple(obj.idEdit:GetText())
				if not err then
					ChoGGi.UserSettings = ChoGGi.SettingFuncs.WriteSettings(settings)
					-- for now just updates console examine list
					Msg("ChoGGi_SettingsUpdated", settings)
					local d, m, h = FormatElapsedTime(os.time(), "dhm")
					local msg = Translate(4273--[[Saved on <save_date>]]):gsub("<save_date>", ": " .. d .. ":" .. m .. ":" .. h)
					MsgPopup(
						msg,
						Strings[302535920001242--[[Edit ECM Settings]]]
					)
				end
			end
		end,
	}
end

function ChoGGi.MenuFuncs.DisableECM()
	local title = Translate(251103844022--[[Disable]]) .. " " .. Strings[302535920000887--[[ECM]]]
	local function CallBackFunc(answer)
		if answer then
			ChoGGi.UserSettings.DisableECM = not ChoGGi.UserSettings.DisableECM
			ChoGGi.SettingFuncs.WriteSettings()

			MsgPopup(
				Strings[302535920001070--[[Restart to take effect.]]],
				title
			)
		end
	end
	ChoGGi.ComFuncs.QuestionBox(
		Strings[302535920000466--[["This will disable the cheats menu, cheats panel, and all hotkeys.
Change DisableECM to false in settings file to re-enable them."]]] .. "\n\n" .. Strings[302535920001070--[[Restart to take effect.]]],
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
				Strings[302535920001070--[[Restart to take effect.]]],
				Strings[302535920000676--[[Reset ECM Settings]]]
			)
		end
	end

	ChoGGi.ComFuncs.QuestionBox(
		Strings[302535920001072--[[Are you sure you want to reset ECM settings?
Old settings are saved as %s (or not saved if you don't use the HelperMod)]]]:format(old) .. "\n\n" .. Strings[302535920001070--[[Restart to take effect.]]],
		CallBackFunc,
		Strings[302535920001084--[[Reset]]] .. "!"
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

For any issues; please report them to my Github/Steam/NexusMods page, or email %s"]]]:format(ChoGGi.email),
		Translate(487939677892--[[Help]])
	)
end
