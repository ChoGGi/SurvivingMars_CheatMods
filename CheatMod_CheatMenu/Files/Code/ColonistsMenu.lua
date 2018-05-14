local cMenuFuncs = ChoGGi.MenuFuncs
local cCodeFuncs = ChoGGi.CodeFuncs
local cComFuncs = ChoGGi.ComFuncs
local cConsts = ChoGGi.Consts
local cInfoFuncs = ChoGGi.InfoFuncs
local cSettingFuncs = ChoGGi.SettingFuncs
local cTables = ChoGGi.Tables

function ChoGGi.MsgFuncs.ColonistsMenu_LoadingScreenPreClose()
  --cComFuncs.AddAction(Menu,Action,Key,Des,Icon)
  local icon = "AlignSel.tga"

  cComFuncs.AddAction(
    "Expanded CM/Colonists/The Soylent Option",
    cMenuFuncs.TheSoylentOption,
    "Ctrl-Numpad 1",
    "Turns selected/moused over colonist into food (between 1-5), or shows a list with homeless/unemployed.",
    "Cube.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/Colonists Move Speed",
    cMenuFuncs.SetColonistMoveSpeed,
    nil,
    "How fast colonists will move.",
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/Add Applicants",
    cMenuFuncs.AddApplicantsToPool,
    nil,
    "Add random applicants to the passenger pool.",
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/Colonists Gravity",
    cMenuFuncs.SetColonistsGravity,
    nil,
    "Change gravity of Colonists.",
    icon
  )

-------------------------------work
  cComFuncs.AddAction(
    "Expanded CM/Colonists/[3]Work/Fire All Colonists!",
    cMenuFuncs.FireAllColonists,
    nil,
    "Fires everyone from every job.",
    "ToggleEnvMap.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/[3]Work/Set All Work Shifts",
    cMenuFuncs.SetAllWorkShifts,
    nil,
    "Set all shifts on or off (able to cancel).",
    "ToggleEnvMap.tga"
  )

