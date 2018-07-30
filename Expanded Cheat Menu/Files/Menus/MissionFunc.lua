--See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local T = ChoGGi.ComFuncs.Trans
local S = ChoGGi.Strings
local default_icon = "UI/Icons/Sections/spaceship.tga"

local type,tostring = type,tostring

local CreateRealTimeThread = CreateRealTimeThread
local GetMissionSponsor = GetMissionSponsor
local Msg = Msg
local PlaceObj = PlaceObj
local RestartGlobalGameTimeThread = RestartGlobalGameTimeThread
local WaitPopupNotification = WaitPopupNotification

function ChoGGi.MenuFuncs.InstantMissionGoal()
  local UICity = UICity

  local goal = UICity.mission_goal
  local target = GetMissionSponsor().goal_target + 1
  -- different goals use different targets, we'll just set them all
  goal.analyzed = target
  goal.amount = target
  goal.researched = target
  goal.colony_approval_sol = UICity.day
  ChoGGi.Temp.InstantMissionGoal = true
  MsgPopup(
    302535920001158--[[Mission goal--]],
    8076--[[Goal--]],
    default_icon
  )
end

function ChoGGi.MenuFuncs.InstantColonyApproval()
  CreateRealTimeThread(WaitPopupNotification, "ColonyViabilityExit_Delay")
  Msg("ColonyApprovalPassed")
  g_ColonyNotViableUntil = -1
end

