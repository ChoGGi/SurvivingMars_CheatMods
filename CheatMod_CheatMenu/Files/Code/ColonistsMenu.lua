local CMenuFuncs = ChoGGi.MenuFuncs
local CCodeFuncs = ChoGGi.CodeFuncs
local CComFuncs = ChoGGi.ComFuncs
local CConsts = ChoGGi.Consts
local CInfoFuncs = ChoGGi.InfoFuncs
local CSettingFuncs = ChoGGi.SettingFuncs
local CTables = ChoGGi.Tables

function ChoGGi.MsgFuncs.ColonistsMenu_LoadingScreenPreClose()
  --CComFuncs.AddAction(Menu,Action,Key,Des,Icon)
  local icon = "AlignSel.tga"

  CComFuncs.AddAction(
    "Expanded CM/Colonists/The Soylent Option",
    CMenuFuncs.TheSoylentOption,
    "Ctrl-Numpad 1",
    "Turns selected/moused over colonist into food (between 1-5), or shows a list with homeless/unemployed.",
    "Cube.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Colonists/Colonists Move Speed",
    CMenuFuncs.SetColonistMoveSpeed,
    nil,
    "How fast colonists will move.",
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Colonists/Add Applicants",
    CMenuFuncs.AddApplicantsToPool,
    nil,
    "Add random applicants to the passenger pool.",
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Colonists/Colonists Gravity",
    CMenuFuncs.SetGravityColonists,
    nil,
    "Change gravity of Colonists.",
    icon
  )

-------------------------------work
  CComFuncs.AddAction(
    "Expanded CM/Colonists/[3]Work/Fire All Colonists!",
    CMenuFuncs.FireAllColonists,
    nil,
    "Fires everyone from every job.",
    "ToggleEnvMap.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Colonists/[3]Work/Set All Work Shifts",
    CMenuFuncs.SetAllWorkShifts,
    nil,
    "Set all shifts on or off (able to cancel).",
    "ToggleEnvMap.tga"
  )

