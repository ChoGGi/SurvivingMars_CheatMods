--See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local AddAction = ChoGGi.ComFuncs.AddAction
local S = ChoGGi.Strings

--~ local icon = "new_city.tga"

--~ AddAction(Entry,Menu,Action,Key,Des,Icon)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[1635--[[Mission--]]],"/",S[302535920000704--[[Instant Mission Goal--]]]),
  ChoGGi.MenuFuncs.InstantMissionGoal,
  nil,
  302535920000705--[[Mission goals are finished instantly (pretty sure the only difference is preventing a msg).

Needs to change Sol to update.--]],
  "AlignSel.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[1635--[[Mission--]]],"/",S[302535920000706--[[Instant Colony Approval--]]]),
  ChoGGi.MenuFuncs.InstantColonyApproval,
  nil,
  302535920000707--[[Make your colony instantly approved (can be called before you summon your first victims).--]],
  "AlignSel.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[1635--[[Mission--]]],"/",S[302535920000710--[[Change Logo--]]]),
  ChoGGi.MenuFuncs.ChangeGameLogo,
  nil,
  302535920000711--[[Change the logo for anything that uses the logo.--]],
  "ViewArea.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[1635--[[Mission--]]],"/[1]",S[302535920000712--[[Set Sponsor--]]]),
  ChoGGi.MenuFuncs.ChangeSponsor,
  nil,
  302535920000713--[[Switch to a different sponsor.--]],
  "SelectByClassName.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[1635--[[Mission--]]],"/[3]",S[302535920000716--[[Set Commander--]]]),
  ChoGGi.MenuFuncs.ChangeCommander,
  nil,
  302535920000717--[[Switch to a different commander.--]],
  "SetCamPos&Loockat.tga"
)

------------
AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[1635--[[Mission--]]],"/[2]",S[302535920000714--[[Set Bonuses Sponsor--]]]),
  ChoGGi.MenuFuncs.SetSponsorBonus,
  nil,
  S[302535920000715--[[Applies the good effects only (no drawbacks).

(if value already exists; set to larger amount).
restart to set disabled.--]]],
  "EV_OpenFromInputBox.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[1635--[[Mission--]]],"/[4]",S[302535920000718--[[Set Bonuses Commander--]]]),
  ChoGGi.MenuFuncs.SetCommanderBonus,
  nil,
  S[302535920000715--[[Applies the good effects only (no drawbacks).

(if value already exists; set to larger amount).
restart to set disabled.--]]],
  "EV_OpenFromInputBox.tga"
)

--------------------disasters
AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[1635--[[Mission--]]],"/",S[3983--[[Disasters--]]],"/",S[302535920000708--[[Meteor Damage--]]]),
  ChoGGi.MenuFuncs.MeteorHealthDamage_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.MeteorHealthDamage,
      302535920000709--[[Disable Meteor damage (colonists?).--]]
    )
  end,
  "remove_water.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[1635--[[Mission--]]],"/",S[3983--[[Disasters--]]],"/",S[4142--[[Dust Devils--]]]),
  function()
    ChoGGi.MenuFuncs.SetDisasterOccurrence("DustDevils")
  end,
  nil,
  S[302535920000966--[["Set the occurrence level of %s disasters.
Current: %s"--]]]:format(S[4142--[[Dust Devils--]]],mapdata.MapSettings_DustDevils),
  "RandomMapPresetEditor.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[1635--[[Mission--]]],"/",S[3983--[[Disasters--]]],"/",S[4148--[[Cold Waves--]]]),
  function()
    ChoGGi.MenuFuncs.SetDisasterOccurrence("ColdWave")
  end,
  nil,
  S[302535920000966--[["Set the occurrence level of %s disasters.
Current: %s"--]]]:format(S[4149--[[Cold Wave--]]],mapdata.MapSettings_ColdWave),
  "RandomMapPresetEditor.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[1635--[[Mission--]]],"/",S[3983--[[Disasters--]]],"/",S[4144--[[Dust Storms--]]]),
  function()
    ChoGGi.MenuFuncs.SetDisasterOccurrence("DustStorm")
  end,
  nil,
  S[302535920000966--[["Set the occurrence level of %s disasters.
Current: %s"--]]]:format(S[4250--[[Dust Storm--]]],mapdata.MapSettings_DustStorm),
  "RandomMapPresetEditor.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[1635--[[Mission--]]],"/",S[3983--[[Disasters--]]],"/",S[4146--[[Meteors--]]]),
  function()
    ChoGGi.MenuFuncs.SetDisasterOccurrence("Meteor")
  end,
  nil,
  S[302535920000966--[["Set the occurrence level of %s disasters.
Current: %s"--]]]:format(S[4146--[[Meteors--]]],mapdata.MapSettings_Meteor),
  "RandomMapPresetEditor.tga"
)

AddAction(
  {"/[20]",S[302535920000104--[[Expanded CM--]]],"/"},
  Concat("/[20]",S[302535920000104--[[Expanded CM--]]],"/",S[1635--[[Mission--]]],"/",S[8800--[[Game Rules--]]]),
  ChoGGi.MenuFuncs.ChangeRules,
  nil,
  302535920000965--[["Change the ""Game Rules""."--]],
  "ListCollections.tga"
)
