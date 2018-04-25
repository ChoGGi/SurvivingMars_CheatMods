function ChoGGi.SponsorsFunc_LoadingScreenPreClose()
  --Commander bonuses
  if ChoGGi.CheatMenuSettings.CommanderInventor then
    ChoGGi.SetCommanderBonuses("Inventor")
  end
  if ChoGGi.CheatMenuSettings.CommanderOligarch then
    ChoGGi.SetCommanderBonuses("Oligarch")
  end
  if ChoGGi.CheatMenuSettings.CommanderHydroEngineer then
    ChoGGi.SetCommanderBonuses("HydroEngineer")
  end
  if ChoGGi.CheatMenuSettings.CommanderDoctor then
    ChoGGi.SetCommanderBonuses("Doctor")
  end
  if ChoGGi.CheatMenuSettings.CommanderPolitician then
    ChoGGi.SetCommanderBonuses("Politician")
  end
  if ChoGGi.CheatMenuSettings.CommanderAuthor then
    ChoGGi.SetCommanderBonuses("Author")
  end
  if ChoGGi.CheatMenuSettings.CommanderEcologist then
    ChoGGi.SetCommanderBonuses("Ecologist")
  end
  if ChoGGi.CheatMenuSettings.CommanderAstrogeologist then
    ChoGGi.SetCommanderBonuses("Astrogeologist")
  end
  --Sponsor bonuses
  if ChoGGi.CheatMenuSettings.SponsorIMM then
    ChoGGi.SetSponsorBonuses("IMM")
  end
  if ChoGGi.CheatMenuSettings.SponsorNASA then
    ChoGGi.SetSponsorBonuses("NASA")
  end
  if ChoGGi.CheatMenuSettings.SponsorBlueSun then
    ChoGGi.SetSponsorBonuses("BlueSun")
  end
  if ChoGGi.CheatMenuSettings.SponsorCNSA then
    ChoGGi.SetSponsorBonuses("CNSA")
  end
  if ChoGGi.CheatMenuSettings.SponsorISRO then
    ChoGGi.SetSponsorBonuses("ISRO")
  end
  if ChoGGi.CheatMenuSettings.SponsorESA then
    ChoGGi.SetSponsorBonuses("ESA")
  end
  if ChoGGi.CheatMenuSettings.SponsorSpaceY then
    ChoGGi.SetSponsorBonuses("SpaceY")
  end
  if ChoGGi.CheatMenuSettings.SponsorNewArk then
    ChoGGi.SetSponsorBonuses("NewArk")
  end
  if ChoGGi.CheatMenuSettings.SponsorRoscosmos then
    ChoGGi.SetSponsorBonuses("Roscosmos")
  end
  if ChoGGi.CheatMenuSettings.SponsorParadox then
    ChoGGi.SetSponsorBonuses("Paradox")
  end
end

function ChoGGi.ChangeSponsor()
  local ItemList = {}
  for _,Value in ipairs(DataInstances.MissionSponsor) do
    if Value.name ~= "random" then
      table.insert(ItemList,{
        text = _InternalTranslate(Value.display_name),
        value = Value.name,
        hint = _InternalTranslate(Value.effect)
      })
    end
  end

  local CallBackFunc = function(choice)
    ChoGGi.SetNewSponsor(choice[1].value,choice[1].text)
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set New Sponsor","Select item for tooltip info.")
end

function ChoGGi.ChangeCommander()
  local ItemList = {}
  for _,Value in ipairs(DataInstances.CommanderProfile) do
    if Value.name ~= "random" then
      table.insert(ItemList,{
        text = _InternalTranslate(Value.display_name),
        value = Value.name,
        hint = _InternalTranslate(Value.effect)
      })
    end
  end

  local CallBackFunc = function(choice)
    ChoGGi.SetNewCommander(choice[1].value,choice[1].text)
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set New Commander","Select item for tooltip info.")
end

function ChoGGi.SetNewSponsor(sName,sDisplay)
  g_CurrentMissionParams.idMissionSponsor = sName

  -- apply tech from new sponsor
  UICity:ApplyModificationsFromProperties()
  --and bonuses
  UICity:InitMissionBonuses()

  ChoGGi.MsgPopup("Sponsor is now " .. sDisplay,
    "Sponsor","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.SetNewCommander(sName,sDisplay)
  g_CurrentMissionParams.idCommanderProfile = sName

  -- apply tech from new commmander
  UICity:ApplyModificationsFromProperties()
  --and bonuses
  UICity:InitMissionBonuses()

  ChoGGi.MsgPopup("Commander is now " .. sDisplay,
    "Commander","UI/Icons/Sections/spaceship.tga"
  )
end

--set just the bonus effects
function ChoGGi.SetCommanderBonus(sType)
  ChoGGi.CheatMenuSettings["Commander" .. sType] = not ChoGGi.CheatMenuSettings["Commander" .. sType]
  if ChoGGi.CheatMenuSettings["Commander" .. sType] then
    ChoGGi.SetCommanderBonuses(sType)
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(sType .. " bonuses: " .. tostring(ChoGGi.CheatMenuSettings["Commander" .. sType]),
    "Commander","UI/Icons/Sections/spaceship.tga"
  )
end
function ChoGGi.SetSponsorBonus(sType)
  ChoGGi.CheatMenuSettings["Sponsor" .. sType] = not ChoGGi.CheatMenuSettings["Sponsor" .. sType]
  if ChoGGi.CheatMenuSettings["Sponsor" .. sType] then
    ChoGGi.SetSponsorBonuses(sType)
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(sType .. " bonuses: " .. tostring(ChoGGi.CheatMenuSettings["Sponsor" .. sType]),
    "Sponsor","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.ChangeGameLogo()
  local ItemList = {}
  for _,Value in ipairs(DataInstances.MissionLogo) do
    if Value.name ~= "random" then
      table.insert(ItemList,{
        text = _InternalTranslate(Value.display_name),
        value = Value.name,
      })
    end
  end

  local CallBackFunc = function(choice)
    ChoGGi.SetNewLogo(choice[1].value,choice[1].text)
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set New Logo")
end

function ChoGGi.SetNewLogo(sName,sDisplay)
  --any newly built/landed uses this logo
  g_CurrentMissionParams.idMissionLogo = sName

  --loop through landed rockets and change logo
  for _,object in ipairs(UICity.labels.AllRockets or empty_table) do
    local tempLogo = object:GetAttach("Logo")
    if tempLogo then
      tempLogo:ChangeEntity(
        DataInstances.MissionLogo[g_CurrentMissionParams.idMissionLogo].entity_name
      )
    end
  end
  --same for any buildings that use the logo
  for _,object in ipairs(UICity.labels.Building or empty_table) do
    local tempLogo = object:GetAttach("Logo")
    if tempLogo then
      tempLogo:ChangeEntity(
        DataInstances.MissionLogo[g_CurrentMissionParams.idMissionLogo].entity_name
      )
    end
  end

  ChoGGi.MsgPopup("Logo: " .. sDisplay,
    "Logo","UI/Icons/Sections/spaceship.tga"
  )
end

