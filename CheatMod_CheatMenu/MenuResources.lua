UserActions.AddActions({

  ChoGGi_DeepScanToggle = {
    icon = "change_height_down.tga",
    menu = "Gameplay/Resources/Deep/Deep Scan Toggle",
    description = function()
      local action = ChoGGi.NumRetBool(Consts.DeepScanAvailable,"(Disabled)","(Enabled)")
      return action .. " deep scan and deep resources exploitable. Also deep scanning probes.."
    end,
    action = ChoGGi.DeepScanToggle
  },

  ChoGGi_DeeperScanEnable = {
    icon = "change_height_down.tga",
    menu = "Gameplay/Resources/Deep/Deeper Scan Enable",
    description = "Uncovers extremely rich underground deposits (unlocks research).",
    action = ChoGGi.DeeperScanEnable
  },

  ChoGGi_FoodPerRocketPassengerDefault = {
    icon = "ToggleTerrainHeight.tga",
    menu = "Gameplay/Resources/Passengers/[1]Food Per Rocket Passenger Default",
    description = function()
      return ChoGGi.Consts.FoodPerRocketPassenger / ChoGGi.Consts.ResourceScale .. " = The amount of Food supplied with each Colonist arrival."
    end,
    action = function()
      ChoGGi.FoodPerRocketPassenger(1)
    end
  },

  ChoGGi_FoodPerRocketPassengerIncrease = {
    icon = "ToggleTerrainHeight.tga",
    menu = "Gameplay/Resources/Passengers/[2]Food Per Rocket Passenger + 25",
    description = function()
      return Consts.FoodPerRocketPassenger / ChoGGi.Consts.ResourceScale .. " + 25 = The amount of Food supplied with each Colonist arrival."
    end,
    action = function()
      ChoGGi.FoodPerRocketPassenger(2)
    end
  },

  ChoGGi_FoodPerRocketPassengerIncrease1000 = {
    icon = "ToggleTerrainHeight.tga",
    menu = "Gameplay/Resources/Passengers/[5]Food Per Rocket Passenger + 1000",
    description = function()
      return Consts.FoodPerRocketPassenger / ChoGGi.Consts.ResourceScale .. " + 1000 = The amount of Food supplied with each Colonist arrival."
    end,
    action = function()
      ChoGGi.FoodPerRocketPassenger(3)
    end
  },

  ChoGGi_Add100PrefabsDrone = {
    icon = "gear.tga",
    menu = "Gameplay/Resources/Prefabs/Add 100 Drones",
    action = ChoGGi.Add100PrefabsDrone
  },

  ChoGGi_Add10PrefabsDroneHub = {
    icon = "gear.tga",
    menu = "Gameplay/Resources/Prefabs/Add 10 DroneHub",
    action = function()
      ChoGGi.AddPrefabs("DroneHub",10,"10 DroneHub Prefabs Added")
    end
  },

  ChoGGi_Add10PrefabsElectronicsFactory = {
    icon = "gear.tga",
    menu = "Gameplay/Resources/Prefabs/Add 10 ElectronicsFactory",
    action = function()
      ChoGGi.AddPrefabs("ElectronicsFactory",10,"10 ElectronicsFactory Prefabs Added")
    end
  },

  ChoGGi_Add10PrefabsFuelFactory = {
    icon = "gear.tga",
    menu = "Gameplay/Resources/Prefabs/Add 10 FuelFactory",
    action = function()
      ChoGGi.AddPrefabs("FuelFactory",10,"10 FuelFactory Prefabs Added")
    end
  },

  ChoGGi_Add10PrefabsMachinePartsFactory = {
    icon = "gear.tga",
    menu = "Gameplay/Resources/Prefabs/Add 10 MachinePartsFactory",
    action = function()
      ChoGGi.AddPrefabs("MachinePartsFactory",10,"10 MachinePartsFactory Prefabs Added")
    end
  },

  ChoGGi_Add10PrefabsMoistureVaporator = {
    icon = "gear.tga",
    menu = "Gameplay/Resources/Prefabs/Add 10 MoistureVaporator",
    action = function()
      ChoGGi.AddPrefabs("MoistureVaporator",10,"10 MoistureVaporator Prefabs Added")
    end
  },

  ChoGGi_Add10PrefabsPolymerPlant = {
    icon = "gear.tga",
    menu = "Gameplay/Resources/Prefabs/Add 10 PolymerPlant",
    action = function()
      ChoGGi.AddPrefabs("PolymerPlant",10,"10 PolymerPlant Prefabs Added")
    end
  },

  ChoGGi_Add10PrefabsStirlingGenerator = {
    icon = "gear.tga",
    menu = "Gameplay/Resources/Prefabs/Add 10 StirlingGenerator",
    action = function()
      ChoGGi.AddPrefabs("StirlingGenerator",10,"10 StirlingGenerator Prefabs Added")
    end
  },

  ChoGGi_Add10PrefabsWaterReclamationSystem = {
    icon = "gear.tga",
    menu = "Gameplay/Resources/Prefabs/Add 10 WaterReclamationSystem",
    action = function()
      ChoGGi.AddPrefabs("WaterReclamationSystem",10,"10 WaterReclamationSystem Prefabs Added")
    end
  },

  ChoGGi_Add10PrefabsArcology = {
    icon = "gear.tga",
    menu = "Gameplay/Resources/Prefabs/Spire/Add 10 Arcology",
    action = function()
      ChoGGi.AddPrefabs("Arcology",10,"10 Arcology Prefabs Added")
    end
  },

  ChoGGi_Add10PrefabsSanatorium = {
    icon = "gear.tga",
    menu = "Gameplay/Resources/Prefabs/Spire/Add 10 Sanatorium",
    action = function()
      ChoGGi.AddPrefabs("Sanatorium",10,"10 Sanatorium Prefabs Added")
    end
  },

  ChoGGi_Add10PrefabsNetworkNode = {
    icon = "gear.tga",
    menu = "Gameplay/Resources/Prefabs/Spire/Add 10 NetworkNode",
    action = function()
      ChoGGi.AddPrefabs("NetworkNode",10,"10 NetworkNode Prefabs Added")
    end
  },

  ChoGGi_Add10PrefabsMedicalCenter = {
    icon = "gear.tga",
    menu = "Gameplay/Resources/Prefabs/Spire/Add 10 MedicalCenter",
    action = function()
      ChoGGi.AddPrefabs("MedicalCenter",10,"10 MedicalCenter Prefabs Added")
    end
  },

  ChoGGi_Add10PrefabsHangingGardens = {
    icon = "gear.tga",
    menu = "Gameplay/Resources/Prefabs/Spire/Add 10 HangingGardens",
    action = function()
      ChoGGi.AddPrefabs("HangingGardens",10,"10 HangingGardens Prefabs Added")
    end
  },

  ChoGGi_Add10PrefabsCloningVats = {
    icon = "gear.tga",
    menu = "Gameplay/Resources/Prefabs/Spire/Add 10 CloningVats",
    action = function()
      ChoGGi.AddPrefabs("CloningVats",10,"10 CloningVats Prefabs Added")
    end
  },

  ChoGGi_FundsAdded10000M = {
    icon = "pirate.tga",
    menu = "Gameplay/Resources/Add Funding/[3]Add 10,000 M",
    action = function()
      ChoGGi.AddFunds(10000,"10,000 M Added")
    end
  },

  ChoGGi_FundsAdded1000M = {
    icon = "pirate.tga",
    menu = "Gameplay/Resources/Add Funding/[2]Add 1,000 M",
    action = function()
      ChoGGi.AddFunds(1000,"1,000 M Added")
    end
  },

  ChoGGi_FundsAdded25M = {
    icon = "pirate.tga",
    menu = "Gameplay/Resources/Add Funding/[1]Add 25 M",
    action = function()
      ChoGGi.AddFunds(25,"25 M Added")
    end
  },

  ChoGGi_FillSelectedResource = {
    icon = "Cube.tga",
    menu = "Gameplay/Resources/Fill Selected Resource",
    description = "Fill the selected object's resource(s)",
    key = "Ctrl-F",
    action = function()
      ChoGGi.FillResource(SelectedObj)
    end
  },

})

if ChoGGi.ChoGGiComp then
  AddConsoleLog("ChoGGi: MenuResources.lua",true)
end
