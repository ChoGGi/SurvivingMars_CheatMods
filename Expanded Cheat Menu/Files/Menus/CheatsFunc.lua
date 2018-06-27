-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local T = ChoGGi.ComFuncs.Trans
local UsualIcon = "UI/Icons/Notifications/research.tga"

local pairs,tostring,type,string = pairs,tostring,type,string

local CheatMapExplore = CheatMapExplore
local CheatSpawnNColonists = CheatSpawnNColonists
local CheatUnlockAllBuildings = CheatUnlockAllBuildings
local CreateGameTimeThread = CreateGameTimeThread
local DeleteThread = DeleteThread
local GenerateDustDevil = GenerateDustDevil
local GetTerrainCursor = GetTerrainCursor
local GrantTech = GrantTech
local MeteorsDisaster = MeteorsDisaster
local ModEditorOpen = ModEditorOpen
local Msg = Msg
local OpenExamine = OpenExamine
local point = point
local RefreshXBuildMenu = RefreshXBuildMenu
local StartBombard = StartBombard
local StartColdWave = StartColdWave
local StartDustStorm = StartDustStorm
local StopColdWave = StopColdWave
local StopDustStorm = StopDustStorm

local g_Classes = g_Classes

function ChoGGi.MenuFuncs.DraggableCheatsMenu_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.DraggableCheatsMenu = not ChoGGi.UserSettings.DraggableCheatsMenu

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(Concat(T(302535920000232--[[Draggable cheats menu--]]),": ",tostring(ChoGGi.UserSettings.DraggableCheatsMenu)),
    T(1000162--[[Menu--]])
  )
end

function ChoGGi.MenuFuncs.WidthOfCheatsHover_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.ToggleWidthOfCheatsHover = not ChoGGi.UserSettings.ToggleWidthOfCheatsHover

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(Concat(T(302535920000233--[[Cheats hover toggle--]]),": ",tostring(ChoGGi.UserSettings.ToggleWidthOfCheatsHover)),
    T(1000162--[[Menu--]])
  )
end

function ChoGGi.MenuFuncs.KeepCheatsMenuPosition_Toggle()
  local ChoGGi = ChoGGi
  if ChoGGi.UserSettings.KeepCheatsMenuPosition then
    ChoGGi.UserSettings.KeepCheatsMenuPosition = nil
  else
    ChoGGi.UserSettings.KeepCheatsMenuPosition = dlgUAMenu:GetPos()
  end

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(Concat(T(302535920000234--[[Cheats menu save position--]]),": ",tostring(ChoGGi.UserSettings.KeepCheatsMenuPosition)),
    T(1000162--[[Menu--]])
  )
end

function ChoGGi.MenuFuncs.OpenModEditor()
  local function CallBackFunc(answer)
    if answer then
      ModEditorOpen()
    end
  end
  ChoGGi.ComFuncs.QuestionBox(
    Concat(T(6779--[[Warning--]]),"!\n",T(302535920000235--[[Save your game.
This will switch to a new map.--]])),
    CallBackFunc,
    Concat(T(6779--[[Warning--]]),": ",T(302535920000236--[[Mod Editor--]])),
    T(302535920000237--[[Okay (change map)--]])
  )
end

--~ UICity.tech_status[tech_id].researched = nil
--~ UICity.tech_status[tech_id].discovered= nil
function ChoGGi.MenuFuncs.ResetAllResearch()
  local function CallBackFunc(answer)
    if answer then
      UICity:InitResearch()
    end
  end
  ChoGGi.ComFuncs.QuestionBox(
    Concat(T(6779--[[Warning--]]),"!\n",T(302535920000238--[[Are you sure you want to reset all research (includes breakthrough tech)?

Buildings are still unlocked.--]])),
    CallBackFunc,
    Concat(T(6779--[[Warning--]]),"!")
  )
end

function ChoGGi.MenuFuncs.DisasterTriggerMissle(Amount)
  Amount = Amount or 1
  --(obj, radius, count, delay_min, delay_max)
  StartBombard(
    ChoGGi.CodeFuncs.SelObject() or GetTerrainCursor(),
    0,
    Amount
  )
end
function ChoGGi.MenuFuncs.DisasterTriggerColdWave()
  CreateGameTimeThread(function()
    local data = DataInstances.MapSettings_ColdWave
    local descr = data[mapdata.MapSettings_ColdWave] or data.ColdWave_VeryLow
    StartColdWave(descr)
  end)
end
function ChoGGi.MenuFuncs.DisasterTriggerDustStorm(storm_type)
  CreateGameTimeThread(function()
    local data = DataInstances.MapSettings_DustStorm
    local descr = data[mapdata.MapSettings_DustStorm] or data.DustStorm_VeryLow
    StartDustStorm(storm_type,descr)
  end)
