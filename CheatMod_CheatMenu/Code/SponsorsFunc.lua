local UsualIcon = "UI/Icons/Sections/spaceship.tga"

function ChoGGi.SponsorsFunc_LoadingScreenPreClose()
  local function SetBonus(Preset,Type,Func)
    local tab = Presets[Preset].Default or empty_table
    for i = 1, #tab do
      if ChoGGi.CheatMenuSettings[Type .. tab[i].id] then
        Func(tab[i].id)
      end
    end
  end
  SetBonus("MissionSponsorPreset","Sponsor",ChoGGi.SetSponsorBonuses)
  SetBonus("CommanderProfilePreset","Commander",ChoGGi.SetCommanderBonuses)
end

--[[
function ChoGGi.SetDisasterOccurrence(sType)
  local ItemList = {}
  local data = DataInstances["MapSettings_" .. sType]

  for i = 1, #data do
    table.insert(ItemList,{
      text = data[i].name,
      value = data[i].name
    })
  end

  local CallBackFunc = function(choice)
    mapdata["MapSettings_" .. sType] = sType .. "_" .. choice[1].value

    ChoGGi.MsgPopup(sType .. " occurrence is now: " .. choice[1].value,
      "Disaster","UI/Icons/Sections/attention.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. " Disaster Occurrences","Current: " .. mapdata["MapSettings_" .. sType])
end

function ChoGGi.ChangeRules()
  local ItemList = {}
  for _,Value in iXpairs(Presets.GameRules.Default) do
    if Value.id ~= "random" then
      table.insert(ItemList,{
        text = _InternalTranslate(Value.display_name),
        value = Value.id,
        hint = _InternalTranslate(Value.description) .. "\n" .. _InternalTranslate(Value.flavor)
      })
    end
  end

  local CallBackFunc = function(choice)
    local check1 = choice[1].check1
    local check2 = choice[1].check2
    if not check1 and not check2 then
      ChoGGi.MsgPopup("Pick a checkbox next time...","Rules",UsualIcon)
      return
    elseif check1 and check2 then
      ChoGGi.MsgPopup("Don't pick both checkboxes next time...","Rules",UsualIcon)
      return
    end

    for i = 1, #ItemList do
      --check to make sure it isn't a fake name (no sense in saving it)
        for j = 1, #choice do
          local value = choice[j].value
          if ItemList[i].value == value then
            --new comm
            if not g_CurrentMissionParams.idGameRules then
              g_CurrentMissionParams.idGameRules = {}
            end
            if check1 then
              g_CurrentMissionParams.idGameRules[value] = true
            elseif check2 then
              g_CurrentMissionParams.idGameRules[value] = nil
            end
          end
        end
      end

    local rules = GetActiveGameRules()
    for _, rule_id in iXpairs(rules) do
      GameRulesMap[rule_id]:OnInitEffect(UICity)
      GameRulesMap[rule_id]:OnApplyEffect(UICity)
    end
    ChoGGi.MsgPopup("Set: " .. #choice,
      "Rules",UsualIcon
    )
  end

  local hint
  local rules = g_CurrentMissionParams.idGameRules
  if type(rules) == "table" and next(rules) then
    hint = "Current:"
    for Key,_ in pairs(rules) do
      hint = hint .. " " .. _InternalTranslate(Presets.GameRules.Default[Key].display_name)
    end
  end

  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Rules",hint,true,"Add","Add selected rules","Remove","Remove selected rules")
end
--]]

function ChoGGi.MeteorHealthDamage_Toggle()
  ChoGGi.SetConstsG("MeteorHealthDamage",ChoGGi.NumRetBool(Consts.MeteorHealthDamage,0,ChoGGi.Consts.MeteorHealthDamage))
  ChoGGi.SetSavedSetting("MeteorHealthDamage",Consts.MeteorHealthDamage)

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.MeteorHealthDamage) .. "\nDamage? Total, sir.\nIt's what we call a global killer.\nThe end of mankind. Doesn't matter where it hits. Nothing would survive, not even bacteria.",
    "Colonists","UI/Icons/Notifications/meteor_storm.tga",true
  )
