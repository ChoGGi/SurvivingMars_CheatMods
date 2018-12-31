### "New Game"
##### last updated Gagarin 237096

##### Show a list of OnMsgs/WaitMsgs that are waiting for Msgs.
##### You need ECM for OpenExamine
`OpenExamine(GetHandledMsg(true))`

#### Show a list of functions in the order they will be called when an OnMsg is fired
```lua
local _,v = debug.getupvalue(getmetatable(OnMsg).__newindex,1)
OpenExamine(v)
```

###### Tabs denote repetition of Msg (not to say these aren't repeated later on)
###### () on the end means the msg has arguments (this list is just for the order), to see args use [OnMsg Print](https://github.com/ChoGGi/SurvivingMars_CheatMods/tree/master/Mods%20ChoGGi/OnMsg%20Print)
###### Parts of the log are also included to get an idea of when the Msgs fire
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
	Msg.OptionsApply
	Msg.Autorun
Reloading done
[mod] Loading OnMsg Print v0.2(id ChoGGi_OnMsg Print, version 2) items from AppData/Mods/OnMsg Print/
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
	Msg.NewMap
	Msg.BuildableGridReady
	Msg.NewMapLoaded
	Msg.PostNewMapLoaded
	Msg.GameTimeStart
	Msg.ChangeMapDone ()
	Msg.ResumeInviteChecks
Map changed to "PreGame" in 7370 ms.
	Msg.GameStateChanged ()
	Msg.Resume ()
	Msg.LoadingScreenPreClose
	Msg.LightmodelChange ()
	Msg.AfterLightmodelChange ()
	Msg.GameStateChangedNotify
	Msg.PlanetCameraSet
*Select screen 1*
Msg.PopsLogin ()
[POPS]Failed to retrieve viewed documents timeout
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
Changing map to "BlankBigTerraceCMix_18"
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
	Msg.OptionsApply
	Msg.Autorun

Reloading done
[mod] Loading OnMsg Print v0.2(id ChoGGi_OnMsg Print, version 2) items from AppData/Mods/OnMsg Print/
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
<color 255 0 0>GetCompatibleTraits is different length</color>
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
starting sector selected: I1
Msg.MapSectorsReady
Msg.SequenceListPlayerStart ()
Msg.SequenceStart ()
game_settings:
    save_game_id: RtuL5+3NZV4fvKGK
    sponsor: IMM
    profile: rocketscientist
    mystery: MarsgateMystery
    mystery_random:
    coordinates: 3,-22
    landing_spot: MagraritiferAlpha
    logo: MarsExpress
map_conditions:
    altitude: -1737
    temperature: -1
    cold_wave: 0
    dust_devils: 56
    dust_storm: 0
    meteors: 109
map_resources:
    concrete: 146
    metals: 109
    precious_metals: 109
    water: 146
Msg.MysteryChosen
	Msg.BuildingPlaced ()
	Msg.BuildingPlaced ()
	Msg.BuildingPlaced ()
	Msg.BuildingPlaced ()
	Msg.BuildingPlaced ()
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
Map changed to "BlankBigTerraceCMix_18" in 13737 ms.
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

*Start of gameplay*
```