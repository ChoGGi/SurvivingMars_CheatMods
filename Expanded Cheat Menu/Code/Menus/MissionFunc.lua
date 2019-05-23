-- See LICENSE for terms

local type = type

local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local Translate = ChoGGi.ComFuncs.Translate
local TableConcat = ChoGGi.ComFuncs.TableConcat
local Strings = ChoGGi.Strings
local blacklist = ChoGGi.blacklist

function ChoGGi.MenuFuncs.SetDisasterOccurrence_Toggle(action)
	local setting_name = action.setting_name
	local us = ChoGGi.UserSettings

	local setting
	if setting_name == Translate(369748345658--[[Toxic Rain--]]) then
		if us.DisasterRainsDisable then
			us.DisasterRainsDisable = nil
		else
			us.DisasterRainsDisable = true
		end
		setting = us.DisasterRainsDisable
	elseif setting_name == Translate(382404446864--[[Marsquake--]]) then
		if us.DisasterQuakeDisable then
			us.DisasterQuakeDisable = nil
		else
			us.DisasterQuakeDisable = true
		end
		setting = us.DisasterQuakeDisable
	end

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(setting),
		setting_name
	)
end

function ChoGGi.MenuFuncs.ChangeRivalColonies()
--~ 		MarsScreenLandingSpots
	local g_CurrentMissionParams = g_CurrentMissionParams
	local rival_colonies = MissionParams.idRivalColonies.items
	local g_RivalAIs = RivalAIs or empty_table

	local skip = {
		random = true,
		none = true,
		[g_CurrentMissionParams.idMissionSponsor] = true,
	}

	local item_list = {}
	local c = 0
	for i = 1, #rival_colonies do
		local rival = rival_colonies[i]
		if not skip[rival.id] then
			local existing = g_RivalAIs[rival.id]
			local name = Translate(rival.display_name)
			local initial_res = {}

			for j = 1, #rival.initial_resources do
				local res = rival.initial_resources[j]
				if res.amount then
					initial_res[j] = res.resource .. " " .. res.amount .. "\n"
				end
			end

			c = c + 1
			item_list[c] = {
				text = existing and (name .. " (" .. Strings[302535920000201--[[Active--]]] .. ")") or name,
				value = rival.id,
				rival = rival,
				existing = existing,
				hint = name .. "\n\n"
					.. Translate(rival.description) .. "\n\n" .. TableConcat(initial_res),
			}
		end
	end

	local function CallBackFunc(choices)
		if choices.nothing_selected then
			return
		end
		local add = choices[1].check1
		local remove = choices[1].check2

		-- if it's an old save without rivals added
		if not g_CurrentMissionParams.idRivalColonies then
			local rivals_table = {}
			local c = 0

			if add then
				for i = 1, #choices do
					rivals_table[i] = choices[i].value
				end
				c = #rivals_table
				if c < 3 then
					for _ = c, 3 - c do
						c = c + 1
						rivals_table[c] = "none"
					end
				end
			elseif remove then
				return
			end

			g_CurrentMissionParams.idRivalColonies = rivals_table
			Msg("OurColonyPlaced")
		end
		local g_RivalAIs = RivalAIs

		if add then
			for i = 1, #choices do
				local choice = choices[i]
				-- if it's an actual rival, and not one already added
				if not g_RivalAIs[choice.value] then
					SpawnRivalAI(choice.rival)
				end
			end
		elseif remove then
			for i = 1, #choices do
				local choice = choices[i]
				if choice.existing then
					DeleteRivalAI(choice.existing)
				end
			end
		end

		MsgPopup(
			tostring(#choices),
			Translate(11034--[[Rival Colonies--]])
		)

	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Translate(11034--[[Rival Colonies--]]),
		hint = Strings[302535920001460--[[Add/remove rival colonies.--]]],
		multisel = true,
		custom_type = 3,
		checkboxes = {
			only_one = true,
			at_least_one = true,
			{
				title = Strings[302535920001183--[[Add--]]],
				hint = Strings[302535920001462--[[%s rival colonies.--]]]:format(Strings[302535920001183--[[Add--]]]),
				checked = true,
			},
			{
				title = Strings[302535920000281--[[Remove--]]],
				hint = Strings[302535920001462--[[%s rival colonies.--]]]:format(Strings[302535920000281--[[Remove--]]]),
			},
		},

	}
