--See LICENSE for terms

local icon = "new_city.tga"

function ChoGGi.MsgFuncs.MissionMenu_LoadingScreenPreClose()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/" .. ChoGGi.ComFuncs.Trans(302535920000704,"Instant Mission Goal"),
    ChoGGi.MenuFuncs.InstantMissionGoal,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000705,"Mission goals are finished instantly (pretty sure the only difference is preventing a msg).\n\nNeeds to change Sol to update."),
    "AlignSel.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/" .. ChoGGi.ComFuncs.Trans(302535920000706,"Instant Colony Approval"),
    ChoGGi.MenuFuncs.InstantColonyApproval,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000707,"Make your colony instantly approved (can be called before you summon your first victims)."),
    "AlignSel.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/Disasters/" .. ChoGGi.ComFuncs.Trans(302535920000708,"Meteor Damage"),
    ChoGGi.MenuFuncs.MeteorHealthDamage_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.MeteorHealthDamage,"(" .. ChoGGi.ComFuncs.Trans(302535920000036,"Disabled") .. ")","(" .. ChoGGi.ComFuncs.Trans(302535920000030,"Enabled") .. ")")
      return des .. " " .. ChoGGi.ComFuncs.Trans(302535920000709,"Disable Meteor damage (colonists?).")
    end,
    "remove_water.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/" .. ChoGGi.ComFuncs.Trans(302535920000710,"Change Logo"),
    ChoGGi.MenuFuncs.ChangeGameLogo,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000711,"Change the logo for anything that uses the logo."),
    "ViewArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/[1]" .. ChoGGi.ComFuncs.Trans(302535920000712,"Set Sponsor"),
    ChoGGi.MenuFuncs.ChangeSponsor,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000713,"Switch to a different sponsor."),
    "SelectByClassName.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/[3]" .. ChoGGi.ComFuncs.Trans(302535920000716,"Set Commander"),
    ChoGGi.MenuFuncs.ChangeCommander,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000717,"Switch to a different commander."),
    "SetCamPos&Loockat.tga"
  )

------------
  local bonusinfo = ChoGGi.ComFuncs.Trans(302535920000715,"Applies the good effects only (no drawbacks).\n\n(if value already exists; set to larger amount).\nrestart to set disabled.")
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/[2]" .. ChoGGi.ComFuncs.Trans(302535920000714,"Set Bonuses Sponsor"),
    ChoGGi.MenuFuncs.SetSponsorBonus,
    nil,
    bonusinfo,
    "EV_OpenFromInputBox.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/[4]" .. ChoGGi.ComFuncs.Trans(302535920000718,"Set Bonuses Commander"),
    ChoGGi.MenuFuncs.SetCommanderBonus,
    nil,
    bonusinfo,
    "EV_OpenFromInputBox.tga"
  )

  --------------------disasters
  --[[
  local function DisasterOccurrenceText(Name)
    local des = mapdata["MapSettings_" .. Name]
    return "Set the occurrence level of " .. Name .. " disasters.\nCurrent: " .. des
  end

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/Disasters/" .. ChoGGi.ComFuncs.Trans()"DustDevils",
    function()
      ChoGGi.MenuFuncs.SetDisasterOccurrence("DustDevils")
    end,
    nil,
    DisasterOccurrenceText("DustDevils"),
    "RandomMapPresetEditor.tga"
  )
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/Disasters/" .. ChoGGi.ComFuncs.Trans()"ColdWave",
    function()
      ChoGGi.MenuFuncs.SetDisasterOccurrence("ColdWave")
    end,
    nil,
    DisasterOccurrenceText("ColdWave"),
    "RandomMapPresetEditor.tga"
  )
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/Disasters/" .. ChoGGi.ComFuncs.Trans()"DustStorm",
    function()
      ChoGGi.MenuFuncs.SetDisasterOccurrence("DustStorm")
    end,
    nil,
    DisasterOccurrenceText("DustStorm"),
    "RandomMapPresetEditor.tga"
  )
  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/Disasters/" .. ChoGGi.ComFuncs.Trans()"Meteor",
    function()
      ChoGGi.MenuFuncs.SetDisasterOccurrence("Meteor")
    end,
    nil,
    DisasterOccurrenceText("Meteor"),
    "RandomMapPresetEditor.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Mission/" .. ChoGGi.ComFuncs.Trans()"Set Rules",
    ChoGGi.ChangeRules,
    nil,
    ChoGGi.ComFuncs.Trans()"Change the map rules.",
    "ListCollections.tga"
  )
--]]
end
