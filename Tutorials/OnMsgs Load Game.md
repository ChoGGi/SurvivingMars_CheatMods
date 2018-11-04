### "Load Game" (last updated Gagarin 237096)

##### Show a list of OnMsgs/WaitMsgs that are waiting for Msgs.
##### You need ECM for OpenExamine
`OpenExamine(GetHandledMsg(true))`

#### Show a list of functions in the order they will be called when an OnMsg is fired
```
local _,v = debug.getupvalue(getmetatable(OnMsg).__newindex,1)
OpenExamine(v)
```

###### Tabs denote repetition of Msg (not to say these aren't repeated later on)
###### () on the end means the msg has arguments (this list is just for the order), use my OnMsg Print mod
###### Parts of the log are also included to get an idea of when the Msgs fire
```
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
Msg.ChangeMapDone
Msg.ResumeInviteChecks
Map changed to "" in 4186 ms.
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
    save_game_id: oCeC1WxH0ab7yrKX
    sponsor: IMM
    profile: rocketscientist
    mystery: random
    mystery_random: DiggersMystery
    coordinates: 10,11
    landing_spot:
    logo: MarsExpress
map_conditions:
    altitude: 802
    temperature: -15
    cold_wave: 36
    dust_devils: 78
    dust_storm: 36
    meteors: 219
map_resources:
    concrete: 255
    metals: 73
    precious_metals: 73
    water: 73
Msg.LoadGame ()
	Msg.ShortcutsReloaded
	Msg.GameStateChangedNotify
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
	Msg.NewMinute ()
Msg.SaveScreenShotEnd

*Game loaded and playable*
```