end

function ChoGGi.MenuFuncs.StartChallenge()
	local item_list = {}
	local challenges = Presets.Challenge.Default
	local DayDuration = const.DayDuration

	for i = 1, #challenges do
		local c = challenges[i]
		local current
		if c.id == g_CurrentMissionParams.challenge_id then
			current = true
		end
		item_list[i] = {
			text = Translate(c.title),
			value = c.id,
			hint = Translate(c.description) .. "\n\n"
				.. Strings[302535920001415--[[Sols to Complete: %s--]]]:format(c.time_completed / DayDuration)
				.. "\n"
				.. Translate(10489--[[<newline>Perfect time: <countdown2>--]]):gsub("<countdown2>", c.time_perfected / DayDuration)
				.. (current and "\n\n" .. Strings[302535920000106--[[Current--]]] or ""),
		}
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		g_CurrentMissionParams.challenge_id = choice[1].value
		-- just in case
		challenges[choice[1].value].TrackProgress = true

		UICity:StartChallenge()

		MsgPopup(
			choice[1].text,
			Strings[302535920001247--[[Start Challenge--]]]
		)
	end

	local hint
	local thread = UICity.challenge_thread
	if not blacklist and IsValidThread(thread) then
		local _, c = debug.getlocal(thread, 1, 1)
		hint = Strings[302535920000106--[[Current--]]] .. ": " .. Translate(c.title) .. ", " .. c.id
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920001247--[[Start Challenge--]]],
		hint = hint,
	}
end

function ChoGGi.MenuFuncs.InstantMissionGoals()
	local T = T
	local GetGoalDescription = GetGoalDescription
	local SponsorGoalsMap = SponsorGoalsMap
	local SponsorGoalProgress = SponsorGoalProgress

	local item_list = {}
	local c = 0
	local sponsor = GetMissionSponsor()
	for i = 1, 5 do
		-- no sense in showing done ones
		if not SponsorGoalProgress[i].state then
			local reward = sponsor["reward_effect_" .. i]

			c = c + 1
			item_list[c] = {
				text = i .. " " .. sponsor["sponsor_goal_" .. i],
				value = i,
				hint = "<image " .. sponsor["goal_image_" .. i] .. ">\n\n"
					.. Strings[302535920001409--[[Goal--]]] .. ": "
					.. Translate(GetGoalDescription(sponsor, i)) .. "\n"
					.. Translate(128569337702--[[Reward:--]]) .. " "
					.. Translate(T{reward.Description, reward}),
				reward = reward,
				goal = SponsorGoalsMap[sponsor["sponsor_goal_" .. i]],
			}
		end
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		for i = 1, #choice do
			local goalprog = SponsorGoalProgress[choice[i].value]
			-- you weiner
			goalprog.state = GameTime()
			goalprog.progress = goalprog.target

			local reward = choice[i].reward
			local goal = choice[i].goal
			-- stuff from City:SetGoals()
			reward:Execute()
			AddOnScreenNotification("GoalCompleted", OpenMissionProfileDlg, {reward_description = T(reward.Description, reward), context = context, rollover_title = T(4773, "<em>Goal:</em> "), rollover_text = goal.description})
			Msg("GoalComplete", goal)
			if AreAllSponsorGoalsCompleted() then
				Msg("MissionEvaluationDone")
			end
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000704--[[Instant Mission Goals--]]],
		multisel = true,
	}
end

