local CMenuFuncs = ChoGGi.MenuFuncs
local CCodeFuncs = ChoGGi.CodeFuncs
local CComFuncs = ChoGGi.ComFuncs
local CConsts = ChoGGi.Consts
local CInfoFuncs = ChoGGi.InfoFuncs
local CSettingFuncs = ChoGGi.SettingFuncs
local CTables = ChoGGi.Tables

function ChoGGi.MsgFuncs.MissionMenu_LoadingScreenPreClose()
  --CComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  CComFuncs.AddAction(
    "Expanded CM/Mission/Instant Mission Goal",
    CMenuFuncs.InstantMissionGoal,
    nil,
    "Mission goals are finished instantly (pretty sure the only difference is preventing a msg).\n\nNeeds to change Sol to update.",
    "AlignSel.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Mission/Instant Colony Approval",
    CMenuFuncs.InstantColonyApproval,
    nil,
    "Make your colony instantly approved (can be called before you summon your first victims).",
    "AlignSel.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Mission/Disasters/Meteor Damage",
    CMenuFuncs.MeteorHealthDamage_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.MeteorHealthDamage,"(Disabled)","(Enabled)")
      return des .. " Disable Meteor damage (colonists?)."
    end,
    "remove_water.tga"
  )

  local bonusinfo = "Applies the good effects only (no drawbacks).\n\n(if value already exists; set to larger amount).\nrestart to set disabled."

  CComFuncs.AddAction(
    "Expanded CM/Mission/Change Logo",
    CMenuFuncs.ChangeGameLogo,
    nil,
    "Change the logo for anything that uses the logo.",
    "ViewArea.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Mission/[1]Set Sponsor",
    CMenuFuncs.ChangeSponsor,
    nil,
    "Switch to a different sponsor.",
    "SelectByClassName.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Mission/[2]Set Bonuses Sponsor",
    CMenuFuncs.SetSponsorBonus,
    nil,
    bonusinfo,
    "EV_OpenFromInputBox.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Mission/[3]Set Commander",
    CMenuFuncs.ChangeCommander,
    nil,
    "Switch to a different commander.",
    "SetCamPos&Loockat.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Mission/[4]Set Bonuses Commander",
    CMenuFuncs.SetCommanderBonus,
    nil,
    bonusinfo,
    "EV_OpenFromInputBox.tga"
  )

--[[
  --------------------disasters
  local function DisasterOccurrenceText(Name)
    local des = mapdata["MapSettings_" .. Name]
    return "Set the occurrence level of " .. Name .. " disasters.\nCurrent: " .. des
  end

  CComFuncs.AddAction(
    "Expanded CM/Mission/Disasters/DustDevils",
    function()
      CMenuFuncs.SetDisasterOccurrence("DustDevils")
    end,
    nil,
    DisasterOccurrenceText("DustDevils"),
    "RandomMapPresetEditor.tga"
  )
  CComFuncs.AddAction(
    "Expanded CM/Mission/Disasters/ColdWave",
    function()
      CMenuFuncs.SetDisasterOccurrence("ColdWave")
    end,
    nil,
    DisasterOccurrenceText("ColdWave"),
    "RandomMapPresetEditor.tga"
  )
  CComFuncs.AddAction(
    "Expanded CM/Mission/Disasters/DustStorm",
    function()
      CMenuFuncs.SetDisasterOccurrence("DustStorm")
    end,
    nil,
    DisasterOccurrenceText("DustStorm"),
    "RandomMapPresetEditor.tga"
  )
  CComFuncs.AddAction(
    "Expanded CM/Mission/Disasters/Meteor",
    function()
      CMenuFuncs.SetDisasterOccurrence("Meteor")
    end,
    nil,
    DisasterOccurrenceText("Meteor"),
    "RandomMapPresetEditor.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Mission/Set Rules",
    ChoGGi.ChangeRules,
    nil,
    "Change the map rules.",
    "ListCollections.tga"
  )
--]]

end
