-- See LICENSE for terms

local S = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions
local StarkFistOfRemoval = "CommonAssets/UI/Menu/AlignSel.tga"
local c = #Actions

local str_ExpandedCM_Colonists = "Expanded CM.Colonists"
c = c + 1
Actions[c] = {
	ActionMenubar = "Expanded CM",
	ActionName = string.format("%s ..",S[547--[[Colonists--]]]),
	ActionId = ".Colonists",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Colonists",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists,
	ActionName = S[302535920000369--[[No More Earthsick--]]],
	ActionId = ".No More Earthsick",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.NoMoreEarthsick,
			302535920000370--[[Colonists will never become Earthsick (and removes any when you enable this).--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.NoMoreEarthsick_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists,
	ActionName = S[302535920000371--[[Traits: Restrict For Selected Building Type--]]],
	ActionId = ".Traits: Restrict For Selected Building Type",
	ActionIcon = "CommonAssets/UI/Menu/SelectByClassName.tga",
	RolloverText = S[302535920000372--[[Select a building and use this to only allow workers with certain traits to work there (block overrides).--]]],
	OnAction = function()
		ChoGGi.MenuFuncs.SetBuildingTraits("restricttraits")
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists,
	ActionName = S[302535920000373--[[Traits: Block For Selected Building Type--]]],
	ActionId = ".Traits: Block For Selected Building Type",
	ActionIcon = "CommonAssets/UI/Menu/SelectByClassName.tga",
	RolloverText = S[302535920000374--[[Select a building and use this to block workers with certain traits from working there (overrides restrict).--]]],
	OnAction = function()
		ChoGGi.MenuFuncs.SetBuildingTraits("blocktraits")
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists,
	ActionName = S[302535920000375--[[The Soylent Option--]]],
	ActionId = ".The Soylent Option",
	ActionIcon = "CommonAssets/UI/Menu/Cube.tga",
	RolloverText = S[302535920000376--[[Turns selected/moused over colonist into food (between 1-5), or shows a list with choices.--]]],
	OnAction = ChoGGi.MenuFuncs.TheSoylentOption,
	ActionShortcut = ChoGGi.Defaults.KeyBindings.TheSoylentOption,
	ActionBindable = true,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists,
	ActionName = S[302535920000377--[[Colonists Move Speed--]]],
	ActionId = ".Colonists Move Speed",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.SpeedColonist,
			302535920000378--[[How fast colonists will move.--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetColonistMoveSpeed,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists,
	ActionName = S[302535920000379--[[Add Or Remove Applicants--]]],
	ActionId = ".Add Or Remove Applicants",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = S[302535920000380--[[Add random applicants to the passenger pool (has option to remove all).--]]],
	OnAction = ChoGGi.MenuFuncs.AddApplicantsToPool,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists,
	ActionName = S[302535920000381--[[Colonists Gravity--]]],
	ActionId = ".Colonists Gravity",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.GravityColonist,
			302535920000382--[[Change gravity of Colonists.--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetColonistsGravity,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists,
	ActionName = S[302535920000416--[[Colonists Suffocate--]]],
	ActionId = ".Colonists Suffocate",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.OxygenMaxOutsideTime,
			302535920000417--[["Disable colonists suffocating with no oxygen.
Works after in-game hour."--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.ColonistsSuffocate_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists,
	ActionName = S[302535920000418--[[Colonists Starve--]]],
	ActionId = ".Colonists Starve",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.TimeBeforeStarving,
			302535920000419--[["Disable colonists starving with no food.
Works after colonist idle."--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.ColonistsStarve_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists,
	ActionName = S[302535920000424--[[Set Age New--]]],
	ActionId = ".Set Age New",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.NewColonistAge,
			302535920000425--[[This will make all newly arrived and born colonists a certain age.--]]
		)
	end,
	OnAction = function()
		ChoGGi.MenuFuncs.SetColonistsAge(1)
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists,
	ActionName = S[302535920000426--[[Set Age--]]],
	ActionId = ".Set Age",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = S[302535920000427--[[This will make all colonists a certain age.--]]],
	OnAction = function()
		ChoGGi.MenuFuncs.SetColonistsAge(2)
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists,
	ActionName = S[302535920000428--[[Set Gender New--]]],
	ActionId = ".Set Gender New",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.NewColonistGender,
			302535920000429--[[This will make all newly arrived and born colonists a certain gender.--]]
		)
	end,
	OnAction = function()
		ChoGGi.MenuFuncs.SetColonistsGender(1)
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists,
	ActionName = S[302535920000430--[[Set Gender--]]],
	ActionId = ".Set Gender",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = S[302535920000431--[[This will make all colonists a certain gender.--]]],
	OnAction = function()
		ChoGGi.MenuFuncs.SetColonistsGender(2)
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists,
	ActionName = S[302535920000432--[[Set Specialization New--]]],
	ActionId = ".Set Specialization New",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.NewColonistSpecialization,
			302535920000433--[[This will make all newly arrived colonists a certain specialization (children and spec = black cube).--]]
		)
	end,
	OnAction = function()
		ChoGGi.MenuFuncs.SetColonistsSpecialization(1)
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists,
	ActionName = S[302535920000434--[[Set Specialization--]]],
	ActionId = ".Set Specialization",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = S[302535920000435--[[This will make all colonists a certain specialization.--]]],
	OnAction = function()
		ChoGGi.MenuFuncs.SetColonistsSpecialization(2)
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists,
	ActionName = S[302535920000436--[[Set Race New--]]],
	ActionId = ".Set Race New",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.NewColonistRace,
			302535920000437--[[This will make all newly arrived and born colonists a certain race.--]]
		)
	end,
	OnAction = function()
		ChoGGi.MenuFuncs.SetColonistsRace(1)
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists,
	ActionName = S[302535920000438--[[Set Race--]]],
	ActionId = ".Set Race",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = S[302535920000439--[[This will make all colonists a certain race.--]]],
	OnAction = function()
		ChoGGi.MenuFuncs.SetColonistsRace(2)
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists,
	ActionName = S[302535920000440--[[Set Traits New--]]],
	ActionId = ".Set Traits New",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.NewColonistTraits,
			302535920000441--[[This will make all newly arrived and born colonists have certain traits.--]]
		)
	end,
	OnAction = function()
		ChoGGi.MenuFuncs.SetColonistsTraits(1)
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists,
	ActionName = S[302535920000442--[[Set Traits--]]],
	ActionId = ".Set Traits",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = S[302535920000443--[[Choose traits for all colonists.--]]],
	OnAction = function()
		ChoGGi.MenuFuncs.SetColonistsTraits(2)
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists,
	ActionName = S[302535920000444--[[Set Stats--]]],
	ActionId = ".Set Stats",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = S[302535920000445--[["Change the stats of all colonists (health/sanity/comfort/morale).

Not permanent."--]]],
	OnAction = ChoGGi.MenuFuncs.SetColonistsStats,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists,
	ActionName = S[302535920000446--[[Colonist Death Age--]]],
	ActionId = ".Colonist Death Age",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.DeathAgeColonist,
			302535920000447--[[Change the age at which colonists die (applies to newly arrived and born colonists as well).--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetDeathAge,
}

local str_ExpandedCM_Colonists_Work = "Expanded CM.Colonists.Work"
c = c + 1
Actions[c] = {
	ActionMenubar = "Expanded CM.Colonists",
	ActionName = string.format("%s ..",S[302535920000212--[[Work--]]]),
	ActionId = ".Work",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Work",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists_Work,
	ActionName = S[302535920000383--[[Fire All Colonists!--]]],
	ActionId = ".Fire All Colonists!",
	ActionIcon = "CommonAssets/UI/Menu/ToggleEnvMap.tga",
	RolloverText = S[302535920000384--[[Fires everyone from every job.--]]],
	OnAction = ChoGGi.MenuFuncs.FireAllColonists,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists_Work,
	ActionName = S[302535920000385--[[Set All Work Shifts--]]],
	ActionId = ".Set All Work Shifts",
	ActionIcon = "CommonAssets/UI/Menu/ToggleEnvMap.tga",
	RolloverText = S[302535920000386--[[Set all shifts on or off (able to cancel).--]]],
	OnAction = ChoGGi.MenuFuncs.SetAllWorkShifts,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists_Work,
	ActionName = S[302535920000387--[[Colonists Avoid Fired Workplace--]]],
	ActionId = ".Colonists Avoid Fired Workplace",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.AvoidWorkplaceSols,
			302535920000388--[["After being fired, Colonists won't avoid that Workplace searching for a Workplace.
Works after colonist idle."--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.AvoidWorkplace_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists_Work,
	ActionName = S[302535920000389--[[Performance Penalty Non-Specialist--]]],
	ActionId = ".Performance Penalty Non-Specialist",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.NonSpecialistPerformancePenalty,
			302535920000390--[["Disable performance penalty for non-Specialists.
Activated when colonist changes job."--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.PerformancePenaltyNonSpecialist_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists_Work,
	ActionName = S[302535920000392--[[Outside Workplace Radius--]]],
	ActionId = ".Outside Workplace Radius",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.DefaultOutsideWorkplacesRadius,
				302535920000391--[[Change how many hexes colonists search outside their dome when looking for a Workplace.--]]
			)
	end,
	OnAction = ChoGGi.MenuFuncs.SetOutsideWorkplaceRadius,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists_Work,
	ActionName = S[302535920000393--[[Add Specialization To All--]]],
	ActionId = ".Add Specialization To All",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = S[302535920000394--[[If Colonist has no Specialization then add a random one--]]],
	OnAction = ChoGGi.MenuFuncs.ColonistsAddSpecializationToAll,
}

local str_ExpandedCM_Colonists_Stats = "Expanded CM.Colonists.Stats"
c = c + 1
Actions[c] = {
	ActionMenubar = "Expanded CM.Colonists",
	ActionName = string.format("%s ..",S[5568--[[Stats--]]]),
	ActionId = ".Stats",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Stats",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists_Stats,
	ActionName = S[302535920000395--[[Min Comfort Birth--]]],
	ActionId = ".Min Comfort Birth",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.MinComfortBirth,
			302535920000396--[[Change the limit on birthing comfort (more/less babies).--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetMinComfortBirth,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists_Stats,
	ActionName = S[302535920000397--[[Visit Fail Penalty--]]],
	ActionId = ".Visit Fail Penalty",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.VisitFailPenalty,
			302535920000398--[[Disable comfort penalty when failing to satisfy a need via a visit.--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.VisitFailPenalty_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists_Stats,
	ActionName = S[302535920000399--[[Renegade Creation Toggle--]]],
	ActionId = ".Renegade Creation Toggle",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.RenegadeCreation,
			302535920000400--[["Disable creation of renegades.
Works after daily update."--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.RenegadeCreation_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists_Stats,
	ActionName = S[302535920000401--[[Set Renegade Status--]]],
	ActionId = ".Set Renegade Status",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = S[302535920000448--[[I'm afraid it could be 9/11 times 1,000.--]]],
	OnAction = ChoGGi.MenuFuncs.SetRenegadeStatus,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists_Stats,
	ActionName = S[302535920000402--[[Morale Always Max--]]],
	ActionId = ".Morale Always Max",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.HighStatLevel,
			302535920000403--[["Colonists always max morale (will effect birthing rates).
Only works on colonists that have yet to spawn (maybe)."--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.ColonistsMoraleAlwaysMax_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists_Stats,
	ActionName = S[302535920000404--[[See Dead Sanity Damage--]]],
	ActionId = ".See Dead Sanity Damage",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.SeeDeadSanity,
			302535920000405--[["Disable colonists taking sanity damage from seeing dead.
Works after in-game hour."--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SeeDeadSanityDamage_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists_Stats,
	ActionName = S[302535920000406--[[No Home Comfort Damage--]]],
	ActionId = ".No Home Comfort Damage",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.NoHomeComfort,
			302535920000407--[["Disable colonists taking comfort damage from not having a home.
Works after in-game hour."--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.NoHomeComfortDamage_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists_Stats,
	ActionName = S[302535920000408--[[Chance Of Sanity Damage--]]],
	ActionId = ".Chance Of Sanity Damage",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.DustStormSanityDamage,
			302535920000409--[["Disable colonists taking sanity damage from certain events.
Works after in-game hour."--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.ChanceOfSanityDamage_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists_Stats,
	ActionName = S[4576--[[Chance Of Suicide--]]],
	ActionId = ".Chance Of Suicide",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.LowSanitySuicideChance,
			302535920000415--[["Disable chance of suicide when Sanity reaches zero.
Works after colonist idle."--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.ColonistsChanceOfSuicide_Toggle,
}

local str_ExpandedCM_Colonists_Traits = "Expanded CM.Colonists.Traits"
c = c + 1
Actions[c] = {
	ActionMenubar = "Expanded CM.Colonists",
	ActionName = string.format("%s ..",S[235--[[Traits--]]]),
	ActionId = ".Traits",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Traits",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists_Traits,
	ActionName = S[302535920000410--[[University Grad Remove Idiot--]]],
	ActionId = ".University Grad Remove Idiot",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.UniversityGradRemoveIdiotTrait,
			302535920000411--[[When colonist graduates this will remove idiot trait.--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.UniversityGradRemoveIdiotTrait_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists_Traits,
	ActionName = S[302535920000412--[[Chance Of Negative Trait--]]],
	ActionId = ".Chance Of Negative Trait",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.LowSanityNegativeTraitChance,
			302535920000413--[["isable chance of getting a negative trait when Sanity reaches zero.
Works after colonist idle."--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.ChanceOfNegativeTrait_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists_Traits,
	ActionName = S[302535920000420--[[Positive Playground--]]],
	ActionId = ".Positive Playground",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.positive_playground_chance,
			302535920000421--[[100% Chance to get a perk (when grown) if colonist has visited a playground as a child.--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.PositivePlayground_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Colonists_Traits,
	ActionName = S[302535920000422--[[Project Morpheus Positive Trait--]]],
	ActionId = ".Project Morpheus Positive Trait",
	ActionIcon = StarkFistOfRemoval,
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.ProjectMorphiousPositiveTraitChance,
			302535920000423--[[100% Chance to get positive trait when Resting and ProjectMorpheus is active.--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.ProjectMorpheusPositiveTrait_Toggle,
}
