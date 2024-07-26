-- See LICENSE for terms

if ChoGGi.what_game ~= "Mars" then
	return
end

local ChoGGi_Funcs = ChoGGi_Funcs
local type, table = type, table
local T = T
local Translate = ChoGGi_Funcs.Common.Translate
local MsgPopup = ChoGGi_Funcs.Common.MsgPopup
local Random = ChoGGi_Funcs.Common.Random
local RetTemplateOrClass = ChoGGi_Funcs.Common.RetTemplateOrClass


function ChoGGi_Funcs.Menus.OutsideWorkplaceSanityDecrease_Toggle()
	ChoGGi_Funcs.Common.SetConsts("OutsideWorkplaceSanityDecrease", ChoGGi_Funcs.Common.NumRetBool(Consts.OutsideWorkplaceSanityDecrease, 0, ChoGGi.Consts.OutsideWorkplaceSanityDecrease))
	ChoGGi_Funcs.Common.SetSavedConstSetting("OutsideWorkplaceSanityDecrease")

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.OutsideWorkplaceSanityDecrease),
		T(302535920001589--[[Outside Workplace Sanity Penalty]])
	)
end

function ChoGGi_Funcs.Menus.NonHomeDomePerformancePenalty_Toggle()
	ChoGGi_Funcs.Common.SetConsts("NonHomeDomePerformancePenalty", ChoGGi_Funcs.Common.NumRetBool(Consts.NonHomeDomePerformancePenalty, 0, ChoGGi.Consts.NonHomeDomePerformancePenalty))
	ChoGGi_Funcs.Common.SetSavedConstSetting("NonHomeDomePerformancePenalty")

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.NonHomeDomePerformancePenalty),
		T(302535920000912--[[Penalty]])
	)
end

function ChoGGi_Funcs.Menus.NoMoreEarthsick_Toggle()
	if ChoGGi.UserSettings.NoMoreEarthsick then
		ChoGGi.UserSettings.NoMoreEarthsick = nil
	else
		ChoGGi.UserSettings.NoMoreEarthsick = true
		local c = UIColony.city_labels.labels.Colonist or ""
		for i = 1, #c do
			if c[i].status_effects.StatusEffect_Earthsick then
				c[i]:Affect("StatusEffect_Earthsick", false)
			end
		end
	end

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		Translate(302535920000736--[[%s: Whoops somebody broke the rocket, guess you're stuck on mars.]]):format(ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.NoMoreEarthsick)),
		T(302535920000369--[[No More Earthsick]])
	)
end

function ChoGGi_Funcs.Menus.UniversityGradRemoveIdiotTrait_Toggle()
	ChoGGi.UserSettings.UniversityGradRemoveIdiotTrait = ChoGGi_Funcs.Common.ToggleValue(ChoGGi.UserSettings.UniversityGradRemoveIdiotTrait)

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		Translate(302535920000737--[[%s: Water? Like out of the toilet?]]):format(ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.UniversityGradRemoveIdiotTrait)),
		T(302535920000410--[[University Grad Remove Idiot]])
	)
end

