-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local S = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions
local c = #Actions

local str_ExpandedCM_Mission = "Expanded CM.Mission"
c = c + 1
Actions[c] = {
	ActionMenubar = "Expanded CM",
	ActionName = Concat(S[1635--[[Mission--]]]," .."),
	ActionId = ".Mission",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Mission",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Mission,
	ActionName = S[302535920000704--[[Instant Mission Goal--]]],
	ActionId = ".Instant Mission Goal",
	ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
	RolloverText = S[302535920000705--[[Mission goals are finished instantly (pretty sure the only difference is preventing a msg).

Needs to change Sol to update.--]]],
	OnAction = ChoGGi.MenuFuncs.InstantMissionGoal,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Mission,
	ActionName = S[302535920000706--[[Instant Colony Approval--]]],
	ActionId = ".Instant Colony Approval",
	ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
	RolloverText = S[302535920000707--[[Make your colony instantly approved (can be called before you summon your first victims).--]]],
	OnAction = ChoGGi.MenuFuncs.InstantColonyApproval,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Mission,
	ActionName = S[302535920000710--[[Change Logo--]]],
	ActionId = ".Change Logo",
	ActionIcon = "CommonAssets/UI/Menu/ViewArea.tga",
	RolloverText = S[302535920000711--[[Change the logo for anything that uses the logo.--]]],
	OnAction = ChoGGi.MenuFuncs.ChangeGameLogo,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Mission,
	ActionName = S[302535920000712--[[Set Sponsor--]]],
	ActionId = ".Set Sponsor",
	ActionIcon = "CommonAssets/UI/Menu/SelectByClassName.tga",
	RolloverText = S[302535920000713--[[Switch to a different sponsor.--]]],
	OnAction = ChoGGi.MenuFuncs.ChangeSponsor,
	ActionSortKey = "21",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Mission,
	ActionName = S[302535920000714--[[Set Bonuses Sponsor--]]],
	ActionId = ".Set Bonuses Sponsor",
	ActionIcon = "CommonAssets/UI/Menu/EV_OpenFromInputBox.tga",
	RolloverText = S[302535920000715--[[Applies the good effects only (no drawbacks).

(if value already exists; set to larger amount).
restart to set disabled.--]]],
	OnAction = ChoGGi.MenuFuncs.SetSponsorBonus,
	ActionSortKey = "22",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Mission,
	ActionName = S[302535920000716--[[Set Commander--]]],
	ActionId = ".Set Commander",
	ActionIcon = "CommonAssets/UI/Menu/SetCamPos&Loockat.tga",
	RolloverText = S[302535920000717--[[Switch to a different commander.--]]],
	OnAction = ChoGGi.MenuFuncs.ChangeCommander,
	ActionSortKey = "23",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Mission,
	ActionName = S[302535920000718--[[Set Bonuses Commander--]]],
	ActionId = ".Set Bonuses Commander",
	ActionIcon = "CommonAssets/UI/Menu/EV_OpenFromInputBox.tga",
	RolloverText = S[302535920000715--[[Applies the good effects only (no drawbacks).

(if value already exists; set to larger amount).
restart to set disabled.--]]],
	OnAction = ChoGGi.MenuFuncs.SetCommanderBonus,
	ActionSortKey = "24",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Mission,
	ActionName = S[8800--[[Game Rules--]]],
	ActionId = ".Game Rules",
	ActionIcon = "CommonAssets/UI/Menu/ListCollections.tga",
	RolloverText = S[302535920000965--[["Change the ""Game Rules""."--]]],
	OnAction = ChoGGi.MenuFuncs.ChangeRules,
}

local str_ExpandedCM_Mission_Disasters = "Expanded CM.Mission.Disasters"
c = c + 1
Actions[c] = {
	ActionMenubar = "Expanded CM.Mission",
	ActionName = Concat(S[3983--[[Disasters--]]]," .."),
	ActionId = ".Disasters",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Disasters",
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Mission_Disasters,
	ActionName = S[302535920000708--[[Meteor Damage--]]],
	ActionId = ".Meteor Damage",
	ActionIcon = "CommonAssets/UI/Menu/remove_water.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.MeteorHealthDamage,
			302535920000709--[[Disable Meteor damage (colonists?).--]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.MeteorHealthDamage_Toggle,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Mission_Disasters,
	ActionName = S[4142--[[Dust Devils--]]],
	ActionId = ".Dust Devils",
	ActionIcon = "CommonAssets/UI/Menu/RandomMapPresetEditor.tga",
	RolloverText = S[302535920000966--[["Set the occurrence level of %s disasters.
Current: %s"--]]]:format(S[4142--[[Dust Devils--]]],mapdata.MapSettings_DustDevils),
	OnAction = function()
		ChoGGi.MenuFuncs.SetDisasterOccurrence("DustDevils")
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Mission_Disasters,
	ActionName = S[4148--[[Cold Waves--]]],
	ActionId = ".Cold Waves",
	ActionIcon = "CommonAssets/UI/Menu/RandomMapPresetEditor.tga",
	RolloverText = S[302535920000966--[["Set the occurrence level of %s disasters.
Current: %s"--]]]:format(S[4149--[[Cold Wave--]]],mapdata.MapSettings_ColdWave),
	OnAction = function()
		ChoGGi.MenuFuncs.SetDisasterOccurrence("ColdWave")
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Mission_Disasters,
	ActionName = S[4144--[[Dust Storms--]]],
	ActionId = ".Dust Storms",
	ActionIcon = "CommonAssets/UI/Menu/RandomMapPresetEditor.tga",
	RolloverText = S[302535920000966--[["Set the occurrence level of %s disasters.
Current: %s"--]]]:format(S[4250--[[Dust Storm--]]],mapdata.MapSettings_DustStorm),
	OnAction = function()
		ChoGGi.MenuFuncs.SetDisasterOccurrence("DustStorm")
	end,
}

c = c + 1
Actions[c] = {
	ActionMenubar = str_ExpandedCM_Mission_Disasters,
	ActionName = S[4146--[[Meteors--]]],
	ActionId = ".Meteors",
	ActionIcon = "CommonAssets/UI/Menu/RandomMapPresetEditor.tga",
	RolloverText = S[302535920000966--[["Set the occurrence level of %s disasters.
Current: %s"--]]]:format(S[4146--[[Meteors--]]],mapdata.MapSettings_Meteor),
	OnAction = function()
		ChoGGi.MenuFuncs.SetDisasterOccurrence("Meteor")
	end,
}
