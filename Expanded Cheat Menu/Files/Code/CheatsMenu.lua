--See LICENSE for terms

local icon = "new_city.tga"

function ChoGGi.MsgFuncs.CheatsMenu_LoadingScreenPreClose()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[999]Menu/" .. ChoGGi.ComFuncs.Trans(302535920000321,"Toggle Width Of Cheats Menu On Hover"),
    ChoGGi.MenuFuncs.WidthOfCheatsHover_Toggle,
    nil,
    function()
      local des = tostring(ChoGGi.UserSettings.ToggleWidthOfCheatsHover)
      return des .. " " .. ChoGGi.ComFuncs.Trans(302535920000322,"Makes the cheats menu just show Cheats till mouseover (restart to take effect).")
    end,
    "select_objects.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[999]Menu/" .. ChoGGi.ComFuncs.Trans(302535920000323,"Draggable Cheats Menu"),
    ChoGGi.MenuFuncs.DraggableCheatsMenu_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.DraggableCheatsMenu and "(" .. ChoGGi.ComFuncs.Trans(302535920000030,"Enabled") .. ")" or "(" .. ChoGGi.ComFuncs.Trans(302535920000036,"Disabled") .. ")"
      return des .. " " .. ChoGGi.ComFuncs.Trans(302535920000324,"Cheats menu can be moved (restart to toggle).")
    end,
    "select_objects.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[999]Menu/" .. ChoGGi.ComFuncs.Trans(302535920000325,"Keep Cheats Menu Position"),
    ChoGGi.MenuFuncs.KeepCheatsMenuPosition_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.KeepCheatsMenuPosition and "(" .. ChoGGi.ComFuncs.Trans(302535920000030,"Enabled") .. ")" or "(" .. ChoGGi.ComFuncs.Trans(302535920000036,"Disabled") .. ")"
      return des .. " " .. ChoGGi.ComFuncs.Trans(302535920000326,"This menu will stay where you drag it.")
    end,
    "CollectionsEditor.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[01]" .. ChoGGi.ComFuncs.Trans(302535920000327,"Map Exploration"),
    ChoGGi.MenuFuncs.ShowScanAndMapOptions,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000328,"Scanning, deep scanning, core mines, and alien imprints."),
    "LightArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[05]" .. ChoGGi.ComFuncs.Trans(302535920000329,"Manage Mysteries"),
    ChoGGi.MenuFuncs.ShowStartedMysteryList,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000330,"Advance to next part or remove mysteries."),
    "SelectionToObjects.tga"
  )
  ChoGGi.ComFuncs.AddAction(
    "Cheats/[05]" .. ChoGGi.ComFuncs.Trans(302535920000331,"Start Mystery"),
    ChoGGi.MenuFuncs.ShowMysteryList,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000332,"Pick and start a mystery (with instant start option)."),
    "SelectionToObjects.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[05]" .. ChoGGi.ComFuncs.Trans(302535920000333,"Trigger Disasters"),
    ChoGGi.MenuFuncs.DisastersTrigger,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000334,"Show the trigger disasters list."),
    "ApplyWaterMarkers.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[06]" .. ChoGGi.ComFuncs.Trans(302535920000335,"Spawn Colonists"),
    ChoGGi.MenuFuncs.SpawnColonists,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000336,"Spawn certain amount of colonists."),
    "UncollectObjects.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[10]" .. ChoGGi.ComFuncs.Trans(302535920000337,"Unlock all buildings"),
    ChoGGi.MenuFuncs.UnlockAllBuildings,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000338,"Unlock all buildings for construction."),
    "TerrainConfigEditor.tga"
  )

----------------------workplaces
  ChoGGi.ComFuncs.AddAction(
    "Cheats/[05]Workplaces/" .. ChoGGi.ComFuncs.Trans(302535920000339,"Toggle All Shifts"),
    CheatToggleAllShifts,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000340,"Toggle all workshifts on or off (farms only get one on)."),
    "AlignSel.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[05]Workplaces/" .. ChoGGi.ComFuncs.Trans(302535920000341,"Update All Workplaces"),
    CheatUpdateAllWorkplaces,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000342,"Updates all colonist's workplaces."),
    "AlignSel.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[05]Workplaces/" .. ChoGGi.ComFuncs.Trans(302535920000343,"Clear Forced Workplaces"),
    CheatClearForcedWorkplaces,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000344,"Removes \"user_forced_workplace\" from all colonists."),
    "AlignSel.tga"
  )

