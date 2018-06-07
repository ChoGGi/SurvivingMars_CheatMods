--See LICENSE for terms

local UsualIcon = "UI/Icons/Notifications/research.tga"

function ChoGGi.MenuFuncs.DraggableCheatsMenu_Toggle()
  ChoGGi.UserSettings.DraggableCheatsMenu = not ChoGGi.UserSettings.DraggableCheatsMenu

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920000232,"Draggable cheats menu: ") .. tostring(ChoGGi.UserSettings.DraggableCheatsMenu),
    ChoGGi.ComFuncs.Trans(1000162,"Menu")
  )
end

function ChoGGi.MenuFuncs.WidthOfCheatsHover_Toggle()
  ChoGGi.UserSettings.ToggleWidthOfCheatsHover = not ChoGGi.UserSettings.ToggleWidthOfCheatsHover

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920000233,"Cheats hover toggle: ") .. tostring(ChoGGi.UserSettings.ToggleWidthOfCheatsHover),
    ChoGGi.ComFuncs.Trans(1000162,"Menu")
  )
end

function ChoGGi.MenuFuncs.KeepCheatsMenuPosition_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.KeepCheatsMenuPosition = not ChoGGi.UserSettings.KeepCheatsMenuPosition
  if ChoGGi.UserSettings.KeepCheatsMenuPosition then
    ChoGGi.UserSettings.KeepCheatsMenuPosition = dlgUAMenu:GetPos()
  end

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920000234,"Cheats menu save position: ") .. tostring(ChoGGi.UserSettings.KeepCheatsMenuPosition),
    ChoGGi.ComFuncs.Trans(1000162,"Menu")
  )
end

function ChoGGi.MenuFuncs.OpenModEditor()
  local CallBackFunc = function()
    ModEditorOpen()
  end
  ChoGGi.ComFuncs.QuestionBox(
    ChoGGi.ComFuncs.Trans(302535920000235,"Warning!\nSave your game.\nThis will switch to a new map."),
    CallBackFunc,
    ChoGGi.ComFuncs.Trans(302535920000236,"Warning: Mod Editor"),
    ChoGGi.ComFuncs.Trans(302535920000237,"Okay (change map)")
  )
end

function ChoGGi.MenuFuncs.ResetAllResearch()
  local CallBackFunc = function()
    UICity:InitResearch()
  end
  ChoGGi.ComFuncs.QuestionBox(
    ChoGGi.ComFuncs.Trans(302535920000238,"Warning!\nAre you sure you want to reset all research (includes breakthrough tech)?\n\nBuildings are still unlocked."),
    CallBackFunc,
    ChoGGi.ComFuncs.Trans(302535920000239,"Warning!")
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

  local mp = g_MeteorsPredicted or empty_table
  while #mp > 0 do
    for i = 1, #mp do
      pcall(function()
        --Msg("MeteorIntercepted", mp[i], MeteorInterceptRocket.shooter)
        Msg("MeteorIntercepted", mp[i])
        mp[i]:ExplodeInAir()
      end)
    end
  end

end

function ChoGGi.MenuFuncs.DisastersTrigger()
  local ChoGGi = ChoGGi
  local ItemList = {
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920000240,"Stop Most Disasters"),value = "Stop"},
    {text = ChoGGi.ComFuncs.Trans(4149,"Cold Wave"),value = "ColdWave"},
    {text = ChoGGi.ComFuncs.Trans(302535920000241,"Dust Devil Major"),value = "DustDevilsMajor"},
    {text = ChoGGi.ComFuncs.Trans(302535920000242,"Dust Devil"),value = "DustDevils"},
    {text = ChoGGi.ComFuncs.Trans(302535920000243,"Dust Storm Electrostatic"),value = "DustStormElectrostatic"},
    {text = ChoGGi.ComFuncs.Trans(302535920000244,"Dust Storm Great"),value = "DustStormGreat"},
    {text = ChoGGi.ComFuncs.Trans(4250,"Dust Storm"),value = "DustStorm"},
    {text = ChoGGi.ComFuncs.Trans(5620,"Meteor Storm"),value = "MeteorStorm"},
    {text = ChoGGi.ComFuncs.Trans(302535920000245,"Meteor Multi-Spawn"),value = "MeteorMultiSpawn"},
    {text = ChoGGi.ComFuncs.Trans(4251,"Meteor"),value = "Meteor"},
    {text = ChoGGi.ComFuncs.Trans(302535920000246,"Missle 1"),value = "Missle1"},
    {text = ChoGGi.ComFuncs.Trans(302535920000247,"Missle 10"),value = "Missle10"},
    {text = ChoGGi.ComFuncs.Trans(302535920000248,"Missle 100"),value = "Missle100"},
    {text = ChoGGi.ComFuncs.Trans(302535920000249,"Missle 500"),value = "Missle500",hint = ChoGGi.ComFuncs.Trans(302535920000250,"Might be a little laggy")},
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
      ChoGGi.ComFuncs.MsgPopup(choice[i].text,"Disasters")
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920000251,"Trigger Disaster"),
    hint = ChoGGi.ComFuncs.Trans(302535920000252,"Targeted to mouse cursor (use arrow keys to select and enter to start, Ctrl/Shift to multi-select)."),
    multisel = true,
  })