--~ 	DeathReasons.ChoGGi_Soylent = T(302535920000738--[[Evil Overlord]])
--~ 	NaturalDeathReasons.ChoGGi_Soylent = true
function ChoGGi_Funcs.Menus.TheSoylentOption()
	local Tables = ChoGGi.Tables

	-- don't drop BlackCube/MysteryResource
	local reslist = {}
	local r_c = 0
	local all = AllResourcesList
	for i = 1, #all do
		if all[i] ~= "BlackCube" and all[i] ~= "MysteryResource" then
			r_c = r_c + 1
			reslist[r_c] = all[i]
		end
	end

	local function MeatbagsToSoylent(meat_bag, res)
		if meat_bag.dying then
			return
		end

		if res then
			res = reslist[Random(1, #reslist)]
		else
			res = "Food"
		end
		PlaceResourcePile(
			GetRealm(meat_bag):GetPassablePointNearby(meat_bag) or meat_bag:GetVisualPos(),
			res, Random(1, 5) * const.ResourceScale
		)
		meat_bag:SetCommand("Erase")
	end

	-- one meatbag at a time
	local obj = ChoGGi_Funcs.Common.SelObject()
	if IsKindOf(obj, "Colonist") then
		MeatbagsToSoylent(obj)
		return
	end

	-- culling the herd
	local item_list = {
		{text = " " .. T(7553--[[Homeless]]), value = "Homeless"},
		{text = " " .. T(6859--[[Unemployed]]), value = "Unemployed"},
		{text = " " .. T(7031--[[Renegades]]), value = "Renegade"},
		{text = " " .. T(240--[[Specialization]]) .. ": " .. T(6761--[[None]]), value = "none"},
	}
	local c = #item_list

	local function AddToList(list, text)
		for i = 1, #list do
			c = c + 1
			item_list[c] = {
				text = text .. ": " .. list[i],
				value = list[i],
				idx = i,
			}
		end
	end

	AddToList(Tables.ColonistAges, Translate(987289847467--[[Age Groups]]))
	AddToList(Tables.ColonistGenders, Translate(4356--[[Sex]]):gsub("<right><Gender>", ""))
	AddToList(Tables.ColonistRaces, T(302535920000741--[[Race]]))
	AddToList(Tables.ColonistSpecializations, Translate(240--[[Specialization]]))

	local birth = Tables.ColonistBirthplaces
	for i = 1, #birth do
		local name = Translate(birth[i].text)
		c = c + 1
		item_list[c] = {
			text = Translate(4357--[[Birthplace]]):gsub("<right><UIBirthplace>", "") .. ": " .. name,
			value = birth[i].value,
			idx = i,
			hint = name .. "\n\n<image " .. birth[i].flag .. ">",
		}
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local check1 = choice[1].check1
		local dome
		obj = SelectedObj
		if IsKindOf(obj, "Colonist") and obj.dome and choice[1].check2 then
			dome = obj.dome
		end

		local function CullLabel(label)
			local objs = UIColony.city_labels.labels[label] or ""
			for i = #objs, 1, -1 do
				if dome then
					local o = objs[i]
					if o.dome and o.dome.handle == dome.handle then
						MeatbagsToSoylent(o, check1)
					end
				else
					MeatbagsToSoylent(objs[i], check1)
				end
			end
		end
		local function CullTrait(trait)
			local objs = UIColony.city_labels.labels.Colonist or ""
			for i = #objs, 1, -1 do
				local o = objs[i]
				if o.traits[trait] then
					if dome then
						if o.dome and o.dome.handle == dome.handle then
							MeatbagsToSoylent(o, check1)
						end
					else
						MeatbagsToSoylent(o, check1)
					end
				end
			end
		end
		local function Cull(trait, trait_type, race)
			-- only race is stored as number (maybe there's a cock^?^?^?^?CoC around?)
			trait = race or trait
			local objs = UIColony.city_labels.labels.Colonist or ""
			for i = #objs, 1, -1 do
				local o = objs[i]
				if o[trait_type] == trait then
					if dome then
						if o.dome and o.dome.handle == dome.handle then
							MeatbagsToSoylent(o, check1)
						end
					else
						MeatbagsToSoylent(o, check1)
					end
				end
			end
		end

		local show_popup = true
		for i = 1, #choice do
			local text = choice[i].text
			local value = choice[i].value

			if value == "Homeless" or value == "Unemployed" then
				CullLabel(value)
			elseif value == "Renegade" then
				CullTrait(value)
			elseif text:find(Translate(240--[[Specialization]])) and (Tables.ColonistSpecializations[value] or value == "none") then
				CullLabel(value)
			elseif text:find(Translate(987289847467--[[Age Groups]])) and Tables.ColonistAges[value] then
				CullTrait(value)
			elseif text:find(Translate(4357--[[Birthplace]]):gsub("<right><UIBirthplace>", "")) and Tables.ColonistBirthplaces[value] then
				Cull(value, "birthplace")
--~ 				-- bonus round
--~ 				if not UIColony.ChoGGi.DaddysLittleHitler then
--~ 					Msg("ChoGGi_DaddysLittleHitler")
--~ 					UIColony.ChoGGi.DaddysLittleHitler = true
--~ 				end
			elseif text:find(Translate(4356--[[Sex]]):gsub("<right><Gender>", "")) and Tables.ColonistGenders[value] then
				CullTrait(value)
			elseif text:find(T(302535920000741--[[Race]])) and Tables.ColonistRaces[value] then
				Cull(value, "race", choice[1].idx)
--~ 				-- bonus round
--~ 				if not UIColony.ChoGGi.DaddysLittleHitler then
--~ 					Msg("ChoGGi_DaddysLittleHitler")
--~ 					UIColony.ChoGGi.DaddysLittleHitler = true
--~ 				end
			end

			if value == "Child" then
				show_popup = false
				-- wonder why they never added this to fallout 3?
				MsgPopup(
					T(302535920000742--[[Congratulations: You've been awarded the Childkiller title.



I think somebody has been playing too much Fallout...]]),
					T(302535920000743--[[Childkiller]]),
					{image = "UI/Icons/Logos/logo_09.tga"}
				)
				if not UIColony.ChoGGi.Childkiller then
					Msg("ChoGGi_Childkiller")
					UIColony.ChoGGi.Childkiller = true
				end
			end
		end

		if show_popup then
			MsgPopup(
				T(302535920000744--[["It is every citizen's final duty to go into the tanks and become one with all the people."]]),
				T(302535920000375--[[The Soylent Option]])
			)
		end

	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		multisel = true,
		custom_type = 3,
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000375--[[The Soylent Option]]),
		hint = T(302535920000747--[[Convert useless meatbags into productive protein.

Certain colonists may take some time (traveling in shuttles).

This will not effect your applicants/game failure (genocide without reprisal ftw).]]),
		checkboxes = {
			{
				title = T(302535920000748--[[Random resource]]),
				hint = T(302535920000749--[[Drops random resource instead of food.]]),
			},
			{
				title = T(302535920000750--[[Dome Only]]),
				hint = T(302535920000751--[[Will only apply to colonists in the same dome as selected colonist.]]),
			},
		},
	}
end

function ChoGGi_Funcs.Menus.AddApplicantsToPool()
	local item_list = {
		{text = 1, value = 1},
		{text = 10, value = 10},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
		{text = 2500, value = 2500},
		{text = 5000, value = 5000},
		{text = 10000, value = 10000},
		{text = 25000, value = 25000},
		{text = 50000, value = 50000},
		{text = 100000, value = 100000},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if choice.check1 then
			g_ApplicantPool = {}
			MsgPopup(
				T(302535920000754--[[Emptied applicants pool.]]),
				T(302535920000755--[[Applicants]])
			)
		else
			if type(value) == "number" then
				local MainCity = MainCity
				local now = GameTime()
				for _ = 1, value do
					GenerateApplicant(now, MainCity)
				end
				g_LastGeneratedApplicantTime = now
				MsgPopup(
					Translate(302535920000756--[[%s: Added applicants.]]):format(choice.text),
					T(302535920000755--[[Applicants]])
				)
			end
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000757--[[Add Applicants To Pool]]),
		hint = T(6779--[[Warning]]) .. ": " .. T(302535920000758--[[Will take some time for 25K and up.]]),
		skip_sort = true,
		checkboxes = {
			{
				title = T(302535920000759--[[Clear Applicant Pool]]),
				hint = T(302535920000760--[["Remove all the applicants currently in the pool (checking this will ignore your list selection).

Current Pool Size: %s"]]):format(tostring(#g_ApplicantPool)),
			},
		},
	}
end

function ChoGGi_Funcs.Menus.FireAllColonists()
	local function CallBackFunc(answer)
		if answer then
			local objs = UIColony.city_labels.labels.Colonist or ""
			for i = 1, #objs do
				objs[i]:GetFired()
			end
		end
	end
	ChoGGi_Funcs.Common.QuestionBox(
		T(302535920000761--[[Are you sure you want to fire everyone?]]),
		CallBackFunc,
		T(302535920000762--[[Yer outta here!]])
	)
end

function ChoGGi_Funcs.Menus.SetAllWorkShifts()
	local item_list = {
		{text = T(302535920000763--[[Turn On All Shifts]]), value = 0},
		{text = T(302535920000764--[[Turn Off All Shifts]]), value = 3.1415926535},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		local shift
		if value == 3.1415926535 then
			shift = {true, true, true}
		else
			shift = {false, false, false}
		end

		local objs = UIColony.city_labels.labels.ShiftsBuilding or ""
		for i = 1, #objs do
			local o = objs[i]
			if o.closed_shifts then
				o.closed_shifts = shift
			end
		end

		MsgPopup(
			T(302535920000765--[[Early night? Vamos al bar un trago!]]),
			T(217--[[Work Shifts]])
		)
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(217--[[Work Shifts]]),
		hint = T(302535920000766--[[This will change ALL shifts.]]),
	}
end

function ChoGGi_Funcs.Menus.SetMinComfortBirth()
	local r = const.ResourceScale
	local default_setting = ChoGGi.Consts.MinComfortBirth / r
	local hint_low = T(302535920000767--[[Lower = more babies]])
	local hint_high = T(302535920000768--[[Higher = less babies]])
	local item_list = {
		{text = T(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 0, value = 0, hint = hint_low},
		{text = 35, value = 35, hint = hint_low},
		{text = 140, value = 140, hint = hint_high},
		{text = 280, value = 280, hint = hint_high},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.MinComfortBirth then
		hint = ChoGGi.UserSettings.MinComfortBirth / r
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			value = value * r
			ChoGGi_Funcs.Common.SetConsts("MinComfortBirth", value)
			ChoGGi_Funcs.Common.SetSavedConstSetting("MinComfortBirth")

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				T(302535920000769--[[Selected]]) .. ": " .. choice[1].text .. T(302535920000770--[[
Look at them, bloody Catholics, filling the bloody world up with bloody people they can't afford to bloody feed.]]),
				T(7425--[[Minimum Colonist Comfort for Birth]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000771--[[Set the minimum comfort needed for birth]]),
		hint = T(302535920000106--[[Current]]) .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.VisitFailPenalty_Toggle()
	ChoGGi_Funcs.Common.SetConsts("VisitFailPenalty", ChoGGi_Funcs.Common.NumRetBool(Consts.VisitFailPenalty, 0, ChoGGi.Consts.VisitFailPenalty))
	ChoGGi_Funcs.Common.SetSavedConstSetting("VisitFailPenalty")

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		T(302535920000772--[["%s:
The mill's closed. There's no more work. We're destitute. I'm afraid I have no choice but to sell you all for scientific experiments."]]):format(ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.VisitFailPenalty)),
		T(302535920000397--[[Visit Fail Penalty]])
	)
end

function ChoGGi_Funcs.Menus.RenegadeCreation_Toggle()
	ChoGGi_Funcs.Common.SetConsts("RenegadeCreation", ChoGGi_Funcs.Common.ValueRetOpp(Consts.RenegadeCreation, max_int, ChoGGi.Consts.RenegadeCreation))
	ChoGGi_Funcs.Common.SetSavedConstSetting("RenegadeCreation")

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		Translate(302535920000773--[[%s: I just love findin' subversives.]]):format(ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.RenegadeCreation)),
		T(302535920000399--[[Renegade Creation Toggle]])
	)
end

function ChoGGi_Funcs.Menus.SetRenegadeStatus()
	local item_list = {
		{text = T(302535920000774--[[Make All Renegades]]), value = "Make"},
		{text = T(302535920000775--[[Remove All Renegades]]), value = "Remove"},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		local dome
		local obj = SelectedObj
		if IsKindOf(obj, "Colonist") and obj.dome and choice[1].check1 then
			dome = obj.dome
		end
		local func
		if value == "Make" then
			func = "AddTrait"
		elseif value == "Remove" then
			func = "RemoveTrait"
		end

		local objs = UIColony.city_labels.labels.Colonist or ""
		for i = 1, #objs do
			local o = objs[i]
			if dome then
				if o.dome and o.dome.handle == dome.handle then
					o[func](o, "Renegade")
				end
			else
				o[func](o, "Renegade")
			end
		end

		MsgPopup(
			T(302535920000776--[["OK, a limousine that can fly. Now I have seen everything.
Really? Have you seen a man eat his own head?
No.
So then, you haven't seen everything."]]),
			T(302535920000401--[[Set Renegade Status]])
		)
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000777--[[Make Renegades]]),
		skip_sort = true,
		checkboxes = {
			{
				title = T(302535920000750--[[Dome Only]]),
				hint = T(302535920000751--[[Will only apply to colonists in the same dome as selected colonist.]]),
			},
		},
	}
end

function ChoGGi_Funcs.Menus.ColonistsMoraleAlwaysMax_Toggle()
	ChoGGi_Funcs.Common.SetConsts("HighStatLevel", ChoGGi_Funcs.Common.NumRetBool(Consts.HighStatLevel, 0, ChoGGi.Consts.HighStatLevel))
	ChoGGi_Funcs.Common.SetConsts("LowStatLevel", ChoGGi_Funcs.Common.NumRetBool(Consts.LowStatLevel, 0, ChoGGi.Consts.LowStatLevel))
	ChoGGi_Funcs.Common.SetConsts("HighStatMoraleEffect", ChoGGi_Funcs.Common.ValueRetOpp(Consts.HighStatMoraleEffect, max_int, ChoGGi.Consts.HighStatMoraleEffect))
	ChoGGi_Funcs.Common.SetSavedConstSetting("HighStatMoraleEffect")
	ChoGGi_Funcs.Common.SetSavedConstSetting("HighStatLevel")
	ChoGGi_Funcs.Common.SetSavedConstSetting("LowStatLevel")

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		Translate(302535920000778--[[%s: Happy as a pig in shit.]]):format(ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.HighStatMoraleEffect)),
		T(302535920000402--[[Morale Always Max]])
	)
end

function ChoGGi_Funcs.Menus.ChanceOfSanityDamage_Toggle()
	ChoGGi_Funcs.Common.SetConsts("DustStormSanityDamage", ChoGGi_Funcs.Common.NumRetBool(Consts.DustStormSanityDamage, 0, ChoGGi.Consts.DustStormSanityDamage))
	ChoGGi_Funcs.Common.SetConsts("MysteryDreamSanityDamage", ChoGGi_Funcs.Common.NumRetBool(Consts.MysteryDreamSanityDamage, 0, ChoGGi.Consts.MysteryDreamSanityDamage))
	ChoGGi_Funcs.Common.SetConsts("ColdWaveSanityDamage", ChoGGi_Funcs.Common.NumRetBool(Consts.ColdWaveSanityDamage, 0, ChoGGi.Consts.ColdWaveSanityDamage))
	ChoGGi_Funcs.Common.SetConsts("MeteorSanityDamage", ChoGGi_Funcs.Common.NumRetBool(Consts.MeteorSanityDamage, 0, ChoGGi.Consts.MeteorSanityDamage))
	ChoGGi_Funcs.Common.SetSavedConstSetting("DustStormSanityDamage")
	ChoGGi_Funcs.Common.SetSavedConstSetting("MysteryDreamSanityDamage")
	ChoGGi_Funcs.Common.SetSavedConstSetting("ColdWaveSanityDamage")
	ChoGGi_Funcs.Common.SetSavedConstSetting("MeteorSanityDamage")

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		Translate(302535920000778--[[%s: Happy as a pig in shit.]]):format(ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.DustStormSanityDamage)),
		T(302535920000408--[[Chance Of Sanity Damage]])
	)
end

function ChoGGi_Funcs.Menus.SeeDeadSanityDamage_Toggle()
	ChoGGi_Funcs.Common.SetConsts("SeeDeadSanity", ChoGGi_Funcs.Common.NumRetBool(Consts.SeeDeadSanity, 0, ChoGGi.Consts.SeeDeadSanity))
	ChoGGi_Funcs.Common.SetSavedConstSetting("SeeDeadSanity")

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		Translate(302535920000779--[[%s: I love me some corpses.]]):format(ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.SeeDeadSanity)),
		T(4561--[[Seeing Death]])
	)
end

function ChoGGi_Funcs.Menus.NoHomeComfortDamage_Toggle()
	ChoGGi_Funcs.Common.SetConsts("NoHomeComfort", ChoGGi_Funcs.Common.NumRetBool(Consts.NoHomeComfort, 0, ChoGGi.Consts.NoHomeComfort))
	ChoGGi_Funcs.Common.SetSavedConstSetting("NoHomeComfort")

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		T(302535920000780--[["%s:
Oh, give me a home where the Buffalo roam.
Where the Deer and the Antelope play;
Where seldom is heard a discouraging word."]]):format(ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.NoHomeComfort)),
		T(4559, "Homeless Comfort Penalty")
	)
end

function ChoGGi_Funcs.Menus.ChanceOfNegativeTrait_Toggle()
	ChoGGi_Funcs.Common.SetConsts("LowSanityNegativeTraitChance", ChoGGi_Funcs.Common.NumRetBool(Consts.LowSanityNegativeTraitChance, 0, ChoGGi_Funcs.Common.GetResearchedTechValue("LowSanityNegativeTraitChance")))
	ChoGGi_Funcs.Common.SetSavedConstSetting("LowSanityNegativeTraitChance")

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		Translate(302535920000781--[[%s: Stupid and happy]]):format(ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.LowSanityNegativeTraitChance)),
		T(302535920000412--[[Chance Of Negative Trait]])
	)
end

function ChoGGi_Funcs.Menus.ColonistsChanceOfSuicide_Toggle()
	ChoGGi_Funcs.Common.SetConsts("LowSanitySuicideChance", ChoGGi_Funcs.Common.ToggleBoolNum(Consts.LowSanitySuicideChance))
	ChoGGi_Funcs.Common.SetSavedConstSetting("LowSanitySuicideChance")

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		Translate(302535920000782--[[%s: Getting away ain't that easy]]):format(ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.LowSanitySuicideChance)),
		T(4576--[[Chance Of Suicide]])
	)
end

function ChoGGi_Funcs.Menus.ColonistsSuffocate_Toggle()
	ChoGGi_Funcs.Common.SetConsts("OxygenMaxOutsideTime", ChoGGi_Funcs.Common.ValueRetOpp(Consts.OxygenMaxOutsideTime, max_int, ChoGGi.Consts.OxygenMaxOutsideTime))
	ChoGGi_Funcs.Common.SetSavedConstSetting("OxygenMaxOutsideTime")

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		Translate(302535920000783--[[%s: Free Air]]):format(ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.OxygenMaxOutsideTime)),
		T(4565--[[Oxygen max outside time]])
	)
end

function ChoGGi_Funcs.Menus.ColonistsStarve_Toggle()
	ChoGGi_Funcs.Common.SetConsts("TimeBeforeStarving", ChoGGi_Funcs.Common.ValueRetOpp(Consts.TimeBeforeStarving, max_int, ChoGGi.Consts.TimeBeforeStarving))
	ChoGGi_Funcs.Common.SetSavedConstSetting("TimeBeforeStarving")

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		T(302535920000784--[[%s: A stale piece of bread is better than nothing.
And nothing is better than a big juicey steak.
Therefore a stale piece of bread is better than a big juicy steak.]]):format(ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.TimeBeforeStarving)),
		T(302535920000418--[[Colonists Starve]])
	)
end

function ChoGGi_Funcs.Menus.AvoidWorkplace_Toggle()
	ChoGGi_Funcs.Common.SetConsts("AvoidWorkplaceSols", ChoGGi_Funcs.Common.NumRetBool(Consts.AvoidWorkplaceSols, 0, ChoGGi.Consts.AvoidWorkplaceSols))
	ChoGGi_Funcs.Common.SetSavedConstSetting("AvoidWorkplaceSols")

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		Translate(302535920000785--[[%s: No Shame]]):format(ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.AvoidWorkplaceSols)),
		T(4689--[[Avoid Workplace Sols]])
	)
end

function ChoGGi_Funcs.Menus.PositivePlayground_Toggle()
	ChoGGi_Funcs.Common.SetConsts("positive_playground_chance", ChoGGi_Funcs.Common.ValueRetOpp(Consts.positive_playground_chance, 101, ChoGGi.Consts.positive_playground_chance))
	ChoGGi_Funcs.Common.SetSavedConstSetting("positive_playground_chance")

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		Translate(302535920000786--[[%s: We've all seen them, on the playground, at the store, walking on the streets.]]):format(ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.positive_playground_chance)),
		T(302535920000420--[[Positive Playground]])
	)
end

function ChoGGi_Funcs.Menus.ProjectMorpheusPositiveTrait_Toggle()
	ChoGGi_Funcs.Common.SetConsts("ProjectMorphiousPositiveTraitChance", ChoGGi_Funcs.Common.ValueRetOpp(Consts.ProjectMorphiousPositiveTraitChance, 100, ChoGGi.Consts.ProjectMorphiousPositiveTraitChance))
	ChoGGi_Funcs.Common.SetSavedConstSetting("ProjectMorphiousPositiveTraitChance")

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		Translate(302535920000787--[["%s: Say, ""Small umbrella, small umbrella."""]]):format(ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.ProjectMorphiousPositiveTraitChance)),
		T(580388115170--[[ProjectMorpheusPositiveTraitChance]])
	)
end

function ChoGGi_Funcs.Menus.PerformancePenaltyNonSpecialist_Toggle()
	ChoGGi_Funcs.Common.SetConsts("NonSpecialistPerformancePenalty", ChoGGi_Funcs.Common.NumRetBool(Consts.NonSpecialistPerformancePenalty, 0, ChoGGi_Funcs.Common.GetResearchedTechValue("NonSpecialistPerformancePenalty")))
	ChoGGi_Funcs.Common.SetSavedConstSetting("NonSpecialistPerformancePenalty")

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.NonSpecialistPerformancePenalty),
		T(302535920000912--[[Penalty]])
	)
end

function ChoGGi_Funcs.Menus.SetOutsideWorkplaceRadius()
	local default_setting = ChoGGi.Consts.DefaultOutsideWorkplacesRadius
	local warn_str = T(302535920000883--[[If you make this too large then you may get dehydration with open domes.]])

	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 15, value = 15, hint = warn_str},
		{text = 20, value = 20, hint = warn_str},
		{text = 25, value = 25, hint = warn_str},
		{text = 50, value = 50, hint = warn_str},
		{text = 75, value = 75, hint = warn_str},
		{text = 100, value = 100, hint = warn_str},
		{text = 250, value = 250, hint = warn_str},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.DefaultOutsideWorkplacesRadius then
		hint = ChoGGi.UserSettings.DefaultOutsideWorkplacesRadius
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			ChoGGi_Funcs.Common.SetConsts("DefaultOutsideWorkplacesRadius", value)
			ChoGGi_Funcs.Common.SetSavedConstSetting("DefaultOutsideWorkplacesRadius")

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				T(302535920000789--[[%s: There's a voice that keeps on calling me
Down the road is where I'll always be
Maybe tomorrow, I'll find what I call home
Until tomorrow, you know I'm free to roam]]):format(choice[1].text),
				T(4691--[[Default outside Workplaces radius]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000790--[[Set Outside Workplace Radius]]),
		hint = T(302535920000791--[[Current distance]]) .. ": " .. hint .. "\n\n"
			.. T(302535920000792--[[You may not want to make it too far away unless you turned off suffocation.]]),
		skip_sort = true,
	}
end

do -- SetDeathAge
	-- function Colonist:GameInit()
	-- self:SetBase("death_age", self.MinAge_Senior + 5 + self:Random(10) + self:Random(5) + self:Random(5))
	local function RetDeathAge(c)
		c = c or Colonist
		return c.MinAge_Senior + 5 + Random(10) + Random(5) + Random(5)
	end
	local movie_lookup = {
		LoganNovel = 21,
		LoganMovie = 30,
		TNG = 60,
		TheHappyPlace = 60,
		InTime = 26,
	}

	function ChoGGi_Funcs.Menus.SetDeathAge()
		local default_str = T(1000121--[[Default]])
		local hint_str = T(9559--[[Well, we needed to know that for sure I guess.]])
		local item_list = {
			{text = default_str, value = default_str, hint = T(302535920000794--[[Uses same code as game to pick death ages.]])},
			{text = 60, value = 60},
			{text = 75, value = 75},
			{text = 100, value = 100},
			{text = 250, value = 250},
			{text = 500, value = 500},
			{text = 1000, value = 1000},
			{text = 10000, value = 10000},
			{text = T(302535920000795--[[Logan's Run (Novel)]]), value = "LoganNovel", hint = hint_str},
			{text = T(302535920000796--[[Logan's Run (Movie)]]), value = "LoganMovie", hint = hint_str},
			{text = T(302535920000797--[[TNG: Half a Life]]), value = "TNG", hint = hint_str},
			{text = T(302535920000798--[[The Happy Place]]), value = "TheHappyPlace", hint = hint_str},
			{text = T(302535920000799--[[In Time]]), value = "InTime", hint = hint_str},
		}

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			choice = choice[1]

			local value = choice.value

			local amount = movie_lookup[value]
			if not amount and type(value) == "number" then
				amount = value
			end

			if value == default_str or type(amount) == "number" then
				if value == default_str then
					-- random age
					local objs = UIColony.city_labels.labels.Colonist or ""
					for i = 1, #objs do
						local o = objs[i]
						o.death_age = RetDeathAge(o)
					end
					ChoGGi.UserSettings.DeathAgeColonist = nil
				else
					-- set age
					local objs = UIColony:GetCityLabels("Colonist")
					for i = 1, #objs do
						objs[i].death_age = amount
					end
					ChoGGi.UserSettings.DeathAgeColonist = amount
				end

				ChoGGi_Funcs.Settings.WriteSettings()

				MsgPopup(
					ChoGGi_Funcs.Common.SettingState(choice.text, T(302535920000446--[[Colonist Death Age]])),
					T(302535920000446--[[Colonist Death Age]])
				)
			end
		end

		ChoGGi_Funcs.Common.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = T(302535920000801--[[Set Death Age]]),
			hint = Translate(302535920000802--[[Usual age is around %s. This doesn't stop colonists from becoming seniors; just death (research ForeverYoung for enternal labour).]]):format(RetDeathAge()),
			skip_sort = true,
		}
	end
end -- do

function ChoGGi_Funcs.Menus.ColonistsAddSpecializationToAll()
	local ColonistUpdateSpecialization = ChoGGi_Funcs.Common.ColonistUpdateSpecialization
	local str = Translate(3490--[[Random]])
	local objs = UIColony.city_labels.labels.Colonist or ""
	for i = 1, #objs do
		local o = objs[i]
		if o.specialist == "none" then
			ColonistUpdateSpecialization(o, str)
		end
	end

	MsgPopup(
		T(302535920000804--[[No lazy good fer nuthins round here]]),
		T(302535920000393--[[Add Specialization To All]])
	)
end

function ChoGGi_Funcs.Menus.SetColonistsAge(action)
	local setting_mask = action.setting_mask

	local default_str = T(1000121--[[Default]])
	local default_setting = default_str
	local TraitPresets = TraitPresets

	local setting_type, setting_name
	if setting_mask == 1 then
		setting_type = T(302535920001356--[[New]]) .. " "
		setting_name = "NewColonistAge"
	else
		setting_type = ""
		default_setting = Translate(3490--[[Random]])
	end

	local item_list = {
		{
			text = " " .. default_setting,
			value = default_setting,
			hint = T(302535920000808--[[How the game normally works]]),
		},
	}
	local c = #item_list

	for i = 1, #ChoGGi.Tables.ColonistAges do
		local age = ChoGGi.Tables.ColonistAges[i]
		local hint
		if age == "Child" then
			hint = T(TraitPresets[age].description) .. "\n\n" .. T(6779--[[Warning]]) .. ": " .. T(302535920000805--[[Child will remove specialization.]])
		else
			hint = T(TraitPresets[age].description)
		end
		c = c + 1
		item_list[c] = {
			text = T(TraitPresets[age].display_name),
			value = age,
			hint = hint,
			icon = ChoGGi.Tables.ColonistAgeImages[age],
			icon_scale = 500,
		}
	end

	local hint = ""
	if setting_mask == 1 then
		hint = default_setting
		if ChoGGi.UserSettings[setting_name] then
			hint = ChoGGi.UserSettings[setting_name]
		end
		hint = T(302535920000106--[[Current]]) .. ": " .. hint .. "\n\n" .. T(302535920000805--[[Warning: Child will remove specialization.]])
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		local obj = SelectedObj
		local dome
		if IsKindOf(obj, "Colonist") and obj.dome and choice.check1 then
			dome = obj.dome
		end

		-- new
		if setting_mask == 1 then
			if value == default_str then
				ChoGGi.UserSettings.NewColonistAge = nil
			else
				ChoGGi_Funcs.Common.SetSavedConstSetting("NewColonistAge", value)
			end
			ChoGGi_Funcs.Settings.WriteSettings()

		-- existing
		elseif setting_mask == 2 then
			if choice.check2 then
				if obj then
					ChoGGi_Funcs.Common.ColonistUpdateAge(obj, value)
				end
			else
				local objs = UIColony.city_labels.labels.Colonist or ""
				for i = 1, #objs do
					if dome then
						local o = objs[i]
						if o.dome and o.dome.handle == dome.handle then
							ChoGGi_Funcs.Common.ColonistUpdateAge(o, value)
						end
					else
						ChoGGi_Funcs.Common.ColonistUpdateAge(objs[i], value)
					end
				end
			end

		end

		MsgPopup(
			ChoGGi_Funcs.Common.SettingState(Translate(choice.text), setting_type),
			T(302535920000807--[[Colonist Age]])
		)
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000129--[[Set]]) .. " " .. setting_type .. T(302535920000807--[[Colonist Age]]),
		hint = hint,
		checkboxes = {
			{
				title = T(302535920000750--[[Dome Only]]),
				hint = T(302535920000751--[[Will only apply to colonists in the same dome as selected colonist.]]),
			},
			{
				title = T(302535920000752--[[Selected Only]]),
				hint = T(302535920000753--[[Will only apply to selected colonist.]]),
			},
		},
	}
end

function ChoGGi_Funcs.Menus.SetColonistsGender(action)
	local setting_mask = action.setting_mask
	local TraitPresets = TraitPresets

	local default_setting, setting_type, setting_name
	if setting_mask == 1 then
		setting_type = T(302535920001356--[[New]]) .. " "
		setting_name = "NewColonistGender"
		default_setting = T(1000121--[[Default]])
	else
		setting_type = ""
		default_setting = Translate(3490--[[Random]])
	end

	local item_list = {
		{
			text = " " .. default_setting,
			value = default_setting,
			hint = T(302535920000808--[[How the game normally works]]),
		},
		{
			text = " " .. T(302535920000800--[[MaleOrFemale]]),
			value = T(302535920000800--[[MaleOrFemale]]),
			hint = T(302535920000809--[[Only set as male or female]]),
		},
	}
	local c = #item_list

	for i = 1, #ChoGGi.Tables.ColonistGenders do
		local gender = ChoGGi.Tables.ColonistGenders[i]
		c = c + 1
		item_list[c] = {
			text = T(TraitPresets[gender].display_name),
			hint = T(TraitPresets[gender].description),
			icon = ChoGGi.Tables.ColonistGenderImages[gender],
			icon_scale = 500,
			value = gender,
		}
	end

	local hint
	if setting_mask == 1 then
		hint = default_setting
		if ChoGGi.UserSettings[setting_name] then
			hint = ChoGGi.UserSettings[setting_name]
		end
		hint = T(302535920000106--[[Current]]) .. ": " .. hint
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		local obj = SelectedObj
		local dome
		if IsKindOf(obj, "Colonist") and obj.dome and choice.check1 then
			dome = obj.dome
		end

		-- new
		if setting_mask == 1 then
			if value == T(1000121--[[Default]]) then
				ChoGGi.UserSettings.NewColonistGender = nil
			else
				ChoGGi_Funcs.Common.SetSavedConstSetting("NewColonistGender", value)
			end
			ChoGGi_Funcs.Settings.WriteSettings()

		-- existing
		elseif setting_mask == 2 then
			local ColonistUpdateGender = ChoGGi_Funcs.Common.ColonistUpdateGender
			if choice.check2 then
				if obj then
					ColonistUpdateGender(obj, value)
				end
			else
				local objs = UIColony.city_labels.labels.Colonist or ""
				for i = 1, #objs do
					local o = objs[i]
					if dome then
						if o.dome and o.dome.handle == dome.handle then
							ColonistUpdateGender(o, value)
						end
					else
						ColonistUpdateGender(o, value)
					end
				end
			end
		end

		MsgPopup(
			ChoGGi_Funcs.Common.SettingState(Translate(choice.text), setting_type),
			T(302535920000810--[[Colonist Gender]])
		)
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000129--[[Set]]) .. " " .. setting_type .. T(302535920000810--[[Colonist Gender]]),
		hint = hint,
		checkboxes = {
			{
				title = T(302535920000750--[[Dome Only]]),
				hint = T(302535920000751--[[Will only apply to colonists in the same dome as selected colonist.]]),
			},
			{
				title = T(302535920000752--[[Selected Only]]),
				hint = T(302535920000753--[[Will only apply to selected colonist.]]),
			},
		},
	}
end

function ChoGGi_Funcs.Menus.SetColonistsSpecialization(action)
	local setting_mask = action.setting_mask
	local TraitPresets = TraitPresets

	local default_setting, setting_type, setting_name
	if setting_mask == 1 then
		setting_type = T(302535920001356--[[New]]) .. " "
		setting_name = "NewColonistSpecialization"
		default_setting = T(1000121--[[Default]])
	else
		setting_type = ""
		default_setting = Translate(3490--[[Random]])
	end

	local item_list = {
		{
			text = " " .. default_setting,
			value = default_setting,
			hint = T(302535920000808--[[How the game normally works]]),
		},
		{
			text = "none",
			value = "none",
			hint = T(302535920000812--[[Removes specializations]]),
			icon = ChoGGi.Tables.ColonistSpecImages.none,
			icon_scale = 500,
		},
	}
	local c = #item_list

	if setting_mask == 1 then
		c = c + 1
		item_list[c] = {
			text = " " .. T(3490--[[Random]]),
			value = Translate(3490--[[Random]]),
			hint = T(302535920000811--[[Everyone gets a spec]]),
		}
	end

	for i = 1, #ChoGGi.Tables.ColonistSpecializations do
		local spec = ChoGGi.Tables.ColonistSpecializations[i]
		c = c + 1
		item_list[c] = {
			text = T(TraitPresets[spec].display_name),
			value = spec,
			hint = T(TraitPresets[spec].description),
			icon = ChoGGi.Tables.ColonistSpecImages[spec],
			icon_scale = 500,
		}
	end

	local hint
	if setting_mask == 1 then
		hint = default_setting
		if ChoGGi.UserSettings[setting_name] then
			hint = ChoGGi.UserSettings[setting_name]
		end
		hint = T(302535920000106--[[Current]]) .. ": " .. hint
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		local obj = SelectedObj
		local dome
		if IsKindOf(obj, "Colonist") and obj.dome and choice.check1 then
			dome = obj.dome
		end

		-- new
		if setting_mask == 1 then
			if value == T(1000121--[[Default]]) then
				ChoGGi.UserSettings.NewColonistSpecialization = nil
			else
				ChoGGi_Funcs.Common.SetSavedConstSetting("NewColonistSpecialization", value)
			end
			ChoGGi_Funcs.Settings.WriteSettings()

		-- existing
		elseif setting_mask == 2 then
			if choice.check2 then
				if obj then
					ChoGGi_Funcs.Common.ColonistUpdateSpecialization(obj, value)
				end
			else
				local objs = UIColony.city_labels.labels.Colonist or ""
				for i = 1, #objs do
					if dome then
						local o = objs[i]
						if o.dome and o.dome.handle == dome.handle then
							ChoGGi_Funcs.Common.ColonistUpdateSpecialization(o, value)
						end
					else
						ChoGGi_Funcs.Common.ColonistUpdateSpecialization(objs[i], value)
					end
				end
			end

		end
		MsgPopup(
			ChoGGi_Funcs.Common.SettingState(choice.text),
			T(302535920000813--[[Colonist Specialization]])
		)
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000129--[[Set]]) .. " " .. setting_type .. T(302535920000813--[[Colonist Specialization]]),
		hint = hint,
		height = 750,
		checkboxes = {
			{
				title = T(302535920000750--[[Dome Only]]),
				hint = T(302535920000751--[[Will only apply to colonists in the same dome as selected colonist.]]),
			},
			{
				title = T(302535920000752--[[Selected Only]]),
				hint = T(302535920000753--[[Will only apply to selected colonist.]]),
			},
		},
	}
end

function ChoGGi_Funcs.Menus.SetColonistsRace(action)
	local setting_mask = action.setting_mask

	local default_setting, setting_type, setting_name
	if setting_mask == 1 then
		setting_type = T(302535920001356--[[New]]) .. " "
		setting_name = "NewColonistRace"
		default_setting = T(1000121--[[Default]])
	else
		setting_type = ""
		default_setting = Translate(3490--[[Random]])
	end

	local item_list = {
		{
			text = " " .. default_setting,
			value = default_setting,
			race = default_setting,
			hint = T(3490--[[Random]]),
			icon = ChoGGi.Tables.ColonistRacesImages[default_setting],
			icon_scale = 500,
		},
	}
	local c = #item_list

	local race = {T(302535920000814--[[Herrenvolk]]), T(302535920000815--[[Schwarzvolk]]), T(302535920000816--[[Asiatischvolk]]), T(302535920000817--[[Indischvolk]]), T(302535920000818--[[Südost Asiatischvolk]])}
	for i = 1, #ChoGGi.Tables.ColonistRaces do
		local name = ChoGGi.Tables.ColonistRaces[i]
		c = c + 1
		item_list[c] = {
			text = name,
			value = i,
			race = race[i],
			icon = ChoGGi.Tables.ColonistRacesImages[name],
			icon_scale = 500,
		}
	end

	local hint
	if setting_mask == 1 then
		hint = default_setting
		if ChoGGi.UserSettings[setting_name] then
			hint = ChoGGi.UserSettings[setting_name]
		end
		hint = T(302535920000106--[[Current]]) .. ": " .. hint
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		local s_obj = SelectedObj
		local dome
		if IsKindOf(s_obj, "Colonist") and s_obj.dome and choice.check1 then
			dome = s_obj.dome
		end

		-- new
		if setting_mask == 1 then
			if value == T(1000121--[[Default]]) then
				ChoGGi.UserSettings.NewColonistRace = nil
			else
				ChoGGi_Funcs.Common.SetSavedConstSetting("NewColonistRace", value)
			end
			ChoGGi_Funcs.Settings.WriteSettings()

		-- existing
		elseif setting_mask == 2 then
			if choice.check2 then
				if s_obj then
					ChoGGi_Funcs.Common.ColonistUpdateRace(s_obj, value)
				end
			else
				local objs = UIColony.city_labels.labels.Colonist or ""
				for i = 1, #objs do
					if dome then
						local obj = objs[i]
						if obj.dome and obj.dome.handle == dome.handle then
							ChoGGi_Funcs.Common.ColonistUpdateRace(obj, value)
						end
					else
						ChoGGi_Funcs.Common.ColonistUpdateRace(objs[i], value)
					end
				end
			end
		end

--~ 		-- remove if random
--~ 		if value == Translate(3490--[[Random]]) then
--~ 			MilestoneCompleted.DaddysLittleHitler = nil
--~ 			UIColony.ChoGGi.DaddysLittleHitler = nil
--~ 		-- If only changing one colonists then you aren't hitler :)
--~ 		elseif not choice.check2 and not UIColony.ChoGGi.DaddysLittleHitler then
--~ 			Msg("ChoGGi_DaddysLittleHitler")
--~ 			UIColony.ChoGGi.DaddysLittleHitler = true
--~ 		end

		MsgPopup(
			ChoGGi_Funcs.Common.SettingState(choice.race, T(302535920000819--[[Nationalsozialistische Rassenhygiene]])),
			T(302535920000820--[[Colonist Race]])
		)
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000129--[[Set]]) .. " " .. setting_type .. T(302535920000820--[[Colonist Race]]),
		hint = hint,
		checkboxes = {
			{
				title = T(302535920000750--[[Dome Only]]),
				hint = T(302535920000751--[[Will only apply to colonists in the same dome as selected colonist.]]),
			},
			{
				title = T(302535920000752--[[Selected Only]]),
				hint = T(302535920000753--[[Will only apply to selected colonist.]]),
			},
		},
	}
end

function ChoGGi_Funcs.Menus.SetColonistsTraits(action)
	local setting_mask = action.setting_mask
	local TraitPresets = TraitPresets

	local hint, default_setting, setting_type
	if setting_mask == 1 then
		setting_type = T(302535920001356--[[New]]) .. " "
		default_setting = T(1000121--[[Default]])
		hint = default_setting
		local saved = ChoGGi.UserSettings.NewColonistTraits
		if saved then
			hint = ""
			for i = 1, #saved do
				hint = hint .. saved[i] .. ", "
			end
		end
		hint = T(302535920000106--[[Current]]) .. ": " .. hint
	elseif setting_mask == 2 then
		hint = ""
		setting_type = ""
		default_setting = Translate(3490--[[Random]])
	end

	hint = hint .. "\n\n" .. T(302535920000821--[[Defaults to adding traits, check Remove to remove. Use Shift or Ctrl to select multiple traits.]])

	local item_list = {
		{text = " " .. default_setting, value = default_setting, hint = T(302535920000822--[[Use game defaults]])},
		{text = " " .. T(302535920000823--[[All Positive Traits]]), value = "PositiveTraits", hint = T(302535920000824--[[All the positive traits...]])},
		{text = " " .. T(302535920000825--[[All Negative Traits]]), value = "NegativeTraits", hint = T(302535920000826--[[All the negative traits...]])},
		{text = " " .. T(302535920001040--[[All Other Traits]]), value = "OtherTraits", hint = T(302535920001050--[[All the other traits...]])},
		{text = " " .. Translate(652319561018--[[All Traits]]), value = "AllTraits", hint = T(302535920000828--[[All the traits...]])},
	}
	local c = #item_list

	if setting_mask == 2 then
		item_list[1].hint = T(302535920000829--[[Random: Each colonist gets three positive and three negative traits (if it picks same traits then you won't get all six).]])
	end

	local function AddTraits(list)
		for i = 1, #list do
			local id = list[i]
			c = c + 1
			item_list[c] = {
				text = Translate(TraitPresets[id].display_name),
				value = id,
				hint = Translate(TraitPresets[id].description),
			}
		end
	end
	AddTraits(ChoGGi.Tables.NegativeTraits)
	AddTraits(ChoGGi.Tables.PositiveTraits)
	AddTraits(ChoGGi.Tables.OtherTraits)

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end

		local check1 = choice[1].check1
		local check2 = choice[1].check2

		local obj = SelectedObj
		local dome
		if IsKindOf(obj, "Colonist") and obj.dome and check1 then
			dome = obj.dome
		end

		-- create list of traits
		local traits_list_temp = {}
		local c = 0
		local function AddToTable(list)
			for x = 1, #list do
				c = c + 1
				traits_list_temp[c] = list[x]
			end
		end

		for i = 1, #choice do
			if choice[i].value == "NegativeTraits" then
				AddToTable(ChoGGi.Tables.NegativeTraits)
			elseif choice[i].value == "PositiveTraits" then
				AddToTable(ChoGGi.Tables.PositiveTraits)
			elseif choice[i].value == "OtherTraits" then
				AddToTable(ChoGGi.Tables.OtherTraits)
			elseif choice[i].value == "AllTraits" then
				AddToTable(ChoGGi.Tables.OtherTraits)
				AddToTable(ChoGGi.Tables.PositiveTraits)
				AddToTable(ChoGGi.Tables.NegativeTraits)
			else
				if choice[i].value then
					c = c + 1
					traits_list_temp[c] = choice[i].value
				end
			end
		end

		-- remove dupes
		table.sort(traits_list_temp)
		local traits_list = {}
		c = 0
		for i = 1, #traits_list_temp do
			if traits_list_temp[i] ~= traits_list_temp[i-1] then
				c = c + 1
				traits_list[c] = traits_list_temp[i]
			end
		end

		-- new
		if setting_mask == 1 then
			if choice[1].value == default_setting then
				ChoGGi.UserSettings.NewColonistTraits = false
			else
				ChoGGi.UserSettings.NewColonistTraits = traits_list
			end
			ChoGGi_Funcs.Settings.WriteSettings()

		-- existing
		elseif setting_mask == 2 then
			--random 3x3
			if choice[1].value == default_setting then
				local function RandomTraits(o)
					-- remove all traits
					ChoGGi_Funcs.Common.ColonistUpdateTraits(o, false, ChoGGi.Tables.OtherTraits)
					ChoGGi_Funcs.Common.ColonistUpdateTraits(o, false, ChoGGi.Tables.PositiveTraits)
					ChoGGi_Funcs.Common.ColonistUpdateTraits(o, false, ChoGGi.Tables.NegativeTraits)
					-- add random ones
					local count = #ChoGGi.Tables.PositiveTraits
					o:AddTrait(ChoGGi.Tables.PositiveTraits[Random(1, count)], true)
					o:AddTrait(ChoGGi.Tables.PositiveTraits[Random(1, count)], true)
					o:AddTrait(ChoGGi.Tables.PositiveTraits[Random(1, count)], true)
					count = #ChoGGi.Tables.NegativeTraits
					o:AddTrait(ChoGGi.Tables.NegativeTraits[Random(1, count)], true)
					o:AddTrait(ChoGGi.Tables.NegativeTraits[Random(1, count)], true)
					o:AddTrait(ChoGGi.Tables.NegativeTraits[Random(1, count)], true)
					Notify(o, "UpdateMorale")
				end
				if check2 then
					if obj then
						RandomTraits(obj)
					end
				else
					local c = UIColony.city_labels.labels.Colonist or ""
					for i = 1, #c do
						if dome then
							if c[i].dome and c[i].dome.handle == dome.handle then
								RandomTraits(c[i])
							end
						else
							RandomTraits(c[i])
						end
					end
				end

			else
				local t_type = "AddTrait"
				if choice[1].check3 then
					t_type = "RemoveTrait"
				end
				if check2 then
					if obj then
						for i = 1, #traits_list do
							obj[t_type](obj, traits_list[i], true)
						end
					end
				else
					local c = UIColony.city_labels.labels.Colonist or ""
					for i = 1, #c do
						for j = 1, #traits_list do
							if dome then
								if c[i].dome and c[i].dome.handle == dome.handle then
									c[i][t_type](c[i], traits_list[j], true)
								end
							else
								c[i][t_type](c[i], traits_list[j], true)
							end
						end
					end
				end

			end

		end

		MsgPopup(
			ChoGGi_Funcs.Common.SettingState(#traits_list, setting_type),
			T(302535920000830--[[Colonists traits set]])
		)
	end

	if setting_mask == 1 then
		ChoGGi_Funcs.Common.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = T(302535920000129--[[Set]]) .. " " .. setting_type .. T(302535920000831--[[Colonist Traits]]),
			hint = hint,
			multisel = true,
			height = 800.0,
		}
	elseif setting_mask == 2 then
		ChoGGi_Funcs.Common.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = T(302535920000129--[[Set]]) .. " " .. setting_type .. T(302535920000831--[[Colonist Traits]]),
			hint = hint,
			multisel = true,
			height = 800.0,
			checkboxes = {
				only_one = true,
				{
					title = T(302535920000750--[[Dome Only]]),
					hint = T(302535920000751--[[Will only apply to colonists in the same dome as selected colonist.]]),
				},
				{
					title = T(302535920000752--[[Selected Only]]),
					hint = T(302535920000753--[[Will only apply to selected colonist.]]),
				},
				{
					title = T(302535920000281--[[Remove]]),
					hint = T(302535920000832--[[Check to remove traits]]),
				},
			},
		}
	end
end

function ChoGGi_Funcs.Menus.SetColonistsStats()
	local r = const.ResourceScale
	local item_list = {
		{text = T(302535920000833--[[All Stats]]) .. " " .. T(302535920000834--[[Max]]), value = 1},
		{text = T(302535920000833--[[All Stats]]) .. " " .. T(302535920000835--[[Fill]]), value = 2},
		{text = T(4291--[[Health]]) .. " " .. T(302535920000834--[[Max]]), value = 3},
		{text = T(4291--[[Health]]) .. " " .. T(302535920000835--[[Fill]]), value = 4},
		{text = T(4297--[[Morale]]) .. " " .. T(302535920000835--[[Fill]]), value = 5},
		{text = T(4293--[[Sanity]]) .. " " .. T(302535920000834--[[Max]]), value = 6},
		{text = T(4293--[[Sanity]]) .. " " .. T(302535920000835--[[Fill]]), value = 7},
		{text = T(4295--[[Comfort]]) .. " " .. T(302535920000834--[[Max]]), value = 8},
		{text = T(4295--[[Comfort]]) .. " " .. T(302535920000835--[[Fill]]), value = 9},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		local obj = SelectedObj
		local dome
		if IsKindOf(obj, "Colonist") and obj.dome and choice.check1 then
			dome = obj.dome
		end

		local max = 100000 * r
		local fill = 100 * r
		local function SetStat(stat, v)
			if v == 1 or v == 3 or v == 6 or v == 8 then
				v = max
			else
				v = fill
			end
			local objs = UIColony.city_labels.labels.Colonist or ""
			for i = 1, #objs do
				if dome then
					local o = objs[i]
					if o.dome and o.dome.handle == dome.handle then
						o[stat] = v
					end
				else
					objs[i][stat] = v
				end
			end
		end

		if value == 1 or value == 2 then
			if value == 1 then
				value = max
			elseif value == 2 then
				value = fill
			end

			local objs = UIColony.city_labels.labels.Colonist or ""
			for i = 1, #objs do
				local o = objs[i]
				if dome then
					if o.dome and o.dome.handle == dome.handle then
						o.stat_morale = value
						o.stat_sanity = value
						o.stat_comfort = value
						o.stat_health = value
					end
				else
					o.stat_morale = value
					o.stat_sanity = value
					o.stat_comfort = value
					o.stat_health = value
				end
			end

		elseif value == 3 or value == 4 then
			SetStat("stat_health", value)
		elseif value == 5 then
			SetStat("stat_morale", value)
		elseif value == 6 or value == 7 then
			SetStat("stat_sanity", value)
		elseif value == 8 or value == 9 then
			SetStat("stat_comfort", value)
		end

		MsgPopup(
			ChoGGi_Funcs.Common.SettingState(choice.text),
			T(302535920000836--[[Set Stats Of All Colonists]])
		)
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000836--[[Set Stats Of All Colonists]]),
		hint = T(302535920000837--[[Fill: Stat bar filled to 100
Max: 100000 (choose fill to reset)

Warning: Disable births or else...]]),
		checkboxes = {
			{
				title = T(302535920000750--[[Dome Only]]),
				hint = T(302535920000751--[[Will only apply to colonists in the same dome as selected colonist.]]),
			},
		},
	}
end

function ChoGGi_Funcs.Menus.SetColonistMoveSpeed()
	local r = const.ResourceScale
	local default_setting = ChoGGi.Consts.SpeedColonist
	local item_list = {
		{text = T(1000121--[[Default]]) .. ": " .. (default_setting / r), value = default_setting},
		{text = 5, value = 5 * r},
		{text = 10, value = 10 * r},
		{text = 15, value = 15 * r},
		{text = 25, value = 25 * r},
		{text = 50, value = 50 * r},
		{text = 100, value = 100 * r},
		{text = 1000, value = 1000 * r},
		{text = 10000, value = 10000 * r},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.SpeedColonist then
		hint = ChoGGi.UserSettings.SpeedColonist
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		local obj = SelectedObj
		local dome
		if IsKindOf(obj, "Colonist") and obj.dome and choice.check1 then
			dome = obj.dome
		end

		if type(value) == "number" then
			if choice.check2 then
				if obj then
					obj:SetBase("move_speed", value)
				end
			else
				local objs = UIColony.city_labels.labels.Colonist or ""
				for i = 1, #objs do
					if dome then
						local o = objs[i]
						if o.dome and o.dome.handle == dome.handle then
							o:SetBase("move_speed", value)
						end
					else
						objs[i]:SetBase("move_speed", value)
					end
				end
			end

			ChoGGi_Funcs.Common.SetSavedConstSetting("SpeedColonist", value)
			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				ChoGGi_Funcs.Common.SettingState(choice.text),
				T(302535920000838--[[Colonist Move Speed]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000838--[[Colonist Move Speed]]),
		hint = hint,
		skip_sort = true,
		checkboxes = {
			{
				title = T(302535920000750--[[Dome Only]]),
				hint = T(302535920000751--[[Will only apply to colonists in the same dome as selected colonist.]]),
			},
			{
				title = T(302535920000752--[[Selected Only]]),
				hint = T(302535920000753--[[Will only apply to selected colonist.]]),
			},
		},
	}
end

function ChoGGi_Funcs.Menus.SetBuildingTraits(action)
	local toggle_type = action.toggle_type

	local TraitPresets = TraitPresets

	local obj = ChoGGi_Funcs.Common.SelObject()
	if not obj or obj and not obj:IsKindOfClasses{"Workplace", "TrainingBuilding"} then
		MsgPopup(
			T(302535920000842--[[Select a workplace or training building.]]),
			T(302535920000992--[[Building Traits]])
		)
		return
	end

	local id = RetTemplateOrClass(obj)
	local name = Translate(obj.display_name)
	local BuildingSettings = ChoGGi.UserSettings.BuildingSettings
	if not BuildingSettings[id] or BuildingSettings[id] and not next(BuildingSettings[id]) then
		BuildingSettings[id] = {
			restricttraits = {},
			blocktraits = {},
		}
	end

	local item_list = {}
	local c = 0
	local str_hint = T(302535920000106--[[Current]]) .. ": "
	for i = 1, #ChoGGi.Tables.NegativeTraits do
		local trait = ChoGGi.Tables.NegativeTraits[i]
		local status = type(BuildingSettings[id][toggle_type][trait]) == "boolean" and "true" or "false"
		c = c + 1
		item_list[c] = {
			text = trait,
			value = trait,
			hint = str_hint .. status .. "\n" .. Translate(TraitPresets[trait].description),
		}
	end
	for i = 1, #ChoGGi.Tables.PositiveTraits do
		local trait = ChoGGi.Tables.PositiveTraits[i]
		local status = type(BuildingSettings[id][toggle_type][trait]) == "boolean" and "true" or "false"
		c = c + 1
		item_list[c] = {
			text = trait,
			value = trait,
			hint = str_hint .. status .. "\n" .. Translate(TraitPresets[trait].description),
		}
	end
	for i = 1, #ChoGGi.Tables.OtherTraits do
		local trait = ChoGGi.Tables.OtherTraits[i]
		local status = type(BuildingSettings[id][toggle_type][trait]) == "boolean" and "true" or "false"
		c = c + 1
		item_list[c] = {
			text = trait,
			value = trait,
			hint = str_hint .. status .. "\n" .. Translate(TraitPresets[trait].description),
		}
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local check1 = choice[1].check1
		for i = 1, #choice do
			local value = choice[i].value

			if BuildingSettings[id][toggle_type][value] then
				BuildingSettings[id][toggle_type][value] = nil
			else
				BuildingSettings[id][toggle_type][value] = true
			end
		end

		if check1 then
			MapForEach("map", obj.class, function(workplace)
				-- all three shifts
				for j = 1, #workplace.workers do
					-- workers in shifts (go through table backwards for when someone gets fired)
					for k = #workplace.workers[j], 1, -1 do
						local worker = workplace.workers[j][k]
						local block, restrict = ChoGGi_Funcs.Common.RetBuildingPermissions(worker.traits, BuildingSettings[id])
						if block or not restrict then
							table.remove_entry(workplace.workers[j], worker)
							workplace:SetWorkplaceWorking()
							workplace:StopWorkCycle(worker)
							if worker:IsInWorkCommand() then
								worker:InterruptCommand()
							end
							workplace:UpdateAttachedSigns()
						end
					end
				end
			end)
		end

		-- remove empty tables
		if not next(BuildingSettings[id].restricttraits) and not next(BuildingSettings[id].blocktraits) then
			BuildingSettings[id].restricttraits = nil
			BuildingSettings[id].blocktraits = nil
		end

		ChoGGi_Funcs.Settings.WriteSettings()

		MsgPopup(
			T(302535920000843--[[Toggled traits]]) .. ": " .. #choice
				.. (check1 and " " .. T(302535920000844--[[Fired workers]]) or ""),
			T(4801--[[Workplace]])
		)
	end

	local hint
	if BuildingSettings[id] and BuildingSettings[id][toggle_type] then
		hint = {
			T(302535920000106--[[Current]]), ": ", BuildingSettings[id][toggle_type], ", ",
		}
	end
	hint = hint or {}

	hint[#hint+1] = "\n\n"
	hint[#hint+1] = T(302535920000847--[[Select traits and click Ok to toggle status.]])
	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000129--[[Set]]) .. " " .. T(302535920000992--[[Building Traits]]) .. " " .. T(302535920000846--[[For]]) .. " " .. name,
		hint = table.concat(hint),
		multisel = true,
		checkboxes = {
			{
				title = T(302535920000848--[[Fire Workers]]),
				hint = Translate(302535920000849--[[Will also fire workers with the traits from all %s.]]):format(name),
			},
		},
	}
end
