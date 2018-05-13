local CMenuFuncs = ChoGGi.MenuFuncs
local CCodeFuncs = ChoGGi.CodeFuncs
local CComFuncs = ChoGGi.ComFuncs
local CConsts = ChoGGi.Consts
local CInfoFuncs = ChoGGi.InfoFuncs
local CSettingFuncs = ChoGGi.SettingFuncs
local CTables = ChoGGi.Tables

function ChoGGi.MsgFuncs.CheatsMenu_LoadingScreenPreClose()
  --CComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  CComFuncs.AddAction(
    "Cheats/[01]Map Exploration",
    CMenuFuncs.ShowScanAndMapOptions,
    nil,
    "Scanning, deep scanning, core mines, and alien imprints.",
    "LightArea.tga"
  )

  CComFuncs.AddAction(
    "Cheats/[05]Start Mystery",
    CMenuFuncs.ShowMysteryList,
    nil,
    "Pick and start a mystery (with instant option).",
    "SelectionToObjects.tga"
  )

  CComFuncs.AddAction(
    "Cheats/[05]Trigger Disasters",
    CMenuFuncs.DisastersTrigger,
    nil,
    "Show the trigger disasters list.",
    "ApplyWaterMarkers.tga"
  )

  CComFuncs.AddAction(
    "Cheats/[05]Spawn Colonists",
    CMenuFuncs.SpawnColonists,
    nil,
    "Spawn certain amount of colonists.",
    "UncollectObjects.tga"
  )

  CComFuncs.AddAction(
    "Cheats/[10]Unlock all buildings",
    CMenuFuncs.UnlockAllBuildings,
    nil,
    "Unlock all buildings for construction.",
    "TerrainConfigEditor.tga"
  )

----------------------workplaces
  CComFuncs.AddAction(
    "Cheats/[05]Workplaces/Toggle All Shifts",
    CheatToggleAllShifts,
    nil,
    "Toggle all workshifts on or off (farms only get one on).",
    "AlignSel.tga"
  )

  CComFuncs.AddAction(
    "Cheats/[05]Workplaces/Update All Workplaces",
    CheatUpdateAllWorkplaces,
    nil,
    "Updates all colonist's workplaces.",
    "AlignSel.tga"
  )

  CComFuncs.AddAction(
    "Cheats/[05]Workplaces/Clear Forced Workplaces",
    CheatClearForcedWorkplaces,
    nil,
    "Removes \"user_forced_workplace\" from all colonists.",
    "AlignSel.tga"
  )

----------------------research
  CComFuncs.AddAction(
    "Cheats/[04]Research/Research Queue Larger",
    CMenuFuncs.ResearchQueueLarger_Toggle,
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

  CComFuncs.AddAction(
    "Cheats/[04]Research/Reset All Research",
    CMenuFuncs.ResetAllResearch,
    nil,
    "Resets all research (includes breakthrough tech).",
    "UnlockCollection.tga"
  )

  CComFuncs.AddAction(
    "Cheats/[04]Research/Research Current Tech",
    CheatResearchCurrent,
    nil,
    "Complete item currently being researched.",
    "ViewArea.tga"
  )

  CComFuncs.AddAction(
    "Cheats/[04]Research/Add Research Points",
    CMenuFuncs.AddResearchPoints,
    nil,
    "Add a specified amount of research points.",
    "pirate.tga"
  )

  CComFuncs.AddAction(
    "Cheats/[04]Research/Outsourcing For Free",
    CMenuFuncs.OutsourcingFree_Toggle,
    nil,
    function()
      local des = CComFuncs.NumRetBool(Consts.OutsourceResearchCost,"(Disabled)","(Enabled)")
      return des .. " Outsourcing is free to purchase (over n over)."
    end,
    "pirate.tga"
  )

  CComFuncs.AddAction(
    "Cheats/[04]Research/Research Tech",
    CMenuFuncs.ShowResearchTechList,
    nil,
    "Pick what you want to unlock/research.",
    "ViewArea.tga"
  )

  CComFuncs.AddAction(
    "Cheats/[04]Research/[14]Set Amount Of Breakthroughs Allowed",
    CMenuFuncs.SetBreakThroughsAllowed,
    nil,
    "How many breakthroughs are allowed to be unlocked?",
    "AlignSel.tga"
  )

  CComFuncs.AddAction(
    "Cheats/[04]Research/[15]Breakthroughs From OmegaTelescope",
    CMenuFuncs.SetBreakThroughsOmegaTelescope,
    nil,
    "How many breakthroughs the OmegaTelescope will unlock.",
    "AlignSel.tga"
  )
----------------------cheats
  CComFuncs.AddAction(
    "Cheats/[10]Unpin All Pinned Objects",
    UnpinAll,
    nil,
    "Removes all objects from the \"Pin\" menu.",
    "CutSceneArea.tga"
  )

  CComFuncs.AddAction(
    "Cheats/[12]Complete wires\\pipes",
    CheatCompleteAllWiresAndPipes,
    nil,
    "Complete all wires and pipes instantly.",
    "ViewCamPath.tga"
  )

  CComFuncs.AddAction(
    "Cheats/[13]Complete constructions",
    CheatCompleteAllConstructions,
    "Alt-B",
    "Complete all constructions instantly.",
    "place_custom_object.tga"
  )

  CComFuncs.AddAction(
    "Cheats/[14]Mod Editor",
    CMenuFuncs.OpenModEditor,
    nil,
    "Switch to the mod editor.",
    "Action.tga"
  )

end
