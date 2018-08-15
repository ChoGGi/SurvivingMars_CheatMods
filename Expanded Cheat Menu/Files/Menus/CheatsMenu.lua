-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local S = ChoGGi.Strings

--~ local icon = "new_city.tga"

local MenuitemsKeys = ChoGGi.Temp.MenuitemsKeys

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = S[27--[[Cheats--]]],
  ActionName = S[302535920000327--[[Map Exploration--]]],
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[01]",S[302535920000327--[[Map Exploration--]]]),
  ActionIcon = "CommonAssets/UI/Menu/LightArea.tga",
  RolloverText = S[302535920000328--[[Scanning, deep scanning, core mines, and alien imprints.--]]],
  OnAction = ChoGGi.MenuFuncs.ShowScanAndMapOptions,
  ActionSortKey = "01",
}

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = S[27--[[Cheats--]]],
  ActionName = S[302535920000329--[[Manage Mysteries--]]],
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[05]",S[302535920000329--[[Manage Mysteries--]]]),
  ActionIcon = "CommonAssets/UI/Menu/SelectionToObjects.tga",
  RolloverText = S[302535920000330--[[Advance to next part or remove mysteries.--]]],
  OnAction = ChoGGi.MenuFuncs.ShowStartedMysteryList,
  ActionSortKey = "05",
}

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = S[27--[[Cheats--]]],
  ActionName = S[302535920000331--[[Start Mystery--]]],
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[05]",S[302535920000331--[[Start Mystery--]]]),
  ActionIcon = "CommonAssets/UI/Menu/SelectionToObjects.tga",
  RolloverText = S[302535920000332--[[Pick and start a mystery (with instant start option).--]]],
  OnAction = ChoGGi.MenuFuncs.ShowMysteryList,
  ActionSortKey = "05",
}

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = S[27--[[Cheats--]]],
  ActionName = Concat(S[1694--[[Start--]]]," ",S[3983--[[Disasters--]]]),
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[05]",S[1694--[[Start--]]]," ",S[3983--[[Disasters--]]]),
  ActionIcon = "CommonAssets/UI/Menu/ApplyWaterMarkers.tga",
  RolloverText = S[302535920000334--[[Show the disasters list and optionally start one.--]]],
  OnAction = ChoGGi.MenuFuncs.DisastersTrigger,
  ActionSortKey = "05",
}

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = S[27--[[Cheats--]]],
  ActionName = Concat(S[302535920000266--[[Spawn--]]]," ",S[547--[[Colonists--]]]),
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[06]",S[302535920000266--[[Spawn--]]]," ",S[547--[[Colonists--]]]),
  ActionIcon = "CommonAssets/UI/Menu/UncollectObjects.tga",
  RolloverText = S[302535920000336--[[Spawn certain amount of colonists.--]]],
  OnAction = ChoGGi.MenuFuncs.SpawnColonists,
  ActionSortKey = "06",
}

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = S[27--[[Cheats--]]],
  ActionName = S[302535920000337--[[Unlock all buildings--]]],
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[10]",S[302535920000337--[[Unlock all buildings--]]]),
  ActionIcon = "CommonAssets/UI/Menu/TerrainConfigEditor.tga",
  RolloverText = S[302535920000338--[[Unlock all buildings for construction.--]]],
  OnAction = ChoGGi.MenuFuncs.UnlockAllBuildings,
  ActionSortKey = "10",
}

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = S[27--[[Cheats--]]],
  ActionName = S[302535920000361--[[Unpin All Pinned Objects--]]],
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[10]",S[302535920000361--[[Unpin All Pinned Objects--]]]),
  ActionIcon = "CommonAssets/UI/Menu/CutSceneArea.tga",
  RolloverText = S[302535920000362--[[Removes all objects from the "Pin" menu.--]]],
  OnAction = UnpinAll,
  ActionSortKey = "10",
}

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = S[27--[[Cheats--]]],
  ActionName = S[302535920000363--[[Complete Wires & Pipes--]]],
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[12]",S[302535920000363--[[Complete Wires & Pipes--]]]),
  ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
  RolloverText = S[302535920000364--[[Complete all wires and pipes instantly.--]]],
  OnAction = CheatCompleteAllWiresAndPipes,
  ActionSortKey = "12",
}

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = S[27--[[Cheats--]]],
  ActionName = S[302535920000365--[[Complete Constructions--]]],
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[13]",S[302535920000365--[[Complete Constructions--]]]),
  ActionIcon = "CommonAssets/UI/Menu/place_custom_object.tga",
  RolloverText = S[302535920000366--[[Complete all constructions instantly.--]]],
  OnAction = CheatCompleteAllConstructions,
  ActionSortKey = "13",
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.CheatCompleteAllConstructions,
}

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = S[27--[[Cheats--]]],
  ActionName = S[302535920000236--[[Mod Editor--]]],
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[14]",S[302535920000236--[[Mod Editor--]]]),
  ActionIcon = "CommonAssets/UI/Menu/Action.tga",
  RolloverText = S[302535920000368--[[Switch to the mod editor.--]]],
  OnAction = ChoGGi.MenuFuncs.OpenModEditor,
  ActionSortKey = "14",
}

