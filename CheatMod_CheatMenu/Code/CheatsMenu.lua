function ChoGGi.CheatsMenu_LoadingScreenPreClose()
  --ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.AddAction(
    "Cheats/[01]Map Exploration",
    ChoGGi.ShowScanAndMapOptions,
    nil,
    "Scanning, deep scanning, core mines, and alien imprints.",
    "LightArea.tga"
  )

  ChoGGi.AddAction(
    "Cheats/[05]Start Mystery",
    ChoGGi.ShowMysteryList,
    nil,
    "Pick and start a mystery (with instant option).",
    "SelectionToObjects.tga"
  )

  ChoGGi.AddAction(
    "Cheats/[05]Trigger Disasters",
    ChoGGi.DisastersTrigger,
    nil,
    "Show the trigger disasters list.",
    "ApplyWaterMarkers.tga"
  )

  ChoGGi.AddAction(
    "Cheats/[05]Spawn Colonists",
    ChoGGi.SpawnColonists,
    nil,
    "Spawn certain amount of colonists.",
    "UncollectObjects.tga"
  )

  ChoGGi.AddAction(
    "Cheats/[10]Unlock all buildings",
    ChoGGi.UnlockAllBuildings,
    nil,
    "Unlock all buildings for construction.",
    "TerrainConfigEditor.tga"
  )

----------------------workplaces
  ChoGGi.AddAction(
    "Cheats/[05]Workplaces/Toggle All Shifts",
    CheatToggleAllShifts,
    nil,
    "Toggle all workshifts on or off (farms only get one on).",
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Cheats/[05]Workplaces/Update All Workplaces",
    CheatUpdateAllWorkplaces,
    nil,
    "Updates all colonist's workplaces.",
    "AlignSel.tga"
  )

  ChoGGi.AddAction(
    "Cheats/[05]Workplaces/Clear Forced Workplaces",
    CheatClearForcedWorkplaces,
    nil,
    "Removes \"user_forced_workplace\" from all colonists.",
    "AlignSel.tga"
  )

----------------------research
  ChoGGi.AddAction(
    "Cheats/[04]Research/Research Queue Larger",
    ChoGGi.ResearchQueueLarger_Toggle,
    nil,
    function()
      local des
      if const.ResearchQueueSize == 25 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Enable up to 25 items in queue."
    end,
    "ShowOcclusion.tga"
  )

  ChoGGi.AddAction(
    "Cheats/[04]Research/Reset All Research",
    ChoGGi.ResetAllResearch,
    nil,
    "Resets all research (includes breakthrough tech).",
    "UnlockCollection.tga"
  )

  ChoGGi.AddAction(
    "Cheats/[04]Research/Research Current Tech",
    CheatResearchCurrent,
    nil,
    "Complete item currently being researched.",
    "ViewArea.tga"
  )

  ChoGGi.AddAction(
    "Cheats/[04]Research/Add Research Points",
    ChoGGi.AddResearchPoints,
    nil,
    "Add a specified amount of research points.",
    "pirate.tga"
  )

  ChoGGi.AddAction(
    "Cheats/[04]Research/Outsourcing For Free",
    ChoGGi.OutsourcingFree_Toggle,
    nil,
    function()
      local des = ChoGGi.NumRetBool(Consts.OutsourceResearchCost,"(Disabled)","(Enabled)")
      return des .. " Outsourcing is free to purchase (over n over)."
    end,
    "pirate.tga"
  )

  ChoGGi.AddAction(
    "Cheats/[04]Research/Research Tech",
    ChoGGi.ShowResearchTechList,
    nil,
    "Pick what you want to unlock/research.",
    "ViewArea.tga"
  )

  ChoGGi.AddAction(
    "Cheats/[04]Research/[14]Set Amount Of Breakthroughs Allowed",
    ChoGGi.SetBreakThroughsAllowed,
    nil,
    "How many breakthroughs are allowed to be unlocked?",
    "AlignSel.tga"
  )
----------------------cheats
  ChoGGi.AddAction(
    "Cheats/[10]Unpin All Pinned Objects",
    UnpinAll,
    nil,
    "Removes all objects from the \"Pin\" menu.",
    "CutSceneArea.tga"
  )

  ChoGGi.AddAction(
    "Cheats/[12]Complete wires\\pipes",
    CheatCompleteAllWiresAndPipes,
    nil,
    "Complete all wires and pipes instantly.",
    "ViewCamPath.tga"
  )

  ChoGGi.AddAction(
    "Cheats/[13]Complete constructions",
    CheatCompleteAllConstructions,
    "Alt-B",
    "Complete all constructions instantly.",
    "place_custom_object.tga"
  )

  ChoGGi.AddAction(
    "Cheats/[14]Mod Editor",
    ChoGGi.OpenModEditor,
    nil,
    "Switch to the mod editor.",
    "Action.tga"
  )

end
