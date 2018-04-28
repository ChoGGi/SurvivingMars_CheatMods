
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

function ChoGGi.ShowScanAndMapOptions()
  local hint_core = "Core: Repeatable"
  local hint_deep = "Deep: Toggleable"
  local ItemList = {
    {text = " All",value = 1,hint = hint_core .. "\n" .. hint_deep},
    {text = " Deep",value = 2,hint = hint_deep},
    {text = " Core",value = 3,hint = hint_core},
    {text = "Deep Scan",value = 4,hint = hint_deep .. "\nEnabled: " .. Consts.DeepScanAvailable},
    {text = "Deep Water",value = 5,hint = hint_deep .. "\nEnabled: " .. Consts.IsDeepWaterExploitable},
    {text = "Deep Metals",value = 6,hint = hint_deep .. "\nEnabled: " .. Consts.IsDeepMetalsExploitable},
    {text = "Deep Precious Metals",value = 7,hint = hint_deep .. "\nEnabled: " .. Consts.IsDeepPreciousMetalsExploitable},
    {text = "Core Water",value = 8,hint = hint_core},
    {text = "Core Metals",value = 9,hint = hint_core},
    {text = "Core Precious Metals",value = 10,hint = hint_core},
    {text = "Alien Imprints",value = 11,hint = hint_core},
    {text = "Reveal deposits",value = 12,hint = "Reveals the map squares"},
    {text = "Reveal deposits deep",value = 13,hint = "Reveals \"Deep\" resources"},
    {text = "Reveal deposits both",value = 14,hint = "Reveals both..."},
  }

  local CallBackFunc = function(choice)
    local function deep()
      ChoGGi.SetConstsG("DeepScanAvailable",ChoGGi.ToggleBoolNum(Consts.DeepScanAvailable))
      ChoGGi.SetConstsG("IsDeepWaterExploitable",ChoGGi.ToggleBoolNum(Consts.IsDeepWaterExploitable))
      ChoGGi.SetConstsG("IsDeepMetalsExploitable",ChoGGi.ToggleBoolNum(Consts.IsDeepMetalsExploitable))
      ChoGGi.SetConstsG("IsDeepPreciousMetalsExploitable",ChoGGi.ToggleBoolNum(Consts.IsDeepPreciousMetalsExploitable))
    end
    local function core()
      Msg("TechResearched","CoreWater", UICity)
      Msg("TechResearched","CoreMetals", UICity)
      Msg("TechResearched","CoreRareMetals", UICity)
      Msg("TechResearched","AlienImprints", UICity)
    end
    local function scan()
      CheatMapExplore("scanned")
      CheatMapExplore("deep scanned")
    end

    local value
    for i=1,#choice do
      value = choice[i].value
      print(value)
      if value == 1 then
        scan()
        deep()
        core()
      elseif value == 2 then
        deep()
      elseif value == 3 then
        core()
      elseif value == 4 then
        ChoGGi.SetConstsG("DeepScanAvailable",ChoGGi.ToggleBoolNum(Consts.DeepScanAvailable))
      elseif value == 5 then
        ChoGGi.SetConstsG("IsDeepWaterExploitable",ChoGGi.ToggleBoolNum(Consts.IsDeepWaterExploitable))
      elseif value == 6 then
        ChoGGi.SetConstsG("IsDeepMetalsExploitable",ChoGGi.ToggleBoolNum(Consts.IsDeepMetalsExploitable))
      elseif value == 7 then
        ChoGGi.SetConstsG("IsDeepPreciousMetalsExploitable",ChoGGi.ToggleBoolNum(Consts.IsDeepPreciousMetalsExploitable))
      elseif value == 8 then
        Msg("TechResearched","CoreWater", UICity)
      elseif value == 9 then
        Msg("TechResearched","CoreMetals", UICity)
      elseif value == 10 then
        Msg("TechResearched","CoreRareMetals", UICity)
      elseif value == 11 then
        Msg("TechResearched","AlienImprints", UICity)
      elseif value == 12 then
        CheatMapExplore("scanned")
      elseif value == 13 then
        CheatMapExplore("deep scanned")
      elseif value == 14 then
        scan()
      end
    end
    ChoGGi.SetSavedSetting("DeepScanAvailable",Consts.DeepScanAvailable)
    ChoGGi.SetSavedSetting("IsDeepWaterExploitable",Consts.IsDeepWaterExploitable)
    ChoGGi.SetSavedSetting("IsDeepMetalsExploitable",Consts.IsDeepMetalsExploitable)
    ChoGGi.SetSavedSetting("IsDeepPreciousMetalsExploitable",Consts.IsDeepPreciousMetalsExploitable)

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("Alice thought to herself \"Now you will see a film... made for children... perhaps... \" But, I nearly forgot... you must... close your eyes... otherwise... you won't see anything.",
     "Scanner","UI/Icons/Notifications/scan.tga",true
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Add Probes","You can select multiple items.",true)
end

function ChoGGi.DisastersTrigger()
  local ItemList = {
    {text = " Stop All Disasters",value = "Stop"},
    {text = "Cold Wave",value = "ColdWave"},
    {text = "Dust Devil Major",value = "DustDevilMajor"},
    {text = "Dust Devil",value = "DustDevil"},
    {text = "Dust Storm Electrostatic",value = "DustStormElectrostatic"},
    {text = "Dust Storm Great",value = "DustStormGreat"},
    {text = "Dust Storm",value = "DustStorm"},
    {text = "Meteors Storm",value = "MeteorsStorm"},
    {text = "Meteors Multi Spawn",value = "MeteorsMultiSpawn"},
    {text = "Meteor",value = "Meteor"},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if value == "Stop" then
      ChoGGi.DisastersStop()
    elseif value == "ColdWave" then
      ChoGGi.DisasterTriggerColdWave()

    elseif value == "DustDevilMajor" then
      ChoGGi.DisasterTriggerDustDevil("major")
    elseif value == "DustDevil" then
      ChoGGi.DisasterTriggerDustDevil()

    elseif value == "DustStormElectrostatic" then
      ChoGGi.DisasterTriggerDustStorm("electrostatic")
    elseif value == "DustStormGreat" then
      ChoGGi.DisasterTriggerDustStorm("great")
    elseif value == "DustStorm" then
      ChoGGi.DisasterTriggerDustStorm("normal")

    elseif value == "MeteorsStorm" then
      ChoGGi.DisasterTriggerMeteor("storm")
    elseif value == "MeteorsMultiSpawn" then
      ChoGGi.DisasterTriggerMeteor("multispawn")
    elseif value == "Meteor" then
      ChoGGi.DisasterTriggerMeteor("single")
    end

    ChoGGi.MsgPopup("Spawned: " .. choice[1].text,
      "Disasters","UI/Icons/Sections/attention.tga"
    )
  end
  local hint = "Targeted to mouse cursor (use arrow keys to select and enter to start).\n\nSelect item for more info."
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Trigger Disaster",hint)
end

function ChoGGi.SpawnColonists()
  local ItemList = {
    {text = 1,value = 1},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 2500,value = 2500},
    {text = 5000,value = 5000},
    {text = 10000,value = 10000},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      CheatSpawnNColonists(value)
      ChoGGi.MsgPopup("Spawned: " .. choice[1].text,
        "Colonists","UI/Icons/Sections/colonist.tga"
      )
    end
  end

  local hint = "Colonist placing priority: Selected dome, Evenly between domes, or centre of map if no domes."
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Spawn Colonists",hint)
end

function ChoGGi.ShowMysteryList()
  local ItemList = {}
  ClassDescendantsList("MysteryBase",function(class)
    table.insert(ItemList,{
      text = (g_Classes[class].scenario_name .. ": " .. _InternalTranslate(T({ChoGGi.MysteryDifficulty[class]})) or "Missing Name"),
      value = class,
      hint = (_InternalTranslate(T({ChoGGi.MysteryDescription[class]})) or "Missing Description")
    })
  end)

  local CallBackFunc = function(choice)
    if ChoGGi.ListChoiceCustomDialog_CheckBox1 then
      --instant
      ChoGGi.StartMystery(choice[1].value,true)
    else
      ChoGGi.StartMystery(choice[1].value)
    end
  end

  local hint = "Warning: Adding a mystery is cumulative, this will NOT replace existing mysteries.\n\nSelect item for more info."
  local checkmarkhint = "May take up to one Sol to \"instantly\" activate mystery."
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Start A Mystery",hint,nil,"Instant Start",checkmarkhint)
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
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 2500,value = 2500},
    {text = 5000,value = 5000},
    {text = 10000,value = 10000},
    {text = 25000,value = 25000},
    {text = 50000,value = 50000},
    {text = 100000,value = 100000},
    {text = 100000000,value = 100000000},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      UICity:AddResearchPoints(value)
      ChoGGi.MsgPopup("Selected: " .. choice[1].text,
        "Research","UI/Icons/Upgrades/eternal_fusion_04.tga"
      )
    end
  end

  local hint = "If you need a little boost (or a lotta boost) in research."
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Add Research Points",hint)
end

function ChoGGi.OutsourcePoints1000000()
  ChoGGi.SetConstsG("OutsourceResearch",1000 * ChoGGi.Consts.ResearchPointsScale)

  ChoGGi.SetSavedSetting("OutsourceResearch",Consts.OutsourceResearch)
  ChoGGi.WriteSettings()
  local msg = "\nThe same thing we do every night, Pinky - try to take over the world!"
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.OutsourceResearch) .. msg,
   "Research","UI/Icons/Upgrades/eternal_fusion_04.tga",true
  )
