local cMenuFuncs = ChoGGi.MenuFuncs
local cCodeFuncs = ChoGGi.CodeFuncs
local cComFuncs = ChoGGi.ComFuncs
local cConsts = ChoGGi.Consts
local cInfoFuncs = ChoGGi.InfoFuncs
local cSettingFuncs = ChoGGi.SettingFuncs
local cTables = ChoGGi.Tables

function ChoGGi.MsgFuncs.CheatsMenu_LoadingScreenPreClose()
  --cComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  cComFuncs.AddAction(
    "Cheats/[01]Map Exploration",
    cMenuFuncs.ShowScanAndMapOptions,
    nil,
    "Scanning, deep scanning, core mines, and alien imprints.",
    "LightArea.tga"
  )

  cComFuncs.AddAction(
    "Cheats/[05]Manage Mysteries",
    cMenuFuncs.ShowStartedMysteryList,
    nil,
    "Advance to next part or remove mysteries.",
    "SelectionToObjects.tga"
  )

  cComFuncs.AddAction(
    "Cheats/[05]Start Mystery",
    cMenuFuncs.ShowMysteryList,
    nil,
    "Pick and start a mystery (with instant start option).",
    "SelectionToObjects.tga"
  )

  cComFuncs.AddAction(
    "Cheats/[05]Trigger Disasters",
    cMenuFuncs.DisastersTrigger,
    nil,
    "Show the trigger disasters list.",
    "ApplyWaterMarkers.tga"
  )

  cComFuncs.AddAction(
    "Cheats/[06]Spawn Colonists",
    cMenuFuncs.SpawnColonists,
    nil,
    "Spawn certain amount of colonists.",
    "UncollectObjects.tga"
  )

  cComFuncs.AddAction(
    "Cheats/[10]Unlock all buildings",
    cMenuFuncs.UnlockAllBuildings,
    nil,
    "Unlock all buildings for construction.",
    "TerrainConfigEditor.tga"
  )

----------------------workplaces
  cComFuncs.AddAction(
    "Cheats/[05]Workplaces/Toggle All Shifts",
    CheatToggleAllShifts,
    nil,
    "Toggle all workshifts on or off (farms only get one on).",
    "AlignSel.tga"
  )

  cComFuncs.AddAction(
    "Cheats/[05]Workplaces/Update All Workplaces",
    CheatUpdateAllWorkplaces,
    nil,
    "Updates all colonist's workplaces.",
    "AlignSel.tga"
  )

  cComFuncs.AddAction(
    "Cheats/[05]Workplaces/Clear Forced Workplaces",
    CheatClearForcedWorkplaces,
    nil,
    "Removes \"user_forced_workplace\" from all colonists.",
    "AlignSel.tga"
  )

----------------------research
  cComFuncs.AddAction(
    "Cheats/[04]Research/Research Tech",
    cMenuFuncs.ShowResearchTechList,
    nil,
    "Pick what you want to unlock/research.",
    "ViewArea.tga"
  )

  cComFuncs.AddAction(
    "Cheats/[04]Research/[0]Research Queue Larger",
    cMenuFuncs.ResearchQueueLarger_Toggle,
    nil,
    function()
      local des = ""
      if const.ResearchQueueSize == 25 then
        des = "(Enabled)"
      else
        des = "(Disabled)"
      end
      return des .. " Enable up to 25 items in queue."
    end,
    "ShowOcclusion.tga"
  )

  cComFuncs.AddAction(
    "Cheats/[04]Research/[0]Reset All Research",
    cMenuFuncs.ResetAllResearch,
    nil,
    "Resets all research (includes breakthrough tech).",
    "UnlockCollection.tga"
  )

  cComFuncs.AddAction(
    "Cheats/[04]Research/[0]Research Current Tech",
    CheatResearchCurrent,
    nil,
    "Complete item currently being researched.",
    "ViewArea.tga"
  )

  cComFuncs.AddAction(
    "Cheats/[04]Research/[0]Add Research Points",
    cMenuFuncs.AddResearchPoints,
    nil,
    "Add a specified amount of research points.",
    "pirate.tga"
  )

  cComFuncs.AddAction(
    "Cheats/[04]Research/[0]Outsourcing For Free",
    cMenuFuncs.OutsourcingFree_Toggle,
    nil,
    function()
      local des = cComFuncs.NumRetBool(Consts.OutsourceResearchCost,"(Disabled)","(Enabled)")
      return des .. " Outsourcing is free to purchase (over n over)."
    end,
    "pirate.tga"
  )

  cComFuncs.AddAction(
    "Cheats/[04]Research/[1]Set Amount Of Breakthroughs Allowed",
    cMenuFuncs.SetBreakThroughsAllowed,
    nil,
    "How many breakthroughs are allowed to be unlocked?",
    "AlignSel.tga"
  )

  cComFuncs.AddAction(
    "Cheats/[04]Research/[2]Breakthroughs From OmegaTelescope",
    cMenuFuncs.SetBreakThroughsOmegaTelescope,
    nil,
    "How many breakthroughs the OmegaTelescope will unlock.",
    "AlignSel.tga"
  )
----------------------cheats
  cComFuncs.AddAction(
    "Cheats/[10]Unpin All Pinned Objects",
    UnpinAll,
    nil,
    "Removes all objects from the \"Pin\" menu.",
    "CutSceneArea.tga"
  )

  cComFuncs.AddAction(
    "Cheats/[12]Complete wires\\pipes",
    CheatCompleteAllWiresAndPipes,
    nil,
    "Complete all wires and pipes instantly.",
    "ViewCamPath.tga"
  )

  cComFuncs.AddAction(
    "Cheats/[13]Complete constructions",
    CheatCompleteAllConstructions,
    "Alt-B",
    "Complete all constructions instantly.",
    "place_custom_object.tga"
  )

  cComFuncs.AddAction(
    "Cheats/[14]Mod Editor",
    cMenuFuncs.OpenModEditor,
    nil,
    "Switch to the mod editor.",
    "Action.tga"
  )

end
