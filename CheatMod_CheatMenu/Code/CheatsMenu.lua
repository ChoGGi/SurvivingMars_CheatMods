--ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

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
  "Cheats/[04]Research/[11]Research Every Breakthrough",
  ChoGGi.ResearchEveryBreakthrough,
  nil,
  "Research all Breakthroughs",
  "ViewArea.tga"
)

ChoGGi.AddAction(
  "Cheats/[04]Research/[12]Unlock Every Breakthrough",
  ChoGGi.UnlockEveryBreakthrough,
  nil,
  "Unlocks all Breakthroughs",
  "ViewArea.tga"
)

ChoGGi.AddAction(
  "Cheats/[04]Research/[13]Research Every Mystery",
  ChoGGi.ResearchEveryMystery,
  nil,
  "Research all Mysteries",
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