end

function ChoGGi.OutsourcingFree_Toggle()
  ChoGGi.SetConstsG("OutsourceResearchCost",ChoGGi.NumRetBool(Consts.OutsourceResearchCost) and 0 or ChoGGi.Consts.OutsourceResearchCost)

  ChoGGi.SetSavedSetting("OutsourceResearchCost",Consts.OutsourceResearchCost)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.OutsourceResearchCost) .. "\nBest hope you picked India as your Mars sponsor",
   "Research","UI/Icons/Sections/research_1.tga",true
  )
end

function ChoGGi.BreakThroughTechsPerGame_Toggle()
  const.BreakThroughTechsPerGame = ChoGGi.ValueRetOpp(const.BreakThroughTechsPerGame,26,ChoGGi.Consts.BreakThroughTechsPerGame)

  ChoGGi.SetSavedSetting("BreakThroughTechsPerGame",const.BreakThroughTechsPerGame)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.BreakThroughTechsPerGame) .. ": S M R T",
   "Research","UI/Icons/Notifications/research.tga"
  )
end

function ChoGGi.ResearchQueueLarger_Toggle()
  const.ResearchQueueSize = ChoGGi.ValueRetOpp(const.ResearchQueueSize,25,ChoGGi.Consts.ResearchQueueSize)
  ChoGGi.SetSavedSetting("ResearchQueueSize",const.ResearchQueueSize)

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.ResearchQueueSize) .. ": Nerdgasm",
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
    if not ChoGGi.ListChoiceCustomDialog_CheckBox1 and not ChoGGi.ListChoiceCustomDialog_CheckBox2 then
      ChoGGi.MsgPopup("Pick a checkbox next time...","Research","UI/Icons/Notifications/research.tga")
      return
    elseif ChoGGi.ListChoiceCustomDialog_CheckBox1 and ChoGGi.ListChoiceCustomDialog_CheckBox2 then
      ChoGGi.MsgPopup("Don't pick both checkboxes next time...","Research","UI/Icons/Notifications/research.tga")
      return
    end

    local sType
    local Which
    --add
    if ChoGGi.ListChoiceCustomDialog_CheckBox1 then
      sType = "DiscoverTech"
      Which = "Unlocked"
    --remove
    elseif ChoGGi.ListChoiceCustomDialog_CheckBox2 then
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

  local hint = "Select Unlock or Research then select the tech you want (Ctrl/Shift to multi-select).\n\nSelect item for more info."
  local checkhint1 = "Just unlocks in the tree"
  local checkhint2 = "Unlocks and researchs."
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Research Unlock",hint,true,"Unlock",checkhint1,"Research",checkhint2)
end

