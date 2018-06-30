-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local T = ChoGGi.ComFuncs.Trans
--~ local icon = "new_city.tga"

local CheatClearForcedWorkplaces = CheatClearForcedWorkplaces
local CheatCompleteAllConstructions = CheatCompleteAllConstructions
local CheatCompleteAllWiresAndPipes = CheatCompleteAllWiresAndPipes
local CheatResearchCurrent = CheatResearchCurrent
local CheatToggleAllShifts = CheatToggleAllShifts
local CheatUpdateAllWorkplaces = CheatUpdateAllWorkplaces
local UnpinAll = UnpinAll

function ChoGGi.MsgFuncs.CheatsMenu_ChoGGi_Loaded()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[999]",T(1000162--[[Menu--]]),"/",T(302535920000232--[[Draggable Cheats Menu--]])),
    ChoGGi.MenuFuncs.DraggableCheatsMenu_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.DraggableCheatsMenu,
        302535920000324--[[Cheats menu can be moved (restart to toggle).--]]
      )
    end,
    "select_objects.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[999]",T(1000162--[[Menu--]]),"/",T(302535920000321--[[Toggle Width Of Cheats Menu On Hover--]])),
    ChoGGi.MenuFuncs.WidthOfCheatsHover_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.ToggleWidthOfCheatsHover,
        302535920000322--[[Makes the cheats menu just show Cheats till mouseover (restart to take effect).--]]
      )
    end,
    "select_objects.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[999]",T(1000162--[[Menu--]]),"/",T(302535920000325--[[Keep Cheats Menu Position--]])),
    ChoGGi.MenuFuncs.KeepCheatsMenuPosition_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.KeepCheatsMenuPosition,
        302535920000326--[[This menu will stay where you drag it.--]]
      )
    end,
    "CollectionsEditor.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[01]",T(302535920000327--[[Map Exploration--]])),
    ChoGGi.MenuFuncs.ShowScanAndMapOptions,
    nil,
    T(302535920000328--[[Scanning, deep scanning, core mines, and alien imprints.--]]),
    "LightArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[05]",T(302535920000329--[[Manage Mysteries--]])),
    ChoGGi.MenuFuncs.ShowStartedMysteryList,
    nil,
    T(302535920000330--[[Advance to next part or remove mysteries.--]]),
    "SelectionToObjects.tga"
  )
  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[05]",T(302535920000331--[[Start Mystery--]])),
    ChoGGi.MenuFuncs.ShowMysteryList,
    nil,
    T(302535920000332--[[Pick and start a mystery (with instant start option).--]]),
    "SelectionToObjects.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[05]",T(302535920000333--[[Trigger Disasters--]])),
    ChoGGi.MenuFuncs.DisastersTrigger,
    nil,
    T(302535920000334--[[Show the trigger disasters list.--]]),
    "ApplyWaterMarkers.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[06]",T(302535920000266--[[Spawn--]])," ",T(547--[[Colonists--]])),
    ChoGGi.MenuFuncs.SpawnColonists,
    nil,
    T(302535920000336--[[Spawn certain amount of colonists.--]]),
    "UncollectObjects.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[10]",T(302535920000337--[[Unlock all buildings--]])),
    ChoGGi.MenuFuncs.UnlockAllBuildings,
    nil,
    T(302535920000338--[[Unlock all buildings for construction.--]]),
    "TerrainConfigEditor.tga"
  )

----------------------workplaces
  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[05]",T(5444--[[Workplaces--]]),"/",T(302535920000339--[[Toggle All Shifts--]])),
    CheatToggleAllShifts,
    nil,
    T(302535920000340--[[Toggle all workshifts on or off (farms only get one on).--]]),
    "AlignSel.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[05]",T(5444--[[Workplaces--]]),"/",T(302535920000341--[[Update All Workplaces--]])),
    CheatUpdateAllWorkplaces,
    nil,
    T(302535920000342--[[Updates all colonist's workplaces.--]]),
    "AlignSel.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[05]",T(5444--[[Workplaces--]]),"/",T(302535920000343--[[Clear Forced Workplaces--]])),
    CheatClearForcedWorkplaces,
    nil,
    T(302535920000344--[[Removes \"user_forced_workplace\" from all colonists.--]]),
    "AlignSel.tga"
  )

----------------------research
  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[04]",T(311--[[Research--]]),"/",T(302535920000345--[[Research Tech--]])),
    ChoGGi.MenuFuncs.ShowResearchTechList,
    nil,
    T(302535920000346--[[Pick what you want to unlock/research.--]]),
    "ViewArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[04]",T(311--[[Research--]]),"/[0]",T(302535920000305--[[Research Queue Size--]])),
    ChoGGi.MenuFuncs.SetResearchQueueSize,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(const.ResearchQueueSize,
        302535920000348--[[Allow more items in queue.--]]
      )
    end,
    "ShowOcclusion.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[04]",T(311--[[Research--]]),"/[0]",T(302535920000349--[[Reset All Research--]])),
    ChoGGi.MenuFuncs.ResetAllResearch,
    nil,
    T(302535920000350--[[Resets all research (includes breakthrough tech).--]]),
    "UnlockCollection.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[04]",T(311--[[Research--]]),"/[0]",T(7790--[[Research Current Tech--]])),
    CheatResearchCurrent,
    nil,
    T(302535920000352--[[Complete item currently being researched.--]]),
    "ViewArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[04]",T(311--[[Research--]]),"/[0]",T(302535920000295--[[Add Research Points--]])),
    ChoGGi.MenuFuncs.AddResearchPoints,
    nil,
    T(302535920000354--[[Add a specified amount of research points.--]]),
    "pirate.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[04]",T(311--[[Research--]]),"/[0]",T(302535920000355--[[Outsourcing For Free--]])),
    ChoGGi.MenuFuncs.OutsourcingFree_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(Consts.OutsourceResearchCost,
        302535920000356--[[Outsourcing is free to purchase (over n over).--]]
      )
    end,
    "pirate.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[04]",T(311--[[Research--]]),"/[1]",T(302535920000357--[[Set Amount Of Breakthroughs Allowed--]])),
    ChoGGi.MenuFuncs.SetBreakThroughsAllowed,
    nil,
    T(302535920000358--[[How many breakthroughs are allowed to be unlocked?--]]),
    "AlignSel.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[04]",T(311--[[Research--]]),"/[2]",T(302535920000359--[[Breakthroughs From OmegaTelescope--]])),
    ChoGGi.MenuFuncs.SetBreakThroughsOmegaTelescope,
    nil,
    T(302535920000360--[[How many breakthroughs the OmegaTelescope will unlock.--]]),
    "AlignSel.tga"
  )
----------------------cheats
  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[10]",T(302535920000361--[[Unpin All Pinned Objects--]])),
    UnpinAll,
    nil,
    T(302535920000362--[[Removes all objects from the "Pin" menu.--]]),
    "CutSceneArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[12]",T(302535920000363--[[Complete Wires & Pipes--]])),
    CheatCompleteAllWiresAndPipes,
    nil,
    T(302535920000364--[[Complete all wires and pipes instantly.--]]),
    "ViewCamPath.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[13]",T(302535920000365--[[Complete Constructions--]])),
    CheatCompleteAllConstructions,
    "Alt-B",
    T(302535920000366--[[Complete all constructions instantly.--]]),
    "place_custom_object.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(27--[[Cheats--]]),"/[14]",T(302535920000367--[[Mod Editor--]])),
    ChoGGi.MenuFuncs.OpenModEditor,
    nil,
    T(302535920000368--[[Switch to the mod editor.--]]),
    "Action.tga"
  )

end