----------------------research
  ChoGGi.ComFuncs.AddAction(
    "Cheats/[04]Research/" .. ChoGGi.ComFuncs.Trans(302535920000345,"Research Tech"),
    ChoGGi.MenuFuncs.ShowResearchTechList,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000346,"Pick what you want to unlock/research."),
    "ViewArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[04]Research/[0]" .. ChoGGi.ComFuncs.Trans(302535920000347,"Research Queue Size"),
    ChoGGi.MenuFuncs.SetResearchQueueSize,
    nil,
    function()
      local ChoGGi = ChoGGi
      local des = ""
      if const.ResearchQueueSize > 4 then
        des = "(" .. ChoGGi.ComFuncs.Trans(302535920000030,"Enabled") .. ")"
      else
        des = "(" .. ChoGGi.ComFuncs.Trans(302535920000036,"Disabled") .. ")"
      end
      return des .. " " .. ChoGGi.ComFuncs.Trans(302535920000348,"Allow more items in queue.")
    end,
    "ShowOcclusion.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[04]Research/[0]" .. ChoGGi.ComFuncs.Trans(302535920000349,"Reset All Research"),
    ChoGGi.MenuFuncs.ResetAllResearch,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000350,"Resets all research (includes breakthrough tech)."),
    "UnlockCollection.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[04]Research/[0]" .. ChoGGi.ComFuncs.Trans(302535920000351,"Research Current Tech"),
    CheatResearchCurrent,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000352,"Complete item currently being researched."),
    "ViewArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[04]Research/[0]" .. ChoGGi.ComFuncs.Trans(302535920000295,"Add Research Points"),
    ChoGGi.MenuFuncs.AddResearchPoints,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000354,"Add a specified amount of research points."),
    "pirate.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[04]Research/[0]" .. ChoGGi.ComFuncs.Trans(302535920000355,"Outsourcing For Free"),
    ChoGGi.MenuFuncs.OutsourcingFree_Toggle,
    nil,
    function()
      local des = ChoGGi.ComFuncs.NumRetBool(Consts.OutsourceResearchCost,"(" .. ChoGGi.ComFuncs.Trans(302535920000036,"Disabled") .. ")","(" .. ChoGGi.ComFuncs.Trans(302535920000030,"Enabled") .. ")")
      return des .. " " .. ChoGGi.ComFuncs.Trans(302535920000356,"Outsourcing is free to purchase (over n over).")
    end,
    "pirate.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[04]Research/[1]" .. ChoGGi.ComFuncs.Trans(302535920000357,"Set Amount Of Breakthroughs Allowed"),
    ChoGGi.MenuFuncs.SetBreakThroughsAllowed,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000358,"How many breakthroughs are allowed to be unlocked?"),
    "AlignSel.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[04]Research/[2]" .. ChoGGi.ComFuncs.Trans(302535920000359,"Breakthroughs From OmegaTelescope"),
    ChoGGi.MenuFuncs.SetBreakThroughsOmegaTelescope,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000360,"How many breakthroughs the OmegaTelescope will unlock."),
    "AlignSel.tga"
  )
----------------------cheats
  ChoGGi.ComFuncs.AddAction(
    "Cheats/[10]" .. ChoGGi.ComFuncs.Trans(302535920000361,"Unpin All Pinned Objects"),
    UnpinAll,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000362,"Removes all objects from the \"Pin\" menu."),
    "CutSceneArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[12]" .. ChoGGi.ComFuncs.Trans(302535920000363,"Complete Wires & Pipes"),
    CheatCompleteAllWiresAndPipes,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000364,"Complete all wires and pipes instantly."),
    "ViewCamPath.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[13]" .. ChoGGi.ComFuncs.Trans(302535920000365,"Complete Constructions"),
    CheatCompleteAllConstructions,
    "Alt-B",
    ChoGGi.ComFuncs.Trans(302535920000366,"Complete all constructions instantly."),
    "place_custom_object.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Cheats/[14]" .. ChoGGi.ComFuncs.Trans(302535920000367,"Mod Editor"),
    ChoGGi.MenuFuncs.OpenModEditor,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000368,"Switch to the mod editor."),
    "Action.tga"
  )

end