function ChoGGi.SetTech_EveryMystery(sType)
  _G[sType]("AlienDiggersDestruction")
  _G[sType]("AlienDiggersDetection")
  _G[sType]("BlackCubesDisposal")
  _G[sType]("DefenseTower")
  _G[sType]("DreamSimulation")
  _G[sType]("NumberSixTracing")
  _G[sType]("PowerDecoy")
  _G[sType]("RegolithExtractor")
  _G[sType]("SolExploration")
  _G[sType]("WildfireCure")
  _G[sType]("XenoExtraction")
  _G[sType]("Xeno-Terraforming")
end

function ChoGGi.SetTech_EveryBreakthrough(sType)
  _G[sType]("AdvancedDroneDrive")
  _G[sType]("AlienImprints")
  _G[sType]("ArtificialMuscles")
  _G[sType]("AutonomousHubs")
  _G[sType]("Cloning")
  _G[sType]("ConstructionNanites")
  _G[sType]("CoreMetals")
  _G[sType]("CoreRareMetals")
  _G[sType]("CoreWater")
  _G[sType]("CryoSleep")
  _G[sType]("DomeStreamlining")
  _G[sType]("DryFarming")
  _G[sType]("EternalFusion")
  _G[sType]("ExtractorAI")
  _G[sType]("FactoryAutomation")
  _G[sType]("ForeverYoung")
  _G[sType]("FrictionlessComposites")
  _G[sType]("GeneSelection")
  _G[sType]("GiantCrops")
  _G[sType]("GoodVibrations")
  _G[sType]("HiveMind")
  _G[sType]("HullPolarization")
  _G[sType]("HypersensitivePhotovoltaics")
  _G[sType]("InspiringArchitecture")
  _G[sType]("InterplanetaryLearning")
  _G[sType]("MagneticExtraction")
  _G[sType]("MartianbornIngenuity")
  _G[sType]("MartianDiet")
  _G[sType]("MartianSteel")
  _G[sType]("MultispiralArchitecture")
  _G[sType]("NanoRefinement")
  _G[sType]("NeoConcrete")
  _G[sType]("NeuralEmpathy")
  _G[sType]("NocturnalAdaptation")
  _G[sType]("OverchargeAmplification")
  _G[sType]("PlasmaRocket")
  _G[sType]("PlutoniumSynthesis")
  _G[sType]("PrefabCompression")
  _G[sType]("PrintedElectronics")
  _G[sType]("ProjectPhoenix")
  _G[sType]("RapidSleep")
  _G[sType]("SafeMode")
  _G[sType]("ServiceBots")
  _G[sType]("SoylentGreen")
  _G[sType]("SpaceRehabilitation")
  _G[sType]("SuperconductingComputing")
  _G[sType]("Superfungus")
  _G[sType]("SuperiorCables")
  _G[sType]("SuperiorPipes")
  _G[sType]("SustainedWorkload")
  _G[sType]("ThePositronicBrain")
  _G[sType]("VectorPump")
  _G[sType]("Vocation-Oriented Society")
  _G[sType]("WirelessPower")
  _G[sType]("ZeroSpaceComputing")
