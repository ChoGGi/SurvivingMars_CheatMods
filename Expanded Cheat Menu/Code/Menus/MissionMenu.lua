-- See LICENSE for terms

if ChoGGi.what_game ~= "Mars" then
	return
end

local T = T
local Translate = ChoGGi.ComFuncs.Translate
local SettingState = ChoGGi.ComFuncs.SettingState
local Actions = ChoGGi.Temp.Actions
local c = #Actions

-- menu
c = c + 1
Actions[c] = {ActionName = T(1635--[[Mission]]),
	ActionMenubar = "ECM.ECM",
	ActionId = ".Mission",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
}

c = c + 1
Actions[c] = {ActionName = T(11034--[[Rival Colonies]]),
	ActionMenubar = "ECM.ECM.Mission",
	ActionId = ".Rival Colonies",
	ActionIcon = "CommonAssets/UI/Menu/add_water.tga",
	RolloverText = T(302535920001460--[[Add/remove rival colonies.]]),
	OnAction = ChoGGi.MenuFuncs.ChangeRivalColonies,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000704--[[Instant Mission Goals]]),
	ActionMenubar = "ECM.ECM.Mission",
	ActionId = ".Instant Mission Goals",
	ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
	RolloverText = T(302535920000705--[[Shows list of mission goals and allows you to pass any of them.]]),
	OnAction = ChoGGi.MenuFuncs.InstantMissionGoals,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000706--[[Instant Colony Approval]]),
	ActionMenubar = "ECM.ECM.Mission",
	ActionId = ".Instant Colony Approval",
	ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
	RolloverText = T(302535920000707--[[Make your colony instantly approved (can be called before you summon your first victims).]]),
	OnAction = ChoGGi.MenuFuncs.InstantColonyApproval,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000710--[[Change Logo]]),
	ActionMenubar = "ECM.ECM.Mission",
	ActionId = ".Change Logo",
	ActionIcon = "CommonAssets/UI/Menu/ViewArea.tga",
	RolloverText = function()
		return SettingState(
			g_CurrentMissionParams.idMissionLogo,
			T(302535920000711--[[Change the logo for anything that uses the logo.]])
		)
	end,
	OnAction = ChoGGi.MenuFuncs.ChangeGameLogo,
}

