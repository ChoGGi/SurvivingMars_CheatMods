local UsualIcon = "UI/Icons/Notifications/research.tga"

function ChoGGi.OpenModEditor()
  local ModEditor = function()
    ModEditorOpen()
  end
  ChoGGi.QuestionBox("Warning!\nSave your game.\nThis will switch to a new map.",ModEditor,"Warning: Mod Editor","Okay (change map)")
end

function ChoGGi.ResetAllResearch()
  local ResetAllResearch = function()
    UICity:InitResearch()
  end
  ChoGGi.QuestionBox("Warning!\nAre you sure you want to reset all research (includes breakthrough tech)?\n\nBuildings are still unlocked.",ResetAllResearch,"Warning!")
end

function ChoGGi.DisasterTriggerMissle(Amount)
  Amount = Amount or 1
  --(obj, radius, count, delay_min, delay_max)
  StartBombard(
    SelectedObj or SelectionMouseObj() or GetTerrainCursor(),
    0,
    Amount
  )
end
function ChoGGi.DisasterTriggerColdWave()
  CreateGameTimeThread(function()
    local data = DataInstances.MapSettings_ColdWave
    local descr = data[mapdata.MapSettings_ColdWave] or data.ColdWave_VeryLow
    StartColdWave(descr)
  end)
end
function ChoGGi.DisasterTriggerDustStorm(storm_type)
  CreateGameTimeThread(function()
    local data = DataInstances.MapSettings_DustStorm
    local descr = data[mapdata.MapSettings_DustStorm] or data.DustStorm_VeryLow
    StartDustStorm(storm_type,descr)
  end)
end
function ChoGGi.DisasterTriggerDustDevils(major)
  local data = DataInstances.MapSettings_DustDevils
  local descr = data[mapdata.MapSettings_DustDevils] or data.DustDevils_VeryLow
  GenerateDustDevil(GetTerrainCursor(), descr, nil, major):Start()
end
function ChoGGi.DisasterTriggerMeteor(meteors_type)
  local data = DataInstances.MapSettings_Meteor
  local descr = data[mapdata.MapSettings_Meteor] or data.Meteor_VeryLow
  CreateGameTimeThread(function()
    MeteorsDisaster(descr, meteors_type, GetTerrainCursor())
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
  --[[causes error msgs for next ones (seems to work fine, but still)
  while #g_MeteorsPredicted > 0 do
    for i = 1, #g_MeteorsPredicted do
      pcall(function()
        g_MeteorsPredicted[i]:ExplodeInAir()
      end)
    end
  end
  --]]
end

function ChoGGi.DisastersTrigger()
  local ItemList = {
    {text = " Stop Most Disasters",value = "Stop",hint = "Can't stop meteors."},
    {text = "Cold Wave",value = "ColdWave"},
    {text = "Dust Devil Major",value = "DustDevilsMajor"},
    {text = "Dust Devil",value = "DustDevils"},
    {text = "Dust Storm Electrostatic",value = "DustStormElectrostatic"},
    {text = "Dust Storm Great",value = "DustStormGreat"},
    {text = "Dust Storm",value = "DustStorm"},
    {text = "Meteor Storm",value = "MeteorStorm"},
    {text = "Meteor Multi-Spawn",value = "MeteorMultiSpawn"},
    {text = "Meteor",value = "Meteor"},
    {text = "Missle 1",value = "Missle1"},
    {text = "Missle 10",value = "Missle10"},
    {text = "Missle 100",value = "Missle100"},
    {text = "Missle 500",value = "Missle500",hint = "Might be a little laggy"},
  }

  local CallBackFunc = function(choice)
    for i = 1, #choice do
      local value = choice[i].value
      if value == "Stop" then
        ChoGGi.DisastersStop()
      elseif value == "ColdWave" then
        ChoGGi.DisasterTriggerColdWave()

      elseif value == "DustDevilsMajor" then
        ChoGGi.DisasterTriggerDustDevils("major")
      elseif value == "DustDevils" then
        ChoGGi.DisasterTriggerDustDevils()

      elseif value == "DustStormElectrostatic" then
        ChoGGi.DisasterTriggerDustStorm("electrostatic")
      elseif value == "DustStormGreat" then
        ChoGGi.DisasterTriggerDustStorm("great")
      elseif value == "DustStorm" then
        ChoGGi.DisasterTriggerDustStorm("normal")

      elseif value == "MeteorStorm" then
        ChoGGi.DisasterTriggerMeteor("storm")
      elseif value == "MeteorMultiSpawn" then
        ChoGGi.DisasterTriggerMeteor("multispawn")
      elseif value == "Meteor" then
        ChoGGi.DisasterTriggerMeteor("single")

      elseif value == "Missle1" then
        ChoGGi.DisasterTriggerMissle(1)
      elseif value == "Missle10" then
        ChoGGi.DisasterTriggerMissle(10)
      elseif value == "Missle100" then
        ChoGGi.DisasterTriggerMissle(100)
      elseif value == "Missle500" then
        ChoGGi.DisasterTriggerMissle(500)
      end
      ChoGGi.MsgPopup(choice[i].text,"Disasters")
    end
  end

  local hint = "Targeted to mouse cursor (use arrow keys to select and enter to start, Ctrl/Shift to multi-select)."
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Trigger Disaster",hint,true)
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
    if choice[1].check1 then
      --instant
      ChoGGi.StartMystery(choice[1].value,true)
    else
      ChoGGi.StartMystery(choice[1].value)
    end
  end

  local hint = "Warning: Adding a mystery is cumulative, this will NOT replace existing mysteries."
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

function ChoGGi.AddResearchPoints()
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
      ChoGGi.MsgPopup("Added: " .. choice[1].text,
        "Research","UI/Icons/Upgrades/eternal_fusion_04.tga"
      )
    end
  end

  local hint = "If you need a little boost (or a lotta boost) in research."
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Add Research Points",hint)
end

function ChoGGi.OutsourcingFree_Toggle()
  ChoGGi.SetConstsG("OutsourceResearchCost",ChoGGi.NumRetBool(Consts.OutsourceResearchCost) and 0 or ChoGGi.Consts.OutsourceResearchCost)

  ChoGGi.SetSavedSetting("OutsourceResearchCost",Consts.OutsourceResearchCost)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.OutsourceResearchCost) .. "\nBest hope you picked India as your Mars sponsor",
    "Research","UI/Icons/Sections/research_1.tga",true
  )
