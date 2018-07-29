-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local AddAction = ChoGGi.ComFuncs.AddAction
local S = ChoGGi.Strings

--~ local icon = "new_city.tga"

local CheatClearForcedWorkplaces = CheatClearForcedWorkplaces
local CheatCompleteAllConstructions = CheatCompleteAllConstructions
local CheatCompleteAllWiresAndPipes = CheatCompleteAllWiresAndPipes
local CheatResearchCurrent = CheatResearchCurrent
local CheatToggleAllShifts = CheatToggleAllShifts
local CheatUpdateAllWorkplaces = CheatUpdateAllWorkplaces
local UnpinAll = UnpinAll

--~ AddAction(Menu,Action,Key,Des,Icon)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[999]",S[1000162--[[Menu--]]],"/",S[302535920000232--[[Draggable Cheats Menu--]]]),
  ChoGGi.MenuFuncs.DraggableCheatsMenu_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DraggableCheatsMenu,
      302535920000324--[[Cheats menu can be moved (restart to toggle).--]]
    )
  end,
  "select_objects.tga"
)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[999]",S[1000162--[[Menu--]]],"/",S[302535920000321--[[Toggle Width Of Cheats Menu On Hover--]]]),
  ChoGGi.MenuFuncs.WidthOfCheatsHover_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.ToggleWidthOfCheatsHover,
      302535920000322--[[Makes the cheats menu just show Cheats till mouseover (restart to take effect).--]]
    )
  end,
  "select_objects.tga"
)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[999]",S[1000162--[[Menu--]]],"/",S[302535920000325--[[Keep Cheats Menu Position--]]]),
  ChoGGi.MenuFuncs.KeepCheatsMenuPosition_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.KeepCheatsMenuPosition,
      302535920000326--[[This menu will stay where you drag it.--]]
    )
  end,
  "CollectionsEditor.tga"
)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[01]",S[302535920000327--[[Map Exploration--]]]),
  ChoGGi.MenuFuncs.ShowScanAndMapOptions,
  nil,
  302535920000328--[[Scanning, deep scanning, core mines, and alien imprints.--]],
  "LightArea.tga"
)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[05]",S[302535920000329--[[Manage Mysteries--]]]),
  ChoGGi.MenuFuncs.ShowStartedMysteryList,
  nil,
  302535920000330--[[Advance to next part or remove mysteries.--]],
  "SelectionToObjects.tga"
)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[05]",S[302535920000331--[[Start Mystery--]]]),
  ChoGGi.MenuFuncs.ShowMysteryList,
  nil,
  302535920000332--[[Pick and start a mystery (with instant start option).--]],
  "SelectionToObjects.tga"
)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[05]",S[302535920000333--[[Trigger Disasters--]]]),
  ChoGGi.MenuFuncs.DisastersTrigger,
  nil,
  302535920000334--[[Show the trigger disasters list.--]],
  "ApplyWaterMarkers.tga"
)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[06]",S[302535920000266--[[Spawn--]]]," ",S[547--[[Colonists--]]]),
  ChoGGi.MenuFuncs.SpawnColonists,
  nil,
  302535920000336--[[Spawn certain amount of colonists.--]],
  "UncollectObjects.tga"
)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[10]",S[302535920000337--[[Unlock all buildings--]]]),
  ChoGGi.MenuFuncs.UnlockAllBuildings,
  nil,
  302535920000338--[[Unlock all buildings for construction.--]],
  "TerrainConfigEditor.tga"
)

