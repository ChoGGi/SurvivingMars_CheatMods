--See LICENSE for terms

local icon = "new_city.tga"

function ChoGGi.MsgFuncs.CheatsMenu_LoadingScreenPreClose()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[01]Map Exploration",
    ChoGGi.MenuFuncs.ShowScanAndMapOptions,
    nil,
    "Scanning, deep scanning, core mines, and alien imprints.",
    "LightArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[05]Manage Mysteries",
    ChoGGi.MenuFuncs.ShowStartedMysteryList,
    nil,
    "Advance to next part or remove mysteries.",
    "SelectionToObjects.tga"
  )
  ChoGGi.ComFuncs.AddAction(
    "Cheats/[05]Start Mystery",
    ChoGGi.MenuFuncs.ShowMysteryList,
    nil,
    "Pick and start a mystery (with instant start option).",
    "SelectionToObjects.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[05]Trigger Disasters",
    ChoGGi.MenuFuncs.DisastersTrigger,
    nil,
    "Show the trigger disasters list.",
    "ApplyWaterMarkers.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[06]Spawn Colonists",
    ChoGGi.MenuFuncs.SpawnColonists,
    nil,
    "Spawn certain amount of colonists.",
    "UncollectObjects.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[10]Unlock all buildings",
    ChoGGi.MenuFuncs.UnlockAllBuildings,
    nil,
    "Unlock all buildings for construction.",
    "TerrainConfigEditor.tga"
  )

----------------------workplaces
  ChoGGi.ComFuncs.AddAction(
    "Cheats/[05]Workplaces/Toggle All Shifts",
    CheatToggleAllShifts,
    nil,
    "Toggle all workshifts on or off (farms only get one on).",
    "AlignSel.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[05]Workplaces/Update All Workplaces",
    CheatUpdateAllWorkplaces,
    nil,
    "Updates all colonist's workplaces.",
    "AlignSel.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[05]Workplaces/Clear Forced Workplaces",
    CheatClearForcedWorkplaces,
    nil,
    "Removes \"user_forced_workplace\" from all colonists.",
    "AlignSel.tga"
  )

----------------------research
  ChoGGi.ComFuncs.AddAction(
    "Cheats/[04]Research/Research Tech",
    ChoGGi.MenuFuncs.ShowResearchTechList,
    nil,
    "Pick what you want to unlock/research.",
    "ViewArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[04]Research/[0]Research Queue Size",
    ChoGGi.MenuFuncs.SetResearchQueueSize,
    nil,
    function()
      local des = ""
      if const.ResearchQueueSize > 4 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Allow more items in queue."
    end,
    "ShowOcclusion.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[04]Research/[0]Reset All Research",
    ChoGGi.MenuFuncs.ResetAllResearch,
    nil,
    "Resets all research (includes breakthrough tech).",
    "UnlockCollection.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[04]Research/[0]Research Current Tech",
    CheatResearchCurrent,
    nil,
    "Complete item currently being researched.",
    "ViewArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[04]Research/[0]Add Research Points",
    ChoGGi.MenuFuncs.AddResearchPoints,
    nil,
    "Add a specified amount of research points.",
    "pirate.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[04]Research/[0]Outsourcing For Free",
    ChoGGi.MenuFuncs.OutsourcingFree_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.OutsourceResearchCost,"(Disabled)","(Enabled)")
      return des .. " Outsourcing is free to purchase (over n over)."
    end,
    "pirate.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[04]Research/[1]Set Amount Of Breakthroughs Allowed",
    ChoGGi.MenuFuncs.SetBreakThroughsAllowed,
    nil,
    "How many breakthroughs are allowed to be unlocked?",
    "AlignSel.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[04]Research/[2]Breakthroughs From OmegaTelescope",
    ChoGGi.MenuFuncs.SetBreakThroughsOmegaTelescope,
    nil,
    "How many breakthroughs the OmegaTelescope will unlock.",
    "AlignSel.tga"
  )
----------------------cheats
  ChoGGi.ComFuncs.AddAction(
    "Cheats/[10]Unpin All Pinned Objects",
    UnpinAll,
    nil,
    "Removes all objects from the \"Pin\" menu.",
    "CutSceneArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[12]Complete wires\\pipes",
    CheatCompleteAllWiresAndPipes,
    nil,
    "Complete all wires and pipes instantly.",
    "ViewCamPath.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[13]Complete constructions",
    CheatCompleteAllConstructions,
    "Alt-B",
    "Complete all constructions instantly.",
    "place_custom_object.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[14]Mod Editor",
    ChoGGi.MenuFuncs.OpenModEditor,
    nil,
    "Switch to the mod editor.",
    "Action.tga"
  )

end