-------------------------------stats
  CComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/Min Comfort Birth",
    CMenuFuncs.SetMinComfortBirth,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.MinComfortBirth,"(Disabled)","(Enabled)")
      return des .. " Change the limit on birthing comfort (more/less babies)."
    end,
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/Visit Fail Penalty",
    CMenuFuncs.VisitFailPenalty_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.VisitFailPenalty,"(Disabled)","(Enabled)")
      return des .. " Disable comfort penalty when failing to satisfy a need via a visit."
    end,
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/Renegade Creation Toggle",
    CMenuFuncs.RenegadeCreation_Toggle,
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

  CComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/Set Renegade Status",
    CMenuFuncs.SetRenegadeStatus,
    nil,
    "I'm afraid it could be 9/11 times 1,000.",
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/Morale Always Max",
    CMenuFuncs.ColonistsMoraleAlwaysMax_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.HighStatLevel,"(Disabled)","(Enabled)")
      return des .. " Colonists always max morale (will effect birthing rates).\nOnly works on colonists that have yet to spawn (maybe)."
    end,
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/See Dead Sanity Damage",
    CMenuFuncs.SeeDeadSanityDamage_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.SeeDeadSanity,"(Disabled)","(Enabled)")
      return des .. " Disable colonists taking sanity damage from seeing dead.\nWorks after in-game hour."
    end,
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/No Home Comfort Damage",
    CMenuFuncs.NoHomeComfortDamage_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.NoHomeComfort,"(Disabled)","(Enabled)")
      return des .. " Disable colonists taking comfort damage from not having a home.\nWorks after in-game hour."
    end,
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/Chance Of Sanity Damage",
    CMenuFuncs.ChanceOfSanityDamage_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.DustStormSanityDamage,"(Disabled)","(Enabled)")
      return des .. " Disable colonists taking sanity damage from certain events.\nWorks after in-game hour."
    end,
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Colonists/[2]Traits/Chance Of Negative Trait",
    CMenuFuncs.ChanceOfNegativeTrait_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.LowSanityNegativeTraitChance,"(Disabled)","(Enabled)")
      return des .. " Disable chance of getting a negative trait when Sanity reaches zero.\nWorks after colonist idle."
    end,
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Colonists/[1]Stats/Chance Of Suicide",
    CMenuFuncs.ColonistsChanceOfSuicide_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.LowSanitySuicideChance,"(Disabled)","(Enabled)")
      return des .. " Disable chance of suicide when Sanity reaches zero.\nWorks after colonist idle."
    end,
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Colonists/Colonists Suffocate",
    CMenuFuncs.ColonistsSuffocate_Toggle,
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

  CComFuncs.AddAction(
    "Expanded CM/Colonists/Colonists Starve",
    CMenuFuncs.ColonistsStarve_Toggle,
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

  CComFuncs.AddAction(
    "Expanded CM/Colonists/[3]Work/Colonists Avoid Fired Workplace",
    CMenuFuncs.AvoidWorkplace_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.AvoidWorkplaceSols,"(Disabled)","(Enabled)")
      return des .. " After being fired, Colonists won't avoid that Workplace searching for a Workplace.\nWorks after colonist idle."
    end,
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Colonists/[2]Traits/Positive Playground",
    CMenuFuncs.PositivePlayground_Toggle,
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

  CComFuncs.AddAction(
    "Expanded CM/Colonists/[2]Traits/Project Morpheus Positive Trait",
    CMenuFuncs.ProjectMorpheusPositiveTrait_Toggle,
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

  CComFuncs.AddAction(
    "Expanded CM/Colonists/[3]Work/Performance Penalty Non-Specialist",
    CMenuFuncs.PerformancePenaltyNonSpecialist_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.NonSpecialistPerformancePenalty,"(Disabled)","(Enabled)")
      return des .. " Disable performance penalty for non-Specialists.\nActivated when colonist changes job."
    end,
    icon
  )

  local function OutsideWorkplaceRadiusText()
    local des = Consts.DefaultOutsideWorkplacesRadius
    return "Change how many hexes colonists search outside their dome when looking for a Workplace.\nCurrent: " .. des
  end
  CComFuncs.AddAction(
    "Expanded CM/Colonists/[3]Work/Outside Workplace Radius",
    CMenuFuncs.SetOutsideWorkplaceRadius,
    nil,
    OutsideWorkplaceRadiusText(),
    icon
  )
  -------------------
  CComFuncs.AddAction(
    "Expanded CM/Colonists/Set Age New",
    function()
      CMenuFuncs.SetColonistsAge(1)
    end,
    nil,
    "This will make all newly arrived and born colonists a certain age.",
    icon
  )
  CComFuncs.AddAction(
    "Expanded CM/Colonists/Set Age",
    function()
      CMenuFuncs.SetColonistsAge(2)
    end,
    nil,
    "This will make all colonists a certain age.",
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Colonists/Set Gender New",
    function()
      CMenuFuncs.SetColonistsGender(1)
    end,
    nil,
    "This will make all newly arrived and born colonists a certain gender.",
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Colonists/Set Gender",
    function()
      CMenuFuncs.SetColonistsGender(2)
    end,
    nil,
    "This will make all colonists a certain gender.",
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Colonists/Set Specialization New",
    function()
      CMenuFuncs.SetColonistsSpecialization(1)
    end,
    nil,
    "This will make all newly arrived and born colonists a certain specialization.",
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Colonists/Set Specialization",
    function()
      CMenuFuncs.SetColonistsSpecialization(2)
    end,
    nil,
    "This will make all colonists a certain specialization.",
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Colonists/Set Race New",
    function()
      CMenuFuncs.SetColonistsRace(1)
    end,
    nil,
    "This will make all newly arrived and born colonists a certain race.",
    icon
  )
  CComFuncs.AddAction(
    "Expanded CM/Colonists/Set Race",
    function()
      CMenuFuncs.SetColonistsRace(2)
    end,
    nil,
    "This will make all colonists a certain race.",
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Colonists/Set Traits New",
    function()
      CMenuFuncs.SetColonistsTraits(1)
    end,
    nil,
    "This will make all newly arrived and born colonists have certain traits.",
    icon
  )
  CComFuncs.AddAction(
    "Expanded CM/Colonists/Set Traits",
    function()
      CMenuFuncs.SetColonistsTraits(2)
    end,
    nil,
    "Choose traits for all colonists.",
    icon
  )

  -------------------

  CComFuncs.AddAction(
    "Expanded CM/Colonists/Set Stats",
    CMenuFuncs.SetColonistsStats,
    nil,
    "Change the stats of all colonists (health/sanity/comfort/morale).\n\nNot permanent.",
    icon
  )

  CComFuncs.AddAction(
    "Expanded CM/Colonists/Colonists Death Age",
    CMenuFuncs.SetDeathAge,
    nil,
    "Change the age at which colonists die.",
    icon
  )
  --------------------
  CComFuncs.AddAction(
    "Expanded CM/Colonists/[3]Work/Add Specialization To All",
    CMenuFuncs.ColonistsAddSpecializationToAll,
    nil,
    "If Colonist has no Specialization then add a random one",
    icon
  )
end