function ChoGGi.MenuFuncs.InstantColonyApproval()
	-- remove founder stage msg
	RemoveOnScreenNotification("FounderStageDuration")
	-- add the passed msg
	if IsGameRuleActive("TheLastArk") then
		CreateRealTimeThread(WaitPopupNotification, "ColonyViabilityExit_Delay_LastArk")
	else
		CreateRealTimeThread(WaitPopupNotification, "ColonyViabilityExit_Delay")
	end
	-- actually pass it
	Msg("ColonyApprovalPassed")
	g_ColonyNotViableUntil = -1
end

function ChoGGi.MenuFuncs.MeteorHealthDamage_Toggle()
	local Consts = Consts
	ChoGGi.ComFuncs.SetConstsG("MeteorHealthDamage", ChoGGi.ComFuncs.NumRetBool(Consts.MeteorHealthDamage, 0, ChoGGi.Consts.MeteorHealthDamage))
	ChoGGi.ComFuncs.SetSavedConstSetting("MeteorHealthDamage")

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(Strings[302535920001160--[["%s
Damage? Total, sir.
It's what we call a global killer.
The end of mankind. Doesn't matter where it hits. Nothing would survive, not even bacteria."--]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.MeteorHealthDamage)),
		Strings[302535920000708--[[Meteor Damage--]]],
		nil,
		true
	)
end

function ChoGGi.MenuFuncs.SetSponsor()
	local GetSponsorDescr = GetSponsorDescr
	local GetMissionSponsor = GetMissionSponsor

	local item_list = {}
	local c = 0

	local objs = Presets.MissionSponsorPreset.Default or ""
	for i = 1, #objs do
		local spon = objs[i]
		if spon.id ~= "random" and spon.id ~= "None" then
			local descr = GetSponsorDescr(spon, false, "include rockets", true, true)
			local stats
			-- the one we want is near the end, but there's also a blank item below it
			for j = 1, #descr do
				local des = descr[j]
				if type(des) == "table" then
					stats = des
				end
			end

			c = c + 1
			item_list[c] = {
				text = Translate(spon.display_name),
				value = spon.id,
				hint = Translate(T{spon.effect, stats[2]})
					.. (spon.save_in ~= "" and "\n\nsave_in: " .. spon.save_in or ""),
			}
		end
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		local g_CurrentMissionParams = g_CurrentMissionParams
		local UICity = UICity
		local sponsor = GetMissionSponsor()
		for i = 1, #item_list do
			-- check to make sure it isn't a fake name (no sense in saving it)
			if item_list[i].value == value then
				-- new spons
				g_CurrentMissionParams.idMissionSponsor = value
				-- apply tech from new sponsor
				UICity:GrantTechFromProperties(sponsor)
				sponsor:game_apply(UICity)
				sponsor:EffectsApply(UICity)
				UICity:ApplyModificationsFromProperties()
				-- and bonuses
				UICity:InitMissionBonuses()

				MsgPopup(
					Strings[302535920001161--[[Sponsor for this save is now %s--]]]:format(choice[1].text),
					Strings[302535920000712--[[Set Sponsor--]]]
				)
				break
			end
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000712--[[Set Sponsor--]]],
		hint = Strings[302535920000106--[[Current--]]] .. ": " .. Translate(GetMissionSponsor().display_name),
	}
end

function ChoGGi.MenuFuncs.SetSponsorBonus()
	local UserSettings = ChoGGi.UserSettings
	local Presets = Presets

	local item_list = {}
	local c = 0
	local objs = Presets.MissionSponsorPreset.Default or ""
	for i = 1, #objs do
		local spon = objs[i]
		if spon.id ~= "random" and spon.id ~= "None" then
			local descr = GetSponsorDescr(spon, false, "include rockets", true, true)
			local stats
			-- the one we want is near the end, but there's also a blank item below it
			for j = 1, #descr do
				local des = descr[j]
				if type(des) == "table" then
					stats = des
				end
			end

			local user_set = UserSettings["Sponsor" .. spon.id]
			c = c + 1
			item_list[c] = {
				text = Translate(spon.display_name),
				value = spon.id,
				hint = Translate(T{spon.effect, stats[2]}) .. "\n\n" .. Strings[302535920001165--[[Enabled Status--]]]
					.. (user_set and ": " .. user_set or " false")
					.. (spon.save_in ~= "" and "\n\nsave_in: " .. spon.save_in or ""),
			}
		end
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		if choice[1].check2 then
			for i = 1, #item_list do
				local value = item_list[i].value
				if type(value) == "string" then
					value = "Sponsor" .. value
					UserSettings[value] = nil
				end
			end
		else
			for i = 1, #choice do
				local value = choice[i].value
				for j = 1, #item_list do
					-- check to make sure it isn't a fake name (no sense in saving it)
					if item_list[j].value == value and type(value) == "string" then
						local name = "Sponsor" .. value
						if choice[1].check1 then
							UserSettings[name] = nil
						else
							UserSettings[name] = true
						end
						if UserSettings[name] then
							ChoGGi.ComFuncs.SetSponsorBonuses(value)
						end
					end
				end
			end
		end

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(#choice),
			Strings[302535920000714--[[Set Bonuses Sponsor--]]]
		)
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000714--[[Set Bonuses Sponsor--]]],
		hint = Strings[302535920000106--[[Current--]]] .. ": " .. Translate(GetMissionSponsor().display_name) .. "\n\n" .. Strings[302535920001168--[[Modded ones are mostly ignored for now (just cargo space/research points).--]]],
		multisel = true,
		checkboxes = {
			{
				title = Strings[302535920001169--[[Turn Off--]]],
				hint = Strings[302535920001170--[[Turn off selected bonuses (defaults to turning on).--]]],
			},
			{
				title = Strings[302535920001171--[[Turn All Off--]]],
				hint = Strings[302535920001172--[[Turns off all bonuses.--]]],
			},
		},
	}