end

function ChoGGi.ChangeSponsor()
  local ItemList = {}
  local tab = Presets.MissionSponsorPreset.Default or empty_table
  for i = 1, #tab do
    if tab[i].id ~= "random" then
      table.insert(ItemList,{
        text = _InternalTranslate(tab[i].display_name),
        value = tab[i].id,
        hint = _InternalTranslate(tab[i].effect)
      })
    end
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    for i = 1, #ItemList do
      --check to make sure it isn't a fake name (no sense in saving it)
      if ItemList[i].value == value then
        --new comm
        g_CurrentMissionParams.idMissionSponsor = value
        -- apply tech from new sponsor
        GetMissionSponsor():game_apply(UICity)
        GetMissionSponsor():OnApplyEffect(UICity)
        UICity:ApplyModificationsFromProperties()

        --and bonuses
        UICity:InitMissionBonuses()

        ChoGGi.MsgPopup("Sponsor for this save is now " .. choice[1].text,
          "Sponsor",UsualIcon
        )
        break
      end
    end
  end

  local hint = "Current: " .. _InternalTranslate(Presets.MissionSponsorPreset.Default[g_CurrentMissionParams.idMissionSponsor].display_name)
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Sponsor",hint)
end

--set just the bonus effects
function ChoGGi.SetSponsorBonus()
  local ItemList = {}
  local tab = Presets.MissionSponsorPreset.Default or empty_table
  for i = 1, #tab do
    if tab[i].id ~= "random" then
      table.insert(ItemList,{
        text = _InternalTranslate(tab[i].display_name),
        value = tab[i].id,
        hint = _InternalTranslate(tab[i].effect) .. "\n\nEnabled Status: " .. tostring(ChoGGi.CheatMenuSettings["Sponsor" .. tab[i].id])
      })
    end
  end

  local CallBackFunc = function(choice)
    if choice[1].check2 then
      for i = 1, #ItemList do
        local value = ItemList[i].value
        if type(value) == "string" then
          value = "Sponsor" .. value
          ChoGGi.CheatMenuSettings[value] = nil
        end
      end
    else
      for i = 1, #choice do
        for j = 1, #ItemList do
          --check to make sure it isn't a fake name (no sense in saving it)
          local value = choice[i].value
          if ItemList[j].value == value and type(value) == "string" then
            local name = "Sponsor" .. value
            if choice[1].check1 then
              ChoGGi.CheatMenuSettings[name] = nil
            else
              ChoGGi.CheatMenuSettings[name] = true
            end
            if ChoGGi.CheatMenuSettings[name] then
              ChoGGi.SetSponsorBonuses(value)
            end
          end
        end
      end
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("Bonuses: " .. #choice,"Sponsor")
  end

  local hint = "Current: " .. _InternalTranslate(Presets.MissionSponsorPreset.Default[g_CurrentMissionParams.idMissionSponsor].display_name)
    .. "\n\nUse Ctrl/Shift for multiple bonuses."
    .. "\n\nModded ones are mostly ignored for now (just cargo space/research points)."
  local hint_check1 = "Turn off selected bonuses (defaults to turning on)."
  local hint_check2 = "Turns off all bonuses."
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Sponsor Bonuses",hint,true,"Turn Off",hint_check1,"Turn All Off",hint_check2)
end

function ChoGGi.ChangeCommander()
  local ItemList = {}
  local tab = Presets.CommanderProfilePreset.Default or empty_table
  for i = 1, #tab do
    if tab[i].id ~= "random" then
      table.insert(ItemList,{
        text = _InternalTranslate(tab[i].display_name),
        value = tab[i].id,
        hint = _InternalTranslate(tab[i].effect)
      })
    end
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    for i = 1, #ItemList do
      --check to make sure it isn't a fake name (no sense in saving it)
      if ItemList[i].value == value then
        --new comm
        g_CurrentMissionParams.idCommanderProfile = value

        -- apply tech from new commmander
        GetCommanderProfile():game_apply(UICity)
        GetCommanderProfile():OnApplyEffect(UICity)
        UICity:ApplyModificationsFromProperties()
        --and bonuses
        UICity:InitMissionBonuses()

        ChoGGi.MsgPopup("Commander for this save is now " .. choice[1].text,
          "Commander",UsualIcon
        )
        break
      end
    end
  end

  local hint = "Current: " .. _InternalTranslate(Presets.CommanderProfilePreset.Default[g_CurrentMissionParams.idCommanderProfile].display_name)
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Commander",hint)
end

--set just the bonus effects
function ChoGGi.SetCommanderBonus()
  local ItemList = {}
  local tab = Presets.CommanderProfilePreset.Default or empty_table
  for i = 1, #tab do
    if tab[i].id ~= "random" then
      table.insert(ItemList,{
        text = _InternalTranslate(tab[i].display_name),
        value = tab[i].id,
        hint = _InternalTranslate(tab[i].effect) .. "\n\nEnabled Status: " .. tostring(ChoGGi.CheatMenuSettings["Commander" .. tab[i].id])
      })
    end
  end

  local CallBackFunc = function(choice)
    if choice[1].check2 then
      for i = 1, #ItemList do
        local value = ItemList[i].value
        if type(value) == "string" then
          value = "Commander" .. value
          ChoGGi.CheatMenuSettings[value] = nil
        end
      end
    else
      for i = 1, #choice do
        for j = 1, #ItemList do
          --check to make sure it isn't a fake name (no sense in saving it)
          local value = choice[i].value
          if ItemList[j].value == value and type(value) == "string" then
            local name = "Commander" .. value
            if choice[1].check1 then
              ChoGGi.CheatMenuSettings[name] = nil
            else
              ChoGGi.CheatMenuSettings[name] = true
            end
            if ChoGGi.CheatMenuSettings[name] then
              ChoGGi.SetCommanderBonuses(value)
            end
          end
        end
      end
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("Bonuses: " .. #choice,"Commander")
  end

  local hint = "Current: " .. _InternalTranslate(Presets.CommanderProfilePreset.Default[g_CurrentMissionParams.idCommanderProfile].display_name)
    .. "\n\nUse Ctrl/Shift for multiple bonuses."
  local hint_check1 = "Turn off selected bonuses (defaults to turning on)."
  local hint_check2 = "Turns off all bonuses."
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Commander Bonuses",hint,true,"Turn Off",hint_check1,"Turn All Off",hint_check2)
end

--pick a logo
function ChoGGi.ChangeGameLogo()
  local ItemList = {}
  local tab = Presets.MissionLogoPreset.Default or empty_table
  for i = 1, #tab do
    table.insert(ItemList,{
      text = _InternalTranslate(tab[i].display_name),
      value = tab[i].id,
    })
  end

  local CallBackFunc = function(choice)
    --any newly built/landed uses this logo
    local value = choice[1].value

    local function ChangeLogo(Label,Name)
      local tab = UICity.labels[Label] or empty_table
      for i = 1, #tab do
        local tab2 = tab[i]:GetAttaches() or empty_table
        for j = 1, #tab2 do
          if tab2[j].class == "Logo" then
            local tempLogo = tab2[j]
            if tempLogo then
              tempLogo:ChangeEntity(Name)
            end
          end
        end
      end
    end

    local tab = Presets.MissionLogoPreset.Default or empty_table
    for i = 1, #tab do
      if tab[i].id == value then
        --for any new objects
        g_CurrentMissionParams.idMissionLogo = value
        local entity_name = Presets.MissionLogoPreset.Default[value].entity_name
        --loop through landed rockets and change logo
        ChangeLogo("AllRockets",entity_name)
        --same for any buildings that use the logo
        ChangeLogo("Building",entity_name)

        ChoGGi.MsgPopup("Logo: " .. choice[1].text,
          "Logo",UsualIcon
        )
      end
    end
  end

  local hint = "Current: " .. _InternalTranslate(Presets.MissionLogoPreset.Default[g_CurrentMissionParams.idMissionLogo].display_name)
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set New Logo",hint)
end
