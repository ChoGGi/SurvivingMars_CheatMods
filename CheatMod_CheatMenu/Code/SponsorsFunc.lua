--ex(DataInstances.MissionSponsor[g_CurrentMissionParams.idMissionSponsor])
--ex(DataInstances.MissionSponsor)

function ChoGGi.SponsorsFunc_ModsLoaded()
  --create Sponsor menus (called later, so we get ones from mods)
  for _,Value in ipairs(DataInstances.MissionSponsor or empty_table) do
    if Value.name ~= "random" then
      ChoGGi.AddAction(
        "Gameplay/Sponsors/" .. _InternalTranslate(Value.display_name),
        function()
          ChoGGi.SetNewSponsor(Value.name,_InternalTranslate(Value.display_name))
        end,
        nil,
        _InternalTranslate(Value.effect),
        "SelectByClassName.tga"
      )
    end
  end
  --create Commander menus
  for _,Value in ipairs(DataInstances.CommanderProfile or empty_table) do
    if Value.name ~= "random" then
      ChoGGi.AddAction(
        "Gameplay/Commanders/" .. _InternalTranslate(Value.display_name),
        function()
          ChoGGi.SetNewCommander(Value.name,_InternalTranslate(Value.display_name))
        end,
        nil,
        _InternalTranslate(Value.effect),
        "SetCamPos&Loockat.tga"
      )
    end
  end
end

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
