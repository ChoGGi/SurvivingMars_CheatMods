
function ChoGGi.DisasterTriggerColdWave()
  CreateGameTimeThread(function()
    local data = DataInstances.MapSettings_ColdWave
    local descr = data[mapdata.MapSettings_ColdWave] or data.ColdWave_VeryLow
    StartColdWave(descr)
  end)
end
function ChoGGi.DisasterTriggerDustDevil(major)
  local pos = point(GetTerrainCursor():x(),GetTerrainCursor():y())
  local data = DataInstances.MapSettings_DustDevils
  --local descr = mapdata.MapSettings_DustDevils ~= "disabled" and data[mapdata.MapSettings_DustDevils] or data.DustDevils_VeryLow
  local descr = data[mapdata.MapSettings_DustDevils] or data.DustDevils_VeryLow
  local devil = GenerateDustDevil(pos, descr, nil, major)
  devil:Start()
end
function ChoGGi.DisasterTriggerDustStorm(storm_type)
  CreateGameTimeThread(function()
    local data = DataInstances.MapSettings_DustStorm
    local descr = data[mapdata.MapSettings_DustStorm] or data.DustStorm_VeryLow
    StartDustStorm(storm_type,descr)
  end)
end
function ChoGGi.DisasterTriggerMeteor(meteors_type)
  local pos = point(GetTerrainCursor():x(),GetTerrainCursor():y())
  local data = DataInstances.MapSettings_Meteor
  --local descr = mapdata.MapSettings_Meteor ~= "disabled" and data[mapdata.MapSettings_Meteor] or data.Meteor_VeryLow
  local descr = data[mapdata.MapSettings_Meteor] or data.Meteor_VeryLow
  CreateGameTimeThread(function()
    MeteorsDisaster(descr, meteors_type, pos)
  end)
end
function ChoGGi.DisastersStop()
  for Key,_ in pairs(g_IncomingMissiles or empty_table) do
    Key:ExplodeInAir()
  end
  if g_DustStorm then
    StopDustStorm()
  end
  if g_ColdWave then
    StopColdWave()
  end
end

function ChoGGi.DisastersTrigger()
  local ItemList = {
    {
      text = "Stop All Disasters",
      value = false,
    },
    {
      text = "Cold Wave",
      value = false,
    },
    {
      text = "Dust Devil Major",
      value = "major",
    },
    {
      text = "Dust Devil",
      value = false,
    },
    {
      text = "Dust Storm Electrostatic",
      value = "electrostatic",
    },
    {
      text = "Dust Storm Great",
      value = "great",
    },
    {
      text = "Dust Storm Normal",
      value = "normal",
    },
    {
      text = "Meteors Storm",
      value = "storm",
    },
    {
      text = "Meteors Multi Spawn",
      value = "multispawn",
    },
    {
      text = "Meteors Single",
      value = "single",
    },
  }

  local CallBackFunc = function(choice)
    if choice[1].which == 1 then
      ChoGGi.DisastersStop()
    elseif choice[1].which == 2 then
      ChoGGi.DisasterTriggerColdWave()
    elseif choice[1].which == 3 or choice[1].which == 4 then
      ChoGGi.DisasterTriggerDustDevil(choice[1].value)
    elseif choice[1].which == 5 or choice[1].which == 6 or choice[1].which == 7 then
      ChoGGi.DisasterTriggerDustStorm(choice[1].value)
    elseif choice[1].which == 8 or choice[1].which == 9 or choice[1].which == 10 then
      ChoGGi.DisasterTriggerMeteor(choice[1].value)
    end


    ChoGGi.MsgPopup("Spawned: " .. choice[1].text,
      "Disasters","UI/Icons/Sections/attention.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Trigger Disaster","Targeted to mouse cursor (use arrow keys and enter to select).")
end

