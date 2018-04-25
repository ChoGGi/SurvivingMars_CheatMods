function OnMsg.Resume()
  --ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

  local appendtext = " Applies the good effects only (no drawbacks).\n\n(if value already exists; set to larger amount).\nrestart to disable."

  ChoGGi.AddAction(
    "Expanded CM/Mission/Commander/[1]Inventor bonuses",
    function()
      ChoGGi.SetCommanderBonus("Inventor")
    end,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.CommanderInventor and "(Enabled)" or "(Disabled)"
      return des .. " Inventor commander bonus" .. appendtext
    end,
    "remove_water.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Commander/[1]Oligarch bonuses",
    function()
      ChoGGi.SetCommanderBonus("Oligarch")
    end,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.CommanderOligarch and "(Enabled)" or "(Disabled)"
      return des .. " Oligarch commander bonus" .. appendtext
    end,
    "remove_water.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Commander/[1]HydroEngineer bonuses",
    function()
      ChoGGi.SetCommanderBonus("HydroEngineer")
    end,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.CommanderHydroEngineer and "(Enabled)" or "(Disabled)"
      return des .. " HydroEngineer commander bonus" .. appendtext
    end,
    "remove_water.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Commander/[1]Doctor bonuses",
    function()
      ChoGGi.SetCommanderBonus("Doctor")
    end,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.CommanderDoctor and "(Enabled)" or "(Disabled)"
      return des .. " Doctor commander bonus" .. appendtext
    end,
    "remove_water.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Commander/[1]Politician bonuses",
    function()
      ChoGGi.SetCommanderBonus("Politician")
    end,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.CommanderPolitician and "(Enabled)" or "(Disabled)"
      return des .. " Politician commander bonus" .. appendtext
    end,
    "remove_water.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Commander/[1]Futurist bonuses",
    function()
      ChoGGi.SetCommanderBonus("Author")
    end,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.CommanderAuthor and "(Enabled)" or "(Disabled)"
      return des .. " Futurist commander bonus" .. appendtext
    end,
    "remove_water.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Commander/[1]Ecologist bonuses",
    function()
      ChoGGi.SetCommanderBonus("Ecologist")
    end,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.CommanderEcologist and "(Enabled)" or "(Disabled)"
      return des .. " Ecologist commander bonus" .. appendtext
    end,
    "remove_water.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Commander/[1]Astrogeologist bonuses",
    function()
      ChoGGi.SetCommanderBonus("Astrogeologist")
    end,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.CommanderAstrogeologist and "(Enabled)" or "(Disabled)"
      return des .. " Astrogeologist commander bonus" .. appendtext
    end,
    "remove_water.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Sponsor/[1]IMM bonuses",
    function()
      ChoGGi.SetSponsorBonus("IMM")
    end,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.SponsorIMM and "(Enabled)" or "(Disabled)"
      return des .. " IMM sponsor bonus" .. appendtext
    end,
    "remove_water.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Sponsor/[1]USA bonuses",
    function()
      ChoGGi.SetSponsorBonus("NASA")
    end,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.SponsorNASA and "(Enabled)" or "(Disabled)"
      return des .. " NASA sponsor bonus" .. appendtext
    end,
    "remove_water.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Sponsor/[1]BlueSun bonuses",
    function()
      ChoGGi.SetSponsorBonus("BlueSun")
    end,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.SponsorBlueSun and "(Enabled)" or "(Disabled)"
      return des .. " BlueSun sponsor bonus" .. appendtext
    end,
    "remove_water.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Sponsor/[1]China bonuses",
    function()
      ChoGGi.SetSponsorBonus("CNSA")
    end,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.SponsorCNSA and "(Enabled)" or "(Disabled)"
      return des .. " China sponsor bonus" .. appendtext
    end,
    "remove_water.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Sponsor/[1]India bonuses",
    function()
      ChoGGi.SetSponsorBonus("ISRO")
    end,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.SponsorISRO and "(Enabled)" or "(Disabled)"
      return des .. " India sponsor bonus" .. appendtext
    end,
    "remove_water.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Sponsor/[1]Europe bonuses",
    function()
      ChoGGi.SetSponsorBonus("ESA")
    end,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.SponsorESA and "(Enabled)" or "(Disabled)"
      return des .. " ESA sponsor bonus" .. appendtext
    end,
    "remove_water.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Sponsor/[1]SpaceY bonuses",
    function()
      ChoGGi.SetSponsorBonus("SpaceY")
    end,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.SponsorSpaceY and "(Enabled)" or "(Disabled)"
      return des .. " SpaceY sponsor bonus" .. appendtext
    end,
    "remove_water.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Sponsor/[1]NewArk bonuses",
    function()
      ChoGGi.SetSponsorBonus("NewArk")
    end,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.SponsorNewArk and "(Enabled)" or "(Disabled)"
      return des .. " NewArk sponsor bonus" .. appendtext
    end,
    "remove_water.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Sponsor/[1]Russia bonuses",
    function()
      ChoGGi.SetSponsorBonus("Roscosmos")
    end,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.SponsorRoscosmos and "(Enabled)" or "(Disabled)"
      return des .. " Russia sponsor bonus" .. appendtext
    end,
    "remove_water.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Sponsor/[1]Paradox bonuses",
    function()
      ChoGGi.SetSponsorBonus("Paradox")
    end,
    nil,
    function()
      local des = ChoGGi.CheatMenuSettings.SponsorParadox and "(Enabled)" or "(Disabled)"
      return des .. " Paradox sponsor bonus" .. appendtext
    end,
    "remove_water.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Sponsor/Set New Sponsor",
    ChoGGi.ChangeSponsor,
    nil,
    "Switch to a different sponsor.",
    "SelectByClassName.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Commander/Set New Commander",
    ChoGGi.ChangeCommander,
    nil,
    "Switch to a different commander.",
    "SetCamPos&Loockat.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Mission/Change Logo",
    ChoGGi.ChangeGameLogo,
    nil,
    "Change the logo for anything that uses the logo.",
    "ViewArea.tga"
  )
end
