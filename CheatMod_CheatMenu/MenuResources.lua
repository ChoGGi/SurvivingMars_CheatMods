UserActions.AddActions({

  ChoGGi_FillSelectedResource = {
    menu = "Resources/Fill Selected Resource",
    description = "Fill the selected object's resource(s)",
    key = "Ctrl-F",
    action = function()
      ChoGGi.FillResource(SelectedObj)
    end
  },

  ChoGGi_FoodPerRocketPassengerDefault = {
    icon = "ToggleTerrainHeight.tga",
    menu = "Resources/Passengers/[1]Food Per Rocket Passenger Default",
    description = "The amount of Food supplied with each Colonist arrival.",
    action = function()
      Consts.FoodPerRocketPassenger = 10 * const.ResourceScale
      ChoGGi.CheatMenuSettings["FoodPerRocketPassenger"] = Consts.FoodPerRocketPassenger
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "FoodPerRocketPassengerDefault",
        "Passengers",
        "om nom nom",
        "UI/Icons/Sections/Food_4.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_FoodPerRocketPassengerIncrease = {
    icon = "ToggleTerrainHeight.tga",
    menu = "Resources/Passengers/[2]Food Per Rocket Passenger + 25",
    description = function()
      return Consts.FoodPerRocketPassenger .. " + 25 = The amount of Food supplied with each Colonist arrival."
    end,
    action = function()
      Consts.FoodPerRocketPassenger = Consts.FoodPerRocketPassenger + (25 * const.ResourceScale)
      ChoGGi.CheatMenuSettings["FoodPerRocketPassenger"] = Consts.FoodPerRocketPassenger
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "FoodPerRocketPassengerIncrease",
        "Passengers",
        "om nom nom",
        "UI/Icons/Sections/Food_4.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_FoodPerRocketPassengerIncrease1000 = {
    icon = "ToggleTerrainHeight.tga",
    menu = "Resources/Passengers/[5]Food Per Rocket Passenger + 1000",
    description = function()
      return Consts.FoodPerRocketPassenger .. " + 1000 = The amount of Food supplied with each Colonist arrival."
    end,
    action = function()
      Consts.FoodPerRocketPassenger = Consts.FoodPerRocketPassenger + (1000 * const.ResourceScale)
      ChoGGi.CheatMenuSettings["FoodPerRocketPassenger"] = Consts.FoodPerRocketPassenger
      ChoGGi.WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "FoodPerRocketPassenger1000",
        "Passengers",
        "om nom nom nom nom nom nom nom nom",
        "UI/Icons/Sections/Food_4.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Add100PrefabsDrone = {
    icon = "gear.tga",
    menu = "Resources/Prefabs/Add 100 Drones",
    action = function()
      UICity.drone_prefabs = UICity.drone_prefabs + 100
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Add100PrefabsDrone",
        "Prefabs",
        "100 Drone Prefabs Added",
        "UI/Icons/Sections/storage.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Add10PrefabsDroneHub = {
    icon = "gear.tga",
    menu = "Resources/Prefabs/Add 10 DroneHub",
    action = function()
      UICity:AddPrefabs("DroneHub", 10)
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Add10PrefabsDroneHub",
        "Prefabs",
        "10 DroneHub Prefabs Added",
        "UI/Icons/Sections/storage.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Add10PrefabsStirlingGenerator = {
    icon = "gear.tga",
    menu = "Resources/Prefabs/Add 10 StirlingGenerator",
    action = function()
      UICity:AddPrefabs("StirlingGenerator", 10)
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Add10PrefabsStirlingGenerator",
        "Prefabs",
        "10 StirlingGenerator Prefabs Added",
        "UI/Icons/Sections/storage.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Add10PrefabsElectronicsFactory = {
    icon = "gear.tga",
    menu = "Resources/Prefabs/Add 10 ElectronicsFactory",
    action = function()
      UICity:AddPrefabs("ElectronicsFactory", 10)
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Add10PrefabsElectronicsFactory",
        "Prefabs",
        "10 ElectronicsFactory Prefabs Added",
        "UI/Icons/Sections/storage.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Add10PrefabsFuelFactory = {
    icon = "gear.tga",
    menu = "Resources/Prefabs/Add 10 FuelFactory",
    action = function()
      UICity:AddPrefabs("FuelFactory", 10)
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Add10PrefabsFuelFactory",
        "Prefabs",
        "10 FuelFactory Prefabs Added",
        "UI/Icons/Sections/storage.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Add10PrefabsMachinePartsFactory = {
    icon = "gear.tga",
    menu = "Resources/Prefabs/Add 10 MachinePartsFactory",
    action = function()
      UICity:AddPrefabs("MachinePartsFactory", 10)
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Add10PrefabsMachinePartsFactory",
        "Prefabs",
        "10 MachinePartsFactory Prefabs Added",
        "UI/Icons/Sections/storage.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Add10PrefabsMoistureVaporator = {
    icon = "gear.tga",
    menu = "Resources/Prefabs/Add 10 MoistureVaporator",
    action = function()
      UICity:AddPrefabs("MoistureVaporator", 10)
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Add10PrefabsMoistureVaporator",
        "Prefabs",
        "10 MoistureVaporator Prefabs Added",
        "UI/Icons/Sections/storage.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Add10PrefabsPolymerPlant = {
    icon = "gear.tga",
    menu = "Resources/Prefabs/Add 10 PolymerPlant",
    action = function()
      UICity:AddPrefabs("PolymerPlant", 10)
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Add10PrefabsPolymerPlant",
        "Prefabs",
        "10 PolymerPlant Prefabs Added",
        "UI/Icons/Sections/storage.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Add10PrefabsStirlingGenerator = {
    icon = "gear.tga",
    menu = "Resources/Prefabs/Add 10 StirlingGenerator",
    action = function()
      UICity:AddPrefabs("StirlingGenerator", 10)
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Add10PrefabsStirlingGenerator",
        "Prefabs",
        "10 StirlingGenerator Prefabs Added",
        "UI/Icons/Sections/storage.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Add10PrefabsWaterReclamationSystem = {
    icon = "gear.tga",
    menu = "Resources/Prefabs/Add 10 WaterReclamationSystem",
    action = function()
      UICity:AddPrefabs("WaterReclamationSystem", 10)
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Add10PrefabsWaterReclamationSystem",
        "Prefabs",
        "10 WaterReclamationSystem Prefabs Added",
        "UI/Icons/Sections/storage.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Add10PrefabsArcology = {
    icon = "gear.tga",
    menu = "Resources/Prefabs/Spire/Add 10 Arcology",
    action = function()
      UICity:AddPrefabs("Arcology", 10)
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Add10PrefabsArcology",
        "Prefabs",
        "10 Arcology Prefabs Added",
        "UI/Icons/Sections/storage.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Add10PrefabsSanatorium = {
    icon = "gear.tga",
    menu = "Resources/Prefabs/Spire/Add 10 Sanatorium",
    action = function()
      UICity:AddPrefabs("Sanatorium", 10)
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Add10PrefabsSanatorium",
        "Prefabs",
        "10 Sanatorium Prefabs Added",
        "UI/Icons/Sections/storage.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Add10PrefabsNetworkNode = {
    icon = "gear.tga",
    menu = "Resources/Prefabs/Spire/Add 10 NetworkNode",
    action = function()
      UICity:AddPrefabs("NetworkNode", 10)
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Add10PrefabsNetworkNode",
        "Prefabs",
        "10 NetworkNode Prefabs Added",
        "UI/Icons/Sections/storage.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Add10PrefabsMedicalCenter = {
    icon = "gear.tga",
    menu = "Resources/Prefabs/Spire/Add 10 MedicalCenter",
    action = function()
      UICity:AddPrefabs("MedicalCenter", 10)
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Add10PrefabsMedicalCenter",
        "Prefabs",
        "10 MedicalCenter Prefabs Added",
        "UI/Icons/Sections/storage.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Add10PrefabsHangingGardens = {
    icon = "gear.tga",
    menu = "Resources/Prefabs/Spire/Add 10 HangingGardens",
    action = function()
      UICity:AddPrefabs("HangingGardens", 10)
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Add10PrefabsHangingGardens",
        "Prefabs",
        "10 HangingGardens Prefabs Added",
        "UI/Icons/Sections/storage.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_Add10PrefabsCloningVats = {
    icon = "gear.tga",
    menu = "Resources/Prefabs/Spire/Add 10 CloningVats",
    action = function()
      UICity:AddPrefabs("CloningVats", 10)
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "Add10PrefabsCloningVats",
        "Prefabs",
        "10 CloningVats Prefabs Added",
        "UI/Icons/Sections/storage.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_FundsAdded10000M = {
    icon = "pirate.tga",
    menu = "Resources/Add Funding/[3]Add 10,000 M",
    action = function()
      ChangeFunding(10000)
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "FundsAdded10000M",
        "Add Funding",
        "10,000 M Added",
        "UI/Icons/IPButtons/rare_metals.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_FundsAdded1000M = {
    icon = "pirate.tga",
    menu = "Resources/Add Funding/[2]Add 1,000 M",
    action = function()
      ChangeFunding(1000)
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "FundsAdded1000M",
        "Add Funding",
        "1,000 M Added",
        "UI/Icons/IPButtons/rare_metals.tga",
        nil,
        {expiration=5000})
      )
    end
  },

  ChoGGi_FundsAdded25M = {
    icon = "pirate.tga",
    menu = "Resources/Add Funding/[1]Add 25 M",
    action = function()
      ChangeFunding(25)
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "FundsAdded25M",
        "Add Funding",
        "25 M Added",
        "UI/Icons/IPButtons/rare_metals.tga",
        nil,
        {expiration=5000})
      )
    end
  },

})
