-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local S = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions

local str_ExpandedCM_Mission = "Expanded CM.Mission"
Actions[#Actions+1] = {
  ActionMenubar = "Expanded CM",
  ActionName = Concat(S[1635--[[Mission--]]]," .."),
  ActionId = str_ExpandedCM_Mission,
  ActionIcon = "CommonAssets/UI/Menu/folder.tga",
  OnActionEffect = "popup",
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Mission,
  ActionName = S[302535920000704--[[Instant Mission Goal--]]],
  ActionId = "Expanded CM.Mission.Instant Mission Goal",
  ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
  RolloverText = S[302535920000705--[[Mission goals are finished instantly (pretty sure the only difference is preventing a msg).

Needs to change Sol to update.--]]],
  OnAction = ChoGGi.MenuFuncs.InstantMissionGoal,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Mission,
  ActionName = S[302535920000706--[[Instant Colony Approval--]]],
  ActionId = "Expanded CM.Mission.Instant Colony Approval",
  ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
  RolloverText = S[302535920000707--[[Make your colony instantly approved (can be called before you summon your first victims).--]]],
  OnAction = ChoGGi.MenuFuncs.InstantColonyApproval,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Mission,
  ActionName = S[302535920000710--[[Change Logo--]]],
  ActionId = "Expanded CM.Mission.Change Logo",
  ActionIcon = "CommonAssets/UI/Menu/ViewArea.tga",
  RolloverText = S[302535920000711--[[Change the logo for anything that uses the logo.--]]],
  OnAction = ChoGGi.MenuFuncs.ChangeGameLogo,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Mission,
  ActionName = S[302535920000712--[[Set Sponsor--]]],
  ActionId = "Expanded CM.Mission.Set Sponsor",
  ActionIcon = "CommonAssets/UI/Menu/SelectByClassName.tga",
  RolloverText = S[302535920000713--[[Switch to a different sponsor.--]]],
  OnAction = ChoGGi.MenuFuncs.ChangeSponsor,
  ActionSortKey = "01",
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Mission,
  ActionName = S[302535920000716--[[Set Commander--]]],
  ActionId = "Expanded CM.Mission.Set Commander",
  ActionIcon = "CommonAssets/UI/Menu/SetCamPos&Loockat.tga",
  RolloverText = S[302535920000717--[[Switch to a different commander.--]]],
  OnAction = ChoGGi.MenuFuncs.ChangeCommander,
  ActionSortKey = "03",
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Mission,
  ActionName = S[302535920000714--[[Set Bonuses Sponsor--]]],
  ActionId = "Expanded CM.Mission.Set Bonuses Sponsor",
  ActionIcon = "CommonAssets/UI/Menu/EV_OpenFromInputBox.tga",
  RolloverText = S[302535920000715--[[Applies the good effects only (no drawbacks).

(if value already exists; set to larger amount).
restart to set disabled.--]]],
  OnAction = ChoGGi.MenuFuncs.SetSponsorBonus,
  ActionSortKey = "02",
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Mission,
  ActionName = S[302535920000718--[[Set Bonuses Commander--]]],
  ActionId = "Expanded CM.Mission.Set Bonuses Commander",
  ActionIcon = "CommonAssets/UI/Menu/EV_OpenFromInputBox.tga",
  RolloverText = S[302535920000715--[[Applies the good effects only (no drawbacks).

(if value already exists; set to larger amount).
restart to set disabled.--]]],
  OnAction = ChoGGi.MenuFuncs.SetCommanderBonus,
  ActionSortKey = "04",
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Mission,
  ActionName = S[8800--[[Game Rules--]]],
  ActionId = "Expanded CM.Mission.Game Rules",
  ActionIcon = "CommonAssets/UI/Menu/ListCollections.tga",
  RolloverText = S[302535920000965--[["Change the ""Game Rules""."--]]],
  OnAction = ChoGGi.MenuFuncs.ChangeRules,
}

local str_ExpandedCM_Mission_Disasters = "Expanded CM.Mission.Disasters"
Actions[#Actions+1] = {
  ActionMenubar = "Expanded CM.Mission",
  ActionName = Concat(S[3983--[[Disasters--]]]," .."),
  ActionId = str_ExpandedCM_Mission_Disasters,
  ActionIcon = "CommonAssets/UI/Menu/folder.tga",
  OnActionEffect = "popup",
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Mission_Disasters,
  ActionName = S[302535920000708--[[Meteor Damage--]]],
  ActionId = "Expanded CM.Mission.Disasters.Meteor Damage",
  ActionIcon = "CommonAssets/UI/Menu/remove_water.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.MeteorHealthDamage,
      302535920000709--[[Disable Meteor damage (colonists?).--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.MeteorHealthDamage_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Mission_Disasters,
  ActionName = S[4142--[[Dust Devils--]]],
  ActionId = "Expanded CM.Mission.Disasters.Dust Devils",
  ActionIcon = "CommonAssets/UI/Menu/RandomMapPresetEditor.tga",
  RolloverText = S[302535920000966--[["Set the occurrence level of %s disasters.
Current: %s"--]]]:format(S[4142--[[Dust Devils--]]],mapdata.MapSettings_DustDevils),
  OnAction = function()
    ChoGGi.MenuFuncs.SetDisasterOccurrence("DustDevils")
  end,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Mission_Disasters,
  ActionName = S[4148--[[Cold Waves--]]],
  ActionId = "Expanded CM.Mission.Disasters.Cold Waves",
  ActionIcon = "CommonAssets/UI/Menu/RandomMapPresetEditor.tga",
  RolloverText = S[302535920000966--[["Set the occurrence level of %s disasters.
Current: %s"--]]]:format(S[4149--[[Cold Wave--]]],mapdata.MapSettings_ColdWave),
  OnAction = function()
    ChoGGi.MenuFuncs.SetDisasterOccurrence("ColdWave")
  end,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Mission_Disasters,
  ActionName = S[4144--[[Dust Storms--]]],
  ActionId = "Expanded CM.Mission.Disasters.Dust Storms",
  ActionIcon = "CommonAssets/UI/Menu/RandomMapPresetEditor.tga",
  RolloverText = S[302535920000966--[["Set the occurrence level of %s disasters.
Current: %s"--]]]:format(S[4250--[[Dust Storm--]]],mapdata.MapSettings_DustStorm),
  OnAction = function()
    ChoGGi.MenuFuncs.SetDisasterOccurrence("DustStorm")
  end,
}

Actions[#Actions+1] = {
  ActionMenubar = str_ExpandedCM_Mission_Disasters,
  ActionName = S[4146--[[Meteors--]]],
  ActionId = "Expanded CM.Mission.Disasters.Meteors",
  ActionIcon = "CommonAssets/UI/Menu/RandomMapPresetEditor.tga",
  RolloverText = S[302535920000966--[["Set the occurrence level of %s disasters.
Current: %s"--]]]:format(S[4146--[[Meteors--]]],mapdata.MapSettings_Meteor),
  OnAction = function()
    ChoGGi.MenuFuncs.SetDisasterOccurrence("Meteor")
  end,
}
