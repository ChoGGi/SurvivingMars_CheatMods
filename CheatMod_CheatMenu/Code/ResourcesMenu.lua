function ChoGGi.MsgFuncs.ResourcesMenu_LoadingScreenPreClose()
  --ChoGGi.Funcs.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Resources/Add Orbital Probes",
    ChoGGi.MenuFuncs.AddOrbitalProbes,
    nil,
    "Add more probes.",
    "ToggleTerrainHeight.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Resources/Food Per Rocket Passenger",
    ChoGGi.MenuFuncs.SetFoodPerRocketPassenger,
    nil,
    "Change the amount of Food supplied with each Colonist arrival.",
    "ToggleTerrainHeight.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Resources/Add Prefabs",
    ChoGGi.MenuFuncs.AddPrefabs,
    nil,
    "Adds prefabs.",
    "gear.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Resources/Add Funding",
    ChoGGi.MenuFuncs.SetFunding,
    "Ctrl-Shift-0",
    "Add more funding (or reset back to 500 M).",
    "pirate.tga"
  )

  ChoGGi.Funcs.AddAction(
    "Expanded CM/Resources/Fill Selected Resource",
    ChoGGi.MenuFuncs.FillResource,
    "Ctrl-F",
    "Fill the selected/moused over object's resource(s)",
    "Cube.tga"
  )
end