end

function ChoGGi.MenuFuncs.SetCommander()
	local g_CurrentMissionParams = g_CurrentMissionParams
	local UICity = UICity

	local item_list = {}
	local c = 0

	local objs = Presets.CommanderProfilePreset.Default or ""
	for i = 1, #objs do
		local comm = objs[i]
		if comm.id ~= "random" and comm.id ~= "None" then
			c = c + 1
			item_list[c] = {
				text = Translate(comm.display_name),
				value = comm.id,
				hint = Translate(comm.effect)
			}
		end
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		for i = 1, #item_list do
			-- check to make sure it isn't a fake name (no sense in saving it)
			if item_list[i].value == value then
				-- new comm
				g_CurrentMissionParams.idCommanderProfile = value
				-- apply tech from new commmander
				local comm = GetCommanderProfile()
				local UICity = UICity

				comm:game_apply(UICity)
				comm:OnApplyEffect(UICity)
				UICity:ApplyModificationsFromProperties()

				-- and bonuses
				UICity:InitMissionBonuses()

				MsgPopup(
					Strings[302535920001173--[[Commander for this save is now %s.--]]]:format(choice[1].text),
					Strings[302535920000716--[[Set Commander--]]]
				)
				break
			end
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000716--[[Set Commander--]]],
		hint = Strings[302535920000106--[[Current--]]] .. ": " .. Translate(GetCommanderProfile().display_name),
	}
end

