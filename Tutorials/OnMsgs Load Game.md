### "Load Game" (last updated Sagan)

##### Show a list of OnMsgs/WaitMsgs that are waiting for Msgs.
##### You need ECM for OpenExamine
`OpenExamine(GetHandledMsg(true))`

#### Show a list of functions in the order they will be called when an OnMsg is fired
```
local _,v = debug.getupvalue(getmetatable(OnMsg).__newindex,1)
OpenExamine(v)
```

###### Tabs denote repetition of Msg (not to say these aren't repeated later on)
###### *snipped* means the msg has arguments (this list is just for the order)
###### Parts of the log are also included to get an idea of when the Msgs fire
```
Changing map to ""
*** Reloading assets from folder BinAssets/

DTM started in 2048 mb
Reloading lua files
*Mod starts loading (Code/Script.lua)*
Msg.BeforeClearEntityData
Msg.ClassesGenerate *snipped*
Msg.ClassesPreprocess *snipped*
Msg.ClassesPostprocess
Msg.GetCustomFXInheritActorRules *snipped*
Msg.RegisterTriggers *snipped*
Msg.ClassesBuilt
Msg.OptionsApply
Msg.Autorun
Reloading done
[mod] Loading OnMsg Print v0.1(id ChoGGi_OnMsg Print, version 1) items from AppData/Mods/OnMsg Print/
Msg.ModsReloaded
Msg.EntitiesLoaded
	Msg.ShortcutsReloaded
Msg.BinAssetsLoaded
Msg.ChangeMapDone
Msg.ResumeInviteChecks
Map changed to "" in 2586 ms.
Msg.PreLoadGame
Msg.PersistGatherPermanents *snipped*
Msg.PersistPreLoad
Msg.PersistLoad *snipped*
Msg.PersistPostLoad *snipped*
Game loaded on map
	Msg.GameStateChanged *snipped*
	Msg.GameStateChanged *snipped*
	Msg.LightmodelNightChange *snipped*
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
game_settings:
    save_game_id: ziu5Oo5fctyXnoDr
    sponsor: IMM
    profile: rocketscientist
    mystery: random
    mystery_random: DiggersMystery
    coordinates: -1,129
    landing_spot:
    logo: MarsExpress
map_conditions:
    altitude: -1853
    temperature: -10
    cold_wave: 24
    dust_devils: 55
    dust_storm: 123
    meteors: 108
map_resources:
    concrete: 109
    metals: 146
    precious_metals: 146
    water: 146
Msg.LoadGame *snipped*
	Msg.ShortcutsReloaded
	Msg.GameStateChangedNotify
	Msg.GameStateChanged *snipped*
	Msg.LightmodelNightChange *snipped*
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
	Msg.GameStateChangedNotify
	Msg.GameStateChanged *snipped*
	Msg.Resume *snipped*
Msg.LoadingScreenPreClose
	Msg.GameStateChangedNotify
Msg.SaveScreenShotEnd

*Game loaded*
```