end

function ChoGGi.SetBreakThroughsAllowed()
  local DefaultSetting = ChoGGi.Consts.BreakThroughTechsPerGame
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 26,value = 26,hint = "Doubled the base amount."},
    {text = 57,value = 57,hint = "There's only 57 in the list, but you could make the amount larger..."},
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.BreakThroughTechsPerGame then
    hint = ChoGGi.CheatMenuSettings.BreakThroughTechsPerGame
  end

  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then
      const.BreakThroughTechsPerGame = value
      ChoGGi.SetSavedSetting("BreakThroughTechsPerGame",value)

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup(choice[1].text .. ": S M R T",
        "Research",UsualIcon
      )
    end
  end

  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"BreakThroughs Allowed","Current: " .. hint)
end

function ChoGGi.ResearchQueueLarger_Toggle()
  const.ResearchQueueSize = ChoGGi.ValueRetOpp(const.ResearchQueueSize,25,ChoGGi.Consts.ResearchQueueSize)
  ChoGGi.SetSavedSetting("ResearchQueueSize",const.ResearchQueueSize)

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.ResearchQueueSize) .. ": Nerdgasm",
    "Research",UsualIcon
  )
end

function ChoGGi.ShowResearchTechList()
  local ItemList = {}
  table.insert(ItemList,{
    text = " Everything",
    value = "Everything",
    hint = "All the tech/breakthroughs/mysteries"
  })
  table.insert(ItemList,{
    text = " All Tech",
    value = "AllTech",
    hint = "All the regular tech"
  })
  table.insert(ItemList,{
    text = " All Breakthroughs",
    value = "AllBreakthroughs",
    hint = "All the breakthroughs"
  })
  table.insert(ItemList,{
    text = " All Mysteries",
    value = "AllMysteries",
    hint = "All the mysteries"
  })
  for i = 1, #TechTree do
    for j = 1, #TechTree[i] do
      local text = _InternalTranslate(TechTree[i][j].display_name)
      --remove " from that one tech...
      if text:find("\"") then
        text = text:gsub("\"","")
      end
      table.insert(ItemList,{
        text = text,
        value = TechTree[i][j].id,
        hint = _InternalTranslate(TechTree[i][j].description)
      })
    end
  end

  local CallBackFunc = function(choice)
    local check1 = choice[1].check1
    local check2 = choice[1].check2
    --nothing checked so just return
    if not check1 and not check2 then
      ChoGGi.MsgPopup("Pick a checkbox next time...","Research",UsualIcon)
      return
    elseif check1 and check2 then
      ChoGGi.MsgPopup("Don't pick both checkboxes next time...","Research",UsualIcon)
      return
    end

    local sType
    local Which
    --add
    if check1 then
      sType = "DiscoverTech"
      Which = "Unlocked"
    --remove
    elseif check2 then
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
      "Research",UsualIcon
    )
  end

  local hint = "Select Unlock or Research then select the tech you want (Ctrl/Shift to multi-select)."
  local checkhint1 = "Just unlocks in the tree"
  local checkhint2 = "Unlocks and researchs."
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Research Unlock",hint,true,"Unlock",checkhint1,"Research",checkhint2)
end

local function listfields(sType,field)
  for i = 1, #TechTree do
    if TechTree[i].id == field then
      for j = 1, #TechTree[i] do
        _G[sType](TechTree[i][j].id)
      end
    end
  end
end

function ChoGGi.SetTech_EveryMystery(sType)
  listfields(sType,"Mysteries")
end

function ChoGGi.SetTech_EveryBreakthrough(sType)
  listfields(sType,"Breakthroughs")
end

function ChoGGi.SetTech_EveryTech(sType)
  listfields(sType,"Biotech")
  listfields(sType,"Engineering")
  listfields(sType,"Physics")
  listfields(sType,"Robotics")
  listfields(sType,"Social")
end

