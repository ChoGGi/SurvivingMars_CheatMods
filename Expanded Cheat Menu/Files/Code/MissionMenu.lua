local icon = "new_city.tga"

function ChoGGi.MsgFuncs.MissionMenu_LoadingScreenPreClose()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/Instant Mission Goal",
    ChoGGi.MenuFuncs.InstantMissionGoal,
    nil,
    "Mission goals are finished instantly (pretty sure the only difference is preventing a msg).\n\nNeeds to change Sol to update.",
    "AlignSel.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/Instant Colony Approval",
    ChoGGi.MenuFuncs.InstantColonyApproval,
    nil,
    "Make your colony instantly approved (can be called before you summon your first victims).",
    "AlignSel.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/Disasters/Meteor Damage",
    ChoGGi.MenuFuncs.MeteorHealthDamage_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.MeteorHealthDamage,"(Disabled)","(Enabled)")
      return des .. " Disable Meteor damage (colonists?)."
    end,
    "remove_water.tga"
  )

  local bonusinfo = "Applies the good effects only (no drawbacks).\n\n(if value already exists; set to larger amount).\nrestart to set disabled."

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/Change Logo",
    ChoGGi.MenuFuncs.ChangeGameLogo,
    nil,
    "Change the logo for anything that uses the logo.",
    "ViewArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/[1]Set Sponsor",
    ChoGGi.MenuFuncs.ChangeSponsor,
    nil,
    "Switch to a different sponsor.",
    "SelectByClassName.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/[2]Set Bonuses Sponsor",
    ChoGGi.MenuFuncs.SetSponsorBonus,
    nil,
    bonusinfo,
    "EV_OpenFromInputBox.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/[3]Set Commander",
    ChoGGi.MenuFuncs.ChangeCommander,
    nil,
    "Switch to a different commander.",
    "SetCamPos&Loockat.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/[4]Set Bonuses Commander",
    ChoGGi.MenuFuncs.SetCommanderBonus,
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

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/Disasters/DustDevils",
    function()
      ChoGGi.MenuFuncs.SetDisasterOccurrence("DustDevils")
    end,
    nil,
    DisasterOccurrenceText("DustDevils"),
    "RandomMapPresetEditor.tga"
  )
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/Disasters/ColdWave",
    function()
      ChoGGi.MenuFuncs.SetDisasterOccurrence("ColdWave")
    end,
    nil,
    DisasterOccurrenceText("ColdWave"),
    "RandomMapPresetEditor.tga"
  )
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/Disasters/DustStorm",
    function()
      ChoGGi.MenuFuncs.SetDisasterOccurrence("DustStorm")
    end,
    nil,
    DisasterOccurrenceText("DustStorm"),
    "RandomMapPresetEditor.tga"
  )
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/Disasters/Meteor",
    function()
      ChoGGi.MenuFuncs.SetDisasterOccurrence("Meteor")
    end,
    nil,
    DisasterOccurrenceText("Meteor"),
    "RandomMapPresetEditor.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/Set Rules",
    ChoGGi.ChangeRules,
    nil,
    "Change the map rules.",
    "ListCollections.tga"
  )
--]]

end
