function OnMsg.Resume()
  --ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.AddAction(
    "Cheats/[01]Map Exploration",
    ChoGGi.ShowScanOptions,
    nil,
    "Reveal all deposits or deposits level 1 and above.",
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
    "Cheats/[04]Research/Outsource Points 1,000,000",
    ChoGGi.OutsourcePoints1000000,
    nil,
    "Gives a crapload of research points when you outsource (almost instant research)",
    "ViewArea.tga"
  )
  ChoGGi.AddAction(
    "Cheats/[04]Research/Add Research Points",
    ChoGGi.AddOutsourcePoints,
    nil,
    "Add a number of research points.",
    "ViewArea.tga"
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
    "Cheats/[04]Research/Research Stuff",
    ChoGGi.ShowResearchDialog,
    nil,
    "Pick what you want to unlock/research.",
    "ViewArea.tga"
  )

  ChoGGi.AddAction(
    "Cheats/[04]Research/[14]Double Amount of Breakthroughs per game",
    ChoGGi.BreakThroughTechsPerGame_Toggle,
    nil,
    function()
      local des
      if const.BreakThroughTechsPerGame == 26 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Doubled amount of breakthroughs unlockable per game."
    end,
    "ViewArea.tga"
  )
end
