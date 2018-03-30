--ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

ChoGGi.AddAction(
  "Gameplay/Resources/Deep Scan Toggle",
  ChoGGi.DeepScanToggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.DeepScanAvailable,"(Enabled)","(Disabled)")
    return des .. " deep scan and deep resources exploitable. Also deep scanning probes.."
  end,
  "change_height_down.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Deeper Scan Enable",
  ChoGGi.DeeperScanEnable,
  nil,
  "Uncovers extremely rich underground deposits (unlocks research).",
  "change_height_down.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Passengers/[1]Food Per Rocket Passenger (Default)",
  function()
    ChoGGi.FoodPerRocketPassenger(1)
  end,
  nil,
  function()
    return ChoGGi.Consts.FoodPerRocketPassenger / ChoGGi.Consts.ResourceScale .. " = The amount of Food supplied with each Colonist arrival."
  end,
  "ToggleTerrainHeight.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Passengers/[2]Food Per Rocket Passenger + 25",
  function()
    ChoGGi.FoodPerRocketPassenger(2)
  end,
  nil,
  function()
    return Consts.FoodPerRocketPassenger / ChoGGi.Consts.ResourceScale .. " + 25 = The amount of Food supplied with each Colonist arrival."
  end,
  "ToggleTerrainHeight.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Passengers/[5]Food Per Rocket Passenger + 1000",
  function()
    ChoGGi.FoodPerRocketPassenger(3)
  end,
  nil,
  function()
    return Consts.FoodPerRocketPassenger / ChoGGi.Consts.ResourceScale .. " + 1000 = The amount of Food supplied with each Colonist arrival."
  end,
  "ToggleTerrainHeight.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Prefabs/Add 100 Drones",
  ChoGGi.Add100PrefabsDrone,
  nil,
  nil,
  "gear.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Prefabs/Add 10 DroneHub",
  function()
    ChoGGi.AddPrefabs("DroneHub",10,"10 DroneHub Prefabs Added")
  end,
  nil,
  nil,
  "gear.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Prefabs/Add 10 ElectronicsFactory",
  function()
    ChoGGi.AddPrefabs("ElectronicsFactory",10,"10 ElectronicsFactory Prefabs Added")
  end,
  nil,
  nil,
  "gear.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Prefabs/Add 10 FuelFactory",
  function()
    ChoGGi.AddPrefabs("FuelFactory",10,"10 FuelFactory Prefabs Added")
  end,
  nil,
  nil,
  "gear.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Prefabs/Add 10 MachinePartsFactory",
  function()
    ChoGGi.AddPrefabs("MachinePartsFactory",10,"10 MachinePartsFactory Prefabs Added")
  end,
  nil,
  nil,
  "gear.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Prefabs/Add 10 MoistureVaporator",
  function()
    ChoGGi.AddPrefabs("MoistureVaporator",10,"10 MoistureVaporator Prefabs Added")
  end,
  nil,
  nil,
  "gear.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Prefabs/Add 10 PolymerPlant",
  function()
    ChoGGi.AddPrefabs("PolymerPlant",10,"10 PolymerPlant Prefabs Added")
  end,
  nil,
  nil,
  "gear.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Prefabs/Add 10 StirlingGenerator",
  function()
    ChoGGi.AddPrefabs("StirlingGenerator",10,"10 StirlingGenerator Prefabs Added")
  end,
  nil,
  nil,
  "gear.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Prefabs/Add 10 WaterReclamationSystem",
  function()
    ChoGGi.AddPrefabs("WaterReclamationSystem",10,"10 WaterReclamationSystem Prefabs Added")
  end,
  nil,
  nil,
  "gear.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Prefabs/Spire/Add 10 Arcology",
  function()
    ChoGGi.AddPrefabs("Arcology",10,"10 Arcology Prefabs Added")
  end,
  nil,
  nil,
  "gear.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Prefabs/Spire/Add 10 Sanatorium",
  function()
    ChoGGi.AddPrefabs("Sanatorium",10,"10 Sanatorium Prefabs Added")
  end,
  nil,
  nil,
  "gear.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Prefabs/Spire/Add 10 NetworkNode",
  function()
    ChoGGi.AddPrefabs("NetworkNode",10,"10 NetworkNode Prefabs Added")
  end,
  nil,
  nil,
  "gear.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Prefabs/Spire/Add 10 MedicalCenter",
  function()
    ChoGGi.AddPrefabs("MedicalCenter",10,"10 MedicalCenter Prefabs Added")
  end,
  nil,
  nil,
  "gear.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Prefabs/Spire/Add 10 HangingGardens",
  function()
    ChoGGi.AddPrefabs("HangingGardens",10,"10 HangingGardens Prefabs Added")
  end,
  nil,
  nil,
  "gear.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Prefabs/Spire/Add 10 CloningVats",
  function()
    ChoGGi.AddPrefabs("CloningVats",10,"10 CloningVats Prefabs Added")
  end,
  nil,
  nil,
  "gear.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Add Funding/[1]Add 100 M",
  function()
    ChoGGi.SetFunds(100,"100 M Added")
  end,
  nil,
  nil,
  "pirate.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Add Funding/[2]Add 1,000 M",
  function()
    ChoGGi.SetFunds(1000,"1,000 M Added")
  end,
  nil,
  nil,
  "pirate.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Add Funding/[3]Add 10,000 M",
  function()
    ChoGGi.SetFunds(10000,"10,000 M Added")
  end,
  nil,
  nil,
  "pirate.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Add Funding/[4]Add 100,000 M",
  function()
    ChoGGi.SetFunds(100000,"100,000 M Added")
  end,
  nil,
  nil,
  "pirate.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Add Funding/[5]Add 1,000,000,000 M",
  function()
    ChoGGi.SetFunds(1000000000,"1,000,000,000 M Added")
  end,
  nil,
  nil,
  "pirate.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Add Funding/[6]Set to 500 M",
  function()
    if UICity then
      UICity.funding = 0
    end
    ChoGGi.SetFunds(500,"500 M")
  end,
  nil,
  nil,
  "pirate.tga"
)

ChoGGi.AddAction(
  "Gameplay/Resources/Fill Selected Resource",
  function()
    ChoGGi.FillResource(SelectedObj)
  end,
  "Ctrl-F",
  "Fill the selected object's resource(s)",
  "Cube.tga"
)

if ChoGGi.ChoGGiTest then
  table.insert(ChoGGi.FilesCount,"MenuResources")
end
