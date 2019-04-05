-- See LICENSE for terms

local Translate = ChoGGi.ComFuncs.Translate
local Strings = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions
local c = #Actions

-- BetaBetaBeta
if LuaRevision > 240905 then
	c = c + 1
	Actions[c] = {ActionName = Translate(11719--[[Placeholder--]]),
		ActionMenubar = "ECM.Cheats",
		ActionId = ".Testering",
		ActionIcon = "CommonAssets/UI/Menu/DarkSideOfTheMoon.tga",
		RolloverText = Strings[302535920001577--[[Placeholder--]]],
		OnAction = ChoGGi.MenuFuncs.TesteringBetaBetaBeta,
	}
end

c = c + 1
Actions[c] = {ActionName = Strings[302535920001355--[[Map--]]] .. " " .. Translate(5422--[[Exploration--]]),
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Map Exploration",
	ActionIcon = "CommonAssets/UI/Menu/LightArea.tga",
	RolloverText = Strings[302535920000328--[[Scanning, deep scanning, core mines, and alien imprints.--]]],
	OnAction = ChoGGi.MenuFuncs.MapExploration,
}

c = c + 1
Actions[c] = {ActionName = Translate(25--[[Anomaly Scanning--]]),
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Anomaly Scanning",
	ActionIcon = "CommonAssets/UI/Menu/LightArea.tga",
	RolloverText = Strings[302535920001286--[[Scan all or certain types of anomalies.--]]],
	OnAction = ChoGGi.MenuFuncs.ShowScanAnomaliesOptions,
}