-------------------------------stats
  cComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/Min Comfort Birth",
    cMenuFuncs.SetMinComfortBirth,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.MinComfortBirth,"(Disabled)","(Enabled)")
      return des .. " Change the limit on birthing comfort (more/less babies)."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/Visit Fail Penalty",
    cMenuFuncs.VisitFailPenalty_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.VisitFailPenalty,"(Disabled)","(Enabled)")
      return des .. " Disable comfort penalty when failing to satisfy a need via a visit."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/Renegade Creation Toggle",
    cMenuFuncs.RenegadeCreation_Toggle,
    nil,
    function()
      local des = ""
      if Consts.RenegadeCreation == 9999900 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Disable creation of renegades.\nWorks after daily update."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/Set Renegade Status",
    cMenuFuncs.SetRenegadeStatus,
    nil,
    "I'm afraid it could be 9/11 times 1,000.",
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/Morale Always Max",
    cMenuFuncs.ColonistsMoraleAlwaysMax_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.HighStatLevel,"(Disabled)","(Enabled)")
      return des .. " Colonists always max morale (will effect birthing rates).\nOnly works on colonists that have yet to spawn (maybe)."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/See Dead Sanity Damage",
    cMenuFuncs.SeeDeadSanityDamage_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.SeeDeadSanity,"(Disabled)","(Enabled)")
      return des .. " Disable colonists taking sanity damage from seeing dead.\nWorks after in-game hour."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/No Home Comfort Damage",
    cMenuFuncs.NoHomeComfortDamage_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.NoHomeComfort,"(Disabled)","(Enabled)")
      return des .. " Disable colonists taking comfort damage from not having a home.\nWorks after in-game hour."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/Chance Of Sanity Damage",
    cMenuFuncs.ChanceOfSanityDamage_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.DustStormSanityDamage,"(Disabled)","(Enabled)")
      return des .. " Disable colonists taking sanity damage from certain events.\nWorks after in-game hour."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/[2]Traits/Chance Of Negative Trait",
    cMenuFuncs.ChanceOfNegativeTrait_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.LowSanityNegativeTraitChance,"(Disabled)","(Enabled)")
      return des .. " Disable chance of getting a negative trait when Sanity reaches zero.\nWorks after colonist idle."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/Chance Of Suicide",
    cMenuFuncs.ColonistsChanceOfSuicide_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.LowSanitySuicideChance,"(Disabled)","(Enabled)")
      return des .. " Disable chance of suicide when Sanity reaches zero.\nWorks after colonist idle."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/Colonists Suffocate",
    cMenuFuncs.ColonistsSuffocate_Toggle,
    nil,
    function()
      local des = ""
      if Consts.OxygenMaxOutsideTime == 99999900 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Disable colonists suffocating with no oxygen.\nWorks after in-game hour."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/Colonists Starve",
    cMenuFuncs.ColonistsStarve_Toggle,
    nil,
    function()
      local des = ""
      if Consts.TimeBeforeStarving == 99999900 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Disable colonists starving with no food.\nWorks after colonist idle."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/[3]Work/Colonists Avoid Fired Workplace",
    cMenuFuncs.AvoidWorkplace_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.AvoidWorkplaceSols,"(Disabled)","(Enabled)")
      return des .. " After being fired, Colonists won't avoid that Workplace searching for a Workplace.\nWorks after colonist idle."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/[2]Traits/Positive Playground",
    cMenuFuncs.PositivePlayground_Toggle,
    nil,
    function()
      local des = ""
      if Consts.positive_playground_chance == 101 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " 100% Chance to get a perk (when grown) if colonist has visited a playground as a child."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/[2]Traits/Project Morpheus Positive Trait",
    cMenuFuncs.ProjectMorpheusPositiveTrait_Toggle,
    nil,
    function()
      local des = ""
      if Consts.ProjectMorphiousPositiveTraitChance == 100 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " 100% Chance to get positive trait when Resting and ProjectMorpheus is active."
    end,
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/[3]Work/Performance Penalty Non-Specialist",
    cMenuFuncs.PerformancePenaltyNonSpecialist_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.NonSpecialistPerformancePenalty,"(Disabled)","(Enabled)")
      return des .. " Disable performance penalty for non-Specialists.\nActivated when colonist changes job."
    end,
    icon
  )

  local function OutsideWorkplaceRadiusText()
    local des = Consts.DefaultOutsideWorkplacesRadius
    return "Change how many hexes colonists search outside their dome when looking for a Workplace.\nCurrent: " .. des
  end
  cComFuncs.AddAction(
    "Expanded CM/Colonists/[3]Work/Outside Workplace Radius",
    cMenuFuncs.SetOutsideWorkplaceRadius,
    nil,
    OutsideWorkplaceRadiusText(),
    icon
  )
  -------------------
  cComFuncs.AddAction(
    "Expanded CM/Colonists/Set Age New",
    function()
      cMenuFuncs.SetColonistsAge(1)
    end,
    nil,
    "This will make all newly arrived and born colonists a certain age.",
    icon
  )
  cComFuncs.AddAction(
    "Expanded CM/Colonists/Set Age",
    function()
      cMenuFuncs.SetColonistsAge(2)
    end,
    nil,
    "This will make all colonists a certain age.",
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/Set Gender New",
    function()
      cMenuFuncs.SetColonistsGender(1)
    end,
    nil,
    "This will make all newly arrived and born colonists a certain gender.",
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/Set Gender",
    function()
      cMenuFuncs.SetColonistsGender(2)
    end,
    nil,
    "This will make all colonists a certain gender.",
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/Set Specialization New",
    function()
      cMenuFuncs.SetColonistsSpecialization(1)
    end,
    nil,
    "This will make all newly arrived and born colonists a certain specialization.",
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/Set Specialization",
    function()
      cMenuFuncs.SetColonistsSpecialization(2)
    end,
    nil,
    "This will make all colonists a certain specialization.",
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/Set Race New",
    function()
      cMenuFuncs.SetColonistsRace(1)
    end,
    nil,
    "This will make all newly arrived and born colonists a certain race.",
    icon
  )
  cComFuncs.AddAction(
    "Expanded CM/Colonists/Set Race",
    function()
      cMenuFuncs.SetColonistsRace(2)
    end,
    nil,
    "This will make all colonists a certain race.",
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/Set Traits New",
    function()
      cMenuFuncs.SetColonistsTraits(1)
    end,
    nil,
    "This will make all newly arrived and born colonists have certain traits.",
    icon
  )
  cComFuncs.AddAction(
    "Expanded CM/Colonists/Set Traits",
    function()
      cMenuFuncs.SetColonistsTraits(2)
    end,
    nil,
    "Choose traits for all colonists.",
    icon
  )

  -------------------

  cComFuncs.AddAction(
    "Expanded CM/Colonists/Set Stats",
    cMenuFuncs.SetColonistsStats,
    nil,
    "Change the stats of all colonists (health/sanity/comfort/morale).\n\nNot permanent.",
    icon
  )

  cComFuncs.AddAction(
    "Expanded CM/Colonists/Colonists Death Age",
    cMenuFuncs.SetDeathAge,
    nil,
    "Change the age at which colonists die.",
    icon
  )
  --------------------
  cComFuncs.AddAction(
    "Expanded CM/Colonists/[3]Work/Add Specialization To All",
    cMenuFuncs.ColonistsAddSpecializationToAll,
    nil,
    "If Colonist has no Specialization then add a random one",
    icon
  )
end