c = c + 1
Actions[c] = {ActionName = T(302535920000712--[[Set Sponsor]]),
	ActionMenubar = "ECM.ECM.Mission",
	ActionId = ".Set Sponsor",
	ActionIcon = "CommonAssets/UI/Menu/SelectByClassName.tga",
	RolloverText = function()
		return SettingState(
			g_CurrentMissionParams.idMissionSponsor,
			T(302535920000713--[[Switch to a different sponsor.]])
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetSponsor,
	ActionSortKey = "21",
}

--~ c = c + 1
--~ Actions[c] = {ActionName = T(302535920000714--[[Set Bonuses Sponsor]]),
--~ 	ActionMenubar = "ECM.ECM.Mission",
--~ 	ActionId = ".Set Bonuses Sponsor",
--~ 	ActionIcon = "CommonAssets/UI/Menu/EV_OpenFromInputBox.tga",
--~ 	RolloverText = T(302535920000715--[[Applies the good effects only (no drawbacks).

--~ (if value already exists; set to larger amount).
--~ restart to set disabled.]]),
--~ 	OnAction = ChoGGi.MenuFuncs.SetSponsorBonus,
--~ 	ActionSortKey = "22",
--~ }

c = c + 1
Actions[c] = {ActionName = T(302535920000716--[[Set Commander]]),
	ActionMenubar = "ECM.ECM.Mission",
	ActionId = ".Set Commander",
	ActionIcon = "CommonAssets/UI/Menu/SetCamPos&Loockat.tga",
	RolloverText = function()
		return SettingState(
			g_CurrentMissionParams.idCommanderProfile,
			T(302535920000717--[[Switch to a different commander.]])
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetCommander,
	ActionSortKey = "23",
}

--~ c = c + 1
--~ Actions[c] = {ActionName = T(302535920000718--[[Set Bonuses Commander]]),
--~ 	ActionMenubar = "ECM.ECM.Mission",
--~ 	ActionId = ".Set Bonuses Commander",
--~ 	ActionIcon = "CommonAssets/UI/Menu/EV_OpenFromInputBox.tga",
--~ 	RolloverText = T(302535920000715--[[Applies the good effects only (no drawbacks).

--~ (if value already exists; set to larger amount).
--~ restart to set disabled.]]),
--~ 	OnAction = ChoGGi.MenuFuncs.SetCommanderBonus,
--~ 	ActionSortKey = "24",
--~ }

c = c + 1
Actions[c] = {ActionName = T(8800--[[Game Rules]]),
	ActionMenubar = "ECM.ECM.Mission",
	ActionId = ".Game Rules",
	ActionIcon = "CommonAssets/UI/Menu/ListCollections.tga",
	RolloverText = T(302535920000965--[["Change the ""Game Rules""."]]),
	OnAction = ChoGGi.MenuFuncs.ChangeRules,
}

c = c + 1
Actions[c] = {ActionName = T(302535920001247--[[Start Challenge]]),
	ActionMenubar = "ECM.ECM.Mission",
	ActionId = ".Start Challenge",
	ActionIcon = "CommonAssets/UI/Menu/ramp.tga",
	RolloverText = T(302535920001249--[[Shows a list of challenges you can start (replaces current).]]),
	OnAction = ChoGGi.MenuFuncs.StartChallenge,
}

-- menu
c = c + 1
Actions[c] = {ActionName = T(3983--[[Disasters]]),
	ActionMenubar = "ECM.ECM.Mission",
	ActionId = ".Disasters",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Disasters",
}

c = c + 1
Actions[c] = {ActionName = T(302535920000708--[[Meteor Damage]]),
	ActionMenubar = "ECM.ECM.Mission.Disasters",
	ActionId = ".Meteor Damage",
	ActionIcon = "CommonAssets/UI/Menu/remove_water.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.MeteorHealthDamage,
			T(7563--[[Health damage from small meteor (one-time on impact)]])
		)
	end,
	OnAction = ChoGGi.MenuFuncs.MeteorHealthDamage_Toggle,
}

c = c + 1
Actions[c] = {ActionName = T(4142--[[Dust Devils]]),
	ActionMenubar = "ECM.ECM.Mission.Disasters",
	ActionId = ".Dust Devils",
	ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
	RolloverText = function()
		return SettingState(
			ActiveMapData.MapSettings_DustDevils,
			Translate(302535920000966--[[Set the occurrence level of %s disasters.]]):format(
				T(4142--[[Dust Devils]])
			)
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetDisasterOccurrence,
	setting_id = "DustDevils",
}

c = c + 1
Actions[c] = {ActionName = T(4148--[[Cold Waves]]),
	ActionMenubar = "ECM.ECM.Mission.Disasters",
	ActionId = ".Cold Waves",
	ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
	RolloverText = function()
		return SettingState(
			ActiveMapData.MapSettings_ColdWave,
			Translate(302535920000966--[[Set the occurrence level of %s disasters.]]):format(
				T(4149--[[Cold Wave]])
			)
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetDisasterOccurrence,
	setting_id = "ColdWave",
}

c = c + 1
Actions[c] = {ActionName = T(4144--[[Dust Storms]]),
	ActionMenubar = "ECM.ECM.Mission.Disasters",
	ActionId = ".Dust Storms",
	ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
	RolloverText = function()
		return SettingState(
			ActiveMapData.MapSettings_DustStorm,
			Translate(302535920000966--[[Set the occurrence level of %s disasters.]]):format(
				T(4250--[[Dust Storm]])
			)
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetDisasterOccurrence,
	setting_id = "DustStorm",
}

c = c + 1
Actions[c] = {ActionName = T(4146--[[Meteors]]),
	ActionMenubar = "ECM.ECM.Mission.Disasters",
	ActionId = ".Meteors",
	ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
	RolloverText = function()
		return SettingState(
			ActiveMapData.MapSettings_Meteor,
			Translate(302535920000966--[[Set the occurrence level of %s disasters.]]):format(
				T(4146--[[Meteors]])
			)
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetDisasterOccurrence,
	setting_id = "Meteor",
}

-- rains and quakes act diff
c = c + 1
Actions[c] = {ActionName = T(558613651480--[[Toxic Rains]]),
	ActionMenubar = "ECM.ECM.Mission.Disasters",
	ActionId = ".Toxic Rains",
	ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
	RolloverText = function()
		local set = false
		if not ChoGGi.UserSettings.DisasterRainsDisable then
			set = T(12259--[[Automated]])
		end
		return SettingState(
			set,
			Translate(302535920000867--[[Toggle occurrence of %s disasters.]]):format(
				T(369748345658--[[Toxic Rain]])
			)
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetDisasterOccurrence_Toggle,
	setting_name = T(369748345658--[[Toxic Rain]]),
}

c = c + 1
Actions[c] = {ActionName = T(382404446864--[[Marsquake]]),
	ActionMenubar = "ECM.ECM.Mission.Disasters",
	ActionId = ".Marsquake",
	ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
	RolloverText = function()
		local set = false
		if not ChoGGi.UserSettings.DisasterQuakeDisable then
			set = T(12259--[[Automated]])
		end
		return SettingState(
			set,
			Translate(302535920000867--[[Toggle occurrence of %s disasters.]]):format(
				T(382404446864--[[Marsquake]])
			)
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetDisasterOccurrence_Toggle,
	setting_name = T(382404446864--[[Marsquake]]),
}
