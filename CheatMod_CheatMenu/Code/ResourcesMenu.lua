--ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

ChoGGi.AddAction(
  "Expanded CM/Resources/Add Orbital Probes",
  ChoGGi.AddOrbitalProbes,
  nil,
  "Add more probes.",
  "ToggleTerrainHeight.tga"
)

ChoGGi.AddAction(
  "Expanded CM/Resources/Deep Scan",
  ChoGGi.DeepScanToggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.DeepScanAvailable,"(Enabled)","(Disabled)")
    return des .. " deep scan and deep resources exploitable. Also deep scanning probes.."
  end,
  "change_height_down.tga"
)

ChoGGi.AddAction(
  "Expanded CM/Resources/Deeper Scan Enable",
  ChoGGi.DeeperScanEnable,
  nil,
  "Uncovers extremely rich underground deposits (unlocks research).",
  "change_height_down.tga"
)

ChoGGi.AddAction(
  "Expanded CM/Resources/Food Per Rocket Passenger",
  ChoGGi.SetFoodPerRocketPassenger,
  nil,
  "Change the amount of Food supplied with each Colonist arrival.",
  "ToggleTerrainHeight.tga"
)

ChoGGi.AddAction(
  "Expanded CM/Resources/Prefabs/Add Drones",
  ChoGGi.AddPrefabsDrone,
  nil,
  "Add drone prefabs (use with DroneHub).",
  "gear.tga"
)

ChoGGi.AddAction(
  "Expanded CM/Resources/Prefabs/Add DroneHubs",
  function()
    ChoGGi.AddPrefabs("DroneHub"," DroneHub prefabs added.")
  end,
  nil,
  "Add DroneHub prefabs.",
  "gear.tga"
)

ChoGGi.AddAction(
  "Expanded CM/Resources/Prefabs/Add ElectronicsFactory",
  function()
    ChoGGi.AddPrefabs("ElectronicsFactory"," ElectronicsFactory prefabs added.")
  end,
  nil,
  "Add ElectronicsFactory prefabs.",
  "gear.tga"
)

ChoGGi.AddAction(
  "Expanded CM/Resources/Prefabs/Add FuelFactory",
  function()
    ChoGGi.AddPrefabs("FuelFactory"," FuelFactory prefabs added.")
  end,
  nil,
  "Add FuelFactory prefabs.",
  "gear.tga"
)

ChoGGi.AddAction(
  "Expanded CM/Resources/Prefabs/Add MachinePartsFactory",
  function()
    ChoGGi.AddPrefabs("MachinePartsFactory"," MachinePartsFactory prefabs added.")
  end,
  nil,
  "Add MachinePartsFactory prefabs.",
  "gear.tga"
)

ChoGGi.AddAction(
  "Expanded CM/Resources/Prefabs/Add MoistureVaporator",
  function()
    ChoGGi.AddPrefabs("MoistureVaporator"," MoistureVaporator prefabs added.")
  end,
  nil,
  "Add MoistureVaporator prefabs.",
  "gear.tga"
)

ChoGGi.AddAction(
  "Expanded CM/Resources/Prefabs/Add PolymerPlant",
  function()
    ChoGGi.AddPrefabs("PolymerPlant"," PolymerPlant prefabs added.")
  end,
  nil,
  "Add PolymerPlant prefabs.",
  "gear.tga"
)

ChoGGi.AddAction(
  "Expanded CM/Resources/Prefabs/Add StirlingGenerator",
  function()
    ChoGGi.AddPrefabs("StirlingGenerator"," StirlingGenerator prefabs added.")
  end,
  nil,
  "Add StirlingGenerator prefabs.",
  "gear.tga"
)

ChoGGi.AddAction(
  "Expanded CM/Resources/Prefabs/Spire/Add WaterReclamationSystem",
  function()
    ChoGGi.AddPrefabs("WaterReclamationSystem"," WaterReclamationSystem prefabs added.")
  end,
  nil,
  "Add WaterReclamationSystem prefabs.",
  "gear.tga"
)

ChoGGi.AddAction(
  "Expanded CM/Resources/Prefabs/Spire/Add Arcology",
  function()
    ChoGGi.AddPrefabs("Arcology"," Arcology prefabs added.")
  end,
  nil,
  "Add Arcology prefabs.",
  "gear.tga"
)

ChoGGi.AddAction(
  "Expanded CM/Resources/Prefabs/Spire/Add Sanatorium",
  function()
    ChoGGi.AddPrefabs("Sanatorium"," Sanatorium prefabs added.")
  end,
  nil,
  "Add Sanatorium prefabs.",
  "gear.tga"
)

ChoGGi.AddAction(
  "Expanded CM/Resources/Prefabs/Spire/Add NetworkNode",
  function()
    ChoGGi.AddPrefabs("NetworkNode"," NetworkNode prefabs added.")
  end,
  nil,
  "Add NetworkNode prefabs.",
  "gear.tga"
)

ChoGGi.AddAction(
  "Expanded CM/Resources/Prefabs/Spire/Add MedicalCenter",
  function()
    ChoGGi.AddPrefabs("MedicalCenter"," MedicalCenter prefabs added.")
  end,
  nil,
  "Add MedicalCenter prefabs.",
  "gear.tga"
)

ChoGGi.AddAction(
  "Expanded CM/Resources/Prefabs/Spire/Add HangingGardens",
  function()
    ChoGGi.AddPrefabs("HangingGardens"," HangingGardens prefabs added.")
  end,
  nil,
  "Add HangingGardens prefabs.",
  "gear.tga"
)

ChoGGi.AddAction(
  "Expanded CM/Resources/Prefabs/Spire/Add CloningVats",
  function()
    ChoGGi.AddPrefabs("CloningVats"," CloningVats prefabs added.")
  end,
  nil,
  "Add CloningVats prefabs.",
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
  function()
    ChoGGi.FillResource(SelectedObj or SelectionMouseObj())
  end,
  "Ctrl-F",
  "Fill the selected object's resource(s)",
  "Cube.tga"
)
