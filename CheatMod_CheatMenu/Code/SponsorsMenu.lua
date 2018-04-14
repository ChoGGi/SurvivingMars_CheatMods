--ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

ChoGGi.AddAction(
  "Gameplay/Commanders/[1]Inventor bonuses",
  ChoGGi.SetCommanderInventor,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.CommanderInventor and "(Enabled)" or "(Disabled)"
    return des .. " Inventor commander bonus (if value already exists; set to larger amount).\nrestart to disable."
  end,
  "remove_water.tga"
)

ChoGGi.AddAction(
  "Gameplay/Commanders/[1]Oligarch bonuses",
  ChoGGi.SetCommanderOligarch,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.CommanderOligarch and "(Enabled)" or "(Disabled)"
    return des .. " Oligarch commander bonus (if value already exists; set to larger amount).\nrestart to disable."
  end,
  "remove_water.tga"
)

ChoGGi.AddAction(
  "Gameplay/Commanders/[1]HydroEngineer bonuses",
  ChoGGi.SetCommanderHydroEngineer,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.CommanderHydroEngineer and "(Enabled)" or "(Disabled)"
    return des .. " HydroEngineer commander bonus (if value already exists; set to larger amount).\nrestart to disable."
  end,
  "remove_water.tga"
)

ChoGGi.AddAction(
  "Gameplay/Commanders/[1]Doctor bonuses",
  ChoGGi.SetCommanderDoctor,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.CommanderDoctor and "(Enabled)" or "(Disabled)"
    return des .. " Doctor commander bonus (if value already exists; set to larger amount).\nrestart to disable."
  end,
  "remove_water.tga"
)

ChoGGi.AddAction(
  "Gameplay/Commanders/[1]Politician bonuses",
  ChoGGi.SetCommanderPolitician,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.CommanderPolitician and "(Enabled)" or "(Disabled)"
    return des .. " Politician commander bonus (if value already exists; set to larger amount).\nrestart to disable."
  end,
  "remove_water.tga"
)

ChoGGi.AddAction(
  "Gameplay/Commanders/[1]Futurist bonuses",
  ChoGGi.SetCommanderAuthor,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.CommanderAuthor and "(Enabled)" or "(Disabled)"
    return des .. " Futurist commander bonus (if value already exists; set to larger amount).\nrestart to disable."
  end,
  "remove_water.tga"
)

ChoGGi.AddAction(
  "Gameplay/Commanders/[1]Ecologist bonuses",
  ChoGGi.SetCommanderEcologist,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.CommanderEcologist and "(Enabled)" or "(Disabled)"
    return des .. " Ecologist commander bonus (if value already exists; set to larger amount).\nrestart to disable."
  end,
  "remove_water.tga"
)

ChoGGi.AddAction(
  "Gameplay/Commanders/[1]Astrogeologist bonuses",
  ChoGGi.SetCommanderAstrogeologist,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.CommanderAstrogeologist and "(Enabled)" or "(Disabled)"
    return des .. " Astrogeologist commander bonus (if value already exists; set to larger amount).\nrestart to disable."
  end,
  "remove_water.tga"
)

ChoGGi.AddAction(
  "Gameplay/Sponsors/[1]IMM bonuses",
  ChoGGi.SetSponsorIMM,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.SponsorIMM and "(Enabled)" or "(Disabled)"
    return des .. " IMM sponsor bonus (if value already exists; set to larger amount).\nrestart to disable."
  end,
  "remove_water.tga"
)

ChoGGi.AddAction(
  "Gameplay/Sponsors/[1]NASA bonuses",
  ChoGGi.SetSponsorNASA,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.SponsorNASA and "(Enabled)" or "(Disabled)"
    return des .. " NASA sponsor bonus (if value already exists; set to larger amount).\nrestart to disable."
  end,
  "remove_water.tga"
)

ChoGGi.AddAction(
  "Gameplay/Sponsors/[1]BlueSun bonuses",
  ChoGGi.SetSponsorBlueSun,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.SponsorBlueSun and "(Enabled)" or "(Disabled)"
    return des .. " BlueSun sponsor bonus (if value already exists; set to larger amount).\nrestart to disable."
  end,
  "remove_water.tga"
)

ChoGGi.AddAction(
  "Gameplay/Sponsors/[1]China bonuses",
  ChoGGi.SetSponsorCNSA,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.SponsorCNSA and "(Enabled)" or "(Disabled)"
    return des .. " China sponsor bonus (if value already exists; set to larger amount).\nrestart to disable."
  end,
  "remove_water.tga"
)

ChoGGi.AddAction(
  "Gameplay/Sponsors/[1]India bonuses",
  ChoGGi.SetSponsorISRO,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.SponsorISRO and "(Enabled)" or "(Disabled)"
    return des .. " India sponsor bonus (if value already exists; set to larger amount).\nrestart to disable."
  end,
  "remove_water.tga"
)

ChoGGi.AddAction(
  "Gameplay/Sponsors/[1]ESA bonuses",
  ChoGGi.SetSponsorESA,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.SponsorESA and "(Enabled)" or "(Disabled)"
    return des .. " ESA sponsor bonus (if value already exists; set to larger amount).\nrestart to disable."
  end,
  "remove_water.tga"
)

ChoGGi.AddAction(
  "Gameplay/Sponsors/[1]SpaceY bonuses",
  ChoGGi.SetSponsorSpaceY,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.SponsorSpaceY and "(Enabled)" or "(Disabled)"
    return des .. " SpaceY sponsor bonus (if value already exists; set to larger amount).\nrestart to disable."
  end,
  "remove_water.tga"
)

ChoGGi.AddAction(
  "Gameplay/Sponsors/[1]NewArk bonuses",
  ChoGGi.SetSponsorNewArk,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.SponsorNewArk and "(Enabled)" or "(Disabled)"
    return des .. " NewArk sponsor bonus (if value already exists; set to larger amount).\nrestart to disable."
  end,
  "remove_water.tga"
)

ChoGGi.AddAction(
  "Gameplay/Sponsors/[1]Russia bonuses",
  ChoGGi.SetSponsorRoscosmos,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.SponsorRoscosmos and "(Enabled)" or "(Disabled)"
    return des .. " Russia sponsor bonus (if value already exists; set to larger amount).\nrestart to disable."
  end,
  "remove_water.tga"
)

ChoGGi.AddAction(
  "Gameplay/Sponsors/[1]Paradox bonuses",
  ChoGGi.SetSponsorParadox,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.SponsorParadox and "(Enabled)" or "(Disabled)"
    return des .. " Paradox sponsor bonus (if value already exists; set to larger amount).\nrestart to disable."
  end,
  "remove_water.tga"
)