end

function ChoGGi.MenuFuncs.ShowScanAndMapOptions()
  local ChoGGi = ChoGGi
  local Msg = Msg
  local UICity = UICity
  local hint_core = ChoGGi.ComFuncs.Trans(302535920000253,"Core: Repeatable, exploit core resources.")
  local hint_deep = ChoGGi.ComFuncs.Trans(302535920000254,"Deep: Toggleable, exploit deep resources.")
  local ItemList = {
    {text = " " .. ChoGGi.ComFuncs.Trans(4493,"All"),value = 1,hint = hint_core .. "\n" .. hint_deep},
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920000255,"Deep"),value = 2,hint = hint_deep},
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920000256,"Core"),value = 3,hint = hint_core},
    {text = ChoGGi.ComFuncs.Trans(302535920000257,"Deep Scan"),value = 4,hint = hint_deep .. "\n" .. ChoGGi.ComFuncs.Trans(302535920000030,"Enabled") .. ": " .. Consts.DeepScanAvailable},
    {text = ChoGGi.ComFuncs.Trans(797,"Deep Water"),value = 5,hint = hint_deep .. "\n" .. ChoGGi.ComFuncs.Trans(302535920000030,"Enabled") .. ": " .. Consts.IsDeepWaterExploitable},
    {text = ChoGGi.ComFuncs.Trans(793,"Deep Metals"),value = 6,hint = hint_deep .. "\n" .. ChoGGi.ComFuncs.Trans(302535920000030,"Enabled") .. ": " .. Consts.IsDeepMetalsExploitable},
    {text = ChoGGi.ComFuncs.Trans(801,"Deep Rare Metals"),value = 7,hint = hint_deep .. "\n" .. ChoGGi.ComFuncs.Trans(302535920000030,"Enabled") .. ": " .. Consts.IsDeepPreciousMetalsExploitable},
    {text = ChoGGi.ComFuncs.Trans(6548,"Core Water"),value = 8,hint = hint_core},
    {text = ChoGGi.ComFuncs.Trans(6546,"Core Metals"),value = 9,hint = hint_core},
    {text = ChoGGi.ComFuncs.Trans(6550,"Core Rare Metals"),value = 10,hint = hint_core},
    {text = ChoGGi.ComFuncs.Trans(6556,"Alien Imprints"),value = 11,hint = hint_core},
    {text = ChoGGi.ComFuncs.Trans(302535920000258,"Reveal Map"),value = 12,hint = ChoGGi.ComFuncs.Trans(302535920000259,"Reveals the map squares")},
    {text = ChoGGi.ComFuncs.Trans(302535920000260,"Reveal Map (Deep)"),value = 13,hint = ChoGGi.ComFuncs.Trans(302535920000261,"Reveals the map and \"Deep\" resources")},
  }

  local CallBackFunc = function(choice)
    local function deep()
      ChoGGi.ComFuncs.SetConstsG("DeepScanAvailable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.DeepScanAvailable))
      ChoGGi.ComFuncs.SetConstsG("IsDeepWaterExploitable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepWaterExploitable))
      ChoGGi.ComFuncs.SetConstsG("IsDeepMetalsExploitable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepMetalsExploitable))
      ChoGGi.ComFuncs.SetConstsG("IsDeepPreciousMetalsExploitable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepPreciousMetalsExploitable))
    end
    local function core()
      Msg("TechResearched","CoreWater", UICity)
      Msg("TechResearched","CoreMetals", UICity)
      Msg("TechResearched","CoreRareMetals", UICity)
      Msg("TechResearched","AlienImprints", UICity)
    end

    local value
    for i=1,#choice do
      value = choice[i].value
      print(value)
      if value == 1 then
        CheatMapExplore("deep scanned")
        deep()
        core()
      elseif value == 2 then
        deep()
      elseif value == 3 then
        core()
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
    ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920000262,"Alice thought to herself.\n\"Now you will see a film made for children\".\nPerhaps.\nBut I nearly forgot! You must close your eyes.\nOtherwise you won't see anything."),
      ChoGGi.ComFuncs.Trans(1000436,"Map"),"UI/Achievements/TheRabbitHole.tga",true
    )
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920000263,"Scan Map"),
    hint = ChoGGi.ComFuncs.Trans(302535920000264,"You can select multiple items."),
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
      ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920000265,"Spawned") .. ": " .. choice[1].text,
        ChoGGi.ComFuncs.Trans(547,"Colonists"),"UI/Icons/Sections/colonist.tga"
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920000266,"Spawn Colonists"),
    hint = ChoGGi.ComFuncs.Trans(302535920000267,"Colonist placing priority: Selected dome, Evenly between domes, or centre of map if no domes."),
  })