c = c + 1
Actions[c] = {ActionName = Translate(5661--[[Mystery Log--]]),
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Mystery Log",
	ActionIcon = "CommonAssets/UI/Menu/SelectionToObjects.tga",
	RolloverText = Strings[302535920000330--[[Advance to next part, show what part you're on, or remove mysteries.--]]],
	OnAction = ChoGGi.MenuFuncs.MysteryLog,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000331--[[Start Mystery--]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Start Mystery",
	ActionIcon = "CommonAssets/UI/Menu/SelectionToObjects.tga",
	RolloverText = Strings[302535920000332--[["Pick and start a mystery (with instant start option).
Certain mysteries need certain objects which get placed when the map is generated on a new game (the green rocks one for instance)."--]]],
	OnAction = ChoGGi.MenuFuncs.ShowMysteryList,
}

c = c + 1
Actions[c] = {ActionName = Translate(3983--[[Disasters--]]),
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Start Disasters",
	ActionIcon = "CommonAssets/UI/Menu/ApplyWaterMarkers.tga",
	RolloverText = Strings[302535920000334--[[Show the disasters list and optionally start one.--]]],
	OnAction = ChoGGi.MenuFuncs.DisastersTrigger,
}

c = c + 1
Actions[c] = {ActionName = Translate(11412--[[Trigger fireworks--]]),
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Trigger fireworks",
	ActionIcon = "CommonAssets/UI/Menu/DisableRMMaps.tga",
	RolloverText = Strings[302535920001402--[[Add some party to your domes for 3 hours (10 domes max).--]]],
	OnAction = TriggerFireworks,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000318--[[Unlock--]]] .. " " .. Translate(697482021580--[[Achievements--]]),
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Unlock Achievements",
	ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
	RolloverText = Strings[302535920001496--[[Show a list of achievements to unlock (permanent!).--]]],
	OnAction = ChoGGi.MenuFuncs.UnlockAchievements,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000266--[[Spawn--]]] .. " " .. Translate(547--[[Colonists--]]),
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Spawn Colonists",
	ActionIcon = "CommonAssets/UI/Menu/UncollectObjects.tga",
	RolloverText = Strings[302535920000336--[[Spawn X amount of colonists.--]]],
	OnAction = ChoGGi.MenuFuncs.SpawnColonists,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000337--[[Toggle Unlock All Buildings--]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Toggle Unlock all buildings",
	ActionIcon = "CommonAssets/UI/Menu/TerrainConfigEditor.tga",
	RolloverText = Strings[302535920000338--[["Unlocks all buildings in the build menu.
This doesn't apply to sponsor limited ones; see ECM>Buildings>Toggles>%s.
To unlock a single building: See ECM>Buildings>%s."--]]]:format(Strings[302535920001398--[[Remove Sponsor Limits--]]],Strings[302535920000180--[[Unlock Locked Buildings--]]]),
	OnAction = ChoGGi.MenuFuncs.UnlockAllBuildings_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000361--[[Unpin All Pinned Objects--]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Unpin All Pinned Objects",
	ActionIcon = "CommonAssets/UI/Menu/CutSceneArea.tga",
	RolloverText = Strings[302535920000362--[[Removes all objects from the "Pin" menu.--]]],
	OnAction = UnpinAll,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000363--[[Complete Wires & Pipes--]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Complete Wires & Pipes",
	ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
	RolloverText = Strings[302535920000364--[[Complete all wires and pipes instantly.--]]],
	OnAction = CheatCompleteAllWiresAndPipes,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000365--[[Complete Constructions--]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Complete Constructions",
	ActionIcon = "CommonAssets/UI/Menu/place_custom_object.tga",
	RolloverText = Strings[302535920000366--[[Complete all constructions instantly.--]]],
	OnAction = ChoGGi.MenuFuncs.CompleteConstructions,
	ActionShortcut = "Alt-B",
	ActionBindable = true,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000236--[[Mod Editor--]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Mod Editor",
	ActionIcon = "CommonAssets/UI/Menu/Action.tga",
	RolloverText = Strings[302535920000368--[[Open the mod editor.--]]],
	OnAction = ChoGGi.MenuFuncs.OpenModEditor,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001394--[[Spawn Planetary Anomalies--]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Spawn Planetary Anomalies",
	ActionIcon = "CommonAssets/UI/Menu/LowerTerrainToLevel.tga",
	RolloverText = Strings[302535920001395--[[Adds Anomaly locations to Planetary View.--]]],
	OnAction = ChoGGi.MenuFuncs.SpawnPlanetaryAnomalies,
}

-- menu
c = c + 1
Actions[c] = {ActionName = Translate(311--[[Research--]]),
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Research",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Research",
}

c = c + 1
Actions[c] = {ActionName = Translate(311--[[Research--]]) .. " / " .. Strings[302535920000318--[[Unlock--]]] .. " " .. Translate(3734--[[Tech--]]),
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Research / Unlock Tech",
	ActionIcon = "CommonAssets/UI/Menu/ViewArea.tga",
	RolloverText = Strings[302535920000346--[[Pick what you want to unlock/research (defaults to unlock).--]]],
	OnAction = ChoGGi.MenuFuncs.ResearchTech,
	ActionSortKey = "-1",
}

c = c + 1
Actions[c] = {ActionName = Translate(311--[[Research--]]) .. " " .. Strings[302535920000281--[[Remove--]]],
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Research Remove",
	ActionIcon = "CommonAssets/UI/Menu/ViewArea.tga",
	RolloverText = Strings[302535920001494--[[Remove a tech from researched list.--]]],
	OnAction = ChoGGi.MenuFuncs.ResearchRemove,
	ActionSortKey = "-2",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001278--[[Instant Research--]]],
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Instant Research",
	ActionIcon = "CommonAssets/UI/Menu/DarkSideOfTheMoon.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.InstantResearch,
			Strings[302535920001279--[[Instantly research anything you click.--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.InstantResearch_toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000305--[[Research Queue Size--]]],
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Research Queue Size",
	ActionIcon = "CommonAssets/UI/Menu/ShowOcclusion.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.ResearchQueueSize,
			Strings[302535920000348--[[Allow more items in queue.--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.ResearchQueueSize_Set,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000349--[[Reset All Research--]]],
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Reset All Research",
	ActionIcon = "CommonAssets/UI/Menu/UnlockCollection.tga",
	RolloverText = Strings[302535920000350--[[Resets all research (includes breakthrough tech).--]]],
	OnAction = ChoGGi.MenuFuncs.ResetAllResearch,
}

c = c + 1
Actions[c] = {ActionName = Translate(7790--[[Research Current Tech--]]),
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Research Current Tec",
	ActionIcon = "CommonAssets/UI/Menu/ViewArea.tga",
	RolloverText = Strings[302535920000352--[[Complete item currently being researched.--]]],
	OnAction = CheatResearchCurrent,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000295--[[Add Research Points--]]],
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Add Research Points",
	ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
	RolloverText = Strings[302535920000354--[[Add a specified amount of research points.--]]],
	OnAction = ChoGGi.MenuFuncs.AddResearchPoints,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000355--[[Outsourcing For Free--]]],
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Outsourcing For Free",
	ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.OutsourceResearchCost,
			Strings[302535920000356--[[Outsourcing is free to purchase (over n over).--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.OutsourcingFree_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001342--[[Change Outsource Limit--]]],
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Change Outsource Limit",
	ActionIcon = "CommonAssets/UI/Menu/change_height_up.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.OutsourceMaxOrderCount,
			Strings[302535920001343--[[How many times you can outsource in a row.--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.OutsourceMaxOrderCount_Set,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000357--[[Set Amount Of Breakthroughs Allowed--]]],
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Set Amount Of Breakthroughs Allowed",
	ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.BreakThroughTechsPerGame,
			Strings[302535920000358--[[How many breakthroughs are allowed to be unlocked?--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.BreakThroughsAllowed_Set,
	ActionSortKey = "2Set Amount Of Breakthroughs Allowed",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000359--[[Breakthroughs From OmegaTelescope--]]],
	ActionMenubar = "ECM.Cheats.Research",
	ActionId = ".Breakthroughs From OmegaTelescope",
	ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.OmegaTelescopeBreakthroughsCount,
			Strings[302535920000360--[[How many breakthroughs the OmegaTelescope will unlock.--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.BreakThroughsOmegaTelescope_Set,
	ActionSortKey = "2Breakthroughs From OmegaTelescope",
}

-- menu
c = c + 1
Actions[c] = {ActionName = Translate(1000162--[[Menu--]]),
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Menu",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Menu",
}
c = c + 1
Actions[c] = {ActionName = Strings[302535920000232--[[Draggable Cheats Menu--]]],
	ActionMenubar = "ECM.Cheats.Menu",
	ActionId = ".Draggable Cheats Menu",
	ActionIcon = "CommonAssets/UI/Menu/select_objects.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.DraggableCheatsMenu,
			Strings[302535920000324--[[Cheats menu can be moved.--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.DraggableCheatsMenu_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000325--[[Keep Cheats Menu Position--]]],
	ActionMenubar = "ECM.Cheats.Menu",
	ActionId = ".Keep Cheats Menu Position",
	ActionIcon = "CommonAssets/UI/Menu/LockCollection.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.KeepCheatsMenuPosition,
			Strings[302535920000326--[[This menu will stay where you drag it.--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.KeepCheatsMenuPosition_Toggle,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001014--[[Hide Cheats Menu--]]],
	ActionMenubar = "ECM.Cheats.Menu",
	ActionId = ".Hide Cheats Menu",
	ActionIcon = "CommonAssets/UI/Menu/ToggleEnvMap.tga",
	RolloverText = Strings[302535920001019--[[This will hide the Cheats menu; Use F2 to see it again.--]]],
	OnAction = ChoGGi.ComFuncs.CheatsMenu_Toggle,
	ActionShortcut = "F2",
	ActionBindable = true,
	ActionSortKey = "-1Hide Cheats Menu",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000696--[[Infopanel Cheats--]]],
	ActionMenubar = "ECM.Cheats.Menu",
	ActionId = ".Infopanel Cheats",
	ActionIcon = "CommonAssets/UI/Menu/toggle_dtm_slots.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.ToggleInfopanelCheats,
			Strings[302535920000697--[[Shows the cheat pane in the info panel (selection panel).--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.InfopanelCheats_Toggle,
	ActionShortcut = "Ctrl-F2",
	ActionBindable = true,
	ActionSortKey = "-1Infopanel Cheats",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920000698--[[Infopanel Cheats Cleanup--]]],
	ActionMenubar = "ECM.Cheats.Menu",
	ActionId = ".Infopanel Cheats Cleanup",
	ActionIcon = "CommonAssets/UI/Menu/toggle_dtm_slots.tga",
	RolloverText = function()
		return ChoGGi.ComFuncs.SettingState(
			ChoGGi.UserSettings.CleanupCheatsInfoPane,
			Strings[302535920000699--[[Remove some entries from the cheat pane (restart to re-enable).

AddMaintenancePnts, MakeSphereTarget, SpawnWorker, SpawnVisitor--]]]
		)
	end,
	OnAction = ChoGGi.MenuFuncs.InfopanelCheatsCleanup_Toggle,
	ActionSortKey = "-1Infopanel Cheats Cleanup",
}

-- menu
c = c + 1
Actions[c] = {ActionName = Translate(948928900281--[[Story Bits--]]),
	ActionMenubar = "ECM.Cheats",
	ActionId = ".StoryBits",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1StoryBits",
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001393--[[Clear Cooldowns--]]],
	ActionMenubar = "ECM.Cheats.StoryBits",
	ActionId = ".StoryBits ClearCooldowns",
	ActionIcon = "CommonAssets/UI/Menu/DisablePostprocess.tga",
	RolloverText = Strings[302535920001392--[[Sets story.cooldown_end to GameTime.--]]],
	OnAction = StoryBitCategoryState.ClearCooldowns,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001580--[[Interrupt Supression Times--]]],
	ActionMenubar = "ECM.Cheats.StoryBits",
	ActionId = ".Interrupt Supression Times",
	ActionIcon = "CommonAssets/UI/Menu/Action.tga",
	RolloverText = Strings[302535920001581--[[Sets story.time_created to -SuppressTime.--]]],
	OnAction = InterruptStoryBitSupressionTimes,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001582--[[Testing Toggle--]]],
	ActionMenubar = "ECM.Cheats.StoryBits",
	ActionId = ".Testing Toggle",
	ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
	RolloverText = Strings[302535920001583--[[Toggles g_StoryBitTesting.--]]],
	OnAction = ToggleStoryBitTesting,
}

c = c + 1
Actions[c] = {ActionName = Strings[302535920001584--[[Testing Delete Backlog--]]],
	ActionMenubar = "ECM.Cheats.StoryBits",
	ActionId = ".Testing Delete Backlog",
	ActionIcon = "CommonAssets/UI/Menu/DelCamera.tga",
	RolloverText = Strings[302535920001585--[[Sets AccountStorage.StoryBitTimestamp to nil.--]]],
	OnAction = DeleteStoryBitTestingBacklog,
}