end

function ChoGGi.SetTech_EveryTech(sType)
  _G[sType]("3DMachining")
  _G[sType]("AdaptedProbes")
  _G[sType]("AdvancedMartianEngines")
  _G[sType]("AdvancedPassengerModule")
  _G[sType]("Arcology")
  _G[sType]("AtomicAccumulator")
  _G[sType]("AutonomousSensors")
  _G[sType]("BatteryOptimization")
  _G[sType]("BehavioralMelding")
  _G[sType]("BehavioralShaping")
  _G[sType]("BiomeEngineering")
  _G[sType]("CO2JetPropulsion")
  _G[sType]("CompactHangars")
  _G[sType]("CompactPassengerModule")
  _G[sType]("DecommissionProtocol")
  _G[sType]("DeepMetalExtraction")
  _G[sType]("DeepScanning")
  _G[sType]("DeepWaterExtraction")
  _G[sType]("DomeBioscaping")
  _G[sType]("DreamReality")
  _G[sType]("DroneHub")
  _G[sType]("DronePrinting")
  _G[sType]("DroneSwarm")
  _G[sType]("DustRepulsion")
  _G[sType]("EarthMarsInitiative")
  _G[sType]("EmergencyTraining")
  _G[sType]("ExplorerAI")
  _G[sType]("ExtractorAmplification")
  _G[sType]("FactoryAI")
  _G[sType]("FactoryAmplification")
  _G[sType]("FarmAutomation ")
  _G[sType]("FuelCompression")
  _G[sType]("FueledExtractors")
  _G[sType]("FusionAutoregulation")
  _G[sType]("GeneAdaptation")
  _G[sType]("GeneralTraining")
  _G[sType]("GravityEngineering")
  _G[sType]("HangingGardens")
  _G[sType]("HighPoweredJets")
  _G[sType]("HolographicScanning")
  _G[sType]("HomeCollective")
  _G[sType]("HygroscopicVaporators")
  _G[sType]("InterplanetaryAstronomy")
  _G[sType]("LargeScaleExcavation")
  _G[sType]("LiveFromMars")
  _G[sType]("LocalizedTerraforming")
  _G[sType]("LowGDrive")
  _G[sType]("LowGEngineering")
  _G[sType]("LowGFungi")
  _G[sType]("LowGHighrise")
  _G[sType]("LowGHydrosynthsis")
  _G[sType]("LowGTurbines")
  _G[sType]("MagneticFiltering")
  _G[sType]("MarsHype")
  _G[sType]("MarsNoveau")
  _G[sType]("MartianAerodynamics")
  _G[sType]("MartianbornAdaptability")
  _G[sType]("MartianbornResilience")
  _G[sType]("MartianbornStrength")
  _G[sType]("MartianCopyrithgts")
  _G[sType]("MartianEducation")
  _G[sType]("MartianFestivals")
  _G[sType]("MartianInstituteOfScience")
  _G[sType]("MartianPatents")
  _G[sType]("MeteorDefenseSystem")
  _G[sType]("MicroFusion")
  _G[sType]("MicrogravityMedicine")
  _G[sType]("MicroManufacturing")
  _G[sType]("MoistureFarming")
  _G[sType]("NuclearFusion")
  _G[sType]("OrbitalEngineering")
  _G[sType]("PlasmaCutters")
  _G[sType]("ProductivityTraining")
  _G[sType]("ProjectMohole")
  _G[sType]("RejuvenationTreatment")
  _G[sType]("ResearchAmplification")
  _G[sType]("ResilientArchitecture")
  _G[sType]("RoverCommandAI")
  _G[sType]("RoverPrinting")
  _G[sType]("SmartHome")
  _G[sType]("SoilAdaptation")
  _G[sType]("StemReconstruction")
  _G[sType]("StirlingGenerator")
  _G[sType]("StorageCompression")
  _G[sType]("SubsurfaceHeating")
  _G[sType]("SupportiveCommunity")
  _G[sType]("SustainableArchitecture")
  _G[sType]("SystematicTraining")
  _G[sType]("TheMartianNetwork")
  _G[sType]("TransportOptimization")
  _G[sType]("TriboelectricScrubbing")
  _G[sType]("UtilityCrops")
  _G[sType]("WasteRockLiquefaction")
  _G[sType]("WaterCoservationSystem")
  _G[sType]("WaterReclamation")
end

