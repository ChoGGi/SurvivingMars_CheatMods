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
    "Pick and start a mystery (instant option).",
    "SelectionToObjects.tga"
  )

  ChoGGi.AddAction(
    "Cheats/[05]Trigger Disasters",
    ChoGGi.DisastersTrigger,
    nil,
    "Trigger a disaster.",
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
    "ViewArea.tga"
  )

  ChoGGi.AddAction(
    "Cheats/[04]Research/Research Tech",
    ChoGGi.ShowResearchDialog,
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

end