end

function ChoGGi.MenuFuncs.ShowMysteryList()
  local ChoGGi = ChoGGi
  local ItemList = {}
  for i = 1, #ChoGGi.Tables.Mystery do
    ItemList[#ItemList+1] = {
      text = ChoGGi.Tables.Mystery[i].number .. ": " .. ChoGGi.Tables.Mystery[i].name,
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

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920000268,"Start A Mystery"),
    hint = ChoGGi.ComFuncs.Trans(302535920000269,"Warning: Adding a mystery is cumulative, this will NOT replace existing mysteries."),
    check1 = ChoGGi.ComFuncs.Trans(302535920000270,"Instant Start"),
    check1_hint = ChoGGi.ComFuncs.Trans(302535920000271,"May take up to one Sol to \"instantly\" activate mystery."),
  })
end

function ChoGGi.MenuFuncs.StartMystery(mystery_id,instant)
  local ChoGGi = ChoGGi
  local UICity = UICity
  --inform people of actions, so they don't add a bunch of them
  ChoGGi.UserSettings.ShowMysteryMsgs = true

  UICity.mystery_id = mystery_id
  local fields = Presets.TechFieldPreset.Default
  for i = 1, #fields do
    local field = fields[i]
    local field_id = field.id
    local costs = field.costs or empty_table
    local list = UICity.tech_field[field_id] or {}
    UICity.tech_field[field_id] = list
    for _, tech in ipairs(Presets.TechPreset[field_id]) do
      if tech.mystery == mystery_id then
        local tech_id = tech.id
        list[#list + 1] = tech_id
        UICity.tech_status[tech_id] = {points = 0, field = field_id}
        tech:EffectsInit(UICity)
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
  local ChoGGi = ChoGGi
  local msgs = {MystName .. ChoGGi.ComFuncs.Trans(302535920000272,"\n\nTo play back speech use \"Exec\" button and type in\ng_Voice:Play(ChoGGi.CurObj.speech)\n")}
  local Players = s_SeqListPlayers or empty_table
  -- 1 is some default map thing
  if #Players == 1 then
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
            local ip = state and (state.ip or state.end_ip or 10000)
            for k = 1, #scenarios do
              local seq = scenarios[k]
              if seq.class == "SA_WaitMessage" then
                --add to msg list
                msgs[#msgs+1] = {
                  [" "] = ChoGGi.ComFuncs.Trans(302535920000273,"Speech") .. ": " .. ChoGGi.ComFuncs.Trans(seq.voiced_text) .. "\n\n\n\n" .. ChoGGi.ComFuncs.Trans(302535920000274,"Message") .. ": " .. ChoGGi.ComFuncs.Trans(seq.text),
                  speech = seq.voiced_text,
                  class = ChoGGi.ComFuncs.Trans(seq.title)
                }
              end
            end
          end
        end
      end
    end
  end
  --display to user
  local ex = Examine:new()
  ex:SetPos(point(550,100))
  ex:SetObj(msgs)
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
        text = id .. ": " .. ChoGGi.Tables.Mystery[id].name,
        value = id,
        func = id,
        seed = PlayerList[i].seed,
        hint = ChoGGi.Tables.Mystery[id].description .. "\n\n<color 255 75 75>" .. ChoGGi.ComFuncs.Trans(302535920000275,"Total parts") .. "</color>: " .. totalparts .. " <color 255 75 75>" .. ChoGGi.ComFuncs.Trans(302535920000289,"Current part") .. "</color>: " .. (ip or ChoGGi.ComFuncs.Trans(302535920000276,"done?"))
      }
    end
  end

  local CallBackFunc = function(choice)
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
      ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920000277,"Removed all!"),ChoGGi.ComFuncs.Trans(3486,"Mystery"))
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
      ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(3486,"Mystery") .. ": " .. choice[1].text .. " " .. ChoGGi.ComFuncs.Trans(302535920000278,"Removed") .. "!",ChoGGi.ComFuncs.Trans(3486,"Mystery"))
    elseif value then
      --next step
      ChoGGi.MenuFuncs.NextMysterySeq(value,seed)
    end

  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920000279,"Manage"),
    hint = ChoGGi.ComFuncs.Trans(302535920000280,"Skip the timer delay, and optionally skip the requirements (applies to all mysteries that are the same type).\n\nSequence part may have more then one check, you may have to skip twice or more.\n\nDouble right-click selected mystery to review past messages."),
    check1 = ChoGGi.ComFuncs.Trans(302535920000281,"Remove"),
    check1_hint = ChoGGi.ComFuncs.Trans(302535920000282,"Warning: This will remove the mystery, if you start it again; it'll be back to the start."),
    check2 = ChoGGi.ComFuncs.Trans(302535920000283,"Remove All"),
    check2_hint = ChoGGi.ComFuncs.Trans(302535920000284,"Warning: This will remove all the mysteries!"),
    custom_type = 6,
    custom_func = ShowMysteryLog,
  })
