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
  local ListDisplay = {"Stop All Disasters","Cold Wave","Dust Devil Major","Dust Devil","Dust Storm Electrostatic","Dust Storm Great","Dust Storm Normal","Meteors Storm","Meteors Multi Spawn","Meteors Single"}
  local ListActual = {nil,nil,"major",nil,"electrostatic","great","normal","storm","multispawn","single"}

  local TempFunc = function(choice)
    if choice == 1 then
      ChoGGi.DisastersStop()
    elseif choice == 2 then
      ChoGGi.DisasterTriggerColdWave()
    elseif choice == 3 or choice == 4 then
      ChoGGi.DisasterTriggerDustDevil(ListActual[choice])
    elseif choice == 5 or choice == 6 or choice == 7 then
      ChoGGi.DisasterTriggerDustStorm(ListActual[choice])
    elseif choice == 8 or choice == 9 or choice == 10 then
      ChoGGi.DisasterTriggerMeteor(ListActual[choice])
    end

    ChoGGi.MsgPopup("Spawned: " .. ListDisplay[choice],
      "Disasters","UI/Icons/Sections/attention.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Trigger Disaster",1,"Targeted to mouse cursor (use arrow keys and enter to select).")
end

function ChoGGi.SpawnColonists()
  local ListDisplay = {1,10,50,100,150,250,500,1000,2500,5000,10000}
  local TempFunc = function(choice)
    CheatSpawnNColonists(ListDisplay[choice])
    ChoGGi.MsgPopup("Spawned: " .. ListDisplay[choice],
      "Colonists","UI/Icons/Sections/colonist.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Spawn Colonists",1,"Colonist placing priority: Selected dome, Evenly between domes, or centre of map if no domes.")
end

function ChoGGi.ShowMysteryList()
  local ListActual = {}
  ClassDescendantsList("MysteryBase", function(class)
    table.insert(ListActual,{
      name = g_Classes[class].scenario_name,
      class = class
    })
    table.insert(ListActual,{
      name = g_Classes[class].scenario_name,
      class = class
    })
  end)
  table.sort(ListActual,ChoGGi.CompareTableNames)

  local ListDisplay = {}
  local hint = ""
  for i = 1, #ListActual do
    local class = ListActual[i].class
    if (i % 2 == 0) then
      table.insert(ListDisplay,(g_Classes[class].scenario_name or "Missing Name: Instant") .. ": " .. _InternalTranslate(T({ChoGGi.MysteryDifficulty[class]})) .. ": Instant")
    else
      table.insert(ListDisplay,(g_Classes[class].scenario_name or "Missing Name") .. ": " .. _InternalTranslate(T({ChoGGi.MysteryDifficulty[class]})))
      hint = hint .. (g_Classes[class].scenario_name or "Missing Name") .. ": " .. (_InternalTranslate(T({ChoGGi.MysteryDescription[class]})) or "Missing Description") .. "\n\n\n\n"
    end
  end
  --clean up text
  hint = hint:gsub("<newline><right>","\n\t\t\t\t")
  hint = "\n\nWarning: Adding a mystery is cumulative, this will NOT replace existing mystery.\nMay take up to one Sol to activate instant mystery.\n\n\n\n\n\n\n\n" .. hint

  local TempFunc = function(choice)
    if (choice % 2 == 0) then
      --instant
      ChoGGi.StartMystery(ListActual[choice].class,true)
    else
      ChoGGi.StartMystery(ListActual[choice].class)
    end
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Start A Mystery",1,hint,true,false)
end

function ChoGGi.UnlockAllBuildings()
  CheatUnlockAllBuildings()
  RefreshXBuildMenu()

  ChoGGi.MsgPopup("Unlocked all buildings for construction.",
   "Buildings","UI/Icons/Upgrades/build_2.tga"
  )
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

--called from below
local function CheatStartMystery(mystery_id,Bool)
--mapdata.StartMystery?
  UICity.mystery_id = mystery_id
  for i = 1, #TechTree do
    local field = TechTree[i]
    local field_id = field.id
    --local costs = field.costs or empty_table
    local list = UICity.tech_field[field_id] or {}
    UICity.tech_field[field_id] = list
    for _, tech in ipairs(field) do
      if tech.mystery == mystery_id then
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

function ChoGGi.StartMystery(Mystery,Bool)
  --inform people of actions, so they don't add a bunch of them
  ChoGGi.CheatMenuSettings.ShowMysteryMsgs = true
  UICity.mystery_id = Mystery
  CheatStartMystery(Mystery,Bool)
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

function ChoGGi.ResearchEveryMystery()
  GrantTech("BlackCubesDisposal")
  GrantTech("AlienDiggersDestruction")
  GrantTech("AlienDiggersDetection")
  GrantTech("XenoExtraction")
  GrantTech("RegolithExtractor")
  GrantTech("PowerDecoy")
  GrantTech("Xeno-Terraforming")
  GrantTech("DreamSimulation")
  GrantTech("NumberSixTracing")
  GrantTech("DefenseTower")
  GrantTech("SolExploration")
  GrantTech("WildfireCure")
  ChoGGi.MsgPopup("Unleash your inner Black Monolith Mystery",
    "Research","UI/Icons/Notifications/research.tga"
  )
end

