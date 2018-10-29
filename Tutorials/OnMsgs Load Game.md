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
###### *snipped* means the msg has arguments (this is just for order though)
###### Some parts of the log are also included to get an idea of when the Msgs fire
```
Changing map to ""
						 time 0:00:17:394
*** Reloading assets from folder BinAssets/

					 time 0:00:18:767
DTM started in 2048 mb
						 time 0:00:18:782
Reloading lua files
*Mod starts loading (Code/Script.lua)*
						 time 0:00:19:048
Msg.BeforeClearEntityData
						 time 0:00:19:063
Msg.ClassesGenerate *snipped*
						 time 0:00:19:126
Msg.ClassesPreprocess *snipped*
						 time 0:00:19:282
Msg.ClassesPostprocess
Msg.GetCustomFXInheritActorRules *snipped*
						 time 0:00:19:297
Msg.RegisterTriggers *snipped*
						 time 0:00:19:313
Msg.ClassesBuilt
						 time 0:00:19:328
Msg.OptionsApply
Msg.Autorun
Reloading done
[mod] Loading OnMsg Print v0.1(id ChoGGi_OnMsg Print, version 1) items from AppData/Mods/OnMsg Print/
Msg.ModsReloaded
						 time 0:00:19:718
Msg.EntitiesLoaded
						 time 0:00:19:750
	Msg.ShortcutsReloaded
Msg.BinAssetsLoaded
Msg.ChangeMapDone
Msg.ResumeInviteChecks
Map changed to "" in 2586 ms.
Msg.PreLoadGame
						 time 0:00:20:233
Msg.PersistGatherPermanents *snipped*
Msg.PersistPreLoad
						 time 0:00:20:342
Msg.PersistLoad *snipped*
Msg.PersistPostLoad *snipped*
						 time 0:00:22:589
Game loaded on map
	Msg.GameStateChanged *snipped*
	Msg.GameStateChanged *snipped*
	Msg.LightmodelNightChange *snipped*
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
						 time 0:00:22:604
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
						 time 0:00:22:620
	Msg.ShortcutsReloaded
	Msg.GameStateChangedNotify
						 time 0:00:24:523
	Msg.GameStateChanged *snipped*
	Msg.LightmodelNightChange *snipped*
						 time 0:00:24:539
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
	Msg.GameStateChangedNotify
						 time 0:00:24:866
	Msg.GameStateChanged *snipped*
	Msg.Resume *snipped*
Msg.LoadingScreenPreClose
	Msg.GameStateChangedNotify
						 time 0:00:24:898
Msg.SaveScreenShotEnd
						 time 0:00:24:944

*Game loaded*
```