end
--[[
  local idx = 0
  for Thread in pairs(ThreadsMessageToThreads) do
    if Thread.thread and IsValidThread(Thread.thread) then
      idx = idx + 1
      print("idx " .. idx)
    end
  end
--]]
--ex(s_SeqListPlayers)
function ChoGGi.MenuFuncs.NextMysterySeq(Mystery,seed)
  local ChoGGi = ChoGGi
  local UICity = UICity
  local ThreadsMessageToThreads = ThreadsMessageToThreads
  local DeleteThread = DeleteThread
  local SA_WaitMarsTime = SA_WaitMarsTime
  local Msg = Msg

  local warning = ChoGGi.ComFuncs.Trans(302535920000285,"\n\nClick \"Ok\" to skip requirements (Warning: may cause issues later on, untested).")
  local name = ChoGGi.ComFuncs.Trans(3486,"Mystery") .. ": " .. ChoGGi.Tables.Mystery[Mystery].name

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
          local title = name .. " " .. ChoGGi.ComFuncs.Trans(302535920000286,"Part") .. ": " .. ip

          --seqs that add delays/tasks
          if seq.class == "SA_WaitMarsTime" or seq.class == "SA_WaitTime" then
            ChoGGi.Temp.SA_WaitMarsTime_StopWait = {seed = seed}
            --we don't want to wait
            seq.wait_type = SA_WaitMarsTime:GetDefaultPropertyValue("wait_type")
            seq.wait_subtype = SA_WaitMarsTime:GetDefaultPropertyValue("wait_subtype")
            seq.loops = SA_WaitMarsTime:GetDefaultPropertyValue("loops")
            seq.duration = 1
            seq.rand_duration = 1
            local wait = Thread.action
            wait.wait_type = SA_WaitMarsTime:GetDefaultPropertyValue("wait_type")
            wait.wait_subtype = SA_WaitMarsTime:GetDefaultPropertyValue("wait_subtype")
            wait.loops = SA_WaitMarsTime:GetDefaultPropertyValue("loops")
            wait.duration = 1
            wait.rand_duration = 1

            Thread.finished = true
            --Thread.action:EndWait(Thread)
            --may not be needed
            Player:UpdateCurrentIP(seq_list)
            --let them know
            ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920000287,"Timer delay removed (may take upto a Sol)."),title)
            break

          elseif seq.class == "SA_WaitExpression" then
            seq.duration = 0
            local CallBackFunc = function()
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
            ChoGGi.ComFuncs.QuestionBox(
              ChoGGi.ComFuncs.Trans(302535920000288,"Advancement requires: ") .. tostring(seq.expression) .. ChoGGi.ComFuncs.Trans(302535920000290,"\n\nTime duration has been set to 0 (you still need to complete the requirements).\n\nWait for a Sol or two for it to update (should give a popup msg).") .. warning,
              CallBackFunc,
              title
            )
            break

          elseif seq.class == "SA_WaitMsg" then
            local CallBackFunc = function()
              ChoGGi.Temp.SA_WaitMarsTime_StopWait = {seed = seed,again = true}
              --send fake msg (ok it's real, but it hasn't happened)
              Msg(seq.msg)
              Player:UpdateCurrentIP(seq_list)
            end
            ChoGGi.ComFuncs.QuestionBox(
              ChoGGi.ComFuncs.Trans(302535920000288,"Advancement requires: ") .. tostring(seq.msg) .. warning,
              CallBackFunc,
              title
            )
            break

          elseif seq.class == "SA_WaitResearch" then
            local CallBackFunc = function()
              GrantTech(seq.Research)

              Thread.finished = true
              Player:UpdateCurrentIP(seq_list)
            end
            ChoGGi.ComFuncs.QuestionBox(
              ChoGGi.ComFuncs.Trans(302535920000288,"Advancement requires: ") .. tostring(seq.Research).. warning,
              CallBackFunc,
              title
            )

          elseif seq.class == "SA_RunSequence" then
            local CallBackFunc = function()
              seq.wait = false
              Thread.finished = true
              Player:UpdateCurrentIP(seq_list)
            end
            ChoGGi.ComFuncs.QuestionBox(
              ChoGGi.ComFuncs.Trans(302535920000291,"Waiting for") .. " " .. seq.sequence .. " " .. ChoGGi.ComFuncs.Trans(302535920000292,"to finish.\n\nSkip it?"),
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
  ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920000293,"Unlocked all buildings for construction."),
    ChoGGi.ComFuncs.Trans(3980,"Buildings"),"UI/Icons/Upgrades/build_2.tga"
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
      ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920000294,"Added") .. ": " .. choice[1].text,
        ChoGGi.ComFuncs.Trans(311,"Research"),"UI/Icons/Upgrades/eternal_fusion_04.tga"
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920000295,"Add Research Points"),
    hint = ChoGGi.ComFuncs.Trans(302535920000296,"If you need a little boost (or a lotta boost) in research."),
  })
