-- See LICENSE for terms

function OnMsg.ClassesGenerate()
	local Translate = ChoGGi.ComFuncs.Translate
	local RetTemplateOrClass = ChoGGi.ComFuncs.RetTemplateOrClass
	local Strings = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local c = #Actions
	local StarkFistOfRemoval = "CommonAssets/UI/Menu/AlignSel.tga"

	-- menu
	c = c + 1
	Actions[c] = {ActionName = Translate(547--[[Colonists--]]),
		ActionMenubar = "ECM.ECM",
		ActionId = ".Colonists",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Colonists",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000369--[[No More Earthsick--]]],
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".No More Earthsick",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.NoMoreEarthsick,
				Strings[302535920000370--[[Colonists will never become Earthsick (and removes any when you enable this).--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.NoMoreEarthsick_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000371--[[Traits: Restrict For Selected Building Type--]]],
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Traits: Restrict For Selected Building Type",
		ActionIcon = "CommonAssets/UI/Menu/SelectByClassName.tga",
		RolloverText = function()
			local obj = ChoGGi.ComFuncs.SelObject()
			return obj and ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".restricttraits",
				Strings[302535920000372--[[Select a building and use this to only allow workers with certain traits to work there (block will override).--]]]
			) or Strings[302535920000372]
		end,
		OnAction = ChoGGi.MenuFuncs.SetBuildingTraits,
		toggle_type = "restricttraits",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000373--[[Traits: Block For Selected Building Type--]]],
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Traits: Block For Selected Building Type",
		ActionIcon = "CommonAssets/UI/Menu/SelectByClassName.tga",
		RolloverText = function()
			local obj = ChoGGi.ComFuncs.SelObject()
			return obj and ChoGGi.ComFuncs.SettingState(
				"ChoGGi.UserSettings.BuildingSettings." .. RetTemplateOrClass(obj) .. ".blocktraits",
				Strings[302535920000374--[[Select a building and use this to block workers with certain traits from working there (overrides restrict).--]]]
			) or Strings[302535920000374]
		end,
		OnAction = ChoGGi.MenuFuncs.SetBuildingTraits,
		toggle_type = "blocktraits",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000375--[[The Soylent Option--]]],
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".The Soylent Option",
		ActionIcon = "CommonAssets/UI/Menu/Cube.tga",
		RolloverText = Strings[302535920000376--[[Turns selected/moused over colonist into food (between 1-5), or shows a list with choices.--]]],
		OnAction = ChoGGi.MenuFuncs.TheSoylentOption,
		ActionShortcut = "Ctrl-Alt-Numpad 1",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000377--[[Colonists Move Speed--]]],
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Colonists Move Speed",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.SpeedColonist,
				Strings[302535920000378--[[How fast colonists will move.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetColonistMoveSpeed,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000379--[[Add Or Remove Applicants--]]],
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Add Or Remove Applicants",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				#(g_ApplicantPool or ""),
				Strings[302535920000380--[[Add random applicants to the passenger pool (has option to remove all).--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.AddApplicantsToPool,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000381--[[Colonists Gravity--]]],
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Colonists Gravity",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.GravityColonist,
				Strings[302535920000382--[[Change gravity of Colonists.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetColonistsGravity,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000416--[[Colonists Suffocate--]]],
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Colonists Suffocate",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.OxygenMaxOutsideTime,
				Strings[302535920000417--[["Disable colonists suffocating with no oxygen.
	Works after in-game hour."--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.ColonistsSuffocate_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000418--[[Colonists Starve--]]],
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Colonists Starve",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.TimeBeforeStarving,
				Strings[302535920000419--[["Disable colonists starving with no food.
Works after colonist idle."--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.ColonistsStarve_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000424--[[Set Age New--]]],
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Set Age New",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.NewColonistAge,
				Strings[302535920000425--[[This will make all newly arrived and born colonists a certain age.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetColonistsAge,
		setting_mask = 1,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000426--[[Set Age--]]],
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Set Age",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = Strings[302535920000427--[[This will make all colonists a certain age.--]]],
		OnAction = ChoGGi.MenuFuncs.SetColonistsAge,
		setting_mask = 2,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000428--[[Set Gender New--]]],
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Set Gender New",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.NewColonistGender,
				Strings[302535920000429--[[This will make all newly arrived and born colonists a certain gender.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetColonistsGender,
		setting_mask = 1,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000430--[[Set Gender--]]],
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Set Gender",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = Strings[302535920000431--[[This will make all colonists a certain gender.--]]],
		OnAction = ChoGGi.MenuFuncs.SetColonistsGender,
		setting_mask = 2,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000432--[[Set Specialization New--]]],
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Set Specialization New",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.NewColonistSpecialization,
				Strings[302535920000433--[[This will make all newly arrived colonists a certain specialization (children and spec = black cube).--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetColonistsSpecialization,
		setting_mask = 1,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000434--[[Set Specialization--]]],
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Set Specialization",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = Strings[302535920000435--[[This will make all colonists a certain specialization.--]]],
		OnAction = ChoGGi.MenuFuncs.SetColonistsSpecialization,
		setting_mask = 2,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000436--[[Set Race New--]]],
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Set Race New",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.NewColonistRace,
				Strings[302535920000437--[[This will make all newly arrived and born colonists a certain race.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetColonistsRace,
		setting_mask = 1,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000438--[[Set Race--]]],
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Set Race",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = Strings[302535920000439--[[This will make all colonists a certain race.--]]],
		OnAction = ChoGGi.MenuFuncs.SetColonistsRace,
		setting_mask = 2,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000440--[[Set Traits New--]]],
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Set Traits New",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.NewColonistTraits,
				Strings[302535920000441--[[This will make all newly arrived and born colonists have certain traits.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetColonistsTraits,
		setting_mask = 1,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000442--[[Set Traits--]]],
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Set Traits",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = Strings[302535920000443--[[Choose traits for all colonists.--]]],
		OnAction = ChoGGi.MenuFuncs.SetColonistsTraits,
		setting_mask = 2,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000444--[[Set Stats--]]],
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Set Stats",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = Strings[302535920000445--[["Change the stats of all colonists (health/sanity/comfort/morale).

	Not permanent."--]]],
		OnAction = ChoGGi.MenuFuncs.SetColonistsStats,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000446--[[Colonist Death Age--]]],
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Colonist Death Age",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.DeathAgeColonist,
				Strings[302535920000447--[[Change the age at which colonists die (applies to newly arrived and born colonists as well).--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetDeathAge,
	}

	-- menu
	c = c + 1
	Actions[c] = {ActionName = Translate(5444--[[Workplaces--]]),
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Workplaces",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Workplaces",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000383--[[Fire All Colonists!--]]],
		ActionMenubar = "ECM.ECM.Colonists.Workplaces",
		ActionId = ".Fire All Colonists!",
		ActionIcon = "CommonAssets/UI/Menu/ToggleEnvMap.tga",
		RolloverText = Strings[302535920000384--[[Fires everyone from every job.--]]],
		OnAction = ChoGGi.MenuFuncs.FireAllColonists,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000385--[[Set All Work Shifts--]]],
		ActionMenubar = "ECM.ECM.Colonists.Workplaces",
		ActionId = ".Set All Work Shifts",
		ActionIcon = "CommonAssets/UI/Menu/ToggleEnvMap.tga",
		RolloverText = Strings[302535920000386--[[Set all shifts on or off (able to cancel).--]]],
		OnAction = ChoGGi.MenuFuncs.SetAllWorkShifts,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000387--[[Colonists Avoid Fired Workplace--]]],
		ActionMenubar = "ECM.ECM.Colonists.Workplaces",
		ActionId = ".Colonists Avoid Fired Workplace",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.AvoidWorkplaceSols,
				Strings[302535920000388--[["After being fired, Colonists won't avoid that Workplace searching for a Workplace.
	Works after colonist idle."--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.AvoidWorkplace_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000389--[[Performance Penalty Non-Specialist--]]],
		ActionMenubar = "ECM.ECM.Colonists.Workplaces",
		ActionId = ".Performance Penalty Non-Specialist",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.NonSpecialistPerformancePenalty,
				Strings[302535920000390--[["Disable performance penalty for non-Specialists.
Activated when colonist changes job."--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.PerformancePenaltyNonSpecialist_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920001446--[[Performance Penalty Connected Dome--]]],
		ActionMenubar = "ECM.ECM.Colonists.Workplaces",
		ActionId = ".Performance Penalty Connected Dome",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.NonHomeDomePerformancePenalty,
				Strings[302535920001451--[["Disable performance penalty for colonists working in another connected dome.
Activated when colonist changes job."--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.NonHomeDomePerformancePenalty_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000392--[[Outside Workplace Radius--]]],
		ActionMenubar = "ECM.ECM.Colonists.Workplaces",
		ActionId = ".Outside Workplace Radius",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
					ChoGGi.UserSettings.DefaultOutsideWorkplacesRadius,
					Strings[302535920000391--[[Change how many hexes colonists search outside their dome when looking for a Workplace.--]]]
				)
		end,
		OnAction = ChoGGi.MenuFuncs.SetOutsideWorkplaceRadius,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000393--[[Add Specialization To All--]]],
		ActionMenubar = "ECM.ECM.Colonists.Workplaces",
		ActionId = ".Add Specialization To All",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = Strings[302535920000394--[[If Colonist has no Specialization then add a random one--]]],
		OnAction = ChoGGi.MenuFuncs.ColonistsAddSpecializationToAll,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000339--[[Toggle All Shifts--]]],
		ActionMenubar = "ECM.ECM.Colonists.Workplaces",
		ActionId = ".Toggle All Shifts",
		ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
		RolloverText = Strings[302535920000340--[[Toggle all workshifts on or off (farms only get one on).--]]],
		OnAction = CheatToggleAllShifts,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000341--[[Update All Workplaces--]]],
		ActionMenubar = "ECM.ECM.Colonists.Workplaces",
		ActionId = ".Update All Workplaces",
		ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
		RolloverText = Strings[302535920000342--[[Updates all colonist's workplaces.--]]],
		OnAction = CheatUpdateAllWorkplaces,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000343--[[Clear Forced Workplaces--]]],
		ActionMenubar = "ECM.ECM.Colonists.Workplaces",
		ActionId = ".Clear Forced Workplaces",
		ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
		RolloverText = Strings[302535920000344--[["Removes ""user_forced_workplace"" from all colonists."--]]],
		OnAction = CheatClearForcedWorkplaces,
	}

	-- menu
	c = c + 1
	Actions[c] = {ActionName = Translate(5568--[[Stats--]]),
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Stats",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Stats",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000395--[[Min Comfort Birth--]]],
		ActionMenubar = "ECM.ECM.Colonists.Stats",
		ActionId = ".Min Comfort Birth",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.MinComfortBirth,
				Strings[302535920000396--[[Change the limit on birthing comfort (more/less babies).--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SetMinComfortBirth,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000397--[[Visit Fail Penalty--]]],
		ActionMenubar = "ECM.ECM.Colonists.Stats",
		ActionId = ".Visit Fail Penalty",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.VisitFailPenalty,
				Strings[302535920000398--[[Disable comfort penalty when failing to satisfy a need via a visit.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.VisitFailPenalty_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000399--[[Renegade Creation Toggle--]]],
		ActionMenubar = "ECM.ECM.Colonists.Stats",
		ActionId = ".Renegade Creation Toggle",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.RenegadeCreation,
				Strings[302535920000400--[["Disable creation of renegades.
	Works after daily update."--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.RenegadeCreation_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000401--[[Set Renegade Status--]]],
		ActionMenubar = "ECM.ECM.Colonists.Stats",
		ActionId = ".Set Renegade Status",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = Strings[302535920000448--[[I'm afraid it could be 9/11 times 1,000.--]]],
		OnAction = ChoGGi.MenuFuncs.SetRenegadeStatus,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000402--[[Morale Always Max--]]],
		ActionMenubar = "ECM.ECM.Colonists.Stats",
		ActionId = ".Morale Always Max",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.HighStatLevel,
				Strings[302535920000403--[["Colonists always max morale (will effect birthing rates).
	Only works on colonists that have yet to spawn (maybe)."--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.ColonistsMoraleAlwaysMax_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000404--[[See Dead Sanity Damage--]]],
		ActionMenubar = "ECM.ECM.Colonists.Stats",
		ActionId = ".See Dead Sanity Damage",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.SeeDeadSanity,
				Strings[302535920000405--[["Disable colonists taking sanity damage from seeing dead.
	Works after in-game hour."--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.SeeDeadSanityDamage_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000406--[[No Home Comfort Damage--]]],
		ActionMenubar = "ECM.ECM.Colonists.Stats",
		ActionId = ".No Home Comfort Damage",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.NoHomeComfort,
				Strings[302535920000407--[["Disable colonists taking comfort damage from not having a home.
	Works after in-game hour."--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.NoHomeComfortDamage_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000408--[[Chance Of Sanity Damage--]]],
		ActionMenubar = "ECM.ECM.Colonists.Stats",
		ActionId = ".Chance Of Sanity Damage",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.DustStormSanityDamage,
				Strings[302535920000409--[["Disable colonists taking sanity damage from certain events.
	Works after in-game hour."--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.ChanceOfSanityDamage_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Translate(4576--[[Chance Of Suicide--]]),
		ActionMenubar = "ECM.ECM.Colonists.Stats",
		ActionId = ".Chance Of Suicide",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.LowSanitySuicideChance,
				Strings[302535920000415--[["Disable chance of suicide when Sanity reaches zero.
	Works after colonist idle."--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.ColonistsChanceOfSuicide_Toggle,
	}

	-- menu
	c = c + 1
	Actions[c] = {ActionName = Translate(235--[[Traits--]]),
		ActionMenubar = "ECM.ECM.Colonists",
		ActionId = ".Traits",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Traits",
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000410--[[University Grad Remove Idiot--]]],
		ActionMenubar = "ECM.ECM.Colonists.Traits",
		ActionId = ".University Grad Remove Idiot",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.UniversityGradRemoveIdiotTrait,
				Strings[302535920000411--[[When colonist graduates this will remove idiot trait.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.UniversityGradRemoveIdiotTrait_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000412--[[Chance Of Negative Trait--]]],
		ActionMenubar = "ECM.ECM.Colonists.Traits",
		ActionId = ".Chance Of Negative Trait",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.LowSanityNegativeTraitChance,
				Strings[302535920000413--[["isable chance of getting a negative trait when Sanity reaches zero.
	Works after colonist idle."--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.ChanceOfNegativeTrait_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000420--[[Positive Playground--]]],
		ActionMenubar = "ECM.ECM.Colonists.Traits",
		ActionId = ".Positive Playground",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.positive_playground_chance,
				Strings[302535920000421--[[100% Chance to get a perk (when grown) if colonist has visited a playground as a child.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.PositivePlayground_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = Strings[302535920000422--[[Project Morpheus Positive Trait--]]],
		ActionMenubar = "ECM.ECM.Colonists.Traits",
		ActionId = ".Project Morpheus Positive Trait",
		ActionIcon = StarkFistOfRemoval,
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.ProjectMorphiousPositiveTraitChance,
				Strings[302535920000423--[[100% Chance to get positive trait when Resting and ProjectMorpheus is active.--]]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.ProjectMorpheusPositiveTrait_Toggle,
	}

end
