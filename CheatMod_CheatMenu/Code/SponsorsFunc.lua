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
  local ListActual = {}
  for _,Value in ipairs(DataInstances.MissionSponsor) do
    if Value.name ~= "random" then
      table.insert(ListActual,Value.name)
    end
  end

  table.sort(ListActual)
  local ListDisplay = {}
  local hint = ""
  for i = 1, #ListActual do
    local Value = DataInstances.MissionSponsor[ListActual[i]]
    table.insert(ListDisplay,_InternalTranslate(Value.display_name))
    hint = hint .. _InternalTranslate(Value.display_name) .. ": " .. _InternalTranslate(Value.effect) .. "\n\n\n\n"
  end

  local TempFunc = function(choice)
    if choice then
      ChoGGi.SetNewSponsor(ListActual[choice],ListDisplay[choice])
    end
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set New Sponsor",1,hint,true,false)

end

function ChoGGi.ChangeCommander()
  local ListActual = {}
  for _,Value in ipairs(DataInstances.CommanderProfile) do
    if Value.name ~= "random" then
      table.insert(ListActual,Value.name)
    end
  end

  table.sort(ListActual)
  local ListDisplay = {}
  local hint = ""
  for i = 1, #ListActual do
    local Value = DataInstances.CommanderProfile[ListActual[i]]
    table.insert(ListDisplay,_InternalTranslate(Value.display_name))
    hint = hint .. _InternalTranslate(Value.display_name) .. ": " .. _InternalTranslate(Value.effect) .. "\n\n\n\n"
  end

  local TempFunc = function(choice)
    if choice then
      ChoGGi.SetNewCommander(ListActual[choice],ListDisplay[choice])
    end
  end
  ChoGGi.FireFuncAfterChoice(TempFunc,ListDisplay,"Set New Commander",1,hint,true,false)
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
