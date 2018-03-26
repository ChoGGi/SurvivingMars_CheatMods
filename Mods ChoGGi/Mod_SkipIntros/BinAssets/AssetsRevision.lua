function OnMsg.DesktopCreated()
  --skip the two logos
  PlayInitialMovies = nil
end

function OnMsg.ReloadLua()
  --opens load game menu, uncomment to enable
  --[[
  CreateRealTimeThread(function()
    OpenPreGameMainMenu("Load")
  end)
  --]]

  --get rid of some of those mod manager warnings (not the reboot prompt)
  ParadoxBuildsModEditorWarning = true
  ParadoxBuildsModManagerWarning = true
end

--return fake revision, 1 seems to work fine
return 1

--[[uncomment to print to the log when these happen
function OnMsg.AccountStorageChanged()
	DebugPrint("INFO_AccountStorageChanged\n")
end
function OnMsg.AchievementUnlocked(xplayer, achievement)
	DebugPrint("INFO_AchievementUnlocked\n")
end
function OnMsg.AfterLightmodelChange()
	DebugPrint("INFO_AfterLightmodelChange\n")
end
function OnMsg.AnomalyRevealed(anomaly) --fired when an anomaly has been releaved.
	DebugPrint("INFO_AnomalyRevealed\n")
end
function OnMsg.AnomalyAnalyzed(anomaly) --fired when a new anomaly has been completely analized.
	DebugPrint("INFO_AnomalyAnalyzed\n")
end
function OnMsg.ApplicationQuit(result)
	DebugPrint("INFO_ApplicationQuit\n")
end
function OnMsg.AssetsLoaded()
	DebugPrint("INFO_AssetsLoaded\n")
end
function OnMsg.Autorun()
	DebugPrint("INFO_Autorun\n")
end
function OnMsg.BinAssetsLoaded()
	DebugPrint("INFO_BinAssetsLoaded\n")
end
function OnMsg.BugReportStart(print_func)
	DebugPrint("INFO_BugReportStart\n")
end
function OnMsg.BuildingPlaced(bld)
	DebugPrint("INFO_BuildingPlaced\n")
end
function OnMsg.BuildingUpgraded(building, upgrade_id)
	DebugPrint("INFO_BuildingUpgraded\n")
end
function OnMsg.CameraTransitionStart(eye, lookat, transition_time)
	DebugPrint("INFO_CameraTransitionStart\n")
end
function OnMsg.ChangeMap(map) --message fired when a new map loading beggins
	DebugPrint("INFO_ChangeMap\n")
end
function OnMsg.ChangeMapDone(map)
	DebugPrint("INFO_ChangeMapDone\n")
end
function OnMsg.Chat(name, account_id, message)
	DebugPrint("INFO_Chat\n")
end
function OnMsg.CityStart()
	DebugPrint("INFO_CityStart\n")
end
function OnMsg.ClassesBuilt() --use this message to perform post-built actions on the final classes
	DebugPrint("INFO_ClassesBuilt\n")
end
function OnMsg.ClassesGenerate(classdefs) --use this message to mess with the classdefs (before classes are built)
	DebugPrint("INFO_ClassesGenerate\n")
end
function OnMsg.ClassesPostprocess() --use this message to make modifications to the built classes (before they are declared final)
	DebugPrint("INFO_ClassesPostprocess\n")
end
function OnMsg.ClassesPreprocess(classdefs) --use this message to do some processing to the already final classdefs (still before classes are built)
	DebugPrint("INFO_ClassesPreprocess\n")
end
function OnMsg.ColdWave()
	DebugPrint("INFO_ColdWave\n")
end
function OnMsg.ColdWaveEnded()
	DebugPrint("INFO_ColdWaveEnded\n")
end
function OnMsg.ColonistAddTrait(colonist, trait_id, init)
	DebugPrint("INFO_ColonistAddTrait\n")
end
function OnMsg.ColonistArrived(colonist) --fired when a colonist has arrived on Mars with a rocket.
	DebugPrint("INFO_ColonistArrived\n")
end
function OnMsg.ColonistBorn(colonist, event) --fired when a colonist has been born/cloned/reborn/spawned/...
	DebugPrint("INFO_ColonistBorn\n")
end
function OnMsg.ColonistCured(colonist, bld)
	DebugPrint("INFO_ColonistCured\n")
end
function OnMsg.ColonistDied(colonist, reason) --fired when a colonist has died.
	DebugPrint("INFO_ColonistDied\n")
end
function OnMsg.ColonistJoinsDome(colonist, dome)
	DebugPrint("INFO_ColonistJoinsDome\n")
end
function OnMsg.ColonistLeavingMars(colonist, rocket)
	DebugPrint("INFO_ColonistLeavingMars\n")
end
function OnMsg.ColonistStatusEffect(colonist, status_effect, bApply, now)
	DebugPrint("INFO_ColonistStatusEffect\n")
end
function OnMsg.ColonyApprovalPassed() --fired when the Founder Stage has been passed successfully.
	DebugPrint("INFO_ColonyApprovalPassed\n")
end
function OnMsg.ConsoleLine(text, bNewLine)
	DebugPrint("INFO_ConsoleLine\n")
end
function OnMsg.ConstructionComplete(building) --fired when the construction of a building is complete
	DebugPrint("INFO_ConstructionComplete\n")
end
function OnMsg.ConstructionSitePlaced(site)
	DebugPrint("INFO_ConstructionSitePlaced\n")
end
function OnMsg.ConstValueChanged(prop, old_value, new_value)
	DebugPrint("INFO_ConstValueChanged\n")
end
function OnMsg.ContentUpdate(def, description)
	DebugPrint("INFO_ContentUpdate\n")
end
function OnMsg.DataLoaded()
	DebugPrint("INFO_DataLoaded\n")
end
function OnMsg.DataLoading()
	DebugPrint("INFO_DataLoading\n")
end
function OnMsg.DebuggerBreak()
	DebugPrint("INFO_DebuggerBreak\n")
end
function OnMsg.DeleteSequenceAction()
	DebugPrint("INFO_DeleteSequenceAction\n")
end
function OnMsg.Demolished(obj)
	DebugPrint("INFO_Demolished\n")
end
function OnMsg.DepositsSpawned()
	DebugPrint("INFO_DepositsSpawned\n")
end
function OnMsg.DesignerWindowMode(window)
	DebugPrint("INFO_DesignerWindowMode\n")
end
function OnMsg.DesktopCreated()
	DebugPrint("INFO_DesktopCreated\n")
end
function OnMsg.DeveloperOptionsChanged(storage, name, id, value)
	DebugPrint("INFO_DeveloperOptionsChanged\n")
end
function OnMsg.DeviceChanged()
	DebugPrint("INFO_DeviceChanged\n")
end
function OnMsg.DlcsLoaded()
	DebugPrint("INFO_DlcsLoaded\n")
end
function OnMsg.DoneMap()
	DebugPrint("INFO_DoneMap\n")
end
function OnMsg.DurangoAppStateChanged()
	DebugPrint("INFO_DurangoAppStateChanged\n")
end
function OnMsg.DurangoNewDLCReady()
	DebugPrint("INFO_DurangoNewDLCReady\n")
end
function OnMsg.DustStorm()
	DebugPrint("INFO_DustStorm\n")
end
function OnMsg.DustStormEnded()
	DebugPrint("INFO_DustStormEnded\n")
end
function OnMsg.EditOpsChanged()
	DebugPrint("INFO_EditOpsChanged\n")
end
function OnMsg.EditorCallback(id, objects, ...)
	DebugPrint("INFO_EditorCallback\n")
end
function OnMsg.EditorSelectionChanged()
	DebugPrint("INFO_EditorSelectionChanged\n")
end
function OnMsg.EditorSelectionChanged(objects)
	DebugPrint("INFO_EditorSelectionChanged\n")
end
function OnMsg.EngineOptionsSaved()
	DebugPrint("INFO_EngineOptionsSaved\n")
end
function OnMsg.EntitiesLoaded()
	DebugPrint("INFO_EntitiesLoaded\n")
end
function OnMsg.FoodProduced(bld, amount)
	DebugPrint("INFO_FoodProduced\n")
end
function OnMsg.FriendsChange(friends, friend_names, event)
	DebugPrint("INFO_FriendsChange\n")
end
function OnMsg.FundingChanged(city, amount)
	DebugPrint("INFO_FundingChanged\n")
end
function OnMsg.GameEnterEditor()
	DebugPrint("INFO_GameEnterEditor\n")
end
function OnMsg.GameExitEditor()
	DebugPrint("INFO_GameExitEditor\n")
end
function OnMsg.GamepadUIStyleChanged()
	DebugPrint("INFO_GamepadUIStyleChanged\n")
end
function OnMsg.GameStateChanged(changed)
	DebugPrint("INFO_GameStateChanged\n")
end
function OnMsg.GameStateChangedNotify()
	DebugPrint("INFO_GameStateChangedNotify\n")
end
function OnMsg.GameTimeStart()
	DebugPrint("INFO_GameTimeStart\n")
end
function OnMsg.GatherFXActions(list)
	DebugPrint("INFO_GatherFXActions\n")
end
function OnMsg.GatherFXActors(list)
	DebugPrint("INFO_GatherFXActors\n")
end
function OnMsg.GatherFXMoments(list)
	DebugPrint("INFO_GatherFXMoments\n")
end
function OnMsg.GatherFXTargets(list)
	DebugPrint("INFO_GatherFXTargets\n")
end
function OnMsg.GatherLabels(labels)
	DebugPrint("INFO_GatherLabels\n")
end
function OnMsg.GedClosed(ged_id)
	DebugPrint("INFO_GedClosed\n")
end
function OnMsg.GedOpened(ged_id)
	DebugPrint("INFO_GedOpened\n")
end
function OnMsg.GedPropertyEdited(ged_id, obj, prop_id, old_value)
	DebugPrint("INFO_GedPropertyEdited\n")
end
function OnMsg.HexShapesRebuilt()
	DebugPrint("INFO_HexShapesRebuilt\n")
end
function OnMsg.IncomingMissile(missile)
	DebugPrint("INFO_IncomingMissile\n")
end
function OnMsg.InGameInterfaceCreated()
	DebugPrint("INFO_InGameInterfaceCreated\n")
end
function OnMsg.LightmodelChange(view, lm, time, prev_lm)
	DebugPrint("INFO_LightmodelChange\n")
end
function OnMsg.LightmodelNightChange(view, lm, time, prev_lm)
	DebugPrint("INFO_LightmodelNightChange\n")
end
function OnMsg.LightmodelRainChange(view, lm, time, prev_lm)
	DebugPrint("INFO_LightmodelRainChange\n")
end
function OnMsg.LoadGame(metadata) --fired after a game has been loaded.
	DebugPrint("INFO_LoadGame\n")
end
function OnMsg.LoadingScreenPreClose()
	DebugPrint("INFO_LoadingScreenPreClose\n")
end
function OnMsg.LocalStorageChanged()
	DebugPrint("INFO_LocalStorageChanged\n")
end
function OnMsg.MapDataLoaded()
	DebugPrint("INFO_MapDataLoaded\n")
end
function OnMsg.MarkersChanged()
	DebugPrint("INFO_MarkersChanged\n")
end
function OnMsg.MarkersRebuildStart()
	DebugPrint("INFO_MarkersRebuildStart\n")
end
function OnMsg.MarkPreciousMetalsExport(city, amount)
	DebugPrint("INFO_MarkPreciousMetalsExport\n")
end
function OnMsg.MarsPause()
	DebugPrint("INFO_MarsPause\n")
end
function OnMsg.MarsResume()
	DebugPrint("INFO_MarsResume\n")
end
function OnMsg.Meteor(meteor)
	DebugPrint("INFO_Meteor\n")
end
function OnMsg.MeteorIntercepted(meteor, shooter)
	DebugPrint("INFO_MeteorIntercepted\n")
end
function OnMsg.MeteorStorm()
	DebugPrint("INFO_MeteorStorm\n")
end
function OnMsg.ModsLoaded()
	DebugPrint("INFO_ModsLoaded\n")
end
function OnMsg.MoraleChanged(colonist)
	DebugPrint("INFO_MoraleChanged\n")
end
function OnMsg.MoveSequenceAction()
	DebugPrint("INFO_MoveSequenceAction\n")
end
function OnMsg.MsgPreControllersAssign()
	DebugPrint("INFO_MsgPreControllersAssign\n")
end
function OnMsg.Mystery8_BeginHealing()
	DebugPrint("INFO_Mystery8_BeginHealing\n")
end
function OnMsg.MysteryBegin()
	DebugPrint("INFO_MysteryBegin\n")
end
function OnMsg.MysteryChosen()
	DebugPrint("INFO_MysteryChosen\n")
end
function OnMsg.MysteryEnd(outcome)
	DebugPrint("INFO_MysteryEnd\n")
end
function OnMsg.NetConnect()
	DebugPrint("INFO_NetConnect\n")
end
function OnMsg.NetDisconnect()
	DebugPrint("INFO_NetDisconnect\n")
end
function OnMsg.NetGameInfo(info)
	DebugPrint("INFO_NetGameInfo\n")
end
function OnMsg.NetGameJoined(game_id, player_id)
	DebugPrint("INFO_NetGameJoined\n")
end
function OnMsg.NetGameLeft()
	DebugPrint("INFO_NetGameLeft\n")
end
function OnMsg.NetPing(server_time)
	DebugPrint("INFO_NetPing\n")
end
function OnMsg.NetPlayerInfo(player, info)
	DebugPrint("INFO_NetPlayerInfo\n")
end
function OnMsg.NetPlayerJoin(player)
	DebugPrint("INFO_NetPlayerJoin\n")
end
function OnMsg.NetPlayerLeft(player, reason)
	DebugPrint("INFO_NetPlayerLeft\n")
end
function OnMsg.NetStats()
	DebugPrint("INFO_NetStats\n")
end
function OnMsg.NewDay(day) --fired every Sol.
	DebugPrint("INFO_NewDay\n")
end
function OnMsg.NewHour(hour) --fired every GameTime hour.
	DebugPrint("INFO_NewHour\n")
end
function OnMsg.NewMap()
	DebugPrint("INFO_NewMap\n")
end
function OnMsg.NewMapLoaded() --fired after a new map has been loaded
	DebugPrint("INFO_NewMapLoaded\n")
end
function OnMsg.NewMinute(hour, minute)
	DebugPrint("INFO_NewMinute\n")
end
function OnMsg.NewSequenceAction()
	DebugPrint("INFO_NewSequenceAction\n")
end
function OnMsg.NewWorkshift(workshift)
	DebugPrint("INFO_NewWorkshift\n")
end
function OnMsg.ObjModified(obj)
	DebugPrint("INFO_ObjModified\n")
end
function OnMsg.OnRender()
	DebugPrint("INFO_OnRender\n")
end
function OnMsg.OnScreenHintChanged(hint)
	DebugPrint("INFO_OnScreenHintChanged\n")
end
function OnMsg.OnSetWorking(building, working) --fired when a buildings working state has been changed.
	DebugPrint("INFO_OnSetWorking\n")
end
function OnMsg.OnXInputControllerConnected(controller)
	DebugPrint("INFO_OnXInputControllerConnected\n")
end
function OnMsg.OnXInputControllerDisconnected(controller)
	DebugPrint("INFO_OnXInputControllerDisconnected\n")
end
function OnMsg.OptionsApply()
	DebugPrint("INFO_OptionsApply\n")
end
function OnMsg.OptionsChanged()
	DebugPrint("INFO_OptionsChanged\n")
end
function OnMsg.Pause()
	DebugPrint("INFO_Pause\n")
end
function OnMsg.PersistGatherPermanents(permanents, direction)
	DebugPrint("INFO_PersistGatherPermanents\n")
end
function OnMsg.PersistLoad(data) --This message is sent during the savegame loading process. data is the deserialized table that was built during saving by the PersistSave message handlers - get anything you have placed in it.
	DebugPrint("INFO_PersistLoad\n")
end
function OnMsg.PersistPostLoad()
	DebugPrint("INFO_PersistPostLoad\n")
end
function OnMsg.PersistSave(data) --This message is sent during the savegame creation process. data is a table, which will be serialized as part of the savegame - add anything you need saved to it.
	DebugPrint("INFO_PersistSave\n")
end
function OnMsg.PopsAccountDetailsRetrieved()
	DebugPrint("INFO_PopsAccountDetailsRetrieved\n")
end
function OnMsg.PopsAutoLoginFailed()
	DebugPrint("INFO_PopsAutoLoginFailed\n")
end
function OnMsg.PopsLogin()
	DebugPrint("INFO_PopsLogin\n")
end
function OnMsg.PopsLogout()
	DebugPrint("INFO_PopsLogout\n")
end
function OnMsg.PopsOwnedProductsChanged()
	DebugPrint("INFO_PopsOwnedProductsChanged\n")
end
function OnMsg.PopsSyncPop(reload_savegames)
	DebugPrint("INFO_PopsSyncPop\n")
end
function OnMsg.PostDoneMap()
	DebugPrint("INFO_PostDoneMap\n")
end
function OnMsg.PostNewMapLoaded()
	DebugPrint("INFO_PostNewMapLoaded\n")
end
function OnMsg.PostSaveMap()
	DebugPrint("INFO_PostSaveMap\n")
end
function OnMsg.PrefabMarkersChanged()
	DebugPrint("INFO_PrefabMarkersChanged\n")
end
function OnMsg.PreLoadGame() --fired before a game is loaded.
	DebugPrint("INFO_PreLoadGame\n")
end
function OnMsg.PreNewMap()
	DebugPrint("INFO_PreNewMap\n")
end
function OnMsg.PreSaveMap()
	DebugPrint("INFO_PreSaveMap\n")
end
function OnMsg.PresetSave()
	DebugPrint("INFO_PresetSave\n")
end
function OnMsg.PropEditor_ContextChanged(old_context_obj, new_context_obj, window_id, view)
	DebugPrint("INFO_PropEditor_ContextChanged\n")
end
function OnMsg.PropEditor_ObjectModified(main_obj, object, prop_id, old_value)
	DebugPrint("INFO_PropEditor_ObjectModified\n")
end
function OnMsg.PropEditor_WindowClosed(main_obj, closed_window_id)
	DebugPrint("INFO_PropEditor_WindowClosed\n")
end
function OnMsg.ReloadLua()
	DebugPrint("INFO_ReloadLua\n")
end
function OnMsg.ReloadSoundData()
	DebugPrint("INFO_ReloadSoundData\n")
end
function OnMsg.ResearchQueueChange(city, tech_id)
	DebugPrint("INFO_ResearchQueueChange\n")
end
function OnMsg.ResourceExtracted(resource, amount)
	DebugPrint("INFO_ResourceExtracted\n")
end
function OnMsg.Resume()
	DebugPrint("INFO_Resume\n")
end
function OnMsg.RocketLanded(rocket) --fired when a rocket has landed on Mars.
	DebugPrint("INFO_RocketLanded\n")
end
function OnMsg.RocketLaunched(rocket)
	DebugPrint("INFO_RocketLaunched\n")
end
function OnMsg.SafeAreaMarginsChanged()
	DebugPrint("INFO_SafeAreaMarginsChanged\n")
end
function OnMsg.SaveGame() --fired before the game is saved.
	DebugPrint("INFO_SaveGame\n")
end
function OnMsg.SaveMap()
	DebugPrint("INFO_SaveMap\n")
end
function OnMsg.SceneStarted(scene, scene_player)
	DebugPrint("INFO_SceneStarted\n")
end
function OnMsg.SceneStopped(scene, scene_player, bStarting)
	DebugPrint("INFO_SceneStopped\n")
end
function OnMsg.SectorScanned(status, col, row)
	DebugPrint("INFO_SectorScanned\n")
end
function OnMsg.SelectedObjChange(obj, prev) --fired when the user changes the selected object.
	DebugPrint("INFO_SelectedObjChange\n")
end
function OnMsg.SelectionAdded(obj)
	DebugPrint("INFO_SelectionAdded\n")
end
function OnMsg.SelectionChange()
	DebugPrint("INFO_SelectionChange\n")
end
function OnMsg.SelectionRemoved(obj)
	DebugPrint("INFO_SelectionRemoved\n")
end
function OnMsg.SequenceListPlayerStart(player)
	DebugPrint("INFO_SequenceListPlayerStart\n")
end
function OnMsg.SequenceListPlayerStop(player)
	DebugPrint("INFO_SequenceListPlayerStop\n")
end
function OnMsg.SequenceStop(player, seq_name)
	DebugPrint("INFO_SequenceStop\n")
end
function OnMsg.ShortcutsReloaded()
	DebugPrint("INFO_ShortcutsReloaded\n")
end
function OnMsg.Start()
	DebugPrint("INFO_Start\n")
end
function OnMsg.StartAcceptingInvites()
	DebugPrint("INFO_StartAcceptingInvites\n")
end
function OnMsg.SunChange()
	DebugPrint("INFO_SunChange\n")
end
function OnMsg.SysChat(message, ...)
	DebugPrint("INFO_SysChat\n")
end
function OnMsg.SystemActivate()
	DebugPrint("INFO_SystemActivate\n")
end
function OnMsg.SystemInactivate()
	DebugPrint("INFO_SystemInactivate\n")
end
function OnMsg.SystemSize(pt)
	DebugPrint("INFO_SystemSize\n")
end
function OnMsg.TechResearched(tech_id, city, first_time) --fired when a tech has been researched.
	DebugPrint("INFO_TechResearched\n")
end
function OnMsg.TextParamsChanged(text_params)
	DebugPrint("INFO_TextParamsChanged\n")
end
function OnMsg.TranslationChanged()
	DebugPrint("INFO_TranslationChanged\n")
end
function OnMsg.UASetMode()
	DebugPrint("INFO_UASetMode\n")
end
function OnMsg.UIModeChange(mode)
	DebugPrint("INFO_UIModeChange\n")
end
function OnMsg.UIPropertyChanged(obj, prop_id)
	DebugPrint("INFO_UIPropertyChanged\n")
end
function OnMsg.Whisper(name, id, message)
	DebugPrint("INFO_Whisper\n")
end
function OnMsg.XInputInited()
	DebugPrint("INFO_XInputInited\n")
end
function OnMsg.XInputInitialized()
	DebugPrint("INFO_XInputInitialized\n")
end
function OnMsg.XTemplatesLoaded()
	DebugPrint("INFO_XTemplatesLoaded\n")
end
function OnMsg.XWindowModified(win, child, leaving)
	DebugPrint("INFO_XWindowModified\n")
end
--]]