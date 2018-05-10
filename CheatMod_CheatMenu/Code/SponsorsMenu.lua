function ChoGGi.SponsorsMenu_LoadingScreenPreClose()
  --ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.AddAction(
    "Expanded CM/Mission/Instant Mission Goal",
    ChoGGi.InstantMissionGoal,
    nil,
    "Mission goals are finished instantly (pretty sure the only difference is preventing a msg).\n\nNeeds to change Sol to update.",
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Instant Colony Approval",
    ChoGGi.InstantColonyApproval,
    nil,
    "Make your colony instantly approved (can be called before you summon your first victims).",
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Disasters/Meteor Damage",
    ChoGGi.MeteorHealthDamage_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.MeteorHealthDamage,"(Disabled)","(Enabled)")
      return des .. " Disable Meteor damage (colonists?)."
    end,
    "remove_water.tga"
  )

  local bonusinfo = "Applies the good effects only (no drawbacks).\n\n(if value already exists; set to larger amount).\nrestart to set disabled."

  ChoGGi.AddAction(
    "Expanded CM/Mission/Change Logo",
    ChoGGi.ChangeGameLogo,
    nil,
    "Change the logo for anything that uses the logo.",
    "ViewArea.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/[1]Set Sponsor",
    ChoGGi.ChangeSponsor,
    nil,
    "Switch to a different sponsor.",
    "SelectByClassName.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/[2]Set Bonuses Sponsor",
    ChoGGi.SetSponsorBonus,
    nil,
    bonusinfo,
    "EV_OpenFromInputBox.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/[3]Set Commander",
    ChoGGi.ChangeCommander,
    nil,
    "Switch to a different commander.",
    "SetCamPos&Loockat.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/[4]Set Bonuses Commander",
    ChoGGi.SetCommanderBonus,
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

  ChoGGi.AddAction(
    "Expanded CM/Mission/Disasters/DustDevils",
    function()
      ChoGGi.SetDisasterOccurrence("DustDevils")
    end,
    nil,
    DisasterOccurrenceText("DustDevils"),
    "RandomMapPresetEditor.tga"
  )
  ChoGGi.AddAction(
    "Expanded CM/Mission/Disasters/ColdWave",
    function()
      ChoGGi.SetDisasterOccurrence("ColdWave")
    end,
    nil,
    DisasterOccurrenceText("ColdWave"),
    "RandomMapPresetEditor.tga"
  )
  ChoGGi.AddAction(
    "Expanded CM/Mission/Disasters/DustStorm",
    function()
      ChoGGi.SetDisasterOccurrence("DustStorm")
    end,
    nil,
    DisasterOccurrenceText("DustStorm"),
    "RandomMapPresetEditor.tga"
  )
  ChoGGi.AddAction(
    "Expanded CM/Mission/Disasters/Meteor",
    function()
      ChoGGi.SetDisasterOccurrence("Meteor")
    end,
    nil,
    DisasterOccurrenceText("Meteor"),
    "RandomMapPresetEditor.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Set Rules",
    ChoGGi.ChangeRules,
    nil,
    "Change the map rules.",
    "ListCollections.tga"
  )
--]]

end