end

function ChoGGi.MenuFuncs.OutsourcingFree_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.ComFuncs.SetConstsG("OutsourceResearchCost",ChoGGi.ComFuncs.NumRetBool(Consts.OutsourceResearchCost) and 0 or ChoGGi.Consts.OutsourceResearchCost)

  ChoGGi.ComFuncs.SetSavedSetting("OutsourceResearchCost",Consts.OutsourceResearchCost)
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.OutsourceResearchCost) .. ChoGGi.ComFuncs.Trans(302535920000297,"\nBest hope you picked India as your Mars sponsor"),
    ChoGGi.ComFuncs.Trans(311,"Research"),"UI/Icons/Sections/research_1.tga",true
  )
end

local hint_maxa = ChoGGi.ComFuncs.Trans(302535920000298,"Max amount in UICity.tech_field list, you could make the amount larger if you want (an update/mod can add more).")
function ChoGGi.MenuFuncs.SetBreakThroughsOmegaTelescope()
  local ChoGGi = ChoGGi
  local DefaultSetting = ChoGGi.Consts.OmegaTelescopeBreakthroughsCount
  local MaxAmount = #UICity.tech_field.Breakthroughs
  local ItemList = {
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920000110,"Default") .. ": " .. DefaultSetting,value = DefaultSetting},
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
      ChoGGi.ComFuncs.MsgPopup(choice[1].text .. ChoGGi.ComFuncs.Trans(302535920000299,": Research is what I'm doing when I don't know what I'm doing."),
        ChoGGi.ComFuncs.Trans(5182,"Omega Telescope"),UsualIcon
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920000300,"BreakThroughs From Omega"),
    hint = ChoGGi.ComFuncs.Trans(302535920000106,"Current") .. ": " .. hint,
  })
end

function ChoGGi.MenuFuncs.SetBreakThroughsAllowed()
  local ChoGGi = ChoGGi
  local DefaultSetting = ChoGGi.Consts.BreakThroughTechsPerGame
  local MaxAmount = #UICity.tech_field.Breakthroughs
  local ItemList = {
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920000110,"Default") .. ": " .. DefaultSetting,value = DefaultSetting},
    {text = 26,value = 26,hint = ChoGGi.ComFuncs.Trans(302535920000301,"Doubled the base amount.")},
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
      ChoGGi.ComFuncs.MsgPopup(choice[1].text .. ChoGGi.ComFuncs.Trans(302535920000302,": S M R T"),
        ChoGGi.ComFuncs.Trans(311,"Research"),UsualIcon
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920000303,"BreakThroughs Allowed"),
    hint = ChoGGi.ComFuncs.Trans(302535920000106,"Current") .. ": " .. hint,
  })