function ChoGGi.SpawnColonists()
  local ItemList = {
    {
      text = 1,
      value = 1,
    },
    {
      text = 10,
      value = 10,
    },
    {
      text = 25,
      value = 25,
    },
    {
      text = 50,
      value = 50,
    },
    {
      text = 75,
      value = 75,
    },
    {
      text = 100,
      value = 100,
    },
    {
      text = 250,
      value = 250,
    },
    {
      text = 500,
      value = 500,
    },
    {
      text = 1000,
      value = 1000,
    },
    {
      text = 2500,
      value = 2500,
    },
    {
      text = 5000,
      value = 5000,
    },
    {
      text = 10000,
      value = 10000,
    },
  }

  local CallBackFunc = function(choice)
    local amount = choice[1].value
    if type(amount) == "number" then
      CheatSpawnNColonists(amount)
      ChoGGi.MsgPopup("Spawned: " .. choice[1].text,
        "Colonists","UI/Icons/Sections/colonist.tga"
      )
    end
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Spawn Colonists","Colonist placing priority: Selected dome, Evenly between domes, or centre of map if no domes.")
end

function ChoGGi.ShowMysteryList()
  local ItemList = {}
  ClassDescendantsList("MysteryBase",function(class)
    table.insert(ItemList,{
      text = (g_Classes[class].scenario_name .. ": " .. _InternalTranslate(T({ChoGGi.MysteryDifficulty[class]})) or "Missing Name"),
      value = class,
      hint = (g_Classes[class].scenario_name or "Missing Name") .. ": " .. (_InternalTranslate(T({ChoGGi.MysteryDescription[class]})) or "Missing Description")
    })
  end)

  local CallBackFunc = function(choice)
    if ChoGGi.ListChoiceCustom_CheckBox1 then
      --instant
      ChoGGi.StartMystery(choice[1].value,true)
    else
      ChoGGi.StartMystery(choice[1].value)
    end
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Start A Mystery","Warning: Adding a mystery is cumulative, this will NOT replace existing mysteries.",nil,"Instant Start","May take up to one Sol to \"instantly\" activate mystery.")
end

function ChoGGi.StartMystery(Mystery,Bool)
  --inform people of actions, so they don't add a bunch of them
  ChoGGi.CheatMenuSettings.ShowMysteryMsgs = true

  UICity.mystery_id = Mystery
  for i = 1, #TechTree do
    local field = TechTree[i]
    local field_id = field.id
    --local costs = field.costs or empty_table
    local list = UICity.tech_field[field_id] or {}
    UICity.tech_field[field_id] = list
    for _, tech in ipairs(field) do
      if tech.mystery == Mystery then
        local tech_id = tech.id
        list[#list + 1] = tech_id
        UICity.tech_status[tech_id] = {points = 0, field = field_id}
        tech:Initialize(UICity)
      end
    end
  end
  UICity:InitMystery()
  --might help
  if UICity.mystery then
    UICity.mystery_id = UICity.mystery.class
    UICity.mystery:ApplyMysteryResourceProperties()
  end
  --instant start
  if Bool == true then
    local sequence = UICity.mystery.seq_player.seq_list[1]
    for i = 1, #sequence do
      if sequence[i].class == "SA_WaitExpression" then
        UICity.mystery.seq_player.seq_list[1][i].duration = 0
        UICity.mystery.seq_player.seq_list[1][i].expression = nil
      elseif sequence[i].class == "SA_WaitMarsTime" then
        UICity.mystery.seq_player.seq_list[1][i].duration = 0
        UICity.mystery.seq_player.seq_list[1][i].rand_duration = 0
        break
      end
    end
    UICity.mystery.seq_player:AutostartSequences()
  end
end

function ChoGGi.UnlockAllBuildings()
  CheatUnlockAllBuildings()
  RefreshXBuildMenu()

  ChoGGi.MsgPopup("Unlocked all buildings for construction.",
   "Buildings","UI/Icons/Upgrades/build_2.tga"
  )
end

function ChoGGi.AddOutsourcePoints()
  local ItemList = {
    {
      text = 100,
      value = 100,
    },
    {
      text = 250,
      value = 250,
    },
    {
      text = 500,
      value = 500,
    },
    {
      text = 1000,
      value = 1000,
    },
    {
      text = 2500,
      value = 2500,
    },
    {
      text = 5000,
      value = 5000,
    },
    {
      text = 10000,
      value = 10000,
    },
    {
      text = 25000,
      value = 25000,
    },
    {
      text = 50000,
      value = 50000,
    },
    {
      text = 100000,
      value = 100000,
    },
    {
      text = 100000000,
      value = 100000000,
    },
  }

  local CallBackFunc = function(choice)
    local amount = choice[1].value
    if type(amount) == "number" then
      UICity:AddResearchPoints(amount)
      ChoGGi.MsgPopup("Selected: " .. choice[1].text,
        "Research","UI/Icons/Upgrades/eternal_fusion_04.tga"
      )
    end
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Add Research Points","If you need a little boost (or a lotta boost) in research.")

end

function ChoGGi.OutsourcePoints1000000()
  Consts.OutsourceResearch = 1000 * ChoGGi.Consts.ResearchPointsScale
  ChoGGi.CheatMenuSettings.OutsourceResearch = Consts.OutsourceResearch
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.OutsourceResearch .. ": The same thing we do every night, Pinky - try to take over the world!",
   "Research","UI/Icons/Upgrades/eternal_fusion_04.tga"
  )
