function ChoGGi.SponsorsMenu_LoadingScreenPreClose()
  --ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

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
    "remove_water.tga"
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
    "remove_water.tga"
  )

end