function ChoGGi.MenuFuncs.MeteorHealthDamage_Toggle()
  local ChoGGi = ChoGGi
  local Consts = Consts
  ChoGGi.ComFuncs.SetConstsG("MeteorHealthDamage",ChoGGi.ComFuncs.NumRetBool(Consts.MeteorHealthDamage,0,ChoGGi.Consts.MeteorHealthDamage))
  ChoGGi.ComFuncs.SetSavedSetting("MeteorHealthDamage",Consts.MeteorHealthDamage)

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(S[302535920001160--[["%s
Damage? Total, sir.
It's what we call a global killer.
The end of mankind. Doesn't matter where it hits. Nothing would survive, not even bacteria."--]]]:format(ChoGGi.UserSettings.MeteorHealthDamage),
    547--[[Colonists--]],
    "UI/Icons/Notifications/meteor_storm.tga",
    true
  )
end

function ChoGGi.MenuFuncs.ChangeSponsor()
  local Presets = Presets

  local ItemList = {}
  local defs = Presets.MissionSponsorPreset.Default or ""
  for i = 1, #defs do
    local def = defs[i]
    if def.id ~= "random" then
      ItemList[#ItemList+1] = {
        text = T(def.display_name),
        value = def.id,
        hint = T(def.effect)
      }
    end
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    local g_CurrentMissionParams = g_CurrentMissionParams
    for i = 1, #ItemList do
      --check to make sure it isn't a fake name (no sense in saving it)
      if ItemList[i].value == value then
        --new comm
        g_CurrentMissionParams.idMissionSponsor = value
        -- apply tech from new sponsor
        local city = UICity
        local sponsor = GetMissionSponsor()
        city:ModifyGlobalConstsFromProperties(sponsor)
        sponsor:game_apply(city)
        sponsor:OnApplyEffect(city)
        --and bonuses
        city:InitMissionBonuses()

        MsgPopup(
          S[302535920001161--[[Sponsor for this save is now %s--]]]:format(choice[1].text),
          302535920001162--[[Sponsor--]],
          default_icon
        )
        break
      end
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920000712--[[Set Sponsor--]],
    hint = Concat(S[302535920000106--[[Current--]]],": ",T(Presets.MissionSponsorPreset.Default[g_CurrentMissionParams.idMissionSponsor].display_name)),
  }
end

--set just the bonus effects
function ChoGGi.MenuFuncs.SetSponsorBonus()
  local ChoGGi = ChoGGi
  local Presets = Presets

  local ItemList = {}
  local tab = Presets.MissionSponsorPreset.Default or ""
  for i = 1, #tab do
    if tab[i].id ~= "random" then
      ItemList[#ItemList+1] = {
        text = T(tab[i].display_name),
        value = tab[i].id,
        hint = Concat(T(tab[i].effect),"\n\n",S[302535920001165--[[Enabled Status--]]],": ",tostring(ChoGGi.UserSettings[Concat("Sponsor",tab[i].id)]))
      }
    end
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if choice[1].check2 then
      for i = 1, #ItemList do
        local value = ItemList[i].value
        if type(value) == "string" then
          value = Concat("Sponsor",value)
          ChoGGi.UserSettings[value] = nil
        end
      end
    else
      for i = 1, #choice do
        for j = 1, #ItemList do
          --check to make sure it isn't a fake name (no sense in saving it)
          local value = choice[i].value
          if ItemList[j].value == value and type(value) == "string" then
            local name = Concat("Sponsor",value)
            if choice[1].check1 then
              ChoGGi.UserSettings[name] = nil
            else
              ChoGGi.UserSettings[name] = true
            end
            if ChoGGi.UserSettings[name] then
              ChoGGi.MenuFuncs.SetSponsorBonuses(value)
            end
          end
        end
      end
    end

    ChoGGi.SettingFuncs.WriteSettings()
    MsgPopup(
      ChoGGi.ComFuncs.SettingState(#choice,302535920001166--[[Bonuses--]]),
      302535920001162--[[Sponsor--]]
    )
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(S[302535920001162--[[Sponsor--]]]," ",S[302535920001166--[[Bonuses--]]]),
    hint = Concat(S[302535920000106--[[Current--]]],": ",T(Presets.MissionSponsorPreset.Default[g_CurrentMissionParams.idMissionSponsor].display_name),"\n\n",S[302535920001167--[[Use Ctrl/Shift for multiple selection.--]]],"\n\n",S[302535920001168--[[Modded ones are mostly ignored for now (just cargo space/research points).--]]]),
    multisel = true,
    check1 = 302535920001169--[[Turn Off--]],
    check1_hint = 302535920001170--[[Turn off selected bonuses (defaults to turning on).--]],
    check2 = 302535920001171--[[Turn All Off--]],
    check2_hint = 302535920001172--[[Turns off all bonuses.--]],
  }
end

function ChoGGi.MenuFuncs.ChangeCommander()
  local Presets = Presets
  local g_CurrentMissionParams = g_CurrentMissionParams
  local UICity = UICity

  local ItemList = {}
  local tab = Presets.CommanderProfilePreset.Default or ""
  for i = 1, #tab do
    if tab[i].id ~= "random" then
      ItemList[#ItemList+1] = {
        text = T(tab[i].display_name),
        value = tab[i].id,
        hint = T(tab[i].effect)
      }
    end
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    for i = 1, #ItemList do
      --check to make sure it isn't a fake name (no sense in saving it)
      if ItemList[i].value == value then
        --new comm
        g_CurrentMissionParams.idCommanderProfile = value

        -- apply tech from new commmander
        local commander = GetMissionSponsor()
        commander:game_apply(UICity)
        commander:OnApplyEffect(UICity)
        UICity:ApplyModificationsFromProperties()
        --and bonuses
        UICity:InitMissionBonuses()

        MsgPopup(
          S[302535920001173--[[Commander for this save is now %s.--]]]:format(choice[1].text),
          302535920001174--[[Commander--]],
          default_icon
        )
        break
      end
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920000716--[[Set Commander--]],
    hint = Concat(S[302535920000106--[[Current--]]],": ",T(Presets.CommanderProfilePreset.Default[g_CurrentMissionParams.idCommanderProfile].display_name)),
  }
end

--set just the bonus effects
function ChoGGi.MenuFuncs.SetCommanderBonus()
  local Presets = Presets

  local ItemList = {}
  local tab = Presets.CommanderProfilePreset.Default or ""
  for i = 1, #tab do
    if tab[i].id ~= "random" then
      ItemList[#ItemList+1] = {
        text = T(tab[i].display_name),
        value = tab[i].id,
        hint = Concat(T(tab[i].effect),"\n\n",S[302535920001165--[[Enabled Status--]]],": ",ChoGGi.UserSettings[Concat("Commander",tab[i].id)])
      }
    end
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end
    if choice[1].check2 then
      for i = 1, #ItemList do
        local value = ItemList[i].value
        if type(value) == "string" then
          value = Concat("Commander",value)
          ChoGGi.UserSettings[value] = nil
        end
      end
    else
      for i = 1, #choice do
        for j = 1, #ItemList do
          --check to make sure it isn't a fake name (no sense in saving it)
          local value = choice[i].value
          if ItemList[j].value == value and type(value) == "string" then
            local name = Concat("Commander",value)
            if choice[1].check1 then
              ChoGGi.UserSettings[name] = nil
            else
              ChoGGi.UserSettings[name] = true
            end
            if ChoGGi.UserSettings[name] then
              ChoGGi.MenuFuncs.SetCommanderBonuses(value)
            end
          end
        end
      end
    end

    ChoGGi.SettingFuncs.WriteSettings()
    MsgPopup(
      ChoGGi.ComFuncs.SettingState(#choice,302535920001166--[[Bonuses--]]),
      302535920001174--[[Commander--]]
    )
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(S[302535920001174--[[Commander--]]]," ",S[302535920001166--[[Bonuses--]]]),
    hint = Concat(S[302535920000106--[[Current--]]],": ",T(Presets.CommanderProfilePreset.Default[g_CurrentMissionParams.idCommanderProfile].display_name),"\n\n",S[302535920001167--[[Use Ctrl/Shift for multiple bonuses.--]]]),
    multisel = true,
    check1 = 302535920001169--[[Turn Off--]],
    check1_hint = 302535920001170--[[Turn off selected bonuses (defaults to turning on).--]],
    check2 = 302535920001171--[[Turn All Off--]],
    check2_hint = 302535920001172--[[Turns off all bonuses.--]],
  }
end

--pick a logo
function ChoGGi.MenuFuncs.ChangeGameLogo()
  local Presets = Presets

  local ItemList = {}
  local tab = Presets.MissionLogoPreset.Default or ""
  for i = 1, #tab do
    ItemList[#ItemList+1] = {
      text = T(tab[i].display_name),
      value = tab[i].id,
    }
  end

  local function CallBackFunc(choice)
    --any newly built/landed uses this logo
    local value = choice[1].value
    if not value then
      return
    end

    local function ChangeLogo(Label,Name)
      local tab = UICity.labels[Label] or ""
      for i = 1, #tab do
        local tab2 = tab[i]:GetAttaches("Logo") or ""
        for j = 1, #tab2 do
          --if tab2[j].class == "Logo" then
            local tempLogo = tab2[j]
            if tempLogo then
              tempLogo:ChangeEntity(Name)
            end
          --end
        end
      end
    end

    local tab = Presets.MissionLogoPreset.Default or ""
    for i = 1, #tab do
      if tab[i].id == value then
        --for any new objects
        g_CurrentMissionParams.idMissionLogo = value
        local entity_name = Presets.MissionLogoPreset.Default[value].entity_name
        --loop through landed rockets and change logo
        ChangeLogo("AllRockets",entity_name)
        --same for any buildings that use the logo
        ChangeLogo("Building",entity_name)

        MsgPopup(
          ChoGGi.ComFuncs.SettingState(choice[1].text,302535920001177--[[Logo--]]),
          302535920001177--[[Logo--]],
          default_icon
        )
      end
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920001178--[[Set New Logo--]],
    hint = Concat(S[302535920000106--[[Current--]]],": ",T(Presets.MissionLogoPreset.Default[g_CurrentMissionParams.idMissionLogo].display_name)),
  }