end

function ChoGGi.OutsourcingFree_Toggle()
  Consts.OutsourceResearchCost = ChoGGi.NumRetBool(Consts.OutsourceResearchCost) and 0 or ChoGGi.Consts.OutsourceResearchCost
  ChoGGi.CheatMenuSettings.OutsourceResearchCost = Consts.OutsourceResearchCost
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.OutsourceResearchCost .. ": Best hope you picked India as your Mars sponsor",
   "Research","UI/Icons/Sections/research_1.tga"
  )
end

function ChoGGi.BreakThroughTechsPerGame_Toggle()
  if const.BreakThroughTechsPerGame == 26 then
    const.BreakThroughTechsPerGame = ChoGGi.Consts.BreakThroughTechsPerGame
  else
    const.BreakThroughTechsPerGame = 26
  end
  ChoGGi.CheatMenuSettings.BreakThroughTechsPerGame = const.BreakThroughTechsPerGame
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(ChoGGi.CheatMenuSettings.BreakThroughTechsPerGame .. ": S M R T",
   "Research","UI/Icons/Notifications/research.tga"
  )
end

function ChoGGi.ShowResearchDialog()
  local ItemList = {}
  table.insert(ItemList,{
    text = "(Everything)",
    value = "Everything",
    hint = "All the tech/breakthroughs/mysteries"
  })
  table.insert(ItemList,{
    text = "(All Tech)",
    value = "AllTech",
    hint = "All the regular tech"
  })
  table.insert(ItemList,{
    text = "(All Breakthroughs)",
    value = "AllBreakthroughs",
    hint = "All the breakthroughs"
  })
  table.insert(ItemList,{
    text = "(All Mysteries)",
    value = "AllMysteries",
    hint = "All the mysteries"
  })
  for i = 1, #TechTree do
    for j = 1, #TechTree[i] do
      table.insert(ItemList,{
        text = _InternalTranslate(TechTree[i][j].display_name),
        value = TechTree[i][j].id,
        hint = _InternalTranslate(TechTree[i][j].description)
      })
    end
  end

  local CallBackFunc = function(choice)

    --nothing checked so just return
    if not ChoGGi.ListChoiceCustom_CheckBox1 and not ChoGGi.ListChoiceCustom_CheckBox2 then
      ChoGGi.MsgPopup("Pick a checkbox next time...","Research","UI/Icons/Notifications/research.tga")
      return
    elseif ChoGGi.ListChoiceCustom_CheckBox1 and ChoGGi.ListChoiceCustom_CheckBox2 then
      ChoGGi.MsgPopup("Don't pick both checkboxes next time...","Research","UI/Icons/Notifications/research.tga")
      return
    end

    local sType
    local Which
    --add
    if ChoGGi.ListChoiceCustom_CheckBox1 then
      sType = "DiscoverTech"
      Which = "Unlocked"
    --remove
    elseif ChoGGi.ListChoiceCustom_CheckBox2 then
      sType = "GrantTech"
      Which = "Researched"
    end

    --MultiSel
    for i = 1, #choice do
      local value = choice[i].value
      if value == "Everything" then
        ChoGGi.SetTech_EveryMystery(sType)
        ChoGGi.SetTech_EveryBreakthrough(sType)
        ChoGGi.SetTech_EveryTech(sType)
      elseif value == "AllTech" then
        ChoGGi.SetTech_EveryTech(sType)
      elseif value == "AllBreakthroughs" then
        ChoGGi.SetTech_EveryBreakthrough(sType)
      elseif value == "AllMysteries" then
        ChoGGi.SetTech_EveryMystery(sType)
      else
        _G[sType](value)
      end
    end

    ChoGGi.MsgPopup(Which .. ": Unleash your inner Black Monolith Mystery.",
      "Research","UI/Icons/Notifications/research.tga"
    )

  end

  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Research Unlock","Select Unlock or Research then select the tech you want (Ctrl/Shift to multi-select).",true,"Unlock","Just unlocks in the tree","Research","Unlocks and researchs.")

