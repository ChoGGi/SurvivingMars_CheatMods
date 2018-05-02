function ChoGGi.ResourcesMenu_LoadingScreenPreClose()
  --ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.AddAction(
    "Expanded CM/Resources/Add Orbital Probes",
    ChoGGi.AddOrbitalProbes,
    nil,
    "Add more probes.",
    "ToggleTerrainHeight.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Resources/Food Per Rocket Passenger",
    ChoGGi.SetFoodPerRocketPassenger,
    nil,
    "Change the amount of Food supplied with each Colonist arrival.",
    "ToggleTerrainHeight.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Resources/Add Prefabs",
    ChoGGi.AddPrefabs,
    nil,
    "Adds prefabs.",
    "gear.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Resources/Add Funding",
    ChoGGi.SetFunding,
    "Ctrl-Shift-0",
    "Add more funding (or reset back to 500 M).",
    "pirate.tga"
  )

  ChoGGi.AddAction(
    "Expanded CM/Resources/Fill Selected Resource",
    ChoGGi.FillResource,
    "Ctrl-F",
    "Fill the selected/moused over object's resource(s)",
    "Cube.tga"
  )
end