end
function ChoGGi.MenuFuncs.DisasterTriggerDustDevils(major)
  local data = DataInstances.MapSettings_DustDevils
  local descr = data[mapdata.MapSettings_DustDevils] or data.DustDevils_VeryLow
  GenerateDustDevil(GetTerrainCursor(), descr, nil, major):Start()
end
function ChoGGi.MenuFuncs.DisasterTriggerMeteor(meteors_type)
  local data = DataInstances.MapSettings_Meteor
  local descr = data[mapdata.MapSettings_Meteor] or data.Meteor_VeryLow
  CreateGameTimeThread(function()
    MeteorsDisaster(descr, meteors_type, GetTerrainCursor())
  end)
end
function ChoGGi.MenuFuncs.DisastersStop()
  local mis = g_IncomingMissiles
  for Key,_ in pairs(mis or empty_table) do
    Key:ExplodeInAir()
  end

  if g_DustStorm then
    StopDustStorm()
  end
  if g_ColdWave then
    StopColdWave()
  end

  local g_DustDevils = g_DustDevils
  if g_DustDevils then
    for i = #g_DustDevils, 1, -1 do
      g_DustDevils[i]:delete()
    end
  end

  local mp = g_MeteorsPredicted or empty_table
  for i = #mp, 1, -1 do
    Msg("MeteorIntercepted", mp[i])
    mp[i]:ExplodeInAir()
  end
end

function ChoGGi.MenuFuncs.DisastersTrigger()
  local ChoGGi = ChoGGi
  local ItemList = {
    {text = Concat(" ",T(302535920000240--[[Stop Most Disasters--]])),value = "Stop"},
    {text = T(4149--[[Cold Wave--]]),value = "ColdWave"},
    {text = T(302535920000241--[[Dust Devil Major--]]),value = "DustDevilsMajor"},
    {text = T(302535920000242--[[Dust Devil--]]),value = "DustDevils"},
    {text = T(302535920000243--[[Dust Storm Electrostatic--]]),value = "DustStormElectrostatic"},
    {text = T(302535920000244--[[Dust Storm Great--]]),value = "DustStormGreat"},
    {text = T(4250--[[Dust Storm--]]),value = "DustStorm"},
    {text = T(5620--[[Meteor Storm--]]),value = "MeteorStorm"},
    {text = T(302535920000245--[[Meteor Multi-Spawn--]]),value = "MeteorMultiSpawn"},
    {text = T(4251--[[Meteor--]]),value = "Meteor"},
    {text = T(302535920000246--[[Missle 1--]]),value = "Missle1"},
    {text = T(302535920000247--[[Missle 10--]]),value = "Missle10"},
    {text = T(302535920000248--[[Missle 100--]]),value = "Missle100"},
    {text = T(302535920000249--[[Missle 500--]]),value = "Missle500",hint = T(302535920000250--[[Might be a little laggy--]])},
  }

  local CallBackFunc = function(choice)
    for i = 1, #choice do
      local value = choice[i].value
      if value == "Stop" then
        ChoGGi.MenuFuncs.DisastersStop()
      elseif value == "ColdWave" then
        ChoGGi.MenuFuncs.DisasterTriggerColdWave()

      elseif value == "DustDevilsMajor" then
        ChoGGi.MenuFuncs.DisasterTriggerDustDevils("major")
      elseif value == "DustDevils" then
        ChoGGi.MenuFuncs.DisasterTriggerDustDevils()

      elseif value == "DustStormElectrostatic" then
        ChoGGi.MenuFuncs.DisasterTriggerDustStorm("electrostatic")
      elseif value == "DustStormGreat" then
        ChoGGi.MenuFuncs.DisasterTriggerDustStorm("great")
      elseif value == "DustStorm" then
        ChoGGi.MenuFuncs.DisasterTriggerDustStorm("normal")

      elseif value == "MeteorStorm" then
        ChoGGi.MenuFuncs.DisasterTriggerMeteor("storm")
      elseif value == "MeteorMultiSpawn" then
        ChoGGi.MenuFuncs.DisasterTriggerMeteor("multispawn")
      elseif value == "Meteor" then
        ChoGGi.MenuFuncs.DisasterTriggerMeteor("single")

      elseif value == "Missle1" then
        ChoGGi.MenuFuncs.DisasterTriggerMissle(1)
      elseif value == "Missle10" then
        ChoGGi.MenuFuncs.DisasterTriggerMissle(10)
      elseif value == "Missle100" then
        ChoGGi.MenuFuncs.DisasterTriggerMissle(100)
      elseif value == "Missle500" then
        ChoGGi.MenuFuncs.DisasterTriggerMissle(500)
      end
      MsgPopup(choice[i].text,"Disasters")
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = T(302535920000251--[[Trigger Disaster--]]),
    hint = T(302535920000252--[[Targeted to mouse cursor (use arrow keys to select and enter to start, Ctrl/Shift to multi-select).--]]),
    multisel = true,
  })
