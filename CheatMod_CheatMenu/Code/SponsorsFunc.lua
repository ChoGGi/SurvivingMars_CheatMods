--ex(DataInstances.MissionSponsor[g_CurrentMissionParams.idMissionSponsor])
--ex(DataInstances.MissionSponsor)

function ChoGGi.SetCommanderInventor()
  ChoGGi.CheatMenuSettings.CommanderInventor = not ChoGGi.CheatMenuSettings.CommanderInventor
  if ChoGGi.CheatMenuSettings.CommanderInventor then
    ChoGGi.CommanderInventor_Enable()
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Inventor bonuses: " .. tostring(ChoGGi.CheatMenuSettings.CommanderInventor),
    "Commander","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.SetCommanderOligarch()
  ChoGGi.CheatMenuSettings.CommanderOligarch = not ChoGGi.CheatMenuSettings.CommanderOligarch
  if ChoGGi.CheatMenuSettings.CommanderOligarch then
    ChoGGi.CommanderOligarch_Enable()
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Oligarch bonuses: " .. tostring(ChoGGi.CheatMenuSettings.CommanderOligarch),
    "Commander","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.SetCommanderHydroEngineer()
  ChoGGi.CheatMenuSettings.CommanderHydroEngineer = not ChoGGi.CheatMenuSettings.CommanderHydroEngineer
  if ChoGGi.CheatMenuSettings.CommanderHydroEngineer then
    ChoGGi.CommanderHydroEngineer_Enable()
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("HydroEngineer bonuses: " .. tostring(ChoGGi.CheatMenuSettings.CommanderHydroEngineer),
    "Commander","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.SetCommanderDoctor()
  ChoGGi.CheatMenuSettings.CommanderDoctor = not ChoGGi.CheatMenuSettings.CommanderDoctor
  if ChoGGi.CheatMenuSettings.CommanderDoctor then
    ChoGGi.CommanderDoctor_Enable()
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Doctor bonuses: " .. tostring(ChoGGi.CheatMenuSettings.CommanderDoctor),
    "Commander","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.SetCommanderPolitician()
  ChoGGi.CheatMenuSettings.CommanderPolitician = not ChoGGi.CheatMenuSettings.CommanderPolitician
  if ChoGGi.CheatMenuSettings.CommanderPolitician then
    ChoGGi.CommanderPolitician_Enable()
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Politician bonuses: " .. tostring(ChoGGi.CheatMenuSettings.CommanderPolitician),
    "Commander","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.SetCommanderAuthor()
  ChoGGi.CheatMenuSettings.CommanderAuthor = not ChoGGi.CheatMenuSettings.CommanderAuthor
  if ChoGGi.CheatMenuSettings.CommanderAuthor then
    ChoGGi.CommanderAuthor_Enable()
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Author bonuses: " .. tostring(ChoGGi.CheatMenuSettings.CommanderAuthor),
    "Commander","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.SetCommanderEcologist()
  ChoGGi.CheatMenuSettings.CommanderEcologist = not ChoGGi.CheatMenuSettings.CommanderEcologist
  if ChoGGi.CheatMenuSettings.CommanderEcologist then
    ChoGGi.CommanderEcologist_Enable()
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Ecologist bonuses: " .. tostring(ChoGGi.CheatMenuSettings.CommanderEcologist),
    "Commander","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.SetCommanderAstrogeologist()
  ChoGGi.CheatMenuSettings.CommanderAstrogeologist = not ChoGGi.CheatMenuSettings.CommanderAstrogeologist
  if ChoGGi.CheatMenuSettings.CommanderAstrogeologist then
    ChoGGi.CommanderAstrogeologist_Enable()
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Astrogeologist bonuses: " .. tostring(ChoGGi.CheatMenuSettings.CommanderAstrogeologist),
    "Commander","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.SetSponsorIMM()
  ChoGGi.CheatMenuSettings.SponsorIMM = not ChoGGi.CheatMenuSettings.SponsorIMM
  if ChoGGi.CheatMenuSettings.SponsorIMM then
    ChoGGi.SponsorIMM_Enable()
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("IMM bonuses: " .. tostring(ChoGGi.CheatMenuSettings.SponsorIMM),
    "Sponsor","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.SetSponsorNASA()
  ChoGGi.CheatMenuSettings.SponsorNASA = not ChoGGi.CheatMenuSettings.SponsorNASA
  if ChoGGi.CheatMenuSettings.SponsorNASA then
    ChoGGi.SponsorNASA_Enable()
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("NASA bonuses: " .. tostring(ChoGGi.CheatMenuSettings.SponsorNASA),
    "Sponsor","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.SetSponsorBlueSun()
  ChoGGi.CheatMenuSettings.SponsorBlueSun = not ChoGGi.CheatMenuSettings.SponsorBlueSun
  if ChoGGi.CheatMenuSettings.SponsorBlueSun then
    ChoGGi.SponsorBlueSun_Enable()
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("BlueSun bonuses: " .. tostring(ChoGGi.CheatMenuSettings.SponsorBlueSun),
    "Sponsor","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.SetSponsorCNSA()
  ChoGGi.CheatMenuSettings.SponsorCNSA = not ChoGGi.CheatMenuSettings.SponsorCNSA
  if ChoGGi.CheatMenuSettings.SponsorCNSA then
    ChoGGi.SponsorCNSA_Enable()
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("CNSA bonuses: " .. tostring(ChoGGi.CheatMenuSettings.SponsorCNSA),
    "Sponsor","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.SetSponsorISRO()
  ChoGGi.CheatMenuSettings.SponsorISRO = not ChoGGi.CheatMenuSettings.SponsorISRO
  if ChoGGi.CheatMenuSettings.SponsorISRO then
    ChoGGi.SponsorISRO_Enable()
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("ISRO bonuses: " .. tostring(ChoGGi.CheatMenuSettings.SponsorISRO),
    "Sponsor","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.SetSponsorESA()
  ChoGGi.CheatMenuSettings.SponsorESA = not ChoGGi.CheatMenuSettings.SponsorESA
  if ChoGGi.CheatMenuSettings.SponsorESA then
    ChoGGi.SponsorESA_Enable()
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("ESA bonuses: " .. tostring(ChoGGi.CheatMenuSettings.SponsorESA),
    "Sponsor","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.SetSponsorSpaceY()
  ChoGGi.CheatMenuSettings.SponsorSpaceY = not ChoGGi.CheatMenuSettings.SponsorSpaceY
  if ChoGGi.CheatMenuSettings.SponsorSpaceY then
    ChoGGi.SponsorSpaceY_Enable()
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("SpaceY bonuses: " .. tostring(ChoGGi.CheatMenuSettings.SponsorSpaceY),
    "Sponsor","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.SetSponsorNewArk()
  ChoGGi.CheatMenuSettings.SponsorNewArk = not ChoGGi.CheatMenuSettings.SponsorNewArk
  if ChoGGi.CheatMenuSettings.SponsorNewArk then
    ChoGGi.SponsorNewArk_Enable()
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("NewArk bonuses: " .. tostring(ChoGGi.CheatMenuSettings.SponsorNewArk),
    "Sponsor","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.SetSponsorRoscosmos()
  ChoGGi.CheatMenuSettings.SponsorRoscosmos = not ChoGGi.CheatMenuSettings.SponsorRoscosmos
  if ChoGGi.CheatMenuSettings.SponsorRoscosmos then
    ChoGGi.SponsorRoscosmos_Enable()
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Russia bonuses: " .. tostring(ChoGGi.CheatMenuSettings.SponsorRoscosmos),
    "Sponsor","UI/Icons/Sections/spaceship.tga"
  )
end

function ChoGGi.SetSponsorParadox()
  ChoGGi.CheatMenuSettings.SponsorParadox = not ChoGGi.CheatMenuSettings.SponsorParadox
  if ChoGGi.CheatMenuSettings.SponsorParadox then
    ChoGGi.SponsorParadox_Enable()
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Paradox bonuses: " .. tostring(ChoGGi.CheatMenuSettings.SponsorParadox),
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
