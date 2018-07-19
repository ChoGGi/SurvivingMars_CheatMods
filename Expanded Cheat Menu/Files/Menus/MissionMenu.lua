--See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local AddAction = ChoGGi.ComFuncs.AddAction
local T = ChoGGi.ComFuncs.Trans

--~ local icon = "new_city.tga"

--~ AddAction(Menu,Action,Key,Des,Icon)

local str_ECM = T(302535920000104--[[Expanded CM--]])
local str_Mission = T(1635--[[Mission--]])
local str_BonusInfo = T(302535920000715--[[Applies the good effects only (no drawbacks).

(if value already exists; set to larger amount).
restart to set disabled.--]])
local str_Disasters = T(3983--[[Disasters--]])
local str_DustDevils = T(4142--[[Dust Devils--]])

AddAction(
  Concat(str_ECM,"/",str_Mission,"/",T(302535920000704--[[Instant Mission Goal--]])),
  ChoGGi.MenuFuncs.InstantMissionGoal,
  nil,
  T(302535920000705--[[Mission goals are finished instantly (pretty sure the only difference is preventing a msg).

Needs to change Sol to update.--]]),
  "AlignSel.tga"
)

AddAction(
  Concat(str_ECM,"/",str_Mission,"/",T(302535920000706--[[Instant Colony Approval--]])),
  ChoGGi.MenuFuncs.InstantColonyApproval,
  nil,
  T(302535920000707--[[Make your colony instantly approved (can be called before you summon your first victims).--]]),
  "AlignSel.tga"
)

AddAction(
  Concat(str_ECM,"/",str_Mission,"/",T(302535920000710--[[Change Logo--]])),
  ChoGGi.MenuFuncs.ChangeGameLogo,
  nil,
  T(302535920000711--[[Change the logo for anything that uses the logo.--]]),
  "ViewArea.tga"
)

AddAction(
  Concat(str_ECM,"/",str_Mission,"/[1]",T(302535920000712--[[Set Sponsor--]])),
  ChoGGi.MenuFuncs.ChangeSponsor,
  nil,
  T(302535920000713--[[Switch to a different sponsor.--]]),
  "SelectByClassName.tga"
)

AddAction(
  Concat(str_ECM,"/",str_Mission,"/[3]",T(302535920000716--[[Set Commander--]])),
  ChoGGi.MenuFuncs.ChangeCommander,
  nil,
  T(302535920000717--[[Switch to a different commander.--]]),
  "SetCamPos&Loockat.tga"
)

------------
AddAction(
  Concat(str_ECM,"/",str_Mission,"/[2]",T(302535920000714--[[Set Bonuses Sponsor--]])),
  ChoGGi.MenuFuncs.SetSponsorBonus,
  nil,
  str_BonusInfo,
  "EV_OpenFromInputBox.tga"
)

AddAction(
  Concat(str_ECM,"/",str_Mission,"/[4]",T(302535920000718--[[Set Bonuses Commander--]])),
  ChoGGi.MenuFuncs.SetCommanderBonus,
  nil,
  str_BonusInfo,
  "EV_OpenFromInputBox.tga"
)

--------------------disasters
AddAction(
  Concat(str_ECM,"/",str_Mission,"/",str_Disasters,"/",T(302535920000708--[[Meteor Damage--]])),
  ChoGGi.MenuFuncs.MeteorHealthDamage_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(Consts.MeteorHealthDamage,
      302535920000709--[[Disable Meteor damage (colonists?).--]]
    )
  end,
  "remove_water.tga"
)

AddAction(
  Concat(str_ECM,"/",str_Mission,"/",str_Disasters,"/",str_DustDevils),
  function()
    ChoGGi.MenuFuncs.SetDisasterOccurrence("DustDevils")
  end,
  nil,
  T(302535920000966--[["Set the occurrence level of %s disasters.
Current: %s"--]]):format(str_DustDevils,mapdata.MapSettings_DustDevils),
  "RandomMapPresetEditor.tga"
)

AddAction(
  Concat(str_ECM,"/",str_Mission,"/",str_Disasters,"/",T(4148--[[Cold Waves--]])),
  function()
    ChoGGi.MenuFuncs.SetDisasterOccurrence("ColdWave")
  end,
  nil,
  T(302535920000966--[["Set the occurrence level of %s disasters.
Current: %s"--]]):format(T(4149--[[Cold Wave--]]),mapdata.MapSettings_ColdWave),
  "RandomMapPresetEditor.tga"
)

AddAction(
  Concat(str_ECM,"/",str_Mission,"/",str_Disasters,"/",T(4144--[[Dust Storms--]])),
  function()
    ChoGGi.MenuFuncs.SetDisasterOccurrence("DustStorm")
  end,
  nil,
  T(302535920000966--[["Set the occurrence level of %s disasters.
Current: %s"--]]):format(T(4250--[[Dust Storm--]]),mapdata.MapSettings_DustStorm),
  "RandomMapPresetEditor.tga"
)

AddAction(
  Concat(str_ECM,"/",str_Mission,"/",str_Disasters,"/",T(4146--[[Meteors--]])),
  function()
    ChoGGi.MenuFuncs.SetDisasterOccurrence("Meteor")
  end,
  nil,
  T(302535920000966--[["Set the occurrence level of %s disasters.
Current: %s"--]]):format(T(4251--[[Meteor--]]),mapdata.MapSettings_Meteor),
  "RandomMapPresetEditor.tga"
)

AddAction(
  Concat(str_ECM,"/",str_Mission,"/",T(8800--[[Game Rules--]])),
  ChoGGi.MenuFuncs.ChangeRules,
  nil,
  T(302535920000965--[["Change the ""Game Rules""."--]]),
  "ListCollections.tga"
)