----------------------workplaces
AddAction(
  Concat(S[27--[[Cheats--]]],"/[05]",S[5444--[[Workplaces--]]],"/",S[302535920000339--[[Toggle All Shifts--]]]),
  CheatToggleAllShifts,
  nil,
  302535920000340--[[Toggle all workshifts on or off (farms only get one on).--]],
  "AlignSel.tga"
)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[05]",S[5444--[[Workplaces--]]],"/",S[302535920000341--[[Update All Workplaces--]]]),
  CheatUpdateAllWorkplaces,
  nil,
  302535920000342--[[Updates all colonist's workplaces.--]],
  "AlignSel.tga"
)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[05]",S[5444--[[Workplaces--]]],"/",S[302535920000343--[[Clear Forced Workplaces--]]]),
  CheatClearForcedWorkplaces,
  nil,
  302535920000344--[[Removes \"user_forced_workplace\" from all colonists.--]],
  "AlignSel.tga"
)

----------------------research
AddAction(
  Concat(S[27--[[Cheats--]]],"/[04]",S[311--[[Research--]]],"/[0]",S[302535920001278--[[Instant Research--]]]),
  ChoGGi.MenuFuncs.InstantResearch_toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.InstantResearch,
      302535920001279--[[Instantly research anything you click.--]]
    )
  end,
  "DarkSideOfTheMoon.tga"
)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[04]",S[311--[[Research--]]],"/[-1]",S[302535920000345--[[Research Tech--]]]),
  ChoGGi.MenuFuncs.ShowResearchTechList,
  nil,
  302535920000346--[[Pick what you want to unlock/research.--]],
  "ViewArea.tga"
)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[04]",S[311--[[Research--]]],"/[0]",S[302535920000305--[[Research Queue Size--]]]),
  ChoGGi.MenuFuncs.SetResearchQueueSize,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      const.ResearchQueueSize,
      302535920000348--[[Allow more items in queue.--]]
    )
  end,
  "ShowOcclusion.tga"
)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[04]",S[311--[[Research--]]],"/[0]",S[302535920000349--[[Reset All Research--]]]),
  ChoGGi.MenuFuncs.ResetAllResearch,
  nil,
  302535920000350--[[Resets all research (includes breakthrough tech).--]],
  "UnlockCollection.tga"
)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[04]",S[311--[[Research--]]],"/[0]",S[7790--[[Research Current Tech--]]]),
  CheatResearchCurrent,
  nil,
  302535920000352--[[Complete item currently being researched.--]],
  "ViewArea.tga"
)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[04]",S[311--[[Research--]]],"/[0]",S[302535920000295--[[Add Research Points--]]]),
  ChoGGi.MenuFuncs.AddResearchPoints,
  nil,
  302535920000354--[[Add a specified amount of research points.--]],
  "pirate.tga"
)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[04]",S[311--[[Research--]]],"/[0]",S[302535920000355--[[Outsourcing For Free--]]]),
  ChoGGi.MenuFuncs.OutsourcingFree_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(
      Consts.OutsourceResearchCost,
      302535920000356--[[Outsourcing is free to purchase (over n over).--]]
    )
  end,
  "pirate.tga"
)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[04]",S[311--[[Research--]]],"/[1]",S[302535920000357--[[Set Amount Of Breakthroughs Allowed--]]]),
  ChoGGi.MenuFuncs.SetBreakThroughsAllowed,
  nil,
  302535920000358--[[How many breakthroughs are allowed to be unlocked?--]],
  "AlignSel.tga"
)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[04]",S[311--[[Research--]]],"/[2]",S[302535920000359--[[Breakthroughs From OmegaTelescope--]]]),
  ChoGGi.MenuFuncs.SetBreakThroughsOmegaTelescope,
  nil,
  302535920000360--[[How many breakthroughs the OmegaTelescope will unlock.--]],
  "AlignSel.tga"
)
----------------------cheats
AddAction(
  Concat(S[27--[[Cheats--]]],"/[10]",S[302535920000361--[[Unpin All Pinned Objects--]]]),
  UnpinAll,
  nil,
  302535920000362--[[Removes all objects from the "Pin" menu.--]],
  "CutSceneArea.tga"
)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[12]",S[302535920000363--[[Complete Wires & Pipes--]]]),
  CheatCompleteAllWiresAndPipes,
  nil,
  302535920000364--[[Complete all wires and pipes instantly.--]],
  "ViewCamPath.tga"
)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[13]",S[302535920000365--[[Complete Constructions--]]]),
  CheatCompleteAllConstructions,
  ChoGGi.UserSettings.KeyBindings.CheatCompleteAllConstructions,
  302535920000366--[[Complete all constructions instantly.--]],
  "place_custom_object.tga"
)

AddAction(
  Concat(S[27--[[Cheats--]]],"/[14]",S[302535920000236--[[Mod Editor--]]]),
  ChoGGi.MenuFuncs.OpenModEditor,
  nil,
  302535920000368--[[Switch to the mod editor.--]],
  "Action.tga"
)