local str_Cheats_Workplaces = Concat(S[27--[[Cheats--]]],".",S[5444--[[Workplaces--]]])
MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = S[27--[[Cheats--]]],
  ActionName = S[5444--[[Workplaces--]]],
  ActionId = str_Cheats_Workplaces,
  ActionIcon = "CommonAssets/UI/Menu/folder.tga",
  OnActionEffect = "popup",
  ActionSortKey = "05",
}

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = str_Cheats_Workplaces,
  ActionName = S[302535920000339--[[Toggle All Shifts--]]],
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[05]",S[5444--[[Workplaces--]]],"/",S[302535920000339--[[Toggle All Shifts--]]]),
  ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
  RolloverText = S[302535920000340--[[Toggle all workshifts on or off (farms only get one on).--]]],
  OnAction = CheatToggleAllShifts,
}

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = str_Cheats_Workplaces,
  ActionName = S[302535920000341--[[Update All Workplaces--]]],
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[05]",S[5444--[[Workplaces--]]],"/",S[302535920000341--[[Update All Workplaces--]]]),
  ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
  RolloverText = S[302535920000342--[[Updates all colonist's workplaces.--]]],
  OnAction = CheatUpdateAllWorkplaces,
}

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = str_Cheats_Workplaces,
  ActionName = S[302535920000343--[[Clear Forced Workplaces--]]],
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[05]",S[5444--[[Workplaces--]]],"/",S[302535920000343--[[Clear Forced Workplaces--]]]),
  ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
  RolloverText = S[302535920000344--[["Removes ""user_forced_workplace"" from all colonists."--]]],
  OnAction = CheatClearForcedWorkplaces,
}

local str_Cheats_Research = Concat(S[27--[[Cheats--]]],".",S[311--[[Research--]]])
MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = S[27--[[Cheats--]]],
  ActionName = S[311--[[Research--]]],
  ActionId = str_Cheats_Research,
  ActionIcon = "CommonAssets/UI/Menu/folder.tga",
  OnActionEffect = "popup",
  ActionSortKey = "04",
}

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = str_Cheats_Research,
  ActionName = S[302535920001278--[[Instant Research--]]],
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[04]",S[311--[[Research--]]],"/[0]",S[302535920001278--[[Instant Research--]]]),
  ActionIcon = "CommonAssets/UI/Menu/DarkSideOfTheMoon.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.InstantResearch,
      302535920001279--[[Instantly research anything you click.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.InstantResearch_toggle,
  ActionSortKey = "00",
}

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = str_Cheats_Research,
  ActionName = Concat(S[311--[[Research--]]]," ",S[3734--[[Tech--]]]),
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[04]",S[311--[[Research--]]],"/[-1]",S[311--[[Research--]]]," ",S[3734--[[Tech--]]]),
  ActionIcon = "CommonAssets/UI/Menu/ViewArea.tga",
  RolloverText = S[302535920000346--[[Pick what you want to unlock/research.--]]],
  OnAction = ChoGGi.MenuFuncs.ShowResearchTechList,
  ActionSortKey = "-1",
}

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = str_Cheats_Research,
  ActionName = S[302535920000305--[[Research Queue Size--]]],
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[04]",S[311--[[Research--]]],"/[0]",S[302535920000305--[[Research Queue Size--]]]),
  ActionIcon = "CommonAssets/UI/Menu/ShowOcclusion.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.ResearchQueueSize,
      302535920000348--[[Allow more items in queue.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetResearchQueueSize,
  ActionSortKey = "00",
}

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = str_Cheats_Research,
  ActionName = S[302535920000349--[[Reset All Research--]]],
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[04]",S[311--[[Research--]]],"/[0]",S[302535920000349--[[Reset All Research--]]]),
  ActionIcon = "CommonAssets/UI/Menu/UnlockCollection.tga",
  RolloverText = S[302535920000350--[[Resets all research (includes breakthrough tech).--]]],
  OnAction = ChoGGi.MenuFuncs.ResetAllResearch,
  ActionSortKey = "00",
}

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = str_Cheats_Research,
  ActionName = S[7790--[[Research Current Tech--]]],
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[04]",S[311--[[Research--]]],"/[0]",S[7790--[[Research Current Tech--]]]),
  ActionIcon = "CommonAssets/UI/Menu/ViewArea.tga",
  RolloverText = S[302535920000352--[[Complete item currently being researched.--]]],
  OnAction = CheatResearchCurrent,
  ActionSortKey = "00",
}

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = str_Cheats_Research,
  ActionName = S[302535920000295--[[Add Research Points--]]],
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[04]",S[311--[[Research--]]],"/[0]",S[302535920000295--[[Add Research Points--]]]),
  ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
  RolloverText = S[302535920000354--[[Add a specified amount of research points.--]]],
  OnAction = ChoGGi.MenuFuncs.AddResearchPoints,
  ActionSortKey = "00",
}

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = str_Cheats_Research,
  ActionName = S[302535920000355--[[Outsourcing For Free--]]],
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[04]",S[311--[[Research--]]],"/[0]",S[302535920000355--[[Outsourcing For Free--]]]),
  ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.OutsourceResearchCost,
      302535920000356--[[Outsourcing is free to purchase (over n over).--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.OutsourcingFree_Toggle,
  ActionSortKey = "00",
}

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = str_Cheats_Research,
  ActionName = S[302535920000357--[[Set Amount Of Breakthroughs Allowed--]]],
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[04]",S[311--[[Research--]]],"/[1]",S[302535920000357--[[Set Amount Of Breakthroughs Allowed--]]]),
  ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.BreakThroughTechsPerGame,
      302535920000358--[[How many breakthroughs are allowed to be unlocked?--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetBreakThroughsAllowed,
  ActionSortKey = "01",
}

MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = str_Cheats_Research,
  ActionName = S[302535920000359--[[Breakthroughs From OmegaTelescope--]]],
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[04]",S[311--[[Research--]]],"/[2]",S[302535920000359--[[Breakthroughs From OmegaTelescope--]]]),
  ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.OmegaTelescopeBreakthroughsCount,
      302535920000360--[[How many breakthroughs the OmegaTelescope will unlock.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetBreakThroughsOmegaTelescope,
  ActionSortKey = "02",
}

local str_Cheats_Menu = Concat(S[27--[[Cheats--]]],".",S[1000162--[[Menu--]]])
MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionMenubar = S[27--[[Cheats--]]],
  ActionName = S[1000162--[[Menu--]]],
  ActionId = str_Cheats_Menu,
  ActionIcon = "CommonAssets/UI/Menu/folder.tga",
  OnActionEffect = "popup",
  ActionSortKey = "99",
}
MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionName = S[302535920000232--[[Draggable Cheats Menu--]]],
  ActionMenubar = str_Cheats_Menu,
  ActionId = Concat(S[283142739680--[[Game--]]],".",S[302535920001058--[[Camera--]]],".",S[302535920000232--[[Draggable Cheats Menu--]]]),
  ActionIcon = "CommonAssets/UI/Menu/select_objects.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DraggableCheatsMenu,
      302535920000324--[[Cheats menu can be moved (restart to toggle).--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.DraggableCheatsMenu_Toggle,
}
MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionName = S[302535920000321--[[Toggle Width Of Cheats Menu On Hover--]]],
  ActionMenubar = str_Cheats_Menu,
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[99]",S[1000162--[[Menu--]]],"/",S[302535920000321--[[Toggle Width Of Cheats Menu On Hover--]]]),
  ActionIcon = "CommonAssets/UI/Menu/select_objects.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.ToggleWidthOfCheatsHover,
      302535920000322--[[Makes the cheats menu just show Cheats till mouseover (restart to take effect).--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.WidthOfCheatsHover_Toggle,
}
MenuitemsKeys[#MenuitemsKeys+1] = {
  ActionName = S[302535920000325--[[Keep Cheats Menu Position--]]],
  ActionMenubar = str_Cheats_Menu,
  ActionId = Concat("/[10]",S[27--[[Cheats--]]],"/[99]",S[1000162--[[Menu--]]],"/",S[302535920000325--[[Keep Cheats Menu Position--]]]),
  ActionIcon = "CommonAssets/UI/Menu/CollectionsEditor.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.KeepCheatsMenuPosition,
      302535920000326--[[This menu will stay where you drag it.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.KeepCheatsMenuPosition_Toggle,
}
