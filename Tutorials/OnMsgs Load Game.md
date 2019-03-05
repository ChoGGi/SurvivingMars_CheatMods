### "Load Game"
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
Msg.ChangeMapDone
Msg.ResumeInviteChecks
Map changed to "" in 9665 ms.
Msg.PreLoadGame
Msg.PersistGatherPermanents ()
Msg.PersistPreLoad
Msg.PersistLoad ()
Msg.PersistPostLoad ()
Game loaded on map
	Msg.GameStateChanged ()
	Msg.GameStateChanged ()
	Msg.LightmodelNightChange ()
	Msg.LightmodelChange ()
	Msg.AfterLightmodelChange ()
game_settings:
    save_game_id: n5MX84tsRVWa5QL3
    sponsor: IMM
    profile: rocketscientist
    mystery: random
    mystery_random: CrystalsMystery
    coordinates: -7,171
    landing_spot: ElysiumAlpha
    logo: MarsExpress
map_conditions:
    altitude: -2776
    temperature: -15
    cold_wave: 36
    dust_devils: 47
    dust_storm: 0
    meteors: 73
map_resources:
    concrete: 220
    metals: 98
    precious_metals: 98
    water: 110
Msg.LoadGame ()
	Msg.ShortcutsReloaded
	Msg.GameStateChangedNotify
Msg.PopsLogin ()
	Msg.UIModeChange ()
Msg.InGameInterfaceCreated ()
	Msg.UIModeChange ()
	Msg.GameStateChanged ()
	Msg.LightmodelNightChange ()
	Msg.LightmodelChange ()
	Msg.AfterLightmodelChange ()
	Msg.GameStateChangedNotify
Msg.CameraTransitionEnd
	Msg.GameStateChanged ()
Msg.Resume ()
Msg.LoadingScreenPreClose
	Msg.GameStateChangedNotify
Msg.SaveScreenShotEnd
Msg.PopsTelemetrySetEnabled
Msg.NewMinute ()
Msg.PopsOwnedProductsChanged

*Game loaded and playable*
```