function ChoGGi.MenuFuncs.SetCommanderBonus()
	local Presets = Presets
	local UserSettings = ChoGGi.UserSettings

	local item_list = {}
	local c = 0
	local objs = Presets.CommanderProfilePreset.Default or ""
	for i = 1, #objs do
		local comm = objs[i]
		if comm.id ~= "random" and comm.id ~= "None" then
			local user_set = UserSettings["Commander" .. comm.id]

			c = c + 1
			item_list[c] = {
				text = Translate(comm.display_name),
				value = comm.id,
				hint = Translate(comm.effect) .. "\n\n"
					.. Strings[302535920001165--[[Enabled Status--]]]
					.. (user_set and ": " .. user_set or " false"),
			}
		end
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end

		if choice[1].check2 then
			for i = 1, #item_list do
				local value = item_list[i].value
				if type(value) == "string" then
					value = "Commander" .. value
					UserSettings[value] = nil
				end
			end
		else
			for i = 1, #choice do
				for j = 1, #item_list do
					-- check to make sure it isn't a fake name (no sense in saving it)
					local value = choice[i].value
					if item_list[j].value == value and type(value) == "string" then
						local name = "Commander" .. value
						if choice[1].check1 then
							UserSettings[name] = nil
						else
							UserSettings[name] = true
						end
						if UserSettings[name] then
							ChoGGi.ComFuncs.SetCommanderBonuses(value)
						end
					end
				end
			end
		end

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(#choice),
			Strings[302535920000718--[[Set Bonuses Commander--]]]
		)
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000718--[[Set Bonuses Commander--]]],
		hint = Strings[302535920000106--[[Current--]]] .. ": " .. Translate(GetCommanderProfile().display_name),
		multisel = true,
		checkboxes = {
			{
				title = Strings[302535920001169--[[Turn Off--]]],
				hint = Strings[302535920001170--[[Turn off selected bonuses (defaults to turning on).--]]],
			},
			{
				title = Strings[302535920001171--[[Turn All Off--]]],
				hint = Strings[302535920001172--[[Turns off all bonuses.--]]],
			},
		},
	}
end

function ChoGGi.MenuFuncs.ChangeGameLogo()
	local MissionLogoPresetMap = MissionLogoPresetMap
	local GetAllAttaches = ChoGGi.ComFuncs.GetAllAttaches
	local RetAllOfClass = ChoGGi.ComFuncs.RetAllOfClass

	local item_list = {}
	local c = 0
	for id, def in pairs(MissionLogoPresetMap) do
		c = c + 1
		item_list[c] = {
			text = Translate(def.display_name),
			value = id,
			hint = "<image " .. def.image .. ">",
		}
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		local logo = MissionLogoPresetMap[value]

		-- check if user typed custom name and screwed up
		if logo then
			local entity_name = logo.entity_name

			local function ChangeLogo(label)
				label = RetAllOfClass(label)
				for i = 1, #label do
					local a_list = GetAllAttaches(label[i])
--~ ex(a_list)
--~ break
					for j = 1, #a_list do
						local attach = a_list[j]
						if attach:IsKindOf("Logo") then
							attach:ChangeEntity(entity_name)
						end
					end
				end
			end

			-- for any new objects
			g_CurrentMissionParams.idMissionLogo = value
			-- loop through rockets and change logo
			ChangeLogo("SupplyRocket")
			-- same for any buildings that use the logo
			ChangeLogo("Building")

			MsgPopup(
				choice[1].text,
				Strings[302535920000710--[[Change Logo--]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920001178--[[Set New Logo--]]],
		hint = Strings[302535920000106--[[Current--]]] .. ": " .. Translate(MissionLogoPresetMap[g_CurrentMissionParams.idMissionLogo].display_name),
		height = 800.0,
		custom_type = 7,
	}
end

function ChoGGi.MenuFuncs.SetDisasterOccurrence(action)
	local setting_id = action.setting_id

	local mapdata = mapdata

	local item_list = {
		{
		text = " " .. Translate(847439380056--[[Disabled--]]),
		value = "disabled",
		}
	}
	local c = #item_list

	local set_name = "MapSettings_" .. setting_id
	local data = DataInstances[set_name]

	for i = 1, #data do
		local rule = data[i]

		local hint = {}
		local hc = 0
		for key, value in pairs(rule) do
			if key ~= "name" and key ~= "use_in_gen" then
				hc = hc + 1
				hint[hc] = key .. ": " .. tostring(value)
			end
		end
		c = c + 1
		item_list[c] = {
			text = rule.name,
			value = rule.name,
			hint = TableConcat(hint, "\n"),
		}
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value

		mapdata[set_name] = value
		if setting_id == "Meteor" then
			RestartGlobalGameTimeThread("Meteors")
			RestartGlobalGameTimeThread("MeteorStorm")
		else
			RestartGlobalGameTimeThread(setting_id)
		end

		MsgPopup(
			Strings[302535920001179--[[%s occurrence is now: %s--]]]:format(setting_id, value),
			Translate(3983--[[Disasters--]])
		)
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000129--[[Set--]]] .. " " .. setting_id .. " " .. Strings[302535920001180--[[Disaster Occurrences--]]],
		hint = Strings[302535920000106--[[Current--]]] .. ": " .. (mapdata[set_name] or ""),
	}