function ChoGGi.UnlockEveryBreakthrough()
  DiscoverTech("ConstructionNanites")
  DiscoverTech("HullPolarization")
  DiscoverTech("ProjectPhoenix")
  DiscoverTech("SoylentGreen")
  DiscoverTech("NeuralEmpathy")
  DiscoverTech("RapidSleep")
  DiscoverTech("ThePositronicBrain")
  DiscoverTech("SafeMode")
  DiscoverTech("HiveMind")
  DiscoverTech("SpaceRehabilitation")
  DiscoverTech("WirelessPower")
  DiscoverTech("PrintedElectronics")
  DiscoverTech("CoreMetals")
  DiscoverTech("CoreWater")
  DiscoverTech("CoreRareMetals")
  DiscoverTech("SuperiorCables")
  DiscoverTech("SuperiorPipes")
  DiscoverTech("AlienImprints")
  DiscoverTech("NocturnalAdaptation")
  DiscoverTech("GeneSelection")
  DiscoverTech("MartianDiet")
  DiscoverTech("EternalFusion")
  DiscoverTech("SuperconductingComputing")
  DiscoverTech("NanoRefinement")
  DiscoverTech("ArtificialMuscles")
  DiscoverTech("InspiringArchitecture")
  DiscoverTech("GiantCrops")
  DiscoverTech("NeoConcrete")
  DiscoverTech("AdvancedDroneDrive")
  DiscoverTech("DryFarming")
  DiscoverTech("MartianSteel")
  DiscoverTech("VectorPump")
  DiscoverTech("Superfungus")
  DiscoverTech("HypersensitivePhotovoltaics")
  DiscoverTech("FrictionlessComposites")
  DiscoverTech("ZeroSpaceComputing")
  DiscoverTech("MultispiralArchitecture")
  DiscoverTech("MagneticExtraction")
  DiscoverTech("SustainedWorkload")
  DiscoverTech("ForeverYoung")
  DiscoverTech("MartianbornIngenuity")
  DiscoverTech("CryoSleep")
  DiscoverTech("Cloning")
  DiscoverTech("GoodVibrations")
  DiscoverTech("DomeStreamlining")
  DiscoverTech("PrefabCompression")
  DiscoverTech("ExtractorAI")
  DiscoverTech("ServiceBots")
  DiscoverTech("OverchargeAmplification")
  DiscoverTech("PlutoniumSynthesis")
  DiscoverTech("InterplanetaryLearning")
  DiscoverTech("Vocation-Oriented Society")
  DiscoverTech("PlasmaRocket")
  DiscoverTech("AutonomousHubs")
  DiscoverTech("FactoryAutomation")
  ChoGGi.MsgPopup("Unleash your inner Black Monolith DiscoverTech",
    "Research","UI/Icons/Notifications/research.tga"
  )
end

function ChoGGi.ResearchEveryBreakthrough()
  GrantTech("ConstructionNanites")
  GrantTech("HullPolarization")
  GrantTech("ProjectPhoenix")
  GrantTech("SoylentGreen")
  GrantTech("NeuralEmpathy")
  GrantTech("RapidSleep")
  GrantTech("ThePositronicBrain")
  GrantTech("SafeMode")
  GrantTech("HiveMind")
  GrantTech("SpaceRehabilitation")
  GrantTech("WirelessPower")
  GrantTech("PrintedElectronics")
  GrantTech("CoreMetals")
  GrantTech("CoreWater")
  GrantTech("CoreRareMetals")
  GrantTech("SuperiorCables")
  GrantTech("SuperiorPipes")
  GrantTech("AlienImprints")
  GrantTech("NocturnalAdaptation")
  GrantTech("GeneSelection")
  GrantTech("MartianDiet")
  GrantTech("EternalFusion")
  GrantTech("SuperconductingComputing")
  GrantTech("NanoRefinement")
  GrantTech("ArtificialMuscles")
  GrantTech("InspiringArchitecture")
  GrantTech("GiantCrops")
  GrantTech("NeoConcrete")
  GrantTech("AdvancedDroneDrive")
  GrantTech("DryFarming")
  GrantTech("MartianSteel")
  GrantTech("VectorPump")
  GrantTech("Superfungus")
  GrantTech("HypersensitivePhotovoltaics")
  GrantTech("FrictionlessComposites")
  GrantTech("ZeroSpaceComputing")
  GrantTech("MultispiralArchitecture")
  GrantTech("MagneticExtraction")
  GrantTech("SustainedWorkload")
  GrantTech("ForeverYoung")
  GrantTech("MartianbornIngenuity")
  GrantTech("CryoSleep")
  GrantTech("Cloning")
  GrantTech("GoodVibrations")
  GrantTech("DomeStreamlining")
  GrantTech("PrefabCompression")
  GrantTech("ExtractorAI")
  GrantTech("ServiceBots")
  GrantTech("OverchargeAmplification")
  GrantTech("PlutoniumSynthesis")
  GrantTech("InterplanetaryLearning")
  GrantTech("Vocation-Oriented Society")
  GrantTech("PlasmaRocket")
  GrantTech("AutonomousHubs")
  GrantTech("FactoryAutomation")
  ChoGGi.MsgPopup("Unleash your inner Black Monolith GrantTech",
    "Research","UI/Icons/Notifications/research.tga"
  )
end