end

function ChoGGi.MenuFuncs.SetCommanderBonuses(sType)
  local currentname = g_CurrentMissionParams.idCommanderProfile
  local comm = MissionParams.idCommanderProfile.items[currentname]
  local bonus = Presets.CommanderProfilePreset.Default[sType]
  local tab = bonus or ""
  for i = 1, #tab do
    CreateRealTimeThread(function()
      comm[#comm+1] = tab[i]
    end)
  end
end

function ChoGGi.MenuFuncs.SetSponsorBonuses(sType)
  local ChoGGi = ChoGGi

  local currentname = g_CurrentMissionParams.idMissionSponsor
  local sponsor = MissionParams.idMissionSponsor.items[currentname]
  local bonus = Presets.MissionSponsorPreset.Default[sType]
  --bonuses multiple sponsors have (CompareAmounts returns equal or larger amount)
  if sponsor.cargo then
    sponsor.cargo = ChoGGi.ComFuncs.CompareAmounts(sponsor.cargo,bonus.cargo)
  end
  if sponsor.additional_research_points then
    sponsor.additional_research_points = ChoGGi.ComFuncs.CompareAmounts(sponsor.additional_research_points,bonus.additional_research_points)
  end

  if sType == "IMM" then
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","FoodPerRocketPassenger",
      "Amount",9000
    })
  elseif sType == "NASA" then
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","SponsorFundingPerInterval",
      "Amount",500
    })
  elseif sType == "BlueSun" then
    sponsor.rocket_price = ChoGGi.ComFuncs.CompareAmounts(sponsor.rocket_price,bonus.rocket_price)
    sponsor.applicants_price = ChoGGi.ComFuncs.CompareAmounts(sponsor.applicants_price,bonus.applicants_price)
    sponsor[#sponsor+1] = PlaceObj("TechEffect_GrantTech",{
      "Field","Physics",
      "Research","DeepMetalExtraction"
    })
  elseif sType == "CNSA" then
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","ApplicantGenerationInterval",
      "Percent",-50
    })
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","MaxColonistsPerRocket",
      "Amount",10
    })
  elseif sType == "ISRO" then
    sponsor[#sponsor+1] = PlaceObj("TechEffect_GrantTech",{
      "Field","Engineering",
      "Research","LowGEngineering"
    })
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","Concrete_cost_modifier",
      "Percent",-20
    })
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","Electronics_cost_modifier",
      "Percent",-20
    })
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","MachineParts_cost_modifier",
      "Percent",-20
    })
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","ApplicantsPoolStartingSize",
      "Percent",50
    })
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","Metals_cost_modifier",
      "Percent",-20
    })
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","Polymers_cost_modifier",
      "Percent",-20
    })
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","PreciousMetals_cost_modifier",
      "Percent",-20
    })
  elseif sType == "ESA" then
    sponsor.funding_per_tech = ChoGGi.ComFuncs.CompareAmounts(sponsor.funding_per_tech,bonus.funding_per_tech)
    sponsor.funding_per_breakthrough = ChoGGi.ComFuncs.CompareAmounts(sponsor.funding_per_breakthrough,bonus.funding_per_breakthrough)
  elseif sType == "SpaceY" then
    sponsor.modifier_name1 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_name1,bonus.modifier_name1)
    sponsor.modifier_value1 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_value1,bonus.modifier_value1)
    sponsor.modifier_name2 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_name2,bonus.bonusmodifier_name2)
    sponsor.modifier_value2 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_value2,bonus.modifier_value2)
    sponsor.modifier_name3 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_name3,bonus.modifier_name3)
    sponsor.modifier_value3 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_value3,bonus.modifier_value3)
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","CommandCenterMaxDrones",
      "Percent",20
    })
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","starting_drones",
      "Percent",4
    })
  elseif sType == "NewArk" then
    sponsor[#sponsor+1] = PlaceObj("TechEffect_ModifyLabel",{
      "Label","Consts",
      "Prop","BirthThreshold",
      "Percent",-50
    })
  elseif sType == "Roscosmos" then
    sponsor.modifier_name1 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_name1,bonus.modifier_name1)
    sponsor.modifier_value1 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_value1,bonus.modifier_value1)
    sponsor[#sponsor+1] = PlaceObj("TechEffect_GrantTech",{
      "Field","Robotics",
      "Research","FueledExtractors"
    })
  elseif sType == "Paradox" then
    sponsor.applicants_per_breakthrough = ChoGGi.ComFuncs.CompareAmounts(sponsor.applicants_per_breakthrough,bonus.applicants_per_breakthrough)
    sponsor.anomaly_bonus_breakthrough = ChoGGi.ComFuncs.CompareAmounts(sponsor.anomaly_bonus_breakthrough,bonus.anomaly_bonus_breakthrough)
  end