end

function ChoGGi.SetTech_EveryMystery(sType)
  _G[sType]("BlackCubesDisposal")
  _G[sType]("AlienDiggersDestruction")
  _G[sType]("AlienDiggersDetection")
  _G[sType]("XenoExtraction")
  _G[sType]("RegolithExtractor")
  _G[sType]("PowerDecoy")
  _G[sType]("Xeno-Terraforming")
  _G[sType]("DreamSimulation")
  _G[sType]("NumberSixTracing")
  _G[sType]("DefenseTower")
  _G[sType]("SolExploration")
  _G[sType]("WildfireCure")
end

function ChoGGi.SetTech_EveryBreakthrough(sType)
  _G[sType]("ConstructionNanites")
  _G[sType]("HullPolarization")
  _G[sType]("ProjectPhoenix")
  _G[sType]("SoylentGreen")
  _G[sType]("NeuralEmpathy")
  _G[sType]("RapidSleep")
  _G[sType]("ThePositronicBrain")
  _G[sType]("SafeMode")
  _G[sType]("HiveMind")
  _G[sType]("SpaceRehabilitation")
  _G[sType]("WirelessPower")
  _G[sType]("PrintedElectronics")
  _G[sType]("CoreMetals")
  _G[sType]("CoreWater")
  _G[sType]("CoreRareMetals")
  _G[sType]("SuperiorCables")
  _G[sType]("SuperiorPipes")
  _G[sType]("AlienImprints")
  _G[sType]("NocturnalAdaptation")
  _G[sType]("GeneSelection")
  _G[sType]("MartianDiet")
  _G[sType]("EternalFusion")
  _G[sType]("SuperconductingComputing")
  _G[sType]("NanoRefinement")
  _G[sType]("ArtificialMuscles")
  _G[sType]("InspiringArchitecture")
  _G[sType]("GiantCrops")
  _G[sType]("NeoConcrete")
  _G[sType]("AdvancedDroneDrive")
  _G[sType]("DryFarming")
  _G[sType]("MartianSteel")
  _G[sType]("VectorPump")
  _G[sType]("Superfungus")
  _G[sType]("HypersensitivePhotovoltaics")
  _G[sType]("FrictionlessComposites")
  _G[sType]("ZeroSpaceComputing")
  _G[sType]("MultispiralArchitecture")
  _G[sType]("MagneticExtraction")
  _G[sType]("SustainedWorkload")
  _G[sType]("ForeverYoung")
  _G[sType]("MartianbornIngenuity")
  _G[sType]("CryoSleep")
  _G[sType]("Cloning")
  _G[sType]("GoodVibrations")
  _G[sType]("DomeStreamlining")
  _G[sType]("PrefabCompression")
  _G[sType]("ExtractorAI")
  _G[sType]("ServiceBots")
  _G[sType]("OverchargeAmplification")
  _G[sType]("PlutoniumSynthesis")
  _G[sType]("InterplanetaryLearning")
  _G[sType]("Vocation-Oriented Society")
  _G[sType]("PlasmaRocket")
  _G[sType]("AutonomousHubs")
  _G[sType]("FactoryAutomation")
end

