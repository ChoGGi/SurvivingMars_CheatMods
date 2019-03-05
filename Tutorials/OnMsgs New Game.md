### "New Game"
##### last updated Tereshkhova (240905), for current use [OnMsg Print](https://github.com/ChoGGi/SurvivingMars_CheatMods/tree/master/Mods%20ChoGGi/OnMsg%20Print)

##### Show a list of OnMsgs/WaitMsgs that are waiting for Msgs (you need ECM for ex).
```lua
ex(GetHandledMsg(true))
```

##### Show a list of functions in the order they will be called when an OnMsg is fired
```lua
local _,v = debug.getupvalue(getmetatable(OnMsg).__newindex,1)
ex(v)
```

##### Tabs denote repetition of Msg. They could also be repeated later on in the game, but this list is during loading.
##### () on the end means the msg has arguments (this list is for the order), to see args use OnMsg Print
##### Parts of the log are also included to get an idea of when the Msgs fire
```lua
Reloading lua files
*Mod starts loading (Code/Script.lua)*
	Msg.BeforeClearEntityData
	Msg.ClassesGenerate ()
	Msg.ClassesPreprocess ()
	Msg.ClassesPostprocess
	Msg.GetCustomFXInheritActorRules ()
	Msg.RegisterTriggers ()
	Msg.ClassesBuilt
	Msg.ApplyAccountOptions
	Msg.ControlSchemeChanged
	Msg.OptionsApply
	Msg.ControlSchemeChanged
	Msg.Autorun
Reloading done
[mod] Loading OnMsg Print v0.3(id ChoGGi_OnMsgPrint, version 3) items from AppData/Mods/OnMsg Print/
	Msg.ModsReloaded
	Msg.HexShapesRebuilt
	Msg.EntitiesLoaded
	Msg.ShortcutsReloaded
	Msg.BinAssetsLoaded
	Msg.ShortcutsReloaded
Msg.ParadoxFeedLoaded
	Msg.PreNewMap
	Msg.LightmodelNightChange ()
	Msg.LightmodelRainChange ()
	Msg.LightmodelChange ()
	Msg.AfterLightmodelChange ()
	Msg.NewMap
	Msg.BuildableGridReady
	Msg.NewMapLoaded
	Msg.PostNewMapLoaded
	Msg.GameTimeStart
	Msg.ChangeMapDone ()
	Msg.ResumeInviteChecks
Map changed to "PreGame" in 8962 ms.
Msg.PopsLogin ()
	Msg.LightmodelChange ()
	Msg.AfterLightmodelChange ()
	Msg.GameStateChanged ()
	Msg.Resume ()
	Msg.LoadingScreenPreClose
	Msg.GameStateChangedNotify
	Msg.PlanetCameraSet
*Select screen 1*
Msg.PopsTelemetrySetEnabled
Msg.PopsOwnedProductsChanged
	Msg.LightmodelChange ()
	Msg.AfterLightmodelChange ()
	Msg.LightmodelChange ()
	Msg.AfterLightmodelChange ()
	Msg.PlanetCameraSet
*Select screen 2*
	Msg.LightmodelChange ()
	Msg.AfterLightmodelChange ()
	Msg.LightmodelChange ()
	Msg.AfterLightmodelChange ()
	Msg.PlanetCameraSet
*Select screen 3*
	Msg.GameStateChanged ()
	Msg.Pause ()
	Msg.GameStateChanged ()
	Msg.GameStateChangedNotify
Changing map to "BlankBigTerraceCMix_03"
Msg.ChangeMap ()
	Msg.LightmodelChange ()
	Msg.AfterLightmodelChange ()
Msg.DoneMap
Msg.PostDoneMap
	Msg.PlanetCameraSet

Reloading lua files
Msg.ReloadLua
*Mod starts loading (Code/Script.lua)*
	Msg.BeforeClearEntityData
	Msg.ClassesGenerate ()
	Msg.ClassesPreprocess ()
	Msg.ClassesPostprocess
	Msg.GetCustomFXInheritActorRules ()
	Msg.RegisterTriggers ()
	Msg.ClassesBuilt
	Msg.ApplyAccountOptions
	Msg.ControlSchemeChanged
	Msg.OptionsApply
	Msg.ControlSchemeChanged
	Msg.Autorun
Reloading done
[mod] Loading OnMsg Print v0.3(id ChoGGi_OnMsgPrint, version 3) items from AppData/Mods/OnMsg Print/
	Msg.ModsReloaded
	Msg.HexShapesRebuilt
	Msg.EntitiesLoaded
	Msg.ShortcutsReloaded
	Msg.BinAssetsLoaded
	Msg.ShortcutsReloaded
	Msg.PreNewMap
	Msg.LightmodelNightChange ()
	Msg.LightmodelRainChange ()
	Msg.LightmodelChange ()
	Msg.AfterLightmodelChange ()
Msg.FundingChanged ()
	Msg.ConstValueChanged ()
Msg.OurColonyPlaced
	Msg.UIModeChange ()
Msg.InGameInterfaceCreated ()
Msg.CityStart
	Msg.NewMap
	Msg.UIModeChange ()
Msg.CameraTransitionEnd
<color 255 255 0>[RM] Default preset Polymers_VeryLow selected for Polymers</color>
	Msg.BuildableGridReady
	Msg.NewMapLoaded
	Msg.PostNewMapLoaded
	Msg.GameTimeStart
	Msg.LightmodelChange ()
	Msg.AfterLightmodelChange ()
Msg.NewDay ()
Msg.SunChange
Msg.NewWorkshift ()
Msg.NewHour ()
	Msg.SubsurfaceDepositRevealed ()
	Msg.WaterDepositRevealed ()
starting sector selected: B1
Msg.MapSectorsReady
Msg.SequenceListPlayerStart ()
	Msg.SequenceStart ()
	Msg.SequenceStart ()
game_settings:
    save_game_id: usDiJlxNNpGu699a
    sponsor: IMM
    profile: rocketscientist
    mystery: random
    mystery_random: AIUprisingMystery
    coordinates: -12,37
    landing_spot:
    logo: MarsExpress
map_conditions:
    altitude: -698
    temperature: -1
    cold_wave: 0
    dust_devils: 65
    dust_storm: 36
    meteors: 139
map_resources:
    concrete: 109
    metals: 73
    precious_metals: 73
    water: 73
Msg.MysteryChosen
	Msg.BuildingPlaced ()
	Msg.BuildingPlaced ()
	Msg.BuildingPlaced ()
	Msg.BuildingPlaced ()
	Msg.BuildingPlaced ()
Msg.MilestoneCompleted ()
	Msg.SubsurfaceDepositRevealed ()
	Msg.WaterDepositRevealed ()
Msg.SequenceStop ()
	Msg.BuildingInit ()
	Msg.BuildingInit ()
	Msg.BuildingInit ()
	Msg.BuildingInit ()
	Msg.BuildingInit ()
	Msg.LightmodelChange ()
	Msg.AfterLightmodelChange ()
	Msg.RocketStatusUpdate ()
	Msg.RocketStatusUpdate ()
	Msg.RocketStatusUpdate ()
	Msg.RocketStatusUpdate ()
	Msg.RocketStatusUpdate ()
	Msg.ConstValueChanged ()
Msg.TechResearched ()
Msg.TechResearchedTrigger ()
	Msg.UpgradeUnlocked ()
	Msg.UpgradeUnlocked ()
	Msg.UpgradeUnlocked ()
	Msg.UpgradeUnlocked ()
	Msg.UpgradeUnlocked ()
	Msg.UpgradeUnlocked ()
Msg.DepositsSpawned
	Msg.GameStateChanged ()
	Msg.ChangeMapDone ()
	Msg.ResumeInviteChecks
Map changed to "BlankBigTerraceCMix_03" in 11884 ms.
	Msg.GameStateChangedNotify
	Msg.GameStateChanged ()
	Msg.GameStateChanged ()
	Msg.Resume ()
	Msg.LoadingScreenPreClose
	Msg.GameStateChangedNotify
Msg.RocketLaunchFromEarth ()
	Msg.RocketStatusUpdate ()
	Msg.RocketStatusUpdate ()
Msg.SectorScanned ()
Msg.CommandCenterClosed
Msg.MessageBoxPreOpen
Msg.PopupNotificationBegin
Msg.MessageBoxOpened
	Msg.GameStateChanged ()
	Msg.Pause ()
	Msg.GameStateChangedNotify
*Game loaded on screen with "Welcome to Mars msgs"*
	Msg.GameStateChanged ()
	Msg.Resume ()
Msg.MarsResume
Msg.MessageBoxClosed
	Msg.GameStateChangedNotify
Msg.NewMinute ()

*Start of gameplay*
```