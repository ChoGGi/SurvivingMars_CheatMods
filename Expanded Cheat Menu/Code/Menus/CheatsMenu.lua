-- See LICENSE for terms

local Translate = ChoGGi.ComFuncs.Translate
local SettingState = ChoGGi.ComFuncs.SettingState
local TranslationTable = TranslationTable
local Actions = ChoGGi.Temp.Actions
local c = #Actions

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920001355--[[Map]]] .. " " .. TranslationTable[5422--[[Exploration]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Map Exploration",
	ActionIcon = "CommonAssets/UI/Menu/LightArea.tga",
	RolloverText = TranslationTable[302535920000328--[[Scanning, deep scanning, core mines, and alien imprints.]]],
	OnAction = ChoGGi.MenuFuncs.MapExploration,
}

--~ c = c + 1
--~ Actions[c] = {ActionName = TranslationTable[5661--[[Mystery Log]]],
--~ 	ActionMenubar = "ECM.Cheats",
--~ 	ActionId = ".Mystery Log",
--~ 	ActionIcon = "CommonAssets/UI/Menu/SelectionToObjects.tga",
--~ 	RolloverText = TranslationTable[302535920000330--[[Advance to next part, show what part you're on, or remove mysteries.]]],
--~ 	OnAction = ChoGGi.MenuFuncs.MysteryLog,
--~ }
c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000331--[[Mystery Start]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Mystery Start",
	ActionIcon = "CommonAssets/UI/Menu/SelectionToObjects.tga",
	RolloverText = TranslationTable[302535920000332--[["Pick and start a mystery (with instant start option).
Certain mysteries need certain objects which get placed when the map is generated on a new game (the green rocks one for instance)."]]],
	OnAction = ChoGGi.MenuFuncs.ShowMysteryList,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[11412--[[Trigger fireworks]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Trigger fireworks",
	ActionIcon = "CommonAssets/UI/Menu/DisableRMMaps.tga",
	RolloverText = TranslationTable[302535920001402--[[Add some party to your domes for 3 hours (10 domes max).]]],
	OnAction = TriggerFireworks,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000318--[[Unlock]]] .. " " .. TranslationTable[697482021580--[[Achievements]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Unlock Achievements",
	ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
	RolloverText = TranslationTable[302535920001496--[[Show a list of achievements to unlock (permanent!).]]],
	OnAction = ChoGGi.MenuFuncs.UnlockAchievements,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000266--[[Spawn]]] .. " " .. TranslationTable[547--[[Colonists]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Spawn Colonists",
	ActionIcon = "CommonAssets/UI/Menu/UncollectObjects.tga",
	RolloverText = TranslationTable[302535920000336--[[Spawn X amount of colonists.]]],
	OnAction = ChoGGi.MenuFuncs.SpawnColonists,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000337--[[Toggle Unlock All Buildings]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Toggle Unlock all buildings",
	ActionIcon = "CommonAssets/UI/Menu/TerrainConfigEditor.tga",
	RolloverText = TranslationTable[302535920000338--[["Unlocks all buildings in the build menu.
This doesn't apply to sponsor limited ones; see ECM>Buildings>Toggles>%s.
To unlock a single building: See ECM>Buildings>%s."]]]:format(TranslationTable[302535920001398--[[Remove Sponsor Limits]]], TranslationTable[302535920000180--[[Unlock Locked Buildings]]]),
	OnAction = ChoGGi.MenuFuncs.UnlockAllBuildings_Toggle,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000361--[[Unpin All Pinned Objects]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Unpin All Pinned Objects",
	ActionIcon = "CommonAssets/UI/Menu/CutSceneArea.tga",
	RolloverText = TranslationTable[302535920000362--[[Removes all objects from the "Pin" menu.]]],
	OnAction = UnpinAll,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000363--[[Complete Wires & Pipes]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Complete Wires & Pipes",
	ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
	RolloverText = TranslationTable[302535920000364--[[Complete all wires and pipes instantly.]]],
	OnAction = CheatCompleteAllWiresAndPipes,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000365--[[Complete Constructions]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Complete Constructions",
	ActionIcon = "CommonAssets/UI/Menu/place_custom_object.tga",
	RolloverText = TranslationTable[302535920000366--[[Complete all constructions instantly.]]],
	OnAction = ChoGGi.MenuFuncs.CompleteConstructions,
	ActionShortcut = "Alt-B",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000236--[[Mod Editor]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Mod Editor",
	ActionIcon = "CommonAssets/UI/Menu/Action.tga",
	RolloverText = TranslationTable[302535920000368--[[Open the mod editor.]]],
	OnAction = ChoGGi.MenuFuncs.OpenModEditor,
}

-- menu
c = c + 1
Actions[c] = {ActionName = TranslationTable[311--[[Research]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Research",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Research",
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[311--[[Research]]] .. " / " .. TranslationTable[302535920000318--[[Unlock]]] .. " " .. TranslationTable[3734--[[Tech]]],
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Research / Unlock Tech",
	ActionIcon = "CommonAssets/UI/Menu/ViewArea.tga",
	RolloverText = TranslationTable[302535920000346--[[Pick what you want to unlock/research (defaults to unlock).]]],
	OnAction = ChoGGi.MenuFuncs.ResearchTech,
	ActionSortKey = "-1",
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[311--[[Research]]] .. " " .. TranslationTable[302535920000281--[[Remove]]],
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Research Remove",
	ActionIcon = "CommonAssets/UI/Menu/ViewArea.tga",
	RolloverText = TranslationTable[302535920001494--[[Remove a tech from researched list and reset any values it adds (not stuff from mods).]]],
	OnAction = ChoGGi.MenuFuncs.ResearchRemove,
	ActionSortKey = "-2",
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920001278--[[Instant Research]]],
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Instant Research",
	ActionIcon = "CommonAssets/UI/Menu/DarkSideOfTheMoon.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.InstantResearch,
			TranslationTable[302535920001279--[[Instantly research anything you click.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.InstantResearch_toggle,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000305--[[Research Queue Size]]],
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Research Queue Size",
	ActionIcon = "CommonAssets/UI/Menu/ShowOcclusion.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.ResearchQueueSize,
			TranslationTable[302535920000348--[[Allow more items in queue.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.ResearchQueueSize_Set,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000349--[[Reset All Research]]],
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Reset All Research",
	ActionIcon = "CommonAssets/UI/Menu/UnlockCollection.tga",
	RolloverText = TranslationTable[302535920000350--[[Resets all research (includes breakthrough tech).]]],
	OnAction = ChoGGi.MenuFuncs.ResetAllResearch,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[7790--[[Research Current Tech]]],
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Research Current Tec",
	ActionIcon = "CommonAssets/UI/Menu/ViewArea.tga",
	RolloverText = TranslationTable[302535920000352--[[Complete item currently being researched.]]],
	OnAction = CheatResearchCurrent,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000295--[[Add Research Points]]],
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Add Research Points",
	ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
	RolloverText = TranslationTable[302535920000354--[[Add a specified amount of research points.]]],
	OnAction = ChoGGi.MenuFuncs.AddResearchPoints,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000355--[[Outsourcing For Free]]],
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Outsourcing For Free",
	ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.OutsourceResearchCost,
			TranslationTable[839458405314--[[Outsource Research Cost (in millions)]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.OutsourcingFree_Toggle,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[970197122036--[[Maximum Outsource Orders]]],
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Maximum Outsource Orders",
	ActionIcon = "CommonAssets/UI/Menu/change_height_up.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.OutsourceMaxOrderCount,
			TranslationTable[302535920001343--[[How many times you can outsource in a row.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.SetOutsourceMaxOrderCount,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000357--[[Set Amount Of Breakthroughs Allowed]]],
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Set Amount Of Breakthroughs Allowed",
	ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.BreakThroughTechsPerGame,
			TranslationTable[302535920000358--[[How many breakthroughs are allowed to be unlocked?]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.BreakThroughsAllowed_Set,
	ActionSortKey = "2Set Amount Of Breakthroughs Allowed",
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000359--[[Breakthroughs From Omega Telescope]]],
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Breakthroughs From OmegaTelescope",
	ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.OmegaTelescopeBreakthroughsCount,
			TranslationTable[302535920000360--[[How many breakthroughs the Omega Telescope will unlock.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.BreakThroughsOmegaTelescope_Set,
	ActionSortKey = "2Breakthroughs From OmegaTelescope",
}

-- menu
c = c + 1
Actions[c] = {ActionName = TranslationTable[1000162--[[Menu]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Menu",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Menu",
}
c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000232--[[Draggable Cheats Menu]]],
	ActionMenubar = "ECM.Cheats.Menu",
	ActionId = ".Draggable Cheats Menu",
	ActionIcon = "CommonAssets/UI/Menu/select_objects.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.DraggableCheatsMenu,
			TranslationTable[302535920000324--[[Cheats menu can be moved.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.DraggableCheatsMenu_Toggle,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000325--[[Keep Cheats Menu Position]]],
	ActionMenubar = "ECM.Cheats.Menu",
	ActionId = ".Keep Cheats Menu Position",
	ActionIcon = "CommonAssets/UI/Menu/LockCollection.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.KeepCheatsMenuPosition,
			TranslationTable[302535920000326--[[This menu will stay where you drag it.]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.KeepCheatsMenuPosition_Toggle,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920001014--[[Hide Cheats Menu]]],
	ActionMenubar = "ECM.Cheats.Menu",
	ActionId = ".Hide Cheats Menu",
	ActionIcon = "CommonAssets/UI/Menu/ToggleEnvMap.tga",
	RolloverText = TranslationTable[302535920001019--[[This will hide the Cheats menu; Use F2 to see it again.]]],
	OnAction = ChoGGi.ComFuncs.CheatsMenu_Toggle,
	ActionShortcut = "F2",
	ActionBindable = true,
	ActionSortKey = "-1Hide Cheats Menu",
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000696--[[Infopanel Cheats]]],
	ActionMenubar = "ECM.Cheats.Menu",
	ActionId = ".Infopanel Cheats",
	ActionIcon = "CommonAssets/UI/Menu/toggle_dtm_slots.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.ToggleInfopanelCheats,
			TranslationTable[302535920000697--[[Shows the cheat pane in the info panel (selection panel).]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.InfopanelCheats_Toggle,
	ActionShortcut = "Ctrl-F2",
	ActionBindable = true,
	ActionSortKey = "-1Infopanel Cheats",
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000698--[[Infopanel Cheats Cleanup]]],
	ActionMenubar = "ECM.Cheats.Menu",
	ActionId = ".Infopanel Cheats Cleanup",
	ActionIcon = "CommonAssets/UI/Menu/toggle_dtm_slots.tga",
	RolloverText = function()
		return SettingState(
			ChoGGi.UserSettings.CleanupCheatsInfoPane,
			TranslationTable[302535920000699--[[Remove some entries from the cheat pane (restart to re-enable).

AddMaintenancePnts, MakeSphereTarget, SpawnWorker, SpawnVisitor]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.InfopanelCheatsCleanup_Toggle,
	ActionSortKey = "-1Infopanel Cheats Cleanup",
}

-- menu
c = c + 1
Actions[c] = {ActionName = TranslationTable[948928900281--[[Story Bits]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".StoryBits",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1StoryBits",
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920001393--[[Clear Cooldowns]]],
	ActionMenubar = "ECM.Cheats.StoryBits",
	ActionId = ".StoryBits ClearCooldowns",
	ActionIcon = "CommonAssets/UI/Menu/DisablePostprocess.tga",
	RolloverText = TranslationTable[302535920001392--[[Sets story.cooldown_end to GameTime.]]],
	OnAction = StoryBitCategoryState.ClearCooldowns,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920001580--[[Interrupt Supression Times]]],
	ActionMenubar = "ECM.Cheats.StoryBits",
	ActionId = ".Interrupt Supression Times",
	ActionIcon = "CommonAssets/UI/Menu/Action.tga",
	RolloverText = TranslationTable[302535920001581--[[Sets story.time_created to -SuppressTime.]]],
	OnAction = InterruptStoryBitSupressionTimes,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920001582--[[Testing Toggle]]],
	ActionMenubar = "ECM.Cheats.StoryBits",
	ActionId = ".Testing Toggle",
	ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
	RolloverText = TranslationTable[302535920001583--[[Toggles g_StoryBitTesting.]]],
	OnAction = ToggleStoryBitTesting,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920001584--[[Testing Delete Backlog]]],
	ActionMenubar = "ECM.Cheats.StoryBits",
	ActionId = ".Testing Delete Backlog",
	ActionIcon = "CommonAssets/UI/Menu/DelCamera.tga",
	RolloverText = TranslationTable[302535920001585--[[Sets AccountStorage.StoryBitTimestamp to nil.]]],
	OnAction = DeleteStoryBitTestingBacklog,
}

-- menu
c = c + 1
Actions[c] = {ActionName = TranslationTable[3984--[[Anomalies]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Anomalies",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Anomalies",
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[25--[[Anomaly Scanning]]],
	ActionMenubar = "ECM.Cheats.Anomalies",
	ActionId = ".Anomaly Scanning",
	ActionIcon = "CommonAssets/UI/Menu/LightArea.tga",
	RolloverText = TranslationTable[302535920001286--[[Scan all or certain types of anomalies.]]],
	OnAction = ChoGGi.MenuFuncs.ShowScanAnomaliesOptions,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000171--[[Unlock Anomaly BreakThroughs]]],
	ActionMenubar = "ECM.Cheats.Anomalies",
	ActionId = ".Unlock Anomaly BreakThroughs",
	ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
	RolloverText = TranslationTable[302535920000173--[[Unlock any breakthroughs in anomalies (not planetary ones).]]],
	OnAction = ChoGGi.MenuFuncs.UnlockBreakthroughs,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920001394--[[Spawn Planetary Anomalies]]],
	ActionMenubar = "ECM.Cheats.Anomalies",
	ActionId = ".Spawn Planetary Anomalies",
	ActionIcon = "CommonAssets/UI/Menu/LowerTerrainToLevel.tga",
	RolloverText = TranslationTable[302535920001395--[[Adds %s locations to Planetary View.]]]:format(TranslationTable[9--[[Anomaly]]]),
	OnAction = ChoGGi.MenuFuncs.SpawnPlanetaryAnomalies,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000931--[[Spawn POIs]]],
	ActionMenubar = "ECM.Cheats.Anomalies",
	ActionId = ".Spawn POIs",
	ActionIcon = "CommonAssets/UI/Menu/DisableRMMaps.tga",
	RolloverText = TranslationTable[302535920001395--[[Adds %s locations to Planetary View.]]]:format(TranslationTable[302535920000934--[[POI]]]),
	OnAction = ChoGGi.MenuFuncs.SpawnPOIs,
}

-- menu
c = c + 1
Actions[c] = {ActionName = TranslationTable[3983--[[Disasters]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Disasters",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Disasters",
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[3983--[[Disasters]]],
	ActionMenubar = "ECM.Cheats.Disasters",
	ActionId = ".Disasters",
	ActionIcon = "CommonAssets/UI/Menu/ApplyWaterMarkers.tga",
	RolloverText = TranslationTable[302535920000334--[[Show the disasters list and optionally start one.]]],
	OnAction = ChoGGi.MenuFuncs.DisastersTrigger,
	ActionSortKey = "0",
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920001587--[[Lightning Strike]]],
	ActionMenubar = "ECM.Cheats.Disasters",
	ActionId = ".Lightning Strike",
	ActionIcon = "CommonAssets/UI/Menu/light_model.tga",
	RolloverText = TranslationTable[302535920001588--[[Strike a random pos or at mouse cursor if using shortcut.]]],
	OnAction = ChoGGi.MenuFuncs.LightningStrike,
	ActionShortcut = "Ctrl-Shift-Z",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920001086--[[Meteor Strike]]],
	ActionMenubar = "ECM.Cheats.Disasters",
	ActionId = ".Meteor Strike",
	ActionIcon = "CommonAssets/UI/Menu/FixUnderwaterEdges.tga",
	RolloverText = TranslationTable[302535920001588--[[Strike a random pos or at mouse cursor if using shortcut.]]],
	OnAction = ChoGGi.MenuFuncs.MeteorStrike,
	ActionShortcut = "Ctrl-Shift-X",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920001087--[[Missile Strike]]],
	ActionMenubar = "ECM.Cheats.Disasters",
	ActionId = ".Missile Strike",
	ActionIcon = "CommonAssets/UI/Menu/SetCamPos&Loockat.tga",
	RolloverText = TranslationTable[302535920001588--[[Strike a random pos or at mouse cursor if using shortcut.]]],
	OnAction = ChoGGi.MenuFuncs.MissileStrike,
	ActionShortcut = "Ctrl-Shift-M",
	ActionBindable = true,
}
c = c + 1
Actions[c] = {ActionName = TranslationTable[13066--[[Cave-in]]],
	ActionMenubar = "ECM.Cheats.Disasters",
	ActionId = ".Cave-in",
	ActionIcon = "CommonAssets/UI/Menu/smooth_terrain.tga",
	RolloverText = TranslationTable[302535920000484--[[Triggers cave-in at location (and disables any nearby struts).]]],
	OnAction = ChoGGi.MenuFuncs.CaveIn,
	ActionShortcut = "Ctrl-Shift-G",
	ActionBindable = true,
}