function ChoGGi.SetTech_EveryTech(sType)
  _G[sType]("HygroscopicVaporators")
  _G[sType]("SoilAdaptation")
  _G[sType]("LowGFungi")
  _G[sType]("MagneticFiltering")
  _G[sType]("WaterReclamation")
  _G[sType]("UtilityCrops")
  _G[sType]("MartianbornAdaptability")
  _G[sType]("BiomeEngineering")
  _G[sType]("DomeBioscaping")
  _G[sType]("MicrogravityMedicine")
  _G[sType]("GeneAdaptation")
  _G[sType]("WaterCoservationSystem")
  _G[sType]("FarmAutomation ")
  _G[sType]("HangingGardens")
  _G[sType]("HolographicScanning")
  _G[sType]("MoistureFarming")
  _G[sType]("RejuvenationTreatment")
  _G[sType]("StemReconstruction")
  _G[sType]("LocalizedTerraforming")
  _G[sType]("FuelCompression")
  _G[sType]("DecommissionProtocol")
  _G[sType]("LowGHydrosynthsis")
  _G[sType]("AdvancedMartianEngines")
  _G[sType]("LowGHighrise")
  _G[sType]("CompactPassengerModule")
  _G[sType]("StorageCompression")
  _G[sType]("LowGEngineering")
  _G[sType]("SustainableArchitecture")
  _G[sType]("SmartHome")
  _G[sType]("MicroManufacturing")
  _G[sType]("Arcology")
  _G[sType]("MarsNoveau")
  _G[sType]("ResilientArchitecture")
  _G[sType]("AdvancedPassengerModule")
  _G[sType]("GravityEngineering")
  _G[sType]("PlasmaCutters")
  _G[sType]("WasteRockLiquefaction")
  _G[sType]("OrbitalEngineering")
  _G[sType]("TransportOptimization")
  _G[sType]("LowGDrive")
  _G[sType]("DroneSwarm")
  _G[sType]("ExplorerAI")
  _G[sType]("DroneHub")
  _G[sType]("BatteryOptimization")
  _G[sType]("RoverCommandAI")
  _G[sType]("DronePrinting")
  _G[sType]("3DMachining")
  _G[sType]("CO2JetPropulsion")
  _G[sType]("FueledExtractors")
  _G[sType]("FactoryAI")
  _G[sType]("MartianAerodynamics")
  _G[sType]("RoverPrinting")
  _G[sType]("CompactHangars")
  _G[sType]("HighPoweredJets")
  _G[sType]("TheMartianNetwork")
  _G[sType]("ProjectMohole")
  _G[sType]("LargeScaleExcavation")
  _G[sType]("ExtractorAmplification")
  _G[sType]("AutonomousSensors")
  _G[sType]("SubsurfaceHeating")
  _G[sType]("LowGTurbines")
  _G[sType]("AdaptedProbes")
  _G[sType]("StirlingGenerator")
  _G[sType]("AtomicAccumulator")
  _G[sType]("DustRepulsion")
  _G[sType]("FactoryAmplification")
  _G[sType]("DeepScanning")
  _G[sType]("DeepWaterExtraction")
  _G[sType]("DeepMetalExtraction")
  _G[sType]("NuclearFusion")
  _G[sType]("MeteorDefenseSystem")
  _G[sType]("TriboelectricScrubbing")
  _G[sType]("ResearchAmplification")
  _G[sType]("FusionAutoregulation")
  _G[sType]("MicroFusion")
  _G[sType]("InterplanetaryAstronomy")
  _G[sType]("LiveFromMars")
  _G[sType]("ProductivityTraining")
  _G[sType]("EarthMarsInitiative")
  _G[sType]("SystematicTraining")
  _G[sType]("MarsHype")
  _G[sType]("MartianEducation")
  _G[sType]("MartianPatents")
  _G[sType]("SupportiveCommunity")
  _G[sType]("EmergencyTraining")
  _G[sType]("GeneralTraining")
  _G[sType]("MartianInstituteOfScience")
  _G[sType]("BehavioralShaping")
  _G[sType]("MartianFestivals")
  _G[sType]("MartianbornStrength")
  _G[sType]("MartianbornResilience")
  _G[sType]("HomeCollective")
  _G[sType]("MartianCopyrithgts")
  _G[sType]("BehavioralMelding")
  _G[sType]("DreamReality")
end