end

function ChoGGi.MenuFuncs.ChangeRules()
	local GameRulesMap = GameRulesMap
	local g_CurrentMissionParams = g_CurrentMissionParams
	local IsGameRuleActive = IsGameRuleActive

	local item_list = {}
	local c = 0
	for id, def in pairs(GameRulesMap) do
		local enabled = IsGameRuleActive(id)
		c = c + 1
		item_list[c] = {
			text = Translate(def.display_name) .. (enabled and " *" or ""),
			value = id,
			hint = (enabled and "<color green>" .. Translate(12227--[[Enabled--]]) .. "</color>\n" or "")
				.. Translate(def.description) .. "\n"
				.. Translate(3491--[[Challenge Mod (%)--]]) .. ": " .. def.challenge_mod .. "\n\n"
				.. (def.exclusionlist and Strings[302535920001357--[[Exclusion List--]]] .. ": " .. def.exclusionlist or "")
				.. "\n".. Translate(def.flavor),
		}
	end


	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local check1 = choice[1].check1
		local check2 = choice[1].check2

		for i = 1, #item_list do
			-- check to make sure it isn't a fake name (no sense in saving it)
			for j = 1, #choice do
				local value = choice[j].value
				if item_list[i].value == value then
					-- new comm
					if not g_CurrentMissionParams.idGameRules then
						g_CurrentMissionParams.idGameRules = {}
					end
					if check1 then
						g_CurrentMissionParams.idGameRules[value] = true
					elseif check2 then
						g_CurrentMissionParams.idGameRules[value] = nil
					end
				end
			end
		end

		-- apply new rules, something tells me this doesn't disable old rules...
		local rules = GetActiveGameRules()
		local UICity = UICity
		for i = 1, #rules do
			local rule = rules[i]
			GameRulesMap[rule]:EffectsInit(UICity)
			GameRulesMap[rule]:EffectsApply(UICity)
		end

		MsgPopup(
			ChoGGi.ComFuncs.SettingState(#choice, Strings[302535920000129--[[Set--]]]),
			Translate(8800--[[Game Rules--]])
		)
	end

	local hint
	local rules = g_CurrentMissionParams.idGameRules
	if type(rules) == "table" and next(rules) then
		hint = {}
		local c = #hint
		hint[c] = Strings[302535920000106--[[Current--]]]
		c = c + 1
		hint[c] = ":"
		for key in pairs(rules) do
			c = c + 1
			hint[c] = " "
			c = c + 1
			hint[c] = Translate(GameRulesMap[key].display_name)
		end
	end
	if hint then
		hint = TableConcat(hint)
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920001182--[[Set Game Rules--]]],
		hint = hint,
		multisel = true,
		checkboxes = {
			only_one = true,
			at_least_one = true,
			{
				title = Strings[302535920001183--[[Add--]]],
				hint = Strings[302535920001185--[[Add selected rules--]]],
				checked = true,
			},
			{
				title = Strings[302535920000281--[[Remove--]]],
				hint = Strings[302535920001186--[[Remove selected rules--]]],
			},
		},
	}
end
