local cMenuFuncs = ChoGGi.MenuFuncs
local cCodeFuncs = ChoGGi.CodeFuncs
local cComFuncs = ChoGGi.ComFuncs
local cConsts = ChoGGi.Consts
local cInfoFuncs = ChoGGi.InfoFuncs
local cSettingFuncs = ChoGGi.SettingFuncs
local cTables = ChoGGi.Tables

function ChoGGi.MsgFuncs.MissionMenu_LoadingScreenPreClose()
  --cComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  cComFuncs.AddAction(
    "Expanded CM/Mission/Instant Mission Goal",
    cMenuFuncs.InstantMissionGoal,
    nil,
    "Mission goals are finished instantly (pretty sure the only difference is preventing a msg).\n\nNeeds to change Sol to update.",
    "AlignSel.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Mission/Instant Colony Approval",
    cMenuFuncs.InstantColonyApproval,
    nil,
    "Make your colony instantly approved (can be called before you summon your first victims).",
    "AlignSel.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Mission/Disasters/Meteor Damage",
    cMenuFuncs.MeteorHealthDamage_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.MeteorHealthDamage,"(Disabled)","(Enabled)")
      return des .. " Disable Meteor damage (colonists?)."
    end,
    "remove_water.tga"
  )

  local bonusinfo = "Applies the good effects only (no drawbacks).\n\n(if value already exists; set to larger amount).\nrestart to set disabled."

  cComFuncs.AddAction(
    "Expanded CM/Mission/Change Logo",
    cMenuFuncs.ChangeGameLogo,
    nil,
    "Change the logo for anything that uses the logo.",
    "ViewArea.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Mission/[1]Set Sponsor",
    cMenuFuncs.ChangeSponsor,
    nil,
    "Switch to a different sponsor.",
    "SelectByClassName.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Mission/[2]Set Bonuses Sponsor",
    cMenuFuncs.SetSponsorBonus,
    nil,
    bonusinfo,
    "EV_OpenFromInputBox.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Mission/[3]Set Commander",
    cMenuFuncs.ChangeCommander,
    nil,
    "Switch to a different commander.",
    "SetCamPos&Loockat.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Mission/[4]Set Bonuses Commander",
    cMenuFuncs.SetCommanderBonus,
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

  cComFuncs.AddAction(
    "Expanded CM/Mission/Disasters/DustDevils",
    function()
      cMenuFuncs.SetDisasterOccurrence("DustDevils")
    end,
    nil,
    DisasterOccurrenceText("DustDevils"),
    "RandomMapPresetEditor.tga"
  )
  cComFuncs.AddAction(
    "Expanded CM/Mission/Disasters/ColdWave",
    function()
      cMenuFuncs.SetDisasterOccurrence("ColdWave")
    end,
    nil,
    DisasterOccurrenceText("ColdWave"),
    "RandomMapPresetEditor.tga"
  )
  cComFuncs.AddAction(
    "Expanded CM/Mission/Disasters/DustStorm",
    function()
      cMenuFuncs.SetDisasterOccurrence("DustStorm")
    end,
    nil,
    DisasterOccurrenceText("DustStorm"),
    "RandomMapPresetEditor.tga"
  )
  cComFuncs.AddAction(
    "Expanded CM/Mission/Disasters/Meteor",
    function()
      cMenuFuncs.SetDisasterOccurrence("Meteor")
    end,
    nil,
    DisasterOccurrenceText("Meteor"),
    "RandomMapPresetEditor.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Mission/Set Rules",
    ChoGGi.ChangeRules,
    nil,
    "Change the map rules.",
    "ListCollections.tga"
  )
--]]

end
