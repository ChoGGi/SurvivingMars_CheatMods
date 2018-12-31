-- See LICENSE for terms

function OnMsg.ClassesGenerate()

	local S = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local StringFormat = string.format
	local c = #Actions

	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s %s",S[302535920001355--[[Map--]]],S[5422--[[Exploration--]]]),
		ActionMenubar = "ECM.Cheats",
		ActionId = ".Map Exploration",
		ActionIcon = "CommonAssets/UI/Menu/LightArea.tga",
		RolloverText = S[302535920000328--[[Scanning, deep scanning, core mines, and alien imprints.--]]],
		OnAction = ChoGGi.MenuFuncs.ShowScanAndMapOptions,
	}

	c = c + 1
	Actions[c] = {ActionName = S[25--[[Anomaly Scanning--]]],
		ActionMenubar = "ECM.Cheats",
		ActionId = ".Anomaly Scanning",
		ActionIcon = "CommonAssets/UI/Menu/LightArea.tga",
		RolloverText = S[302535920001286--[[Scan all or certain types of anomalies.--]]],
		OnAction = ChoGGi.MenuFuncs.ShowScanAnomaliesOptions,
	}

	c = c + 1
	Actions[c] = {ActionName = S[5661--[[Mystery Log--]]],
		ActionMenubar = "ECM.Cheats",
		ActionId = ".Mystery Log",
		ActionIcon = "CommonAssets/UI/Menu/SelectionToObjects.tga",
		RolloverText = S[302535920000330--[[Advance to next part, show what part you're on, or remove mysteries.--]]],
		OnAction = ChoGGi.MenuFuncs.ShowStartedMysteryList,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000331--[[Start Mystery--]]],
		ActionMenubar = "ECM.Cheats",
		ActionId = ".Start Mystery",
		ActionIcon = "CommonAssets/UI/Menu/SelectionToObjects.tga",
		RolloverText = S[302535920000332--[["Pick and start a mystery (with instant start option).
Certain mysteries need certain objects which get placed when the map is generated on a new game (the green rocks one for instance)."--]]],
		OnAction = ChoGGi.MenuFuncs.ShowMysteryList,
	}

	c = c + 1
	Actions[c] = {ActionName = S[3983--[[Disasters--]]],
		ActionMenubar = "ECM.Cheats",
		ActionId = ".Start Disasters",
		ActionIcon = "CommonAssets/UI/Menu/ApplyWaterMarkers.tga",
		RolloverText = S[302535920000334--[[Show the disasters list and optionally start one.--]]],
		OnAction = ChoGGi.MenuFuncs.DisastersTrigger,
	}

	c = c + 1
	Actions[c] = {ActionName = S[11412--[[Trigger fireworks--]]],
		ActionMenubar = "ECM.Cheats",
		ActionId = ".Trigger fireworks",
		ActionIcon = "CommonAssets/UI/Menu/DisableRMMaps.tga",
		RolloverText = S[302535920001402--[[Add some party to your domes for 3 hours (10 domes max).--]]],
		OnAction = TriggerFireworks,
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s %s",S[302535920000318--[[Unlock--]]],S[697482021580--[[Achievements--]]]),
		ActionMenubar = "ECM.Cheats",
		ActionId = ".Unlock Achievements",
		ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
		RolloverText = S[302535920001496--[[Show a list of achievements to unlock (permanent!).--]]],
		OnAction = ChoGGi.MenuFuncs.UnlockAchievements,
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s %s",S[302535920000266--[[Spawn--]]],S[547--[[Colonists--]]]),
		ActionMenubar = "ECM.Cheats",
		ActionId = ".Spawn Colonists",
		ActionIcon = "CommonAssets/UI/Menu/UncollectObjects.tga",
		RolloverText = S[302535920000336--[[Spawn X amount of colonists.--]]],
		OnAction = ChoGGi.MenuFuncs.SpawnColonists,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000337--[[Toggle Unlock All Buildings--]]],
		ActionMenubar = "ECM.Cheats",
		ActionId = ".Toggle Unlock all buildings",
		ActionIcon = "CommonAssets/UI/Menu/TerrainConfigEditor.tga",
		RolloverText = S[302535920000338--[["Unlocks all buildings in the build menu.
This doesn't apply to sponsor limited ones; see ECM>Buildings>Toggles>%s.
To unlock a single building: See ECM>Buildings>%s."--]]]:format(S[302535920001398--[[Remove Sponsor Limits--]]],S[302535920000180--[[Unlock Locked Buildings--]]]),
		OnAction = ChoGGi.MenuFuncs.UnlockAllBuildings_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000361--[[Unpin All Pinned Objects--]]],
		ActionMenubar = "ECM.Cheats",
		ActionId = ".Unpin All Pinned Objects",
		ActionIcon = "CommonAssets/UI/Menu/CutSceneArea.tga",
		RolloverText = S[302535920000362--[[Removes all objects from the "Pin" menu.--]]],
		OnAction = UnpinAll,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000363--[[Complete Wires & Pipes--]]],
		ActionMenubar = "ECM.Cheats",
		ActionId = ".Complete Wires & Pipes",
		ActionIcon = "CommonAssets/UI/Menu/ViewCamPath.tga",
		RolloverText = S[302535920000364--[[Complete all wires and pipes instantly.--]]],
		OnAction = CheatCompleteAllWiresAndPipes,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000365--[[Complete Constructions--]]],
		ActionMenubar = "ECM.Cheats",
		ActionId = ".Complete Constructions",
		ActionIcon = "CommonAssets/UI/Menu/place_custom_object.tga",
		RolloverText = S[302535920000366--[[Complete all constructions instantly.--]]],
		OnAction = CheatCompleteAllConstructions,
		ActionShortcut = "Alt-B",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000236--[[Mod Editor--]]],
		ActionMenubar = "ECM.Cheats",
		ActionId = ".Mod Editor",
		ActionIcon = "CommonAssets/UI/Menu/Action.tga",
		RolloverText = S[302535920000368--[[Show a list of mods to load in the mod editor.--]]],
		OnAction = ChoGGi.MenuFuncs.OpenModEditor,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001393--[[StoryBits ClearCooldowns--]]],
		ActionMenubar = "ECM.Cheats",
		ActionId = ".StoryBits ClearCooldowns",
		ActionIcon = "CommonAssets/UI/Menu/Voice.tga",
		RolloverText = S[302535920001392--[[Clears story bit cooldowns... (got me).--]]],
		OnAction = StoryBitCategoryState.ClearCooldowns,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001394--[[Spawn Planetary Anomalies--]]],
		ActionMenubar = "ECM.Cheats",
		ActionId = ".Spawn Planetary Anomalies",
		ActionIcon = "CommonAssets/UI/Menu/LowerTerrainToLevel.tga",
		RolloverText = S[302535920001395--[[Adds Anomaly locations to Planetary View.--]]],
		OnAction = ChoGGi.MenuFuncs.SpawnPlanetaryAnomalies,
	}

	local str_Cheats_Workplaces = "ECM.Cheats.Workplaces"
	c = c + 1
	Actions[c] = {ActionName = S[5444--[[Workplaces--]]],
		ActionMenubar = "ECM.Cheats",
		ActionId = ".Workplaces",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Workplaces",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000339--[[Toggle All Shifts--]]],
		ActionMenubar = str_Cheats_Workplaces,
		ActionId = ".Toggle All Shifts",
		ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
		RolloverText = S[302535920000340--[[Toggle all workshifts on or off (farms only get one on).--]]],
		OnAction = CheatToggleAllShifts,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000341--[[Update All Workplaces--]]],
		ActionMenubar = str_Cheats_Workplaces,
		ActionId = ".Update All Workplaces",
		ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
		RolloverText = S[302535920000342--[[Updates all colonist's workplaces.--]]],
		OnAction = CheatUpdateAllWorkplaces,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000343--[[Clear Forced Workplaces--]]],
		ActionMenubar = str_Cheats_Workplaces,
		ActionId = ".Clear Forced Workplaces",
		ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
		RolloverText = S[302535920000344--[["Removes ""user_forced_workplace"" from all colonists."--]]],
		OnAction = CheatClearForcedWorkplaces,
	}

	local str_Cheats_Research = "ECM.Cheats.Research"
	c = c + 1
	Actions[c] = {ActionName = S[311--[[Research--]]],
		ActionMenubar = "ECM.Cheats",
		ActionId = ".Research",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Research",
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s %s",S[311--[[Research--]]],S[3734--[[Tech--]]]),
		ActionMenubar = str_Cheats_Research,
		ActionId = ".Research Tech",
		ActionIcon = "CommonAssets/UI/Menu/ViewArea.tga",
		RolloverText = S[302535920000346--[[Pick what you want to unlock/research.--]]],
		OnAction = ChoGGi.MenuFuncs.ResearchTech,
		ActionSortKey = "-1",
	}

	c = c + 1
	Actions[c] = {ActionName = StringFormat("%s %s",S[311--[[Research--]]],S[302535920000281--[[Remove--]]]),
		ActionMenubar = str_Cheats_Research,
		ActionId = ".Research Remove",
		ActionIcon = "CommonAssets/UI/Menu/ViewArea.tga",
		RolloverText = S[302535920001494--[[Stop a tech from being researched.--]]],
		OnAction = ChoGGi.MenuFuncs.ResearchRemove,
		ActionSortKey = "-2",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001278--[[Instant Research--]]],
		ActionMenubar = str_Cheats_Research,
		ActionId = ".Instant Research",
		ActionIcon = "CommonAssets/UI/Menu/DarkSideOfTheMoon.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.InstantResearch,
				302535920001279--[[Instantly research anything you click.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.InstantResearch_toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000305--[[Research Queue Size--]]],
		ActionMenubar = str_Cheats_Research,
		ActionId = ".Research Queue Size",
		ActionIcon = "CommonAssets/UI/Menu/ShowOcclusion.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.ResearchQueueSize,
				302535920000348--[[Allow more items in queue.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.ResearchQueueSize_Set,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000349--[[Reset All Research--]]],
		ActionMenubar = str_Cheats_Research,
		ActionId = ".Reset All Research",
		ActionIcon = "CommonAssets/UI/Menu/UnlockCollection.tga",
		RolloverText = S[302535920000350--[[Resets all research (includes breakthrough tech).--]]],
		OnAction = ChoGGi.MenuFuncs.ResetAllResearch,
	}

	c = c + 1
	Actions[c] = {ActionName = S[7790--[[Research Current Tech--]]],
		ActionMenubar = str_Cheats_Research,
		ActionId = ".Research Current Tec",
		ActionIcon = "CommonAssets/UI/Menu/ViewArea.tga",
		RolloverText = S[302535920000352--[[Complete item currently being researched.--]]],
		OnAction = CheatResearchCurrent,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000295--[[Add Research Points--]]],
		ActionMenubar = str_Cheats_Research,
		ActionId = ".Add Research Points",
		ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
		RolloverText = S[302535920000354--[[Add a specified amount of research points.--]]],
		OnAction = ChoGGi.MenuFuncs.AddResearchPoints,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000355--[[Outsourcing For Free--]]],
		ActionMenubar = str_Cheats_Research,
		ActionId = ".Outsourcing For Free",
		ActionIcon = "CommonAssets/UI/Menu/pirate.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.OutsourceResearchCost,
				302535920000356--[[Outsourcing is free to purchase (over n over).--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.OutsourcingFree_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920001342--[[Change Outsource Limit--]]],
		ActionMenubar = str_Cheats_Research,
		ActionId = ".Change Outsource Limit",
		ActionIcon = "CommonAssets/UI/Menu/change_height_up.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.OutsourceMaxOrderCount,
				302535920001343--[[How many times you can outsource in a row.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.OutsourceMaxOrderCount_Set,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000357--[[Set Amount Of Breakthroughs Allowed--]]],
		ActionMenubar = str_Cheats_Research,
		ActionId = ".Set Amount Of Breakthroughs Allowed",
		ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.BreakThroughTechsPerGame,
				302535920000358--[[How many breakthroughs are allowed to be unlocked?--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.BreakThroughsAllowed_Set,
		ActionSortKey = "2Set Amount Of Breakthroughs Allowed",
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000359--[[Breakthroughs From OmegaTelescope--]]],
		ActionMenubar = str_Cheats_Research,
		ActionId = ".Breakthroughs From OmegaTelescope",
		ActionIcon = "CommonAssets/UI/Menu/AlignSel.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.OmegaTelescopeBreakthroughsCount,
				302535920000360--[[How many breakthroughs the OmegaTelescope will unlock.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.BreakThroughsOmegaTelescope,
		ActionSortKey = "2Breakthroughs From OmegaTelescope",
	}

	local str_Cheats_Menu = "ECM.Cheats.Menu"
	c = c + 1
	Actions[c] = {ActionName = S[1000162--[[Menu--]]],
		ActionMenubar = "ECM.Cheats",
		ActionId = ".Menu",
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		ActionSortKey = "1Menu",
	}
	c = c + 1
	Actions[c] = {ActionName = S[302535920000232--[[Draggable Cheats Menu--]]],
		ActionMenubar = str_Cheats_Menu,
		ActionId = ".Draggable Cheats Menu",
		ActionIcon = "CommonAssets/UI/Menu/select_objects.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.DraggableCheatsMenu,
				302535920000324--[[Cheats menu can be moved (restart to toggle).--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.DraggableCheatsMenu_Toggle,
	}

	c = c + 1
	Actions[c] = {ActionName = S[302535920000325--[[Keep Cheats Menu Position--]]],
		ActionMenubar = str_Cheats_Menu,
		ActionId = ".Keep Cheats Menu Position",
		ActionIcon = "CommonAssets/UI/Menu/LockCollection.tga",
		RolloverText = function()
			return ChoGGi.ComFuncs.SettingState(
				ChoGGi.UserSettings.KeepCheatsMenuPosition,
				302535920000326--[[This menu will stay where you drag it.--]]
			)
		end,
		OnAction = ChoGGi.MenuFuncs.KeepCheatsMenuPosition_Toggle,
	}

end