end

function ChoGGi.MenuFuncs.ShowScanAndMapOptions()
  local ChoGGi = ChoGGi
  local Consts = Consts
  local UICity = UICity
  local hint_core = T(302535920000253--[[Core: Repeatable, exploit core resources.--]])
  local hint_deep = T(302535920000254--[[Deep: Toggleable, exploit deep resources.--]])
  local ItemList = {
    {text = Concat(" ",T(4493--[[All--]])),value = 1,hint = Concat(hint_core,"\n",hint_deep)},
    {text = Concat(" ",T(302535920000255--[[Deep--]])),value = 2,hint = hint_deep},
    {text = Concat(" ",T(302535920000256--[[Core--]])),value = 3,hint = hint_core},
    {text = T(302535920000257--[[Deep Scan--]]),value = 4,hint = Concat(hint_deep,"\n",T(302535920000030--[[Enabled--]]),": ",Consts.DeepScanAvailable)},
    {text = T(797--[[Deep Water--]]),value = 5,hint = Concat(hint_deep,"\n",T(302535920000030--[[Enabled--]]),": ",Consts.IsDeepWaterExploitable)},
    {text = T(793--[[Deep Metals--]]),value = 6,hint = Concat(hint_deep,"\n",T(302535920000030--[[Enabled--]]),": ",Consts.IsDeepMetalsExploitable)},
    {text = T(801--[[Deep Rare Metals--]]),value = 7,hint = Concat(hint_deep,"\n",T(302535920000030--[[Enabled--]]),": ",Consts.IsDeepPreciousMetalsExploitable)},
    {text = T(6548--[[Core Water--]]),value = 8,hint = hint_core},
    {text = T(6546--[[Core Metals--]]),value = 9,hint = hint_core},
    {text = T(6550--[[Core Rare Metals--]]),value = 10,hint = hint_core},
    {text = T(6556--[[Alien Imprints--]]),value = 11,hint = hint_core},
    {text = T(302535920000258--[[Reveal Map--]]),value = 12,hint = T(302535920000259--[[Reveals the map squares--]])},
    {text = T(302535920000260--[[Reveal Map (Deep)--]]),value = 13,hint = T(302535920000261--[[Reveals the map and \"Deep\" resources--]])},
  }

  local CallBackFunc = function(choice)
    local function ExploreDeep()
      ChoGGi.ComFuncs.SetConstsG("DeepScanAvailable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.DeepScanAvailable))
      ChoGGi.ComFuncs.SetConstsG("IsDeepWaterExploitable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepWaterExploitable))
      ChoGGi.ComFuncs.SetConstsG("IsDeepMetalsExploitable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepMetalsExploitable))
      ChoGGi.ComFuncs.SetConstsG("IsDeepPreciousMetalsExploitable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepPreciousMetalsExploitable))
    end
    local function ExploreCore()
      Msg("TechResearched","CoreWater", UICity)
      Msg("TechResearched","CoreMetals", UICity)
      Msg("TechResearched","CoreRareMetals", UICity)
      Msg("TechResearched","AlienImprints", UICity)
    end

    local value
    for i=1,#choice do
      value = choice[i].value
      if value == 1 then
        CheatMapExplore("deep scanned")
        ExploreDeep()
        ExploreCore()
      elseif value == 2 then
        ExploreDeep()
      elseif value == 3 then
        ExploreCore()
      elseif value == 4 then
        ChoGGi.ComFuncs.SetConstsG("DeepScanAvailable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.DeepScanAvailable))
      elseif value == 5 then
        ChoGGi.ComFuncs.SetConstsG("IsDeepWaterExploitable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepWaterExploitable))
      elseif value == 6 then
        ChoGGi.ComFuncs.SetConstsG("IsDeepMetalsExploitable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepMetalsExploitable))
      elseif value == 7 then
        ChoGGi.ComFuncs.SetConstsG("IsDeepPreciousMetalsExploitable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepPreciousMetalsExploitable))
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
      end
    end
    ChoGGi.ComFuncs.SetSavedSetting("DeepScanAvailable",Consts.DeepScanAvailable)
    ChoGGi.ComFuncs.SetSavedSetting("IsDeepWaterExploitable",Consts.IsDeepWaterExploitable)
    ChoGGi.ComFuncs.SetSavedSetting("IsDeepMetalsExploitable",Consts.IsDeepMetalsExploitable)
    ChoGGi.ComFuncs.SetSavedSetting("IsDeepPreciousMetalsExploitable",Consts.IsDeepPreciousMetalsExploitable)

    ChoGGi.SettingFuncs.WriteSettings()
    MsgPopup(T(302535920000262--[[Alice thought to herself.\n\"Now you will see a film made for children\".\nPerhaps.\nBut I nearly forgot! You must close your eyes.\nOtherwise you won't see anything.--]]),
      T(1000436--[[Map--]]),"UI/Achievements/TheRabbitHole.tga",true
    )
  end

  ChoGGi.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = T(302535920000263--[[Scan Map--]]),
    hint = T(302535920000264--[[You can select multiple items.--]]),
    multisel = true,
  })
end

function ChoGGi.MenuFuncs.SpawnColonists()
  local ChoGGi = ChoGGi
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
      MsgPopup(Concat(T(302535920000014--[[Spawned--]]),": ",choice[1].text),
        T(547--[[Colonists--]]),"UI/Icons/Sections/colonist.tga"
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(T(302535920000266--[[Spawn--]])," ",T(547--[[Colonists--]])),
    hint = T(302535920000267--[[Colonist placing priority: Selected dome, Evenly between domes, or centre of map if no domes.--]]),
  })
end

function ChoGGi.MenuFuncs.ShowMysteryList()
  local ChoGGi = ChoGGi
  local ItemList = {}
  for i = 1, #ChoGGi.Tables.Mystery do
    ItemList[#ItemList+1] = {
      text = Concat(ChoGGi.Tables.Mystery[i].number,": ",ChoGGi.Tables.Mystery[i].name),
      value = ChoGGi.Tables.Mystery[i].class,
      hint = ChoGGi.Tables.Mystery[i].description
    }
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if choice[1].check1 then
      --instant
      ChoGGi.MenuFuncs.StartMystery(value,true)
    else
      ChoGGi.MenuFuncs.StartMystery(value)
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = T(302535920000268--[[Start A Mystery--]]),
    hint = Concat(T(6779--[[Warning--]]),": ",T(302535920000269--[[Adding a mystery is cumulative, this will NOT replace existing mysteries.--]])),
    check1 = T(302535920000270--[[Instant Start--]]),
    check1_hint = T(302535920000271--[[May take up to one Sol to \"instantly\" activate mystery.--]]),
  })
end

function ChoGGi.MenuFuncs.StartMystery(mystery_id,instant)
  local ChoGGi = ChoGGi
  local UICity = UICity
  local Presets = Presets
  --inform people of actions, so they don't add a bunch of them
  ChoGGi.UserSettings.ShowMysteryMsgs = true

  UICity.mystery_id = mystery_id
  local fields = Presets.TechFieldPreset.Default
  for i = 1, #fields do
    local field = fields[i]
    local field_id = field.id
--~     local costs = field.costs or empty_table
    local list = UICity.tech_field[field_id] or empty_table
    UICity.tech_field[field_id] = list
--~     for _, tech in ipairs(Presets.TechPreset[field_id]) do
    local ids = Presets.TechPreset[field_id] or empty_table
    for j = 1, #ids do
      if ids[j].mystery == mystery_id then
        local tech_id = ids[j].id
        list[#list + 1] = tech_id
        UICity.tech_status[tech_id] = {points = 0, field = field_id}
        ids[j]:EffectsInit(UICity)
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
  if instant then
    local seqs = UICity.mystery.seq_player.seq_list[1]
    for i = 1, #seqs do
      local seq = seqs[i]
      if seq.class == "SA_WaitExpression" then
        seq.duration = 0
        seq.expression = nil
      elseif seq.class == "SA_WaitMarsTime" then
        seq.duration = 0
        seq.rand_duration = 0
        break
      end
    end
  end

  --needed to start mystery
  UICity.mystery.seq_player:AutostartSequences()
end

--loops through all the sequence and adds the logs we've already seen
local function ShowMysteryLog(MystName)
  local msgs = {Concat(MystName,"\n\n",T(302535920000272--[[To play back speech use \"Exec\" button and type in\ng_Voice:Play(ChoGGi.CurObj.speech)"),"\n--]]))}
  local Players = s_SeqListPlayers
  -- 1 is some default map thing
  if #Players < 2 then
    return
  end
  for i = 1, #Players do
    if i > 1 then
      local seq_list = Players[i].seq_list
      if seq_list.name == MystName then
        for j = 1, #seq_list do
          local scenarios = seq_list[j]
          local state = Players[i].seq_states[scenarios.name]
          --have we started this seq yet?
          if state then
--~            local ip = state and (state.ip or state.end_ip or 10000)
            for k = 1, #scenarios do
              local seq = scenarios[k]
              if seq.class == "SA_WaitMessage" then
                --add to msg list
                msgs[#msgs+1] = {
                  [" "] = Concat(T(302535920000273--[[Speech--]]),": ",T(seq.voiced_text),"\n\n\n\n",T(302535920000274--[[Message--]]),": ",T(seq.text)),
                  speech = seq.voiced_text,
                  class = T(seq.title)
                }
              end
            end
          end
        end
      end
    end
  end
  --display to user
  OpenExamine(msgs, point(550,100))
end

function ChoGGi.MenuFuncs.ShowStartedMysteryList()
  local ChoGGi = ChoGGi
  local ItemList = {}
  local PlayerList = s_SeqListPlayers
  for i = 1, #PlayerList do
    --1 is always there from map loading
    if i > 1 then
      local seq_list = PlayerList[i].seq_list
      local totalparts = #seq_list[1]
      local id = seq_list.name
      local ip = PlayerList[i].seq_states[seq_list[1].name].ip

      ItemList[#ItemList+1] = {
        text = Concat(id,": ",ChoGGi.Tables.Mystery[id].name),
        value = id,
        func = id,
        seed = PlayerList[i].seed,
        hint = Concat(ChoGGi.Tables.Mystery[id].description,"\n\n<color 255 75 75>",T(302535920000275--[[Total parts--]]),"</color>: ",totalparts," <color 255 75 75>",T(302535920000289--[[Current part--]]),"</color>: ",(ip or T(302535920000276--[[done?--]])))
      }
    end
  end

  local CallBackFunc = function(choice)
    local ThreadsMessageToThreads = ThreadsMessageToThreads
    local value = choice[1].value
    local seed = choice[1].seed
    if choice[1].check2 then
      --remove all
      for i = #PlayerList, 1, -1 do
        if i > 1 then
          PlayerList[i]:delete()
        end
      end
      for Thread in pairs(ThreadsMessageToThreads) do
        if Thread.player and Thread.player.seq_list.file_name then
          DeleteThread(Thread.thread)
        end
      end
      MsgPopup(T(302535920000277--[[Removed all!--]]),T(3486--[[Mystery--]]))
    elseif choice[1].check1 then
      --remove mystery
      for i = #PlayerList, 1, -1 do
        if PlayerList[i].seed == seed then
          PlayerList[i]:delete()
        end
      end
      for Thread in pairs(ThreadsMessageToThreads) do
        if Thread.player and Thread.player.seed == seed then
          DeleteThread(Thread.thread)
        end
      end
      MsgPopup(Concat(T(3486--[[Mystery--]]),": ",choice[1].text," ",T(302535920000278--[[Removed--]]),"!",T(3486--[[Mystery--]])))
    elseif value then
      --next step
      ChoGGi.MenuFuncs.NextMysterySeq(value,seed)
    end

  end

  ChoGGi.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = T(302535920000279--[[Manage--]]),
    hint = T(302535920000280--[[Skip the timer delay, and optionally skip the requirements (applies to all mysteries that are the same type).\n\nSequence part may have more then one check, you may have to skip twice or more.\n\nDouble right-click selected mystery to review past messages.--]]),
    check1 = T(302535920000281--[[Remove--]]),
    check1_hint = Concat(T(6779--[[Warning--]]),": ",T(302535920000282--[[This will remove the mystery, if you start it again; it'll be back to the start.--]])),
    check2 = T(302535920000283--[[Remove All--]]),
    check2_hint = Concat(T(6779--[[Warning--]]),": ",T(302535920000284--[[This will remove all the mysteries!--]])),
    custom_type = 6,
    custom_func = ShowMysteryLog,
  })
end
--~   local idx = 0
--~   for Thread in pairs(ThreadsMessageToThreads) do
--~     if Thread.thread and IsValidThread(Thread.thread) then
--~       idx = idx + 1
--~       print(Concat("idx ",idx))
--~     end
--~   end
--~ ex(s_SeqListPlayers)
function ChoGGi.MenuFuncs.NextMysterySeq(Mystery,seed)
  local ChoGGi = ChoGGi
  local ThreadsMessageToThreads = ThreadsMessageToThreads

  local warning = Concat("\n\n",T(302535920000285--[[Click \"Ok\" to skip requirements (Warning: may cause issues later on, untested).--]]))
  local name = Concat(T(3486--[[Mystery--]]),": ",ChoGGi.Tables.Mystery[Mystery].name)

  for Thread in pairs(ThreadsMessageToThreads) do
    if Thread.player and Thread.player.seed == seed then

      --only remove finished waittime threads, can cause issues removing other threads
      if Thread.finished == true and (Thread.action.class == "SA_WaitMarsTime" or Thread.action.class == "SA_WaitTime" or Thread.action.class == "SA_RunSequence") then
        DeleteThread(Thread.thread)
      end

      local Player = Thread.player
      local seq_list = Thread.sequence
      local state = Player.seq_states
      local ip = state[seq_list.name].ip

      for i = 1, #seq_list do
        --skip older seqs
        if i >= ip then
          local seq = seq_list[i]
          local title = Concat(name," ",T(302535920000286--[[Part--]]),": ",ip)

          --seqs that add delays/tasks
          if seq.class == "SA_WaitMarsTime" or seq.class == "SA_WaitTime" then
            ChoGGi.Temp.SA_WaitMarsTime_StopWait = {seed = seed}
            --we don't want to wait
            seq.wait_type = g_Classes.SA_WaitMarsTime:GetDefaultPropertyValue("wait_type")
            seq.wait_subtype = g_Classes.SA_WaitMarsTime:GetDefaultPropertyValue("wait_subtype")
            seq.loops = g_Classes.SA_WaitMarsTime:GetDefaultPropertyValue("loops")
            seq.duration = 1
            seq.rand_duration = 1
            local wait = Thread.action
            wait.wait_type = g_Classes.SA_WaitMarsTime:GetDefaultPropertyValue("wait_type")
            wait.wait_subtype = g_Classes.SA_WaitMarsTime:GetDefaultPropertyValue("wait_subtype")
            wait.loops = g_Classes.SA_WaitMarsTime:GetDefaultPropertyValue("loops")
            wait.duration = 1
            wait.rand_duration = 1

            Thread.finished = true
            --Thread.action:EndWait(Thread)
            --may not be needed
            Player:UpdateCurrentIP(seq_list)
            --let them know
            MsgPopup(T(302535920000287--[[Timer delay removed (may take upto a Sol).--]]),title)
            break

          elseif seq.class == "SA_WaitExpression" then
            seq.duration = 0
            local function CallBackFunc(answer)
              if answer then
                seq.expression = nil
                --the first SA_WaitExpression always has a SA_WaitMarsTime, if they're skipping the first then i doubt they want this
                if i == 1 or i == 2 then
                  ChoGGi.Temp.SA_WaitMarsTime_StopWait = {seed = seed,again = true}
                else
                  ChoGGi.Temp.SA_WaitMarsTime_StopWait = {seed = seed}
                end

                Thread.finished = true
                Player:UpdateCurrentIP(seq_list)
              end
            end
            ChoGGi.ComFuncs.QuestionBox(
              Concat(T(302535920000288--[[Advancement requires--]]),": ",tostring(seq.expression),"\n\n",T(302535920000290--[[Time duration has been set to 0 (you still need to complete the requirements).\n\nWait for a Sol or two for it to update (should give a popup msg).--]]),warning),
              CallBackFunc,
              title
            )
            break

          elseif seq.class == "SA_WaitMsg" then
            local function CallBackFunc(answer)
              if answer then
                ChoGGi.Temp.SA_WaitMarsTime_StopWait = {seed = seed,again = true}
                --send fake msg (ok it's real, but it hasn't happened)
                Msg(seq.msg)
                Player:UpdateCurrentIP(seq_list)
              end
            end
            ChoGGi.ComFuncs.QuestionBox(
              Concat(T(302535920000288--[[Advancement requires--]]),": ",tostring(seq.msg),warning),
              CallBackFunc,
              title
            )
            break

          elseif seq.class == "SA_WaitResearch" then
            local function CallBackFunc(answer)
              if answer then
                GrantTech(seq.Research)
                Thread.finished = true
                Player:UpdateCurrentIP(seq_list)
              end
            end
            ChoGGi.ComFuncs.QuestionBox(
              Concat(T(302535920000288--[[Advancement requires--]]),": ",tostring(seq.Research).. warning),
              CallBackFunc,
              title
            )

          elseif seq.class == "SA_RunSequence" then
            local function CallBackFunc(answer)
              if answer then
                seq.wait = false
                Thread.finished = true
                Player:UpdateCurrentIP(seq_list)
              end
            end
            ChoGGi.ComFuncs.QuestionBox(
              string.format(T(302535920000291--[[Waiting for %s to finish.\n\nSkip it?--]]),seq.sequence),
              string.format(T(302535920000291--[[Waiting for %s to finish.\n\nSkip it?--]]),seq.sequence),
              CallBackFunc,
              title
            )

          end -- if seq type

        end --if i >= ip
      end --for seq_list

    end --if mystery thread
  end --for Thread

end

function ChoGGi.MenuFuncs.UnlockAllBuildings()
  CheatUnlockAllBuildings()
  RefreshXBuildMenu()
  MsgPopup(T(302535920000293--[[Unlocked all buildings for construction.--]]),
    T(3980--[[Buildings--]]),"UI/Icons/Upgrades/build_2.tga"
  )
end

function ChoGGi.MenuFuncs.AddResearchPoints()
  local ChoGGi = ChoGGi
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
      MsgPopup(Concat(T(302535920000294--[[Added--]]),": ",choice[1].text),
        T(311--[[Research--]]),"UI/Icons/Upgrades/eternal_fusion_04.tga"
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = T(302535920000295--[[Add Research Points--]]),
    hint = T(302535920000296--[[If you need a little boost (or a lotta boost) in research.--]]),
  })
end

function ChoGGi.MenuFuncs.OutsourcingFree_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.ComFuncs.SetConstsG("OutsourceResearchCost",ChoGGi.ComFuncs.NumRetBool(Consts.OutsourceResearchCost) and 0 or ChoGGi.Consts.OutsourceResearchCost)

  ChoGGi.ComFuncs.SetSavedSetting("OutsourceResearchCost",Consts.OutsourceResearchCost)
  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(Concat(tostring(ChoGGi.UserSettings.OutsourceResearchCost),"\n",T(302535920000297--[[Best hope you picked India as your Mars sponsor--]])),
    T(311--[[Research--]]),"UI/Icons/Sections/research_1.tga",true
  )
end

local hint_maxa = T(302535920000298--[[Max amount in UICity.tech_field list, you could make the amount larger if you want (an update/mod can add more).--]])
function ChoGGi.MenuFuncs.SetBreakThroughsOmegaTelescope()
  local ChoGGi = ChoGGi
  local DefaultSetting = ChoGGi.Consts.OmegaTelescopeBreakthroughsCount
  local MaxAmount = #UICity.tech_field.Breakthroughs
  local ItemList = {
    {text = Concat(" ",T(302535920000110--[[Default--]]),": ",DefaultSetting),value = DefaultSetting},
    {text = 6,value = 6},
    {text = 12,value = 12},
    {text = 24,value = 24},
    {text = MaxAmount,value = MaxAmount,hint = hint_maxa},
  }

  local hint = DefaultSetting
  if ChoGGi.UserSettings.OmegaTelescopeBreakthroughsCount then
    hint = ChoGGi.UserSettings.OmegaTelescopeBreakthroughsCount
  end

  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then
      const.OmegaTelescopeBreakthroughsCount = value
      ChoGGi.ComFuncs.SetSavedSetting("OmegaTelescopeBreakthroughsCount",value)

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(Concat(choice[1].text,T(302535920000299--[[: Research is what I'm doing when I don't know what I'm doing.--]])),
        T(5182--[[Omega Telescope--]]),UsualIcon
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = T(302535920000300--[[BreakThroughs From Omega--]]),
    hint = Concat(T(302535920000106--[[Current--]]),": ",hint),
  })
end

function ChoGGi.MenuFuncs.SetBreakThroughsAllowed()
  local ChoGGi = ChoGGi
  local DefaultSetting = ChoGGi.Consts.BreakThroughTechsPerGame
  local MaxAmount = #UICity.tech_field.Breakthroughs
  local ItemList = {
    {text = Concat(" ",T(302535920000110--[[Default--]]),": ",DefaultSetting),value = DefaultSetting},
    {text = 26,value = 26,hint = T(302535920000301--[[Doubled the base amount.--]])},
    {text = MaxAmount,value = MaxAmount,hint = hint_maxa},
  }

  local hint = DefaultSetting
  if ChoGGi.UserSettings.BreakThroughTechsPerGame then
    hint = ChoGGi.UserSettings.BreakThroughTechsPerGame
  end

  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then
      const.BreakThroughTechsPerGame = value
      ChoGGi.ComFuncs.SetSavedSetting("BreakThroughTechsPerGame",value)

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(Concat(choice[1].text,T(302535920000302--[[: S M R T--]])),
        T(311--[[Research--]]),UsualIcon
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = T(302535920000303--[[BreakThroughs Allowed--]]),
    hint = Concat(T(302535920000106--[[Current--]]),": ",hint),
  })
end

function ChoGGi.MenuFuncs.SetResearchQueueSize()
  local ChoGGi = ChoGGi
  local DefaultSetting = ChoGGi.Consts.ResearchQueueSize
  local ItemList = {
    {text = Concat(" ",T(302535920000110--[[Default--]]),": ",DefaultSetting),value = DefaultSetting},
    {text = 5,value = 5},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
  }

  --other hint type
  local hint = DefaultSetting
  local ResearchQueueSize = ChoGGi.UserSettings.ResearchQueueSize
  if ResearchQueueSize then
    hint = ResearchQueueSize
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then

      const.ResearchQueueSize = value
      ChoGGi.ComFuncs.SetSavedSetting("ResearchQueueSize",value)

      ChoGGi.SettingFuncs.WriteSettings()
      MsgPopup(Concat(tostring(ChoGGi.UserSettings.ResearchQueueSize),T(302535920000304--[[: Nerdgasm--]])),
        T(311--[[Research--]]),UsualIcon
      )
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = T(302535920000305--[[Research Queue Size--]]),
    hint = Concat(T(302535920000106--[[Current--]]),": ",hint),
  })
end

function ChoGGi.MenuFuncs.ShowResearchTechList()
  local ChoGGi = ChoGGi
  local Presets = Presets
  local ItemList = {}
  ItemList[#ItemList+1] = {
    text = Concat(" ",T(302535920000306--[[Everything--]])),
    value = "Everything",
    hint = T(302535920000307--[[All the tech/breakthroughs/mysteries--]])
  }
  ItemList[#ItemList+1] = {
    text = Concat(" ",T(302535920000308--[[All Tech--]])),
    value = "AllTech",
    hint = T(302535920000309--[[All the regular tech--]])
  }
  ItemList[#ItemList+1] = {
    text = Concat(" ",T(302535920000310--[[All Breakthroughs--]])),
    value = "AllBreakthroughs",
    hint = T(302535920000311--[[All the breakthroughs--]])
  }
  ItemList[#ItemList+1] = {
    text = Concat(" ",T(302535920000312--[[All Mysteries--]])),
    value = "AllMysteries",
    hint = T(302535920000313--[[All the mysteries--]])
  }

  for i = 1, #Presets.TechPreset do
    for j = 1, #Presets.TechPreset[i] do
      local tech = Presets.TechPreset[i][j]
      local text = T(tech.display_name)
      --remove " from that one tech...
      if text:find("\"") then
        text = text:gsub("\"","")
      end
      ItemList[#ItemList+1] = {
        text = text,
        value = tech.id,
        hint = Concat(T(tech.description),"\n\n",T(1000097--[[Category--]]),": ",tech.group)
      }
    end
  end

  local CallBackFunc = function(choice)
    local check1 = choice[1].check1
    local check2 = choice[1].check2
    --nothing checked so just return
    if not check1 and not check2 then
      MsgPopup(T(302535920000038--[[Pick a checkbox next time...--]]),T(311--[[Research--]]),UsualIcon)
      return
    elseif check1 and check2 then
      MsgPopup(T(302535920000039--[[Don't pick both checkboxes next time...--]]),T(311--[[Research--]]),UsualIcon)
      return
    end

    local tech_func
    local Which
    --add
    if check1 then
      tech_func = "DiscoverTech"
      Which = T(8690--[[Unlocked--]])
    --remove
    elseif check2 then
      tech_func = "GrantTech"
      Which = T(302535920000314--[[Researched--]])
    end

    --MultiSel
    for i = 1, #choice do
      local value = choice[i].value
      if value == "Everything" then
        ChoGGi.MenuFuncs.SetTech_EveryMystery(tech_func)
        ChoGGi.MenuFuncs.SetTech_EveryBreakthrough(tech_func)
        ChoGGi.MenuFuncs.SetTech_EveryTech(tech_func)
      elseif value == "AllTech" then
        ChoGGi.MenuFuncs.SetTech_EveryTech(tech_func)
      elseif value == "AllBreakthroughs" then
        ChoGGi.MenuFuncs.SetTech_EveryBreakthrough(tech_func)
      elseif value == "AllMysteries" then
        ChoGGi.MenuFuncs.SetTech_EveryMystery(tech_func)
      else
        _G[tech_func](value)
      end
    end

    MsgPopup(Concat(Which,T(302535920000315--[[: Unleash your inner Black Monolith Mystery.--]])),
      T(311--[[Research--]]),UsualIcon
    )
  end

  ChoGGi.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = T(302535920000316--[[Research Unlock--]]),
    hint = T(302535920000317--[[Select Unlock or Research then select the tech you want (Ctrl/Shift to multi-select).--]]),
    multisel = true,
    check1 = T(302535920000318--[[Unlock--]]),
    check1_hint = T(302535920000319--[[Just unlocks in the research tree.--]]),
    check2 = T(311--[[Research--]]),
    check2_hint = T(302535920000320--[[Unlocks and researchs.--]]),
  })
end

--tech_func = DiscoverTech/GrantTech
local function ListFields(tech_func,field,tech)
  for i = 1, #tech[field] do
    _G[tech_func](tech[field][i].id)
  end
end

function ChoGGi.MenuFuncs.SetTech_EveryMystery(tech_func)
  ListFields(tech_func,"Mysteries",Presets.TechPreset)
end

function ChoGGi.MenuFuncs.SetTech_EveryBreakthrough(tech_func)
  ListFields(tech_func,"Breakthroughs",Presets.TechPreset)
end

function ChoGGi.MenuFuncs.SetTech_EveryTech(tech_func)
  local tech = Presets.TechPreset
  ListFields(tech_func,"Biotech",tech)
  ListFields(tech_func,"Engineering",tech)
  ListFields(tech_func,"Physics",tech)
  ListFields(tech_func,"Robotics",tech)
  ListFields(tech_func,"Social",tech)
end