end

function ChoGGi.MenuFuncs.SetResearchQueueSize()
  local ChoGGi = ChoGGi
  local DefaultSetting = ChoGGi.Consts.ResearchQueueSize
  local ItemList = {
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920000110,"Default") .. ": " .. DefaultSetting,value = DefaultSetting},
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
      ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.ResearchQueueSize) .. ChoGGi.ComFuncs.Trans(302535920000304,": Nerdgasm"),
        ChoGGi.ComFuncs.Trans(311,"Research"),UsualIcon
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920000305,"Research Queue Size"),
    hint = ChoGGi.ComFuncs.Trans(302535920000106,"Current") .. ": " .. hint,
  })
end

function ChoGGi.MenuFuncs.ShowResearchTechList()
  local ChoGGi = ChoGGi
  local Presets = Presets
  local ItemList = {}
  ItemList[#ItemList+1] = {
    text = " " .. ChoGGi.ComFuncs.Trans(302535920000306,"Everything"),
    value = "Everything",
    hint = ChoGGi.ComFuncs.Trans(302535920000307,"All the tech/breakthroughs/mysteries")
  }
  ItemList[#ItemList+1] = {
    text = " " .. ChoGGi.ComFuncs.Trans(302535920000308,"All Tech"),
    value = "AllTech",
    hint = ChoGGi.ComFuncs.Trans(302535920000309,"All the regular tech")
  }
  ItemList[#ItemList+1] = {
    text = " " .. ChoGGi.ComFuncs.Trans(302535920000310,"All Breakthroughs"),
    value = "AllBreakthroughs",
    hint = ChoGGi.ComFuncs.Trans(302535920000311,"All the breakthroughs")
  }
  ItemList[#ItemList+1] = {
    text = " " .. ChoGGi.ComFuncs.Trans(302535920000312,"All Mysteries"),
    value = "AllMysteries",
    hint = ChoGGi.ComFuncs.Trans(302535920000313,"All the mysteries")
  }

  for i = 1, #Presets.TechPreset do
    for j = 1, #Presets.TechPreset[i] do
      local tech = Presets.TechPreset[i][j]
      local text = ChoGGi.ComFuncs.Trans(tech.display_name)
      --remove " from that one tech...
      if text:find("\"") then
        text = text:gsub("\"","")
      end
      ItemList[#ItemList+1] = {
        text = text,
        value = tech.id,
        hint = ChoGGi.ComFuncs.Trans(tech.description) .. "\n\n" .. ChoGGi.ComFuncs.Trans(1000097,"Category") .. ": " .. tech.group
      }
    end
  end

  local CallBackFunc = function(choice)
    local check1 = choice[1].check1
    local check2 = choice[1].check2
    --nothing checked so just return
    if not check1 and not check2 then
      ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920000038,"Pick a checkbox next time..."),ChoGGi.ComFuncs.Trans(311,"Research"),UsualIcon)
      return
    elseif check1 and check2 then
      ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920000039,"Don't pick both checkboxes next time..."),ChoGGi.ComFuncs.Trans(311,"Research"),UsualIcon)
      return
    end

    local tech_func
    local Which
    --add
    if check1 then
      tech_func = "DiscoverTech"
      Which = ChoGGi.ComFuncs.Trans(8690,"Unlocked")
    --remove
    elseif check2 then
      tech_func = "GrantTech"
      Which = ChoGGi.ComFuncs.Trans(302535920000314,"Researched")
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

    ChoGGi.ComFuncs.MsgPopup(Which .. ChoGGi.ComFuncs.Trans(302535920000315,": Unleash your inner Black Monolith Mystery."),
      ChoGGi.ComFuncs.Trans(311,"Research"),UsualIcon
    )
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920000316,"Research Unlock"),
    hint = ChoGGi.ComFuncs.Trans(302535920000317,"Select Unlock or Research then select the tech you want (Ctrl/Shift to multi-select)."),
    multisel = true,
    check1 = ChoGGi.ComFuncs.Trans(302535920000318,"Unlock"),
    check1_hint = ChoGGi.ComFuncs.Trans(302535920000319,"Just unlocks in the research tree."),
    check2 = ChoGGi.ComFuncs.Trans(311,"Research"),
    check2_hint = ChoGGi.ComFuncs.Trans(302535920000320,"Unlocks and researchs."),
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
