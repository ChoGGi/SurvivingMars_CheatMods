-- See LICENSE for terms

function OnMsg.ClassesGenerate()

	local MsgPopup = ChoGGi.ComFuncs.MsgPopup
	local Random = ChoGGi.ComFuncs.Random
	local Trans = ChoGGi.ComFuncs.Translate
	local S = ChoGGi.Strings
	local default_icon = "UI/Icons/Notifications/colonist.tga"

	local type,table = type,table
	local StringFormat = string.format

	function ChoGGi.MenuFuncs.NoMoreEarthsick_Toggle()
		local ChoGGi = ChoGGi
		if ChoGGi.UserSettings.NoMoreEarthsick then
			ChoGGi.UserSettings.NoMoreEarthsick = nil
		else
			ChoGGi.UserSettings.NoMoreEarthsick = true
			local c = UICity.labels.Colonist or ""
			for i = 1, #c do
				if c[i].status_effects.StatusEffect_Earthsick then
					c[i]:Affect("StatusEffect_Earthsick", false)
				end
			end
		end

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000736--[[%s: Whoops somebody broke the rocket, guess you're stuck on mars.--]]]:format(ChoGGi.UserSettings.NoMoreEarthsick),
			547--[[Colonists--]],
			default_icon
		)
	end

	function ChoGGi.MenuFuncs.UniversityGradRemoveIdiotTrait_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.UserSettings.UniversityGradRemoveIdiotTrait = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.UniversityGradRemoveIdiotTrait)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000737--[[%s: Water? Like out of the toilet?--]]]:format(ChoGGi.UserSettings.UniversityGradRemoveIdiotTrait),
			6652--[[Idiot--]],
			default_icon
		)
	end

	DeathReasons.ChoGGi_Soylent = S[302535920000738--[[Evil Overlord--]]]
	NaturalDeathReasons.ChoGGi_Soylent = true
	function ChoGGi.MenuFuncs.TheSoylentOption()
		local UICity = UICity
		local ChoGGi = ChoGGi

		--don't drop BlackCube/MysteryResource
		local reslist = {}
		local all = AllResourcesList
		for i = 1, #all do
			if all[i] ~= "BlackCube" and all[i] ~= "MysteryResource" then
				reslist[#reslist+1] = all[i]
			end
		end

		local function MeatbagsToSoylent(MeatBag,res)
			if MeatBag.dying then
				return
			end

			if res then
				res = reslist[Random(1,#reslist)]
			else
				res = "Food"
			end
			PlaceResourcePile(MeatBag:GetVisualPos(), res, Random(1,5) * ChoGGi.Consts.ResourceScale)
			MeatBag:SetCommand("Die","ChoGGi_Soylent")
--~ 			MeatBag.ChoGGi_Soylent = true
			-- gotta wait for a tad else log gets spammed with changepath and other stuff
			CreateRealTimeThread(function()
				Sleep(100)
				MeatBag:Done()
				DoneObject(MeatBag)
--~ 				local Table = UICity.labels.Colonist or ""
--~ 				for i = 1, #Table do
--~ 					if Table[i].ChoGGi_Soylent then
--~ 						Table[i]:Done()
--~ 						DoneObject(Table[i])
--~ 					end
--~ 				end
			end)
		end

		--one meatbag at a time
		local sel = ChoGGi.ComFuncs.SelObject()
		if IsKindOf(sel,"Colonist") then
			MeatbagsToSoylent(sel)
			return
		end

		--culling the herd
		local ItemList = {
			{text = StringFormat(" %s",S[7553--[[Homeless--]]]),value = "Homeless"},
			{text = StringFormat(" %s",S[6859--[[Unemployed--]]]),value = "Unemployed"},
			{text = StringFormat(" %s",S[7031--[[Renegades--]]]),value = "Renegade"},
			{text = StringFormat(" %s: %s",S[240--[[Specialization--]]],S[6761--[[None--]]]),value = "none"},
		}
		local function AddToList(c,text)
			for i = 1, #c do
				ItemList[#ItemList+1] = {
					text = StringFormat("%s: %s",S[text],c[i]),
					value = c[i],
					idx = i,
				}
			end
		end
		AddToList(ChoGGi.Tables.ColonistAges,987289847467--[[Age Groups--]])
		AddToList(ChoGGi.Tables.ColonistGenders,4356--[[Sex--]])
		AddToList(ChoGGi.Tables.ColonistRaces,302535920000741--[[Race--]])
		AddToList(ChoGGi.Tables.ColonistSpecializations,240--[[Specialization--]])
		local birth = ChoGGi.Tables.ColonistBirthplaces
		local icon = "%s\n\n<image %s>"
		for i = 1, #birth do
			local name = Trans(birth[i].text)
			ItemList[#ItemList+1] = {
				text = StringFormat("%s: %s",S[4357--[[Birthplace--]]],name),
				value = birth[i].value,
				idx = i,
				hint = icon:format(name,birth[i].flag),
			}
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			local check1 = choice[1].check1
			local dome
			sel = SelectedObj
			if IsKindOf(sel,"Colonist") and sel.dome and choice[1].check2 then
				dome = sel.dome
			end

			local function CullLabel(label)
				local objs = UICity.labels[label] or ""
				for i = #objs, 1, -1 do
					if dome then
						if objs[i].dome and objs[i].dome.handle == dome.handle then
							MeatbagsToSoylent(objs[i],check1)
						end
					else
						MeatbagsToSoylent(objs[i],check1)
					end
				end
			end
			local function CullTrait(trait)
				local objs = UICity.labels.Colonist or ""
				for i = #objs, 1, -1 do
					if objs[i].traits[trait] then
						if dome then
							if objs[i].dome and objs[i].dome.handle == dome.handle then
								MeatbagsToSoylent(objs[i],check1)
							end
						else
							MeatbagsToSoylent(objs[i],check1)
						end
					end
				end
			end
			local function Cull(trait,trait_type,race)
				--only race is stored as number (maybe there's a cock^?^?^?^?CoC around)
				trait = race or trait
				local objs = UICity.labels.Colonist or ""
				for i = #objs, 1, -1 do
					if objs[i][trait_type] == trait then
						if dome then
							if objs[i].dome and objs[i].dome.handle == dome.handle then
								MeatbagsToSoylent(objs[i],check1)
							end
						else
							MeatbagsToSoylent(objs[i],check1)
						end
					end
				end
			end
			local text = choice[1].text

			if value == "Homeless" or value == "Unemployed" then
				CullLabel(value)
			elseif value == "Renegade" then
				CullTrait(value)
			elseif text:find(S[240--[[Specialization--]]],1,true) and (ChoGGi.Tables.ColonistSpecializations[value] or value == "none") then
				CullLabel(value)
			elseif text:find(S[987289847467--[[Age Groups--]]],1,true) and ChoGGi.Tables.ColonistAges[value] then
				CullTrait(value)
			elseif text:find(S[4357--[[Birthplace--]]],1,true) and ChoGGi.Tables.ColonistBirthplaces[value] then
				Cull(value,"birthplace")
				-- bonus round
				if not UICity.ChoGGi.DaddysLittleHitler then
					Msg("ChoGGi_DaddysLittleHitler")
					UICity.ChoGGi.DaddysLittleHitler = true
				end
			elseif text:find(S[4356--[[Sex--]]],1,true) and ChoGGi.Tables.ColonistGenders[value] then
				CullTrait(value)
			elseif text:find(S[302535920000741--[[Race--]]],1,true) and ChoGGi.Tables.ColonistRaces[value] then
				Cull(value,"race",choice[1].idx)
				-- bonus round
				if not UICity.ChoGGi.DaddysLittleHitler then
					Msg("ChoGGi_DaddysLittleHitler")
					UICity.ChoGGi.DaddysLittleHitler = true
				end
			end

			if value == "Child" then
				--wonder why they never added this to fallout 3?
				MsgPopup(
					302535920000742--[[Congratulations: You've been awarded the Childkiller title.



	I think somebody has been playing too much Fallout...--]],
					302535920000743--[[Childkiller--]],
					"UI/Icons/Logos/logo_09.tga",
					true
				)
				if not UICity.ChoGGi.Childkiller then
					Msg("ChoGGi_Childkiller")
					UICity.ChoGGi.Childkiller = true
				end
			else
				MsgPopup(
					S[302535920000744--[[%s: Wholesale slaughter--]]]:format(choice[1].text),
					302535920000745--[[Snacks--]],
					"UI/Icons/Sections/Food_1.tga"
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000375--[[The Soylent Option--]],
			hint = 302535920000747--[[Convert useless meatbags into productive protein.

	Certain colonists may take some time (traveling in shuttles).

	This will not effect your applicants/game failure (genocide without reprisal ftw).--]],
			check = {
				{
					title = 302535920000748--[[Random resource--]],
					hint = 302535920000749--[[Drops random resource instead of food.--]],
				},
				{
					title = 302535920000750--[[Dome Only--]],
					hint = 302535920000751--[[Will only apply to colonists in the same dome as selected colonist.--]],
				},
			},
		}
	end

	function ChoGGi.MenuFuncs.AddApplicantsToPool()
		local ChoGGi = ChoGGi
		local ItemList = {
			{text = 1,value = 1},
			{text = 10,value = 10},
			{text = 25,value = 25},
			{text = 50,value = 50},
			{text = 75,value = 75},
			{text = 100,value = 100},
			{text = 250,value = 250},
			{text = 500,value = 500},
			{text = 1000,value = 1000},
			{text = 2500,value = 2500},
			{text = 5000,value = 5000},
			{text = 10000,value = 10000},
			{text = 25000,value = 25000},
			{text = 50000,value = 50000},
			{text = 100000,value = 100000},
		}

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if choice[1].check1 then
				g_ApplicantPool = {}
				MsgPopup(
					302535920000754--[[Emptied applicants pool.--]],
					302535920000755--[[Applicants--]],
					default_icon
				)
			else
				if type(value) == "number" then
					local UICity = UICity
					local now = GameTime()
					for _ = 1, value do
						GenerateApplicant(now, UICity)
					end
					g_LastGeneratedApplicantTime = now
					MsgPopup(
						S[302535920000756--[[%s: Added applicants.--]]]:format(choice[1].text),
						302535920000755--[[Applicants--]],
						default_icon
					)
				end
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000757--[[Add Applicants To Pool--]],
			hint = StringFormat("%s: %s",S[6779--[[Warning--]]],S[302535920000758--[[Will take some time for 25K and up.--]]]),
			check = {
				{
					title = 302535920000759--[[Clear Applicant Pool--]],
					hint = S[302535920000760--[["Remove all the applicants currently in the pool (checking this will ignore your list selection).

	Current Pool Size: %s"--]]]:format(#g_ApplicantPool),
				},
			},
		}
	end

	function ChoGGi.MenuFuncs.FireAllColonists()
		local function CallBackFunc(answer)
			if answer then
				local tab = UICity.labels.Colonist or ""
				for i = 1, #tab do
					tab[i]:GetFired()
				end
			end
		end
		ChoGGi.ComFuncs.QuestionBox(
			302535920000761--[[Are you sure you want to fire everyone?--]],
			CallBackFunc,
			302535920000762--[[Yer outta here!--]]
		)
	end

	function ChoGGi.MenuFuncs.SetAllWorkShifts()
		local ItemList = {
			{text = S[302535920000763--[[Turn On All Shifts--]]],value = 0},
			{text = S[302535920000764--[[Turn Off All Shifts--]]],value = 3.1415926535},
		}

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			local shift
			if value == 3.1415926535 then
				shift = {true,true,true}
			else
				shift = {false,false,false}
			end

			local tab = UICity.labels.ShiftsBuilding or ""
			for i = 1, #tab do
				if tab[i].closed_shifts then
					tab[i].closed_shifts = shift
				end
			end

			MsgPopup(
				302535920000765--[[Early night? Vamos al bar un trago!--]],
				217--[[Work Shifts--]],
				default_icon
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 217--[[Work Shifts--]],
			hint = 302535920000766--[[This will change ALL shifts.--]],
		}
	end

	function ChoGGi.MenuFuncs.SetMinComfortBirth()
		local r = ChoGGi.Consts.ResourceScale
		local DefaultSetting = ChoGGi.Consts.MinComfortBirth / r
		local hint_low = S[302535920000767--[[Lower = more babies--]]]
		local hint_high = S[302535920000768--[[Higher = less babies--]]]
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
			{text = 0,value = 0,hint = hint_low},
			{text = 35,value = 35,hint = hint_low},
			{text = 140,value = 140,hint = hint_high},
			{text = 280,value = 280,hint = hint_high},
		}

		local hint = DefaultSetting
		if ChoGGi.UserSettings.MinComfortBirth then
			hint = ChoGGi.UserSettings.MinComfortBirth / r
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				value = value * r
				ChoGGi.ComFuncs.SetConstsG("MinComfortBirth",value)
				ChoGGi.ComFuncs.SetSavedSetting("MinComfortBirth",Consts.MinComfortBirth)

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					StringFormat("%s: %s%s",S[302535920000769--[[Selected--]]],choice[1].text,S[302535920000770--[[
	Look at them, bloody Catholics, filling the bloody world up with bloody people they can't afford to bloody feed.--]]]),
					547--[[Colonists--]],
					default_icon,
					true
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000771--[[Set the minimum comfort needed for birth--]],
			hint = StringFormat("%s: %s",S[302535920000106--[[Current--]]],hint),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.VisitFailPenalty_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.SetConstsG("VisitFailPenalty",ChoGGi.ComFuncs.NumRetBool(Consts.VisitFailPenalty,0,ChoGGi.Consts.VisitFailPenalty))

		ChoGGi.ComFuncs.SetSavedSetting("VisitFailPenalty",Consts.VisitFailPenalty)
		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000772--[["%s:
	The mill's closed. There's no more work. We're destitute. I'm afraid I have no choice but to sell you all for scientific experiments."--]]]:format(ChoGGi.UserSettings.VisitFailPenalty),
			547--[[Colonists--]],
			default_icon,
			true
		)
	end

	function ChoGGi.MenuFuncs.RenegadeCreation_Toggle()
		local ChoGGi = ChoGGi
		local Consts = Consts
		ChoGGi.ComFuncs.SetConstsG("RenegadeCreation",ChoGGi.ComFuncs.ValueRetOpp(Consts.RenegadeCreation,max_int,ChoGGi.Consts.RenegadeCreation))

		ChoGGi.ComFuncs.SetSavedSetting("RenegadeCreation",Consts.RenegadeCreation)
		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000773--[[%s: I just love findin' subversives.--]]]:format(ChoGGi.UserSettings.RenegadeCreation),
			547--[[Colonists--]],
			default_icon
		)
	end

	function ChoGGi.MenuFuncs.SetRenegadeStatus()
		local ItemList = {
			{text = S[302535920000774--[[Make All Renegades--]]],value = "Make"},
			{text = S[302535920000775--[[Remove All Renegades--]]],value = "Remove"},
		}

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			local dome
			local sel = SelectedObj
			if IsKindOf(sel,"Colonist") and sel.dome and choice[1].check1 then
				dome = sel.dome
			end
			local Type
			if value == "Make" then
				Type = "AddTrait"
			elseif value == "Remove" then
				Type = "RemoveTrait"
			end

			local tab = UICity.labels.Colonist or ""
			for i = 1, #tab do
				if dome then
					if tab[i].dome and tab[i].dome.handle == dome.handle then
						tab[i][Type](tab[i],"Renegade")
					end
				else
					tab[i][Type](tab[i],"Renegade")
				end
			end
			MsgPopup(
				302535920000776--[["OK, a limousine that can fly. Now I have seen everything.
	Really? Have you seen a man eat his own head?
	No.
	So then, you haven't seen everything."--]],
				547--[[Colonists--]],
				default_icon,
				true
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000777--[[Make Renegades--]],
			check = {
				{
					title = 302535920000750--[[Dome Only--]],
					hint = 302535920000751--[[Will only apply to colonists in the same dome as selected colonist.--]],
				},
			},
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.ColonistsMoraleAlwaysMax_Toggle()
		local ChoGGi = ChoGGi
		-- was -100
		ChoGGi.ComFuncs.SetConstsG("HighStatLevel",ChoGGi.ComFuncs.NumRetBool(Consts.HighStatLevel,0,ChoGGi.Consts.HighStatLevel))
		ChoGGi.ComFuncs.SetConstsG("LowStatLevel",ChoGGi.ComFuncs.NumRetBool(Consts.LowStatLevel,0,ChoGGi.Consts.LowStatLevel))
		ChoGGi.ComFuncs.SetConstsG("HighStatMoraleEffect",ChoGGi.ComFuncs.ValueRetOpp(Consts.HighStatMoraleEffect,max_int,ChoGGi.Consts.HighStatMoraleEffect))
		ChoGGi.ComFuncs.SetSavedSetting("HighStatMoraleEffect",Consts.HighStatMoraleEffect)
		ChoGGi.ComFuncs.SetSavedSetting("HighStatLevel",Consts.HighStatLevel)
		ChoGGi.ComFuncs.SetSavedSetting("LowStatLevel",Consts.LowStatLevel)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000778--[[%s: Happy as a pig in shit.--]]]:format(ChoGGi.UserSettings.HighStatMoraleEffect),
			547--[[Colonists--]],
			default_icon
		)
	end

	function ChoGGi.MenuFuncs.ChanceOfSanityDamage_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.SetConstsG("DustStormSanityDamage",ChoGGi.ComFuncs.NumRetBool(Consts.DustStormSanityDamage,0,ChoGGi.Consts.DustStormSanityDamage))
		ChoGGi.ComFuncs.SetConstsG("MysteryDreamSanityDamage",ChoGGi.ComFuncs.NumRetBool(Consts.MysteryDreamSanityDamage,0,ChoGGi.Consts.MysteryDreamSanityDamage))
		ChoGGi.ComFuncs.SetConstsG("ColdWaveSanityDamage",ChoGGi.ComFuncs.NumRetBool(Consts.ColdWaveSanityDamage,0,ChoGGi.Consts.ColdWaveSanityDamage))
		ChoGGi.ComFuncs.SetConstsG("MeteorSanityDamage",ChoGGi.ComFuncs.NumRetBool(Consts.MeteorSanityDamage,0,ChoGGi.Consts.MeteorSanityDamage))
		ChoGGi.ComFuncs.SetSavedSetting("DustStormSanityDamage",Consts.DustStormSanityDamage)
		ChoGGi.ComFuncs.SetSavedSetting("MysteryDreamSanityDamage",Consts.MysteryDreamSanityDamage)
		ChoGGi.ComFuncs.SetSavedSetting("ColdWaveSanityDamage",Consts.ColdWaveSanityDamage)
		ChoGGi.ComFuncs.SetSavedSetting("MeteorSanityDamage",Consts.MeteorSanityDamage)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000778--[[%s: Happy as a pig in shit.--]]]:format(ChoGGi.UserSettings.DustStormSanityDamage),
			547--[[Colonists--]],
			default_icon
		)
	end

	function ChoGGi.MenuFuncs.SeeDeadSanityDamage_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.SetConstsG("SeeDeadSanity",ChoGGi.ComFuncs.NumRetBool(Consts.SeeDeadSanity,0,ChoGGi.Consts.SeeDeadSanity))
		ChoGGi.ComFuncs.SetSavedSetting("SeeDeadSanity",Consts.SeeDeadSanity)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000779--[[%s: I love me some corpses.--]]]:format(ChoGGi.UserSettings.SeeDeadSanity),
			547--[[Colonists--]],
			default_icon
		)
	end

	function ChoGGi.MenuFuncs.NoHomeComfortDamage_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.SetConstsG("NoHomeComfort",ChoGGi.ComFuncs.NumRetBool(Consts.NoHomeComfort,0,ChoGGi.Consts.NoHomeComfort))
		ChoGGi.ComFuncs.SetSavedSetting("NoHomeComfort",Consts.NoHomeComfort)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000780--[["%s:
	Oh, give me a home where the Buffalo roam.
	Where the Deer and the Antelope play;
	Where seldom is heard a discouraging word."--]]]:format(ChoGGi.UserSettings.NoHomeComfort),
			547--[[Colonists--]],
			default_icon,
			true
		)
	end

	function ChoGGi.MenuFuncs.ChanceOfNegativeTrait_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.SetConstsG("LowSanityNegativeTraitChance",ChoGGi.ComFuncs.NumRetBool(Consts.LowSanityNegativeTraitChance,0,ChoGGi.ComFuncs.GetResearchedTechValue("LowSanityNegativeTraitChance")))
		ChoGGi.ComFuncs.SetSavedSetting("LowSanityNegativeTraitChance",Consts.LowSanityNegativeTraitChance)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000781--[[%s: Stupid and happy--]]]:format(ChoGGi.UserSettings.LowSanityNegativeTraitChance),
			547--[[Colonists--]],
			default_icon
		)
	end

	function ChoGGi.MenuFuncs.ColonistsChanceOfSuicide_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.SetConstsG("LowSanitySuicideChance",ChoGGi.ComFuncs.ToggleBoolNum(Consts.LowSanitySuicideChance))
		ChoGGi.ComFuncs.SetSavedSetting("LowSanitySuicideChance",Consts.LowSanitySuicideChance)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000782--[[%s: Getting away ain't that easy--]]]:format(ChoGGi.UserSettings.LowSanitySuicideChance),
			547--[[Colonists--]],
			default_icon
		)
	end

	function ChoGGi.MenuFuncs.ColonistsSuffocate_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.SetConstsG("OxygenMaxOutsideTime",ChoGGi.ComFuncs.ValueRetOpp(Consts.OxygenMaxOutsideTime,max_int,ChoGGi.Consts.OxygenMaxOutsideTime))
		ChoGGi.ComFuncs.SetSavedSetting("OxygenMaxOutsideTime",Consts.OxygenMaxOutsideTime)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000783--[[%s: Free Air--]]]:format(ChoGGi.UserSettings.OxygenMaxOutsideTime),
			547--[[Colonists--]],
			default_icon
		)
	end

	function ChoGGi.MenuFuncs.ColonistsStarve_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.SetConstsG("TimeBeforeStarving",ChoGGi.ComFuncs.ValueRetOpp(Consts.TimeBeforeStarving,max_int,ChoGGi.Consts.TimeBeforeStarving))
		ChoGGi.ComFuncs.SetSavedSetting("TimeBeforeStarving",Consts.TimeBeforeStarving)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000784--[[%s: A stale piece of bread is better than nothing.
And nothing is better than a big juicey steak.
Therefore a stale piece of bread is better than a big juicy steak.--]]]:format(ChoGGi.UserSettings.TimeBeforeStarving),
			547--[[Colonists--]],
			"UI/Icons/Sections/Food_2.tga",
			true
		)
	end

	function ChoGGi.MenuFuncs.AvoidWorkplace_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.SetConstsG("AvoidWorkplaceSols",ChoGGi.ComFuncs.NumRetBool(Consts.AvoidWorkplaceSols,0,ChoGGi.Consts.AvoidWorkplaceSols))
		ChoGGi.ComFuncs.SetSavedSetting("AvoidWorkplaceSols",Consts.AvoidWorkplaceSols)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000785--[[%s: No Shame--]]]:format(ChoGGi.UserSettings.AvoidWorkplaceSols),
			547--[[Colonists--]],
			default_icon
		)
	end

	function ChoGGi.MenuFuncs.PositivePlayground_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.SetConstsG("positive_playground_chance",ChoGGi.ComFuncs.ValueRetOpp(Consts.positive_playground_chance,101,ChoGGi.Consts.positive_playground_chance))
		ChoGGi.ComFuncs.SetSavedSetting("positive_playground_chance",Consts.positive_playground_chance)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000786--[[%s: We've all seen them, on the playground, at the store, walking on the streets.--]]]:format(ChoGGi.UserSettings.positive_playground_chance),
			235--[[Traits--]],
			"UI/Icons/Upgrades/home_collective_02.tga"
		)
	end

	function ChoGGi.MenuFuncs.ProjectMorpheusPositiveTrait_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.SetConstsG("ProjectMorphiousPositiveTraitChance",ChoGGi.ComFuncs.ValueRetOpp(Consts.ProjectMorphiousPositiveTraitChance,100,ChoGGi.Consts.ProjectMorphiousPositiveTraitChance))
		ChoGGi.ComFuncs.SetSavedSetting("ProjectMorphiousPositiveTraitChance",Consts.ProjectMorphiousPositiveTraitChance)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000787--[["%s: Say, ""Small umbrella, small umbrella."""--]]]:format(ChoGGi.UserSettings.ProjectMorphiousPositiveTraitChance),
			547--[[Colonists--]],
			"UI/Icons/Upgrades/rejuvenation_treatment_04.tga"
		)
	end

	function ChoGGi.MenuFuncs.PerformancePenaltyNonSpecialist_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.ComFuncs.SetConstsG("NonSpecialistPerformancePenalty",ChoGGi.ComFuncs.NumRetBool(Consts.NonSpecialistPerformancePenalty,0,ChoGGi.ComFuncs.GetResearchedTechValue("NonSpecialistPerformancePenalty")))
		ChoGGi.ComFuncs.SetSavedSetting("NonSpecialistPerformancePenalty",Consts.NonSpecialistPerformancePenalty)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			S[302535920000788--[[%s: You never know what you're gonna get.--]]]:format(ChoGGi.UserSettings.NonSpecialistPerformancePenalty),
			302535920000912--[[Penalty--]],
			default_icon,
			true
		)
	end

	function ChoGGi.MenuFuncs.SetOutsideWorkplaceRadius()
		local ChoGGi = ChoGGi
		local DefaultSetting = ChoGGi.Consts.DefaultOutsideWorkplacesRadius
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
			{text = 15,value = 15},
			{text = 20,value = 20},
			{text = 25,value = 25},
			{text = 50,value = 50},
			{text = 75,value = 75},
			{text = 100,value = 100},
			{text = 250,value = 250},
		}

		local hint = DefaultSetting
		if ChoGGi.UserSettings.DefaultOutsideWorkplacesRadius then
			hint = ChoGGi.UserSettings.DefaultOutsideWorkplacesRadius
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				ChoGGi.ComFuncs.SetConstsG("DefaultOutsideWorkplacesRadius",value)
				ChoGGi.ComFuncs.SetSavedSetting("DefaultOutsideWorkplacesRadius",value)

				ChoGGi.SettingFuncs.WriteSettings()
					MsgPopup(
						S[302535920000789--[[%s: There's a voice that keeps on calling me
	Down the road is where I'll always be
	Maybe tomorrow, I'll find what I call home
	Until tomorrow, you know I'm free to roam--]]]:format(choice[1].text),
						547--[[Colonists--]],
						"UI/Icons/Sections/dome.tga",
						true
					)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000790--[[Set Outside Workplace Radius--]],
			hint = StringFormat("%s: %s\n\n%s",S[302535920000791--[[Current distance--]]],hint,S[302535920000792--[[You may not want to make it too far away unless you turned off suffocation.--]]]),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetDeathAge()
		local function RetDeathAge(c)
			c = c or Colonist
	--~		 return c.MinAge_Senior + 5 + c:Random(10) + c:Random(5) + c:Random(5)
			return c.MinAge_Senior + 5 + Random(10) + Random(5) + Random(5)
		end

		local default_str = S[1000121--[[Default--]]]
		local ItemList = {
			{text = default_str,value = default_str,hint = 302535920000794--[[Uses same code as game to pick death ages.--]]},
			{text = 60,value = 60},
			{text = 75,value = 75},
			{text = 100,value = 100},
			{text = 250,value = 250},
			{text = 500,value = 500},
			{text = 1000,value = 1000},
			{text = 10000,value = 10000},
			{text = S[302535920000795--[[Logan's Run (Novel)--]]],value = "LoganNovel"},
			{text = S[302535920000796--[[Logan's Run (Movie)--]]],value = "LoganMovie"},
			{text = S[302535920000797--[[TNG: Half a Life--]]],value = "TNG"},
			{text = S[302535920000798--[[The Happy Place--]]],value = "TheHappyPlace"},
			{text = S[302535920000799--[[In Time--]]],value = "InTime"},
		}

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			local amount
			if value == "LoganNovel" then
				amount = 21
			elseif value == "LoganMovie" then
				amount = 30
			elseif value == "TNG" then
				amount = 60
			elseif value == "TheHappyPlace" then
				amount = 60
			elseif value == "InTime" then
				amount = 26
			elseif type(value) == "number" then
				amount = value
			end

			if value == default_str or type(amount) == "number" then
				if value == default_str then
					local tab = UICity.labels.Colonist or ""
					for i = 1, #tab do
						tab[i].death_age = RetDeathAge(tab[i])
					end
					ChoGGi.UserSettings.DeathAgeColonist = nil
				elseif type(amount) == "number" then
					local tab = UICity.labels.Colonist or ""
					for i = 1, #tab do
						tab[i].death_age = amount
					end
					ChoGGi.UserSettings.DeathAgeColonist = amount
				end

				ChoGGi.SettingFuncs.WriteSettings()

				MsgPopup(
					ChoGGi.ComFuncs.SettingState(choice[1].text,302535920000446--[[Colonist Death Age--]]),
					547--[[Colonists--]],
					default_icon
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000801--[[Set Death Age--]],
			hint = S[302535920000802--[[Usual age is around %s. This doesn't stop colonists from becoming seniors; just death (research ForeverYoung for enternal labour).--]]]:format(RetDeathAge()),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.ColonistsAddSpecializationToAll()
		local ChoGGi = ChoGGi
		local tab = UICity.labels.Colonist or ""
		for i = 1, #tab do
			if tab[i].specialist == "none" then
				ChoGGi.ComFuncs.ColonistUpdateSpecialization(tab[i],S[3490--[[Random--]]])
			end
		end

		MsgPopup(
			302535920000804--[[No lazy good fer nuthins round here--]],
			547--[[Colonists--]],
			"UI/Icons/Upgrades/home_collective_04.tga"
		)
	end

	function ChoGGi.MenuFuncs.SetColonistsAge(iType)
		local ChoGGi = ChoGGi
		local default_str = S[1000121--[[Default--]]]
		local DefaultSetting = default_str
		local sType
		local sSetting = "NewColonistAge"

		if iType == 1 then
			sType = StringFormat("%s ",S[302535920001356--[[New--]]])
		else
			sType = ""
			DefaultSetting = S[3490--[[Random--]]]
			sSetting = nil
		end

		local ItemList = {}
		ItemList[#ItemList+1] = {
			text = StringFormat(" %s",DefaultSetting),
			value = DefaultSetting,
		}
		for i = 1, #ChoGGi.Tables.ColonistAges do
			ItemList[#ItemList+1] = {
				text = ChoGGi.Tables.ColonistAges[i],
				value = ChoGGi.Tables.ColonistAges[i],
				hint = ChoGGi.Tables.ColonistAges[i] == "Child" and StringFormat("%s: %s",S[6779--[[Warning--]]],S[302535920000805--[[Child will remove specialization.--]]]),
			}
		end

		local hint = ""
		if iType == 1 then
			hint = DefaultSetting
			if ChoGGi.UserSettings[sSetting] then
				hint = ChoGGi.UserSettings[sSetting]
			end
			hint = StringFormat("%s: %s\n\n%s",S[302535920000106--[[Current--]]],hint,S[302535920000805--[[Warning: Child will remove specialization.--]]])
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			local sel = SelectedObj
			local dome
			if IsKindOf(sel,"Colonist") and sel.dome and choice[1].check1 then
				dome = sel.dome
			end

			-- new
			if iType == 1 then
				if value == default_str then
					ChoGGi.UserSettings.NewColonistAge = nil
				else
					ChoGGi.ComFuncs.SetSavedSetting("NewColonistAge",value)
				end
				ChoGGi.SettingFuncs.WriteSettings()

			-- existing
			elseif iType == 2 then
				if choice[1].check2 then
					if sel then
						ChoGGi.ComFuncs.ColonistUpdateAge(sel,value)
					end
				else
					local tab = UICity.labels.Colonist or ""
					for i = 1, #tab do
						if dome then
							if tab[i].dome and tab[i].dome.handle == dome.handle then
								ChoGGi.ComFuncs.ColonistUpdateAge(tab[i],value)
							end
						else
							ChoGGi.ComFuncs.ColonistUpdateAge(tab[i],value)
						end
					end
				end

			end

			MsgPopup(
				StringFormat("%s: %s%s",choice[1].text,sType,S[547--[[Colonists--]]]),
				547--[[Colonists--]],
				default_icon
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = StringFormat("%s %s%s",S[302535920000129--[[Set--]]],sType,S[302535920000807--[[Colonist Age--]]]),
			hint = hint,
			check = {
				{
					title = 302535920000750--[[Dome Only--]],
					hint = 302535920000751--[[Will only apply to colonists in the same dome as selected colonist.--]],
				},
				{
					title = 302535920000752--[[Selected Only--]],
					hint = 302535920000753--[[Will only apply to selected colonist.--]],
				},
			},
		}
	end

	function ChoGGi.MenuFuncs.SetColonistsGender(iType)
		local ChoGGi = ChoGGi
		local MaleOrFemale = S[302535920000800--[[MaleOrFemale--]]]
		local DefaultSetting = S[1000121--[[Default--]]]
		local sType
		local sSetting = "NewColonistGender"

		if iType == 1 then
			sType = StringFormat("%s ",S[302535920001356--[[New--]]])
		else
			sType = ""
			DefaultSetting = S[3490--[[Random--]]]
			sSetting = nil
		end

		local ItemList = {}
		ItemList[#ItemList+1] = {
			text = StringFormat(" %s",DefaultSetting),
			value = DefaultSetting,
			hint = 302535920000808--[[How the game normally works--]],
		}
		ItemList[#ItemList+1] = {
			text = StringFormat(" %s",MaleOrFemale),
			value = MaleOrFemale,
			hint = 302535920000809--[[Only set as male or female--]],
		}
		for i = 1, #ChoGGi.Tables.ColonistGenders do
			ItemList[#ItemList+1] = {
				text = ChoGGi.Tables.ColonistGenders[i],
				value = ChoGGi.Tables.ColonistGenders[i],
			}
		end

		local hint
		if iType == 1 then
			hint = DefaultSetting
			if ChoGGi.UserSettings[sSetting] then
				hint = ChoGGi.UserSettings[sSetting]
			end
			hint = StringFormat("%s: %s",S[302535920000106--[[Current--]]],hint)
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			local sel = SelectedObj
			local dome
			if IsKindOf(sel,"Colonist") and sel.dome and choice[1].check1 then
				dome = sel.dome
			end

			-- new
			if iType == 1 then
				if value == S[1000121--[[Default--]]] then
					ChoGGi.UserSettings.NewColonistGender = nil
				else
					ChoGGi.ComFuncs.SetSavedSetting("NewColonistGender",value)
				end
				ChoGGi.SettingFuncs.WriteSettings()

			-- existing
			elseif iType == 2 then
				if choice[1].check2 then
					if sel then
						ChoGGi.ComFuncs.ColonistUpdateGender(sel,value)
					end
				else
					local tab = UICity.labels.Colonist or ""
					for i = 1, #tab do
						if dome then
							if tab[i].dome and tab[i].dome.handle == dome.handle then
								ChoGGi.ComFuncs.ColonistUpdateGender(tab[i],value)
							end
						else
							ChoGGi.ComFuncs.ColonistUpdateGender(tab[i],value)
						end
					end
				end

			end
			MsgPopup(
				StringFormat("%s: %s",choice[1].text,sType,S[547--[[Colonists--]]]),
				547--[[Colonists--]],
				default_icon
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = StringFormat("%s %s%s",S[302535920000129--[[Set--]]],sType,S[302535920000810--[[Colonist Gender--]]]),
			hint = hint,
			check = {
				{
					title = 302535920000750--[[Dome Only--]],
					hint = 302535920000751--[[Will only apply to colonists in the same dome as selected colonist.--]],
				},
				{
					title = 302535920000752--[[Selected Only--]],
					hint = 302535920000753--[[Will only apply to selected colonist.--]],
				},
			},
		}
	end

	function ChoGGi.MenuFuncs.SetColonistsSpecialization(iType)
		local ChoGGi = ChoGGi
		local DefaultSetting = S[1000121--[[Default--]]]
		local sType
		local sSetting = "NewColonistSpecialization"

		if iType == 1 then
			sType = StringFormat("%s ",S[302535920001356--[[New--]]])
		else
			sType = ""
			DefaultSetting = S[3490--[[Random--]]]
			sSetting = nil
		end

		local ItemList = {}
		ItemList[#ItemList+1] = {
			text = DefaultSetting,
			value = DefaultSetting,
			hint = 302535920000808--[[How the game normally works--]],
		}
		if iType == 1 then
			ItemList[#ItemList+1] = {
				text = S[3490--[[Random--]]],
				value = S[3490--[[Random--]]],
				hint = 302535920000811--[[Everyone gets a spec--]],
			}
		end
		ItemList[#ItemList+1] = {
			text = "none",
			value = "none",
			hint = 302535920000812--[[Removes specializations--]],
		}
		for i = 1, #ChoGGi.Tables.ColonistSpecializations do
			ItemList[#ItemList+1] = {
				text = ChoGGi.Tables.ColonistSpecializations[i],
				value = ChoGGi.Tables.ColonistSpecializations[i],
			}
		end

		local hint
		if iType == 1 then
			hint = DefaultSetting
			if ChoGGi.UserSettings[sSetting] then
				hint = ChoGGi.UserSettings[sSetting]
			end
			hint = StringFormat("%s: %s",S[302535920000106--[[Current--]]],hint)
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			local sel = SelectedObj
			local dome
			if IsKindOf(sel,"Colonist") and sel.dome and choice[1].check1 then
				dome = sel.dome
			end

			-- new
			if iType == 1 then
				if value == S[1000121--[[Default--]]] then
					ChoGGi.UserSettings.NewColonistSpecialization = nil
				else
					ChoGGi.ComFuncs.SetSavedSetting("NewColonistSpecialization",value)
				end
				ChoGGi.SettingFuncs.WriteSettings()

			-- existing
			elseif iType == 2 then
				if choice[1].check2 then
					if sel then
						ChoGGi.ComFuncs.ColonistUpdateSpecialization(sel,value)
					end
				else
					local tab = UICity.labels.Colonist or ""
					for i = 1, #tab do
						if dome then
							if tab[i].dome and tab[i].dome.handle == dome.handle then
								ChoGGi.ComFuncs.ColonistUpdateSpecialization(tab[i],value)
							end
						else
							ChoGGi.ComFuncs.ColonistUpdateSpecialization(tab[i],value)
						end
					end
				end

			end
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice[1].text,547--[[Colonists--]]),
				547--[[Colonists--]],
				default_icon
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = StringFormat("%s %s%s",S[302535920000129--[[Set--]]],sType,S[302535920000813--[[Colonist Specialization--]]]),
			hint = hint,
			check = {
				{
					title = 302535920000750--[[Dome Only--]],
					hint = 302535920000751--[[Will only apply to colonists in the same dome as selected colonist.--]],
				},
				{
					title = 302535920000752--[[Selected Only--]],
					hint = 302535920000753--[[Will only apply to selected colonist.--]],
				},
			},
		}
	end

	function ChoGGi.MenuFuncs.SetColonistsRace(iType)
		local ChoGGi = ChoGGi
		local DefaultSetting = S[1000121--[[Default--]]]
		local sType
		local sSetting = "NewColonistRace"

		if iType == 1 then
			sType = StringFormat("%s ",S[302535920001356--[[New--]]])
		else
			sType = ""
			DefaultSetting = S[3490--[[Random--]]]
			sSetting = nil
		end

		local ItemList = {}
		ItemList[#ItemList+1] = {
			text = StringFormat(" %s",DefaultSetting),
			value = DefaultSetting,
			race = DefaultSetting,
		}
		local race = {S[302535920000814--[[Herrenvolk--]]],S[302535920000815--[[Schwarzvolk--]]],S[302535920000816--[[Asiatischvolk--]]],S[302535920000817--[[Indischvolk--]]],S[302535920000818--[[Südost Asiatischvolk--]]]}
		for i = 1, #ChoGGi.Tables.ColonistRaces do
			ItemList[#ItemList+1] = {
				text = ChoGGi.Tables.ColonistRaces[i],
				value = i,
				race = race[i],
			}
		end

		local hint
		if iType == 1 then
			hint = DefaultSetting
			if ChoGGi.UserSettings[sSetting] then
				hint = ChoGGi.UserSettings[sSetting]
			end
			hint = StringFormat("%s: %s",S[302535920000106--[[Current--]]],hint)
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			local sel = SelectedObj
			local dome
			if IsKindOf(sel,"Colonist") and sel.dome and choice[1].check1 then
				dome = sel.dome
			end

			-- new
			if iType == 1 then
				if value == S[1000121--[[Default--]]] then
					ChoGGi.UserSettings.NewColonistRace = nil
				else
					ChoGGi.ComFuncs.SetSavedSetting("NewColonistRace",value)
				end
				ChoGGi.SettingFuncs.WriteSettings()

			-- existing
			elseif iType == 2 then
				if choice[1].check2 then
					if sel then
						ChoGGi.ComFuncs.ColonistUpdateRace(sel,value)
					end
				else
					local tab = UICity.labels.Colonist or ""
					for i = 1, #tab do
						if dome then
							if tab[i].dome and tab[i].dome.handle == dome.handle then
								ChoGGi.ComFuncs.ColonistUpdateRace(tab[i],value)
							end
						else
							ChoGGi.ComFuncs.ColonistUpdateRace(tab[i],value)
						end
					end
				end
			end

			-- remove if random
			if value == S[3490--[[Random--]]] then
				MilestoneCompleted.DaddysLittleHitler = nil
				UICity.ChoGGi.DaddysLittleHitler = nil
			-- if only changing one colonists then you aren't hitler :)
			elseif not choice[1].check2 and not UICity.ChoGGi.DaddysLittleHitler then
				Msg("ChoGGi_DaddysLittleHitler")
				UICity.ChoGGi.DaddysLittleHitler = true
			end

			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice[1].race,302535920000819--[[Nationalsozialistische Rassenhygiene--]]),
				547--[[Colonists--]],
				default_icon
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = StringFormat("%s %s%s",S[302535920000129--[[Set--]]],sType,S[302535920000820--[[Colonist Race--]]]),
			hint = hint,
			check = {
				{
					title = 302535920000750--[[Dome Only--]],
					hint = 302535920000751--[[Will only apply to colonists in the same dome as selected colonist.--]],
				},
				{
					title = 302535920000752--[[Selected Only--]],
					hint = 302535920000753--[[Will only apply to selected colonist.--]],
				},
			},
		}
	end

	function ChoGGi.MenuFuncs.SetColonistsTraits(iType)
		local ChoGGi = ChoGGi
		local TraitPresets = TraitPresets
		local DefaultSetting = S[1000121--[[Default--]]]
		local sSetting = "NewColonistTraits"
		local sType = StringFormat("%s ",S[302535920001356--[[New--]]])

		local hint = ""
		if iType == 1 then
			hint = DefaultSetting
			local saved = ChoGGi.UserSettings[sSetting]
			if saved then
				hint = ""
				for i = 1, #saved do
					hint = StringFormat("%s%s,",hint,saved[i])
				end
			end
			hint = StringFormat("%s: %s",S[302535920000106--[[Current--]]],hint)
		elseif iType == 2 then
			sType = ""
			DefaultSetting = S[3490--[[Random--]]]
		end

		hint = StringFormat("%s\n\n%s",hint,S[302535920000821--[[Defaults to adding traits, check Remove to remove. Use Shift or Ctrl to select multiple traits.--]]])

		local ItemList = {
			{text = StringFormat(" %s",DefaultSetting),value = DefaultSetting,hint = 302535920000822--[[Use game defaults--]]},
			{text = StringFormat(" %s",S[302535920000823--[[All Positive Traits--]]]),value = "PositiveTraits",hint = 302535920000824--[[All the positive traits...--]]},
			{text = StringFormat(" %s",S[302535920000825--[[All Negative Traits--]]]),value = "NegativeTraits",hint = 302535920000826--[[All the negative traits...--]]},
			{text = StringFormat(" %s",S[302535920001040--[[All Other Traits--]]]),value = "OtherTraits",hint = 302535920001050--[[All the other traits...--]]},
			{text = StringFormat(" %s",S[652319561018--[[All Traits--]]]),value = "AllTraits",hint = 302535920000828--[[All the traits...--]]},
		}
		local c = #ItemList

		if iType == 2 then
			ItemList[1].hint = 302535920000829--[[Random: Each colonist gets three positive and three negative traits (if it picks same traits then you won't get all six).--]]
		end

		for i = 1, #ChoGGi.Tables.NegativeTraits do
			c = c + 1
			ItemList[c] = {
				text = ChoGGi.Tables.NegativeTraits[i],
				value = ChoGGi.Tables.NegativeTraits[i],
			}
		end
		for i = 1, #ChoGGi.Tables.PositiveTraits do
			c = c + 1
			ItemList[c] = {
				text = ChoGGi.Tables.PositiveTraits[i],
				value = ChoGGi.Tables.PositiveTraits[i],
			}
		end
		for i = 1, #ChoGGi.Tables.OtherTraits do
			c = c + 1
			ItemList[c] = {
				text = ChoGGi.Tables.OtherTraits[i],
				value = ChoGGi.Tables.OtherTraits[i],
			}
		end
		-- add hint descriptions
		for i = 1, #ItemList do
			local hinttemp = TraitPresets[ItemList[i].text]
			if hinttemp then
				ItemList[i].hint = StringFormat(": %s",Trans(hinttemp.description))
			end
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end

			local check1,check2 = choice[1].check1,choice[1].check2
			if check1 and check2 then
				MsgPopup(
					302535920000039--[[Don't pick both checkboxes next time...--]],
					547--[[Colonists--]]
				)
				return
			end

			local sel = SelectedObj
			local dome
			if IsKindOf(sel,"Colonist") and sel.dome and check1 then
				dome = sel.dome
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
			if iType == 1 then
				if choice[1].value == DefaultSetting then
					ChoGGi.UserSettings.NewColonistTraits = false
				else
					ChoGGi.UserSettings.NewColonistTraits = traits_list
				end
				ChoGGi.SettingFuncs.WriteSettings()

			-- existing
			elseif iType == 2 then
				--random 3x3
				if choice[1].value == DefaultSetting then
					local function RandomTraits(o)
						-- remove all traits
						ChoGGi.ComFuncs.ColonistUpdateTraits(o,false,ChoGGi.Tables.OtherTraits)
						ChoGGi.ComFuncs.ColonistUpdateTraits(o,false,ChoGGi.Tables.PositiveTraits)
						ChoGGi.ComFuncs.ColonistUpdateTraits(o,false,ChoGGi.Tables.NegativeTraits)
						-- add random ones
						local count = #ChoGGi.Tables.PositiveTraits
						o:AddTrait(ChoGGi.Tables.PositiveTraits[Random(1,count)],true)
						o:AddTrait(ChoGGi.Tables.PositiveTraits[Random(1,count)],true)
						o:AddTrait(ChoGGi.Tables.PositiveTraits[Random(1,count)],true)
						count = #ChoGGi.Tables.NegativeTraits
						o:AddTrait(ChoGGi.Tables.NegativeTraits[Random(1,count)],true)
						o:AddTrait(ChoGGi.Tables.NegativeTraits[Random(1,count)],true)
						o:AddTrait(ChoGGi.Tables.NegativeTraits[Random(1,count)],true)
						Notify(o,"UpdateMorale")
					end
					if check2 then
						if sel then
							RandomTraits(sel)
						end
					else
						local c = UICity.labels.Colonist or ""
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
						if sel then
							for i = 1, #traits_list do
								sel[t_type](sel,traits_list[i],true)
							end
						end
					else
						local c = UICity.labels.Colonist or ""
						for i = 1, #c do
							for j = 1, #traits_list do
								if dome then
									if c[i].dome and c[i].dome.handle == dome.handle then
										c[i][t_type](c[i],traits_list[j],true)
									end
								else
									c[i][t_type](c[i],traits_list[j],true)
								end
							end
						end
					end

				end

			end

			MsgPopup(
				StringFormat("%s: %s%s",#traits_list,sType,S[302535920000830--[[Colonists traits set--]]]),
				547--[[Colonists--]],
				default_icon
			)
		end

		if iType == 1 then
			ChoGGi.ComFuncs.OpenInListChoice{
				callback = CallBackFunc,
				items = ItemList,
				title = StringFormat("%s %s%s",S[302535920000129--[[Set--]]],sType,S[302535920000831--[[Colonist Traits--]]]),
				hint = hint,
				multisel = true,
			}
		elseif iType == 2 then
			ChoGGi.ComFuncs.OpenInListChoice{
				callback = CallBackFunc,
				items = ItemList,
				title = StringFormat("%s %s%s",S[302535920000129--[[Set--]]],sType,S[302535920000831--[[Colonist Traits--]]]),
				hint = hint,
				multisel = true,
				check = {
					{
						title = 302535920000750--[[Dome Only--]],
						hint = 302535920000751--[[Will only apply to colonists in the same dome as selected colonist.--]],
					},
					{
						title = 302535920000752--[[Selected Only--]],
						hint = 302535920000753--[[Will only apply to selected colonist.--]],
					},
					{
						title = 302535920000281--[[Remove--]],
						hint = 302535920000832--[[Check to remove traits--]],
					},
				},
				height = 800.0,
			}
		end
	end

	function ChoGGi.MenuFuncs.SetColonistsStats()
		local ChoGGi = ChoGGi
		local r = ChoGGi.Consts.ResourceScale
		local ItemList = {
			{text = StringFormat("%s %s",S[302535920000833--[[All Stats--]]],S[302535920000834--[[Max--]]]),value = 1},
			{text = StringFormat("%s %s",S[302535920000833--[[All Stats--]]],S[302535920000835--[[Fill--]]]),value = 2},
			{text = StringFormat("%s %s",S[4291--[[Health--]]],S[302535920000834--[[Max--]]]),value = 3},
			{text = StringFormat("%s %s",S[4291--[[Health--]]],S[302535920000835--[[Fill--]]]),value = 4},
			{text = StringFormat("%s %s",S[4297--[[Morale--]]],S[302535920000835--[[Fill--]]]),value = 5},
			{text = StringFormat("%s %s",S[4293--[[Sanity--]]],S[302535920000834--[[Max--]]]),value = 6},
			{text = StringFormat("%s %s",S[4293--[[Sanity--]]],S[302535920000835--[[Fill--]]]),value = 7},
			{text = StringFormat("%s %s",S[4295--[[Comfort--]]],S[302535920000834--[[Max--]]]),value = 8},
			{text = StringFormat("%s %s",S[4295--[[Comfort--]]],S[302535920000835--[[Fill--]]]),value = 9},
		}

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			local sel = SelectedObj
			local dome
			if IsKindOf(sel,"Colonist") and sel.dome and choice[1].check1 then
				dome = sel.dome
			end

			local max = 100000 * r
			local fill = 100 * r
			local function SetStat(Stat,v)
				if v == 1 or v == 3 or v == 6 or v == 8 then
					v = max
				else
					v = fill
				end
				local tab = UICity.labels.Colonist or ""
				for i = 1, #tab do
					if dome then
						if tab[i].dome and tab[i].dome.handle == dome.handle then
							tab[i][Stat] = v
						end
					else
						tab[i][Stat] = v
					end
				end
			end

			if value == 1 or value == 2 then
				if value == 1 then
					value = max
				elseif value == 2 then
					value = fill
				end

				local tab = UICity.labels.Colonist or ""
				for i = 1, #tab do
					if dome then
						if tab[i].dome and tab[i].dome.handle == dome.handle then
							tab[i].stat_morale = value
							tab[i].stat_sanity = value
							tab[i].stat_comfort = value
							tab[i].stat_health = value
						end
					else
						tab[i].stat_morale = value
						tab[i].stat_sanity = value
						tab[i].stat_comfort = value
						tab[i].stat_health = value
					end
				end

			elseif value == 3 or value == 4 then
				SetStat("stat_health",value)
			elseif value == 5 then
				SetStat("stat_morale",value)
			elseif value == 6 or value == 7 then
				SetStat("stat_sanity",value)
			elseif value == 8 or value == 9 then
				SetStat("stat_comfort",value)
			end

			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice[1].text,302535920000444--[[Set Stats--]]),
				547--[[Colonists--]],
				default_icon
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000836--[[Set Stats Of All Colonists--]],
			hint = 302535920000837--[[Fill: Stat bar filled to 100
	Max: 100000 (choose fill to reset)

	Warning: Disable births or else...--]],
			check = {
				{
					title = 302535920000750--[[Dome Only--]],
					hint = 302535920000751--[[Will only apply to colonists in the same dome as selected colonist.--]],
				},
			},
		}
	end

	function ChoGGi.MenuFuncs.SetColonistMoveSpeed()
		local ChoGGi = ChoGGi
		local r = ChoGGi.Consts.ResourceScale
		local DefaultSetting = ChoGGi.Consts.SpeedColonist
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting / r),value = DefaultSetting},
			{text = 5,value = 5 * r},
			{text = 10,value = 10 * r},
			{text = 15,value = 15 * r},
			{text = 25,value = 25 * r},
			{text = 50,value = 50 * r},
			{text = 100,value = 100 * r},
			{text = 1000,value = 1000 * r},
			{text = 10000,value = 10000 * r},
		}

		local hint = DefaultSetting
		if ChoGGi.UserSettings.SpeedColonist then
			hint = ChoGGi.UserSettings.SpeedColonist
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			local sel = SelectedObj
			local dome
			if IsKindOf(sel,"Colonist") and sel.dome and choice[1].check1 then
				dome = sel.dome
			end

			if type(value) == "number" then
				if choice[1].check2 then
					if sel then
						sel:SetMoveSpeed(value)
					end
				else
					local tab = UICity.labels.Colonist or ""
					for i = 1, #tab do
						if dome then
							if tab[i].dome and tab[i].dome.handle == dome.handle then
								tab[i]:SetMoveSpeed(value)
							end
						else
							tab[i]:SetMoveSpeed(value)
						end
					end
				end

				ChoGGi.ComFuncs.SetSavedSetting("SpeedColonist",value)
				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					ChoGGi.ComFuncs.SettingState(choice[1].text,302535920000769--[[Selected--]]),
					547--[[Colonists--]],
					default_icon
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000838--[[Colonist Move Speed--]],
			hint = hint,
			check = {
				{
					title = 302535920000750--[[Dome Only--]],
					hint = 302535920000751--[[Will only apply to colonists in the same dome as selected colonist.--]],
				},
				{
					title = 302535920000752--[[Selected Only--]],
					hint = 302535920000753--[[Will only apply to selected colonist.--]],
				},
			},
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetColonistsGravity()
		local ChoGGi = ChoGGi
		local DefaultSetting = ChoGGi.Consts.GravityColonist
		local r = ChoGGi.Consts.ResourceScale
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
			{text = 1,value = 1},
			{text = 2,value = 2},
			{text = 3,value = 3},
			{text = 4,value = 4},
			{text = 5,value = 5},
			{text = 10,value = 10},
			{text = 15,value = 15},
			{text = 25,value = 25},
			{text = 50,value = 50},
			{text = 75,value = 75},
			{text = 100,value = 100},
			{text = 250,value = 250},
			{text = 500,value = 500},
		}

		local hint = DefaultSetting
		if ChoGGi.UserSettings.GravityColonist then
			hint = ChoGGi.UserSettings.GravityColonist / r
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			local sel = SelectedObj
			local dome
			if IsKindOf(sel,"Colonist") and sel.dome and choice[1].check1 then
				dome = sel.dome
			end

			if type(value) == "number" then
				value = value * r
				if choice[1].check2 then
					if sel then
						sel:SetGravity(value)
					end
				else
					local tab = UICity.labels.Colonist or ""
					for i = 1, #tab do
						if dome then
							if tab[i].dome and tab[i].dome.handle == dome.handle then
								tab[i]:SetGravity(value)
							end
						else
							tab[i]:SetGravity(value)
						end
					end
				end

				ChoGGi.ComFuncs.SetSavedSetting("GravityColonist",value)

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					S[302535920000839--[[Colonist gravity is now %s.--]]]:format(choice[1].text),
					547--[[Colonists--]],
					default_icon
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000840--[[Set Colonist Gravity--]],
			hint = S[302535920000841--[[Current gravity: %s--]]]:format(hint),
			check = {
				{
					title = 302535920000750--[[Dome Only--]],
					hint = 302535920000751--[[Will only apply to colonists in the same dome as selected colonist.--]],
				},
				{
					title = 302535920000752--[[Selected Only--]],
					hint = 302535920000753--[[Will only apply to selected colonist.--]],
				},
			},
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetBuildingTraits(toggle_type)
		local ChoGGi = ChoGGi
		local TraitPresets = TraitPresets

		local sel = ChoGGi.ComFuncs.SelObject()
		if not sel or sel and not (sel:IsKindOf("Workplace") or sel:IsKindOf("TrainingBuilding")) then
			MsgPopup(
				302535920000842--[[Select a workplace or training building.--]],
				302535920000992--[[Building Traits--]],
				default_icon
			)
			return
		end

		local id = sel.template_name
		local name = Trans(sel.display_name)
		local BuildingSettings = ChoGGi.UserSettings.BuildingSettings
		if not BuildingSettings[id] or BuildingSettings[id] and not next(BuildingSettings[id]) then
			BuildingSettings[id] = {
				restricttraits = {},
				blocktraits = {},
			}
		end

		local ItemList = {}
		local c = 0
		local str_hint = StringFormat("%s: %s",S[302535920000106--[[Current--]]],"%s")
		for i = 1, #ChoGGi.Tables.NegativeTraits do
			local trait = ChoGGi.Tables.NegativeTraits[i]
			local status = type(BuildingSettings[id][toggle_type][trait]) == "boolean" and "true" or "false"
			c = c + 1
			ItemList[c] = {
				text = trait,
				value = trait,
				hint = StringFormat("%s\n%s",str_hint:format(status),Trans(TraitPresets[trait].description)),
			}
		end
		for i = 1, #ChoGGi.Tables.PositiveTraits do
			local trait = ChoGGi.Tables.PositiveTraits[i]
			local status = type(BuildingSettings[id][toggle_type][trait]) == "boolean" and "true" or "false"
			c = c + 1
			ItemList[c] = {
				text = trait,
				value = trait,
				hint = StringFormat("%s\n%s",str_hint:format(status),Trans(TraitPresets[trait].description)),
			}
		end
		for i = 1, #ChoGGi.Tables.OtherTraits do
			local trait = ChoGGi.Tables.OtherTraits[i]
			local status = type(BuildingSettings[id][toggle_type][trait]) == "boolean" and "true" or "false"
			c = c + 1
			ItemList[c] = {
				text = trait,
				value = trait,
				hint = StringFormat("%s\n%s",str_hint:format(status),Trans(TraitPresets[trait].description)),
			}
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
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
				MapForEach("map",sel.class,function(workplace)
					-- all three shifts
					for j = 1, #workplace.workers do
						-- workers in shifts (go through table backwards for when someone gets fired)
						for k = #workplace.workers[j], 1, -1 do
							local worker = workplace.workers[j][k]
							local block,restrict = ChoGGi.ComFuncs.RetBuildingPermissions(worker.traits,BuildingSettings[id])
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

			ChoGGi.SettingFuncs.WriteSettings()

			MsgPopup(
				StringFormat("%s: %s%s%s",S[302535920000843--[[Toggled traits--]]],#choice,check1 and " " or "",check1 and S[302535920000844--[[Fired workers--]]] or ""),
				4801--[[Workplace--]],
				default_icon
			)
		end

		local hint = {}
		if BuildingSettings[id] and BuildingSettings[id][toggle_type] then
			hint[#hint+1] = S[302535920000106--[[Current--]]]
			hint[#hint+1] = ": "
			hint[#hint+1] = StringFormat("%s,",BuildingSettings[id][toggle_type])
		end

		hint[#hint+1] = "\n\n"
		hint[#hint+1] = S[302535920000847--[[Select traits and click Ok to toggle status.--]]]
		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = StringFormat("%s %s %s %s",S[302535920000129--[[Set--]]],S[302535920000992--[[Building Traits--]]],S[302535920000846--[[For--]]],name),
			hint = ChoGGi.ComFuncs.TableConcat(hint),
			multisel = true,
			check = {
				{
					title = 302535920000848--[[Fire Workers--]],
					hint = S[302535920000849--[[Will also fire workers with the traits from all %s.--]]]:format(name),
				},
			},
		}
	end

end
