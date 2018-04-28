function ChoGGi.SponsorsFunc_LoadingScreenPreClose()
  for _,Value in ipairs(Presets.MissionSponsorPreset.Default) do
   local name = "Sponsor" .. Value.id
    if ChoGGi.CheatMenuSettings[name] then
      ChoGGi.SetSponsorBonuses(Value.id)
    end
  end
  for _,Value in ipairs(Presets.CommanderProfilePreset.Default) do
   local name = "Commander" .. Value.id
    if ChoGGi.CheatMenuSettings[name] then
      ChoGGi.SetCommanderBonuses(Value.id)
    end
  end
end

function ChoGGi.ChangeSponsor()
  local ItemList = {}
  for _,Value in ipairs(Presets.MissionSponsorPreset.Default) do
    if Value.id ~= "random" then
      table.insert(ItemList,{
        text = _InternalTranslate(Value.display_name),
        value = Value.id,
        hint = _InternalTranslate(Value.effect)
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

        -- apply tech from new commmander
        UICity:ApplyModificationsFromProperties()
        --and bonuses
        UICity:InitMissionBonuses()

        ChoGGi.MsgPopup("Sponsor for this save is now " .. choice[1].text,
          "Sponsor","UI/Icons/Sections/spaceship.tga"
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
  for _,Value in ipairs(Presets.MissionSponsorPreset.Default) do
    if Value.id ~= "random" then
      table.insert(ItemList,{
        text = _InternalTranslate(Value.display_name),
        value = Value.id,
        hint = _InternalTranslate(Value.effect)
      })
    end
  end

  local CallBackFunc = function(choice)
    if ChoGGi.ListChoiceCustomDialog_CheckBox2 then
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
            if ChoGGi.ListChoiceCustomDialog_CheckBox1 then
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
  for _,Value in ipairs(Presets.CommanderProfilePreset.Default) do
    if Value.id ~= "random" then
      table.insert(ItemList,{
        text = _InternalTranslate(Value.display_name),
        value = Value.id,
        hint = _InternalTranslate(Value.effect)
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
        UICity:ApplyModificationsFromProperties()
        --and bonuses
        UICity:InitMissionBonuses()

        ChoGGi.MsgPopup("Commander for this save is now " .. choice[1].text,
          "Commander","UI/Icons/Sections/spaceship.tga"
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
  for _,Value in ipairs(Presets.CommanderProfilePreset.Default) do
    if Value.id ~= "random" then
      table.insert(ItemList,{
        text = _InternalTranslate(Value.display_name),
        value = Value.id,
        hint = _InternalTranslate(Value.effect)
      })
    end
  end

  local CallBackFunc = function(choice)
    if ChoGGi.ListChoiceCustomDialog_CheckBox2 then
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
            if ChoGGi.ListChoiceCustomDialog_CheckBox1 then
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
  for _,logo in ipairs(Presets.MissionLogoPreset.Default) do
    table.insert(ItemList,{
      text = _InternalTranslate(logo.display_name),
      value = logo.id,
    })
  end

  local CallBackFunc = function(choice)
    --any newly built/landed uses this logo
    local value = choice[1].value

    local function changelogo(label,name)
      for _,object in ipairs(UICity.labels[label] or empty_table) do
        for _,attached in ipairs(object:GetAttaches()) do

          if attached.class == "Logo" then
            local tempLogo = attached
            if tempLogo then
              tempLogo:ChangeEntity(name)
            end
          end

        end
      end
    end

    for _,logo in ipairs(Presets.MissionLogoPreset.Default) do
      if logo.id == value then
        --for any new objects
        g_CurrentMissionParams.idMissionLogo = value
        local entity_name = Presets.MissionLogoPreset.Default[value].entity_name
        --loop through landed rockets and change logo
        changelogo("AllRockets",entity_name)
        --same for any buildings that use the logo
        changelogo("Building",entity_name)

        ChoGGi.MsgPopup("Logo: " .. choice[1].text,
          "Logo","UI/Icons/Sections/spaceship.tga"
        )
      end
    end
  end

  local hint = "Current: " .. _InternalTranslate(Presets.MissionLogoPreset.Default[g_CurrentMissionParams.idMissionLogo].display_name)
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set New Logo",hint)
end