end

function ChoGGi.MenuFuncs.SetDisasterOccurrence(sType)
  local mapdata = mapdata

  local ItemList = {{
    text = Concat(" ",S[302535920000036--[[Disabled--]]]),
    value = "disabled"
  }}
  local data = DataInstances[Concat("MapSettings_",sType)]

  for i = 1, #data do
    ItemList[#ItemList+1] = {
      text = data[i].name,
      value = data[i].name
    }
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end

    mapdata[Concat("MapSettings_",sType)] = value
    if sType == "Meteor" then
      RestartGlobalGameTimeThread("Meteors")
      RestartGlobalGameTimeThread("MeteorStorm")
    else
      RestartGlobalGameTimeThread(sType)
    end

    MsgPopup(
      S[302535920001179--[[%s occurrence is now: %s--]]]:format(sType,value),
      3983--[[Disasters--]],
      "UI/Icons/Sections/attention.tga"
    )
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(S[302535920000129--[[Set--]]]," ",sType," ",S[302535920001180--[[Disaster Occurrences--]]]),
    hint = Concat(S[302535920000106--[[Current--]]],": ",mapdata[Concat("MapSettings_",sType)]),
  }
end

function ChoGGi.MenuFuncs.ChangeRules()
  local Presets = Presets
  local GameRulesMap = GameRulesMap
  local g_CurrentMissionParams = g_CurrentMissionParams

  local ItemList = {}
  local defs = Presets.GameRules.Default
  for i = 1, #defs do
    local def = defs[i]
    if def.id ~= "random" then
      ItemList[#ItemList+1] = {
        text = T(def.display_name),
        value = def.id,
        hint = Concat(T(def.description),"\n",T(def.flavor))
      }
    end
  end

  local function CallBackFunc(choice)
    local value = choice[1].value
    if not value then
      return
    end

    local check1 = choice[1].check1
    local check2 = choice[1].check2
    if not check1 and not check2 then
      MsgPopup(
        302535920000038--[[Pick a checkbox next time...--]],
        302535920001181--[[Rules--]],
        default_icon
      )
      return
    elseif check1 and check2 then
      MsgPopup(
        302535920000039--[[Don't pick both checkboxes next time...--]],
        302535920001181--[[Rules--]],
        default_icon
      )
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
    for i = 1, #rules do
      local rule = rules[i]
      GameRulesMap[rule]:OnInitEffect(UICity)
      GameRulesMap[rule]:OnApplyEffect(UICity)
    end
    MsgPopup(
      ChoGGi.ComFuncs.SettingState(#choice,302535920000129--[[Set--]]),
      302535920001181--[[Rules--]],
      default_icon
    )
  end

  local hint = {}
  local rules = g_CurrentMissionParams.idGameRules
  if type(rules) == "table" and next(rules) then
    hint[#hint+1] = S[302535920000106--[[Current--]]]
    hint[#hint+1] = ":"
    for Key,_ in pairs(rules) do
      hint[#hint+1] = " "
      hint[#hint+1] = T(Presets.GameRules.Default[Key].display_name)
    end
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920001182--[[Set Game Rules--]],
    hint = ChoGGi.ComFuncs.TableConcat(hint),
    multisel = true,
    check1 = 302535920001183--[[Add--]],
    check1_hint = 302535920001185--[[Add selected rules--]],
    check2 = 302535920000281--[[Remove--]],
    check2_hint = 302535920001186--[[Remove selected rules--]],
  }
end
