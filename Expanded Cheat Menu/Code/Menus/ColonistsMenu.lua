-- See LICENSE for terms

if ChoGGi.what_game ~= "Mars" then
	return
end

local ChoGGi_Funcs = ChoGGi_Funcs
local T = T
local Translate = ChoGGi_Funcs.Common.Translate
local SettingState = ChoGGi_Funcs.Common.SettingState
local RetTemplateOrClass = ChoGGi_Funcs.Common.RetTemplateOrClass
local Actions = ChoGGi.Temp.Actions
local c = #Actions
local StarkFistOfRemoval = "CommonAssets/UI/Menu/AlignSel.tga"

-- menu
c = c + 1
Actions[c] = {ActionName = T(547--[[Colonists]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Colonists",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000369--[[No More Earthsick]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".No More Earthsick",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.NoMoreEarthsick,
			T(302535920000370--[[Colonists will never become Earthsick (and removes any when you enable this).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.NoMoreEarthsick_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000371--[[Traits: Restrict For Selected Building Type]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".Traits: Restrict For Selected Building Type",
	ActionIcon = "CommonAssets/UI/Menu/SelectByClassName.tga",
	RolloverText = function()
		local obj = SelectedObj
		return obj and SettingState(
			"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".restricttraits",
			T(302535920000372--[[Select a building and use this to only allow workers with certain traits to work there (block will override).]])
		) or T(302535920000372)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetBuildingTraits,
	toggle_type = "restricttraits",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000373--[[Traits: Block For Selected Building Type]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".Traits: Block For Selected Building Type",
	ActionIcon = "CommonAssets/UI/Menu/SelectByClassName.tga",
	RolloverText = function()
		local obj = SelectedObj
		return obj and SettingState(
			"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".blocktraits",
			T(302535920000374--[[Select a building and use this to block workers with certain traits from working there (overrides restrict).]])
		) or T(302535920000374)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetBuildingTraits,
	toggle_type = "blocktraits",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000375--[[The Soylent Option]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".The Soylent Option",
	ActionIcon = "CommonAssets/UI/Menu/Cube.tga",
	RolloverText = T(302535920000376--[[Turns selected/moused over colonist into food (between 1-5), or shows a list with choices.]]),
	OnAction = ChoGGi_Funcs.Menus.TheSoylentOption,
	ActionShortcut = "Ctrl-Alt-Numpad 1",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000377--[[Colonists Move Speed]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".Colonists Move Speed",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.SpeedColonist,
			T(302535920000378--[[How fast colonists will move.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetColonistMoveSpeed,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000379--[[Add Or Remove Applicants]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".Add Or Remove Applicants",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			#(g_ApplicantPool or ""),
			T(302535920000380--[[Add random applicants to the passenger pool (has option to remove all).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.AddApplicantsToPool,
}

c = c + 1
Actions[c] = {ActionName = T(4565--[[Oxygen max outside time]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".Oxygen max outside time",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.OxygenMaxOutsideTime,
			T(4564--[[This is the time it takes for Colonists outside of Domes to start losing health]])
				.. "\n" .. T(302535920000405--[[Works after in-game hour.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.ColonistsSuffocate_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000418--[[Colonists Starve]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".Colonists Starve",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.TimeBeforeStarving,
			T(4760--[[Time before starting to starve]])
				.. "\n" .. T(302535920000388--[[Works after colonist idle.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.ColonistsStarve_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000424--[[Set Age New]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".Set Age New",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.NewColonistAge,
			T(302535920000425--[[This will make all newly arrived and born colonists a certain age.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetColonistsAge,
	setting_mask = 1,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000426--[[Set Age]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".Set Age",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = T(302535920000427--[[This will make all colonists a certain age.]]),
	OnAction = ChoGGi_Funcs.Menus.SetColonistsAge,
	setting_mask = 2,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000428--[[Set Gender New]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".Set Gender New",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.NewColonistGender,
			T(302535920000429--[[This will make all newly arrived and born colonists a certain gender.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetColonistsGender,
	setting_mask = 1,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000430--[[Set Gender]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".Set Gender",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = T(302535920000431--[[This will make all colonists a certain gender.]]),
	OnAction = ChoGGi_Funcs.Menus.SetColonistsGender,
	setting_mask = 2,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000432--[[Set Specialization New]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".Set Specialization New",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.NewColonistSpecialization,
			T(302535920000433--[[This will make all newly arrived colonists a certain specialization (children and spec = black cube).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetColonistsSpecialization,
	setting_mask = 1,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000434--[[Set Specialization]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".Set Specialization",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = T(302535920000435--[[This will make all colonists a certain specialization.]]),
	OnAction = ChoGGi_Funcs.Menus.SetColonistsSpecialization,
	setting_mask = 2,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000436--[[Set Race New]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".Set Race New",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.NewColonistRace,
			T(302535920000437--[[This will make all newly arrived and born colonists a certain race.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetColonistsRace,
	setting_mask = 1,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000438--[[Set Race]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".Set Race",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = T(302535920000439--[[This will make all colonists a certain race.]]),
	OnAction = ChoGGi_Funcs.Menus.SetColonistsRace,
	setting_mask = 2,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000440--[[Set Traits New]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".Set Traits New",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.NewColonistTraits,
			T(302535920000441--[[This will make all newly arrived and born colonists have certain traits.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetColonistsTraits,
	setting_mask = 1,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000442--[[Set Traits]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".Set Traits",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = T(302535920000443--[[Choose traits for all colonists.]]),
	OnAction = ChoGGi_Funcs.Menus.SetColonistsTraits,
	setting_mask = 2,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000836--[[Set Stats Of All Colonists]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".Set Stats Of All Colonists",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = T(302535920000445--[["Change the stats of all colonists (health/sanity/comfort/morale).

Not permanent."]]),
	OnAction = ChoGGi_Funcs.Menus.SetColonistsStats,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000446--[[Colonist Death Age]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".Colonist Death Age",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DeathAgeColonist,
			T(302535920000447--[[Change the age at which colonists die (applies to newly arrived and born colonists as well).]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetDeathAge,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(5444--[[Workplaces]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".Workplaces",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Workplaces",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000383--[[Fire All Colonists!]]),
	ActionMenubar = "ECM.ECM.Colonists.Workplaces",
	ActionId = ".Fire All Colonists!",
	ActionIcon = "CommonAssets/UI/Menu/ToggleEnvMap.tga",
	RolloverText = T(302535920000384--[[Fires everyone from every job.]]),
	OnAction = ChoGGi_Funcs.Menus.FireAllColonists,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000385--[[Set All Work Shifts]]),
	ActionMenubar = "ECM.ECM.Colonists.Workplaces",
	ActionId = ".Set All Work Shifts",
	ActionIcon = "CommonAssets/UI/Menu/ToggleEnvMap.tga",
	RolloverText = T(302535920000386--[[Set all shifts on or off (able to cancel).]]),
	OnAction = ChoGGi_Funcs.Menus.SetAllWorkShifts,
}

c = c + 1
Actions[c] = {ActionName = T(4689--[[Avoid Workplace Sols]]),
	ActionMenubar = "ECM.ECM.Colonists.Workplaces",
	ActionId = ".Avoid Workplace Sols",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.AvoidWorkplaceSols,
			T(4688--[[After being fired, Colonists will avoid that Workplace for this many days when searching for a Workplace]])
				.. "\n" .. T(302535920000388--[[Works after colonist idle.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.AvoidWorkplace_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(4741--[[Non-specialist performance penalty]]),
	ActionMenubar = "ECM.ECM.Colonists.Workplaces",
	ActionId = ".Non-specialist performance penalty",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.NonSpecialistPerformancePenalty,
			T(4740--[[Performance penalty for non-Specialists assigned to a specialized work position]])
				.. "\n" .. T(302535920000390--[[Activated when colonist changes job.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.PerformancePenaltyNonSpecialist_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(8806--[[Connected dome performance penalty]]),
	ActionMenubar = "ECM.ECM.Colonists.Workplaces",
	ActionId = ".Connected dome performance penalty",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.NonHomeDomePerformancePenalty,
			T(8805--[[TPerformance penalty for colonists working in another connected dome]])
				.. "\n" .. T(302535920000390--[[Activated when colonist changes job.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.NonHomeDomePerformancePenalty_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(4572--[[Outside Workplace Sanity Penalty]]),
	ActionMenubar = "ECM.ECM.Colonists.Workplaces",
	ActionId = ".Outside Workplace Sanity Penalty",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.OutsideWorkplaceSanityDecrease,
			T(302535920001590--[["Remove the ""Worked outside the Dome"" penalty."]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.OutsideWorkplaceSanityDecrease_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(4691--[[Default outside Workplaces radius]]),
	ActionMenubar = "ECM.ECM.Colonists.Workplaces",
	ActionId = ".Default outside Workplaces radius",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
				ChoGGi.UserSettings.DefaultOutsideWorkplacesRadius,
				T(4690--[[Colonists search this far (in hexes) outisde their Dome when looking for a Workplace]])
			)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetOutsideWorkplaceRadius,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000393--[[Add Specialization To All]]),
	ActionMenubar = "ECM.ECM.Colonists.Workplaces",
	ActionId = ".Add Specialization To All",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = T(302535920000394--[[If Colonist has no Specialization then add a random one]]),
	OnAction = ChoGGi_Funcs.Menus.ColonistsAddSpecializationToAll,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000339--[[Toggle All Shifts]]),
	ActionMenubar = "ECM.ECM.Colonists.Workplaces",
	ActionId = ".Toggle All Shifts",
	ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
	RolloverText = T(302535920000340--[[Toggle all workshifts on or off (farms only get one on).]]),
	OnAction = CheatToggleAllShifts,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000341--[[Update All Workplaces]]),
	ActionMenubar = "ECM.ECM.Colonists.Workplaces",
	ActionId = ".Update All Workplaces",
	ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
	RolloverText = T(302535920000342--[[Updates all colonist's workplaces.]]),
	OnAction = CheatUpdateAllWorkplaces,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000343--[[Clear Forced Workplaces]]),
	ActionMenubar = "ECM.ECM.Colonists.Workplaces",
	ActionId = ".Clear Forced Workplaces",
	ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
	RolloverText = T(302535920000344--[["Removes ""user_forced_workplace"" from all colonists."]]),
	OnAction = CheatClearForcedWorkplaces,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(5568--[[Stats]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".Stats",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Stats",
}

c = c + 1
Actions[c] = {ActionName = T(7425--[[Minimum Colonist Comfort for Birth]]),
	ActionMenubar = "ECM.ECM.Colonists.Stats",
	ActionId = ".Minimum Colonist Comfort for Birth",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.MinComfortBirth,
			T(7424--[[Minimum Colonist Comfort for Birth]])
				.. "\n" .. T(302535920000400--[[Works after daily update.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SetMinComfortBirth,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000397--[[Visit Fail Penalty]]),
	ActionMenubar = "ECM.ECM.Colonists.Stats",
	ActionId = ".Visit Fail Penalty",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.VisitFailPenalty,
			T(4763--[[Comfort penalty when failing to satisfy a need via a visit]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.VisitFailPenalty_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000399--[[Renegade Creation Toggle]]),
	ActionMenubar = "ECM.ECM.Colonists.Stats",
	ActionId = ".Renegade Creation Toggle",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.RenegadeCreation,
			T(302535920001589--[[Disable creation of renegades.]])
				.. "\n" .. T(302535920000400--[[Works after daily update.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.RenegadeCreation_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000401--[[Set Renegade Status]]),
	ActionMenubar = "ECM.ECM.Colonists.Stats",
	ActionId = ".Set Renegade Status",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = T(302535920000448--[[I'm afraid it could be 9/11 times 1, 000.]]),
	OnAction = ChoGGi_Funcs.Menus.SetRenegadeStatus,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000402--[[Morale Always Max]]),
	ActionMenubar = "ECM.ECM.Colonists.Stats",
	ActionId = ".Morale Always Max",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.HighStatLevel,
			T(302535920000403--[["Colonists always max morale (will effect birthing rates).
Only works on colonists that have yet to spawn (maybe)."]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.ColonistsMoraleAlwaysMax_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(4561--[[Seeing Death]]),
	ActionMenubar = "ECM.ECM.Colonists.Stats",
	ActionId = ".Seeing Death",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.SeeDeadSanity,
			T(4560--[[Colonist Sanity decreases when a Colonist from the same Residence dies from non-natural causes]])
				.. "\n" .. T(302535920000405--[[Works after in-game hour.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.SeeDeadSanityDamage_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(4559--[[Homeless Comfort Penalty]]),
	ActionMenubar = "ECM.ECM.Colonists.Stats",
	ActionId = ".Homeless Comfort Penalty",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.NoHomeComfort,
			T(4558--[[Colonist Comfort decreases when homeless]])
				.. "\n" .. T(302535920000405--[[Works after in-game hour.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.NoHomeComfortDamage_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000408--[[Chance Of Sanity Damage]]),
	ActionMenubar = "ECM.ECM.Colonists.Stats",
	ActionId = ".Chance Of Sanity Damage",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DustStormSanityDamage,
			T(302535920000409--[[Disable colonists taking sanity damage from certain events.]])
				.. "\n" .. T(302535920000405--[[Works after in-game hour.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.ChanceOfSanityDamage_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(4576--[[Chance Of Suicide]]),
	ActionMenubar = "ECM.ECM.Colonists.Stats",
	ActionId = ".Chance Of Suicide",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.LowSanitySuicideChance,
			T(4575--[[Chance of suicide when Sanity reaches zero, in %]])
				.. "\n" .. T(302535920000388--[[Works after colonist idle.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.ColonistsChanceOfSuicide_Toggle,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(235--[[Traits]]),
	ActionMenubar = "ECM.ECM.Colonists",
	ActionId = ".Traits",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Traits",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000410--[[University Grad Remove Idiot]]),
	ActionMenubar = "ECM.ECM.Colonists.Traits",
	ActionId = ".University Grad Remove Idiot",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.UniversityGradRemoveIdiotTrait,
			T(302535920000411--[[When colonist graduates this will remove idiot trait.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.UniversityGradRemoveIdiotTrait_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000412--[[Chance Of Negative Trait]]),
	ActionMenubar = "ECM.ECM.Colonists.Traits",
	ActionId = ".Chance Of Negative Trait",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.LowSanityNegativeTraitChance,
			T(4577--[[Chance of getting a negative trait when Sanity reaches zero, in %]])
				.. "\n" .. T(302535920000388--[[Works after colonist idle.]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.ChanceOfNegativeTrait_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000420--[[Positive Playground]]),
	ActionMenubar = "ECM.ECM.Colonists.Traits",
	ActionId = ".Positive Playground",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.positive_playground_chance,
			T(4754--[[Colonist's chance to get a Perk when grown if they\226\128\153ve visited a playground as a child]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.PositivePlayground_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(580388115170--[[ProjectMorpheusPositiveTraitChance]]),
	ActionMenubar = "ECM.ECM.Colonists.Traits",
	ActionId = ".ProjectMorpheusPositiveTraitChance",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.ProjectMorphiousPositiveTraitChance,
			T(603743631388--[[Chance to get positive trait when Resting and ProjectMorpheus is active]])
		)
	end,
	OnAction = ChoGGi_Funcs.Menus.ProjectMorpheusPositiveTrait_Toggle,
}
