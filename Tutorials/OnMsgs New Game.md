### "New Game" (last updated Sagan)

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
Changing map to "PreGame"
						 time 0:00:06:100
*** Reloading assets from folder BinAssets/

					 time 0:00:07:364
DTM started in 2048 mb
						 time 0:00:07:395
Reloading lua files
*Mod starts loading (Code/Script.lua)*
						 time 0:00:07:676
	Msg.BeforeClearEntityData
						 time 0:00:07:707
	Msg.ClassesGenerate *snipped*
						 time 0:00:07:769
	Msg.ClassesPreprocess *snipped*
						 time 0:00:07:925
	Msg.ClassesPostprocess
						 time 0:00:07:941
	Msg.GetCustomFXInheritActorRules *snipped*
	Msg.RegisterTriggers *snipped*
						 time 0:00:07:956
	Msg.ClassesBuilt
						 time 0:00:07:972
	Msg.OptionsApply
	Msg.Autorun
Reloading done
[mod] Loading OnMsg Print v0.1(id ChoGGi_OnMsg Print, version 1) items from AppData/Mods/OnMsg Print/
	Msg.ModsReloaded
						 time 0:00:08:346
	Msg.EntitiesLoaded
						 time 0:00:08:362
	Msg.ShortcutsReloaded
						 time 0:00:08:378
	Msg.BinAssetsLoaded
						 time 0:00:08:518
	Msg.ShortcutsReloaded
						 time 0:00:08:580
POPS: [CurlCallManager::update] FAIL '0000000066BFD710' http status was none of 100, 200, 304: 401
POPS: [CAccountLogInToken] Received errorCode:'Failure'
POPS: [CAccountLogInToken] Server returned success code but JSON reply says failure. This might indicate subtle failure modes.
POPS: [CAccountLogInToken] Received errorMessage:'Unauthorized'
[POPS]Saved auth token autologin failed: not-authorized
Msg.PopsAutoLoginFailed
	Msg.PreNewMap
	Msg.LightmodelNightChange *snipped*
	Msg.LightmodelRainChange *snipped*
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
	Msg.NewMap
						 time 0:00:10:125
	Msg.NewMapLoaded
						 time 0:00:10:156
	Msg.PostNewMapLoaded
						 time 0:00:10:203
	Msg.GameTimeStart
						 time 0:00:11:685
	Msg.ChangeMapDone *snipped*
	Msg.ResumeInviteChecks
Map changed to "PreGame" in 5818 ms.
						 time 0:00:12:309
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
						 time 0:00:12:340
	Msg.GameStateChanged *snipped*
	Msg.Resume *snipped*
	Msg.LoadingScreenPreClose
						 time 0:00:12:356
	Msg.GameStateChangedNotify
						 time 0:00:19:906
*Select screen 1*
						 time 0:00:27:129
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
						 time 0:00:27:160
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
						 time 0:00:29:282
*Select screen 2*
						 time 0:00:32:761
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
						 time 0:00:32:792
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
						 time 0:00:34:960
*Select screen 3*
						 time 0:00:38:579
	Msg.GameStateChanged *snipped*
	Msg.Pause *snipped*
	Msg.GameStateChanged *snipped*
	Msg.GameStateChangedNotify
						 time 0:00:38:673
Changing map to "BlankBigTerraceCMix_15"
Msg.ChangeMap *snipped*
						 time 0:00:38:751
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
						 time 0:00:38:782
Msg.DoneMap
Msg.PostDoneMap
						 time 0:00:38:829
Reloading lua files
						 time 0:00:38:876
Msg.ReloadLua
						 time 0:00:39:125
	Msg.BeforeClearEntityData
						 time 0:00:39:172
	Msg.ClassesGenerate *snipped*
						 time 0:00:39:235
	Msg.ClassesPreprocess *snipped*
						 time 0:00:39:406
	Msg.ClassesPostprocess
						 time 0:00:39:422
	Msg.GetCustomFXInheritActorRules *snipped*
	Msg.RegisterTriggers *snipped*
						 time 0:00:39:437
	Msg.ClassesBuilt
						 time 0:00:39:469
	Msg.OptionsApply
	Msg.Autorun
Reloading done
						 time 0:00:39:578
[mod] Loading OnMsg Print v0.1(id ChoGGi_OnMsg Print, version 1) items from AppData/Mods/OnMsg Print/
						 time 0:00:39:593
	Msg.ModsReloaded
						 time 0:00:39:983
	Msg.EntitiesLoaded
						 time 0:00:39:999
	Msg.ShortcutsReloaded
						 time 0:00:40:030
	Msg.BinAssetsLoaded
						 time 0:00:40:139
	Msg.ShortcutsReloaded
						 time 0:00:40:451
	Msg.PreNewMap
	Msg.LightmodelNightChange *snipped*
	Msg.LightmodelRainChange *snipped*
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
	Msg.ConstValueChanged *snipped*
						 time 0:00:40:763
	Msg.NewMap
						 time 0:00:44:117
Msg.CameraTransitionEnd
						 time 0:00:48:891
<color 255 255 0>[RM] Default preset Polymers_VeryLow selected for Polymers</color>
						 time 0:00:48:907
<color 255 255 0>[RM] Failed to find places for all Metals deposits in a Small cluster (idx:9): 1/2</color>
						 time 0:00:49:063
	Msg.NewMapLoaded
						 time 0:00:49:110
	Msg.PostNewMapLoaded
						 time 0:00:51:075
	Msg.GameTimeStart
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
Msg.NewDay *snipped*
Msg.SunChange
Msg.NewWorkshift *snipped*
						 time 0:00:51:091
starting sector selected: D1
						 time 0:00:51:247
Msg.SequenceListPlayerStart *snipped*
	Msg.SequenceStart *snipped*
	Msg.SequenceStart *snipped*
game_settings:
    save_game_id: 4ugNTABRBELRyvTF
    sponsor: IMM
    profile: rocketscientist
    mystery: random
    mystery_random: AIUprisingMystery
    coordinates: -6,3
    landing_spot:
    logo: MarsExpress
map_conditions:
    altitude: -1045
    temperature: -15
    cold_wave: 36
    dust_devils: 62
    dust_storm: 123
    meteors: 140
map_resources:
    concrete: 220
    metals: 73
    precious_metals: 73
    water: 73
Msg.SequenceStop *snipped*
	Msg.BuildingInit *snipped*
	Msg.BuildingInit *snipped*
	Msg.BuildingInit *snipped*
	Msg.BuildingInit *snipped*
	Msg.BuildingInit *snipped*
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
	Msg.ConstValueChanged *snipped*
						 time 0:00:51:512
	Msg.GameStateChanged *snipped*
	Msg.ChangeMapDone *snipped*
	Msg.ResumeInviteChecks
Map changed to "BlankBigTerraceCMix_15" in 12835 ms.
	Msg.GameStateChangedNotify
						 time 0:00:51:621
	Msg.GameStateChanged *snipped*
	Msg.GameStateChanged *snipped*
	Msg.Resume *snipped*
	Msg.LoadingScreenPreClose
	Msg.GameStateChangedNotify
Msg.SectorScanned *snipped*
						 time 0:00:51:886
	Msg.GameStateChanged *snipped*
	Msg.Pause *snipped*
	Msg.GameStateChangedNotify
						 time 0:01:14:678
*Game loaded on screen with "Welcome to Mars msgs"*
						 time 0:01:17:018
	Msg.GameStateChanged *snipped*
	Msg.Resume *snipped*
	Msg.GameStateChangedNotify

*Start of actual gameplay*
```