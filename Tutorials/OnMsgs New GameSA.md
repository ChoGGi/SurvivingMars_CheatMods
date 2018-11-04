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
###### *snipped* means the msg has arguments (this list is just for the order)
###### Parts of the log are also included to get an idea of when the Msgs fire
```
Changing map to "PreGame"
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
	Msg.ShortcutsReloaded
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
	Msg.NewMapLoaded
	Msg.PostNewMapLoaded
	Msg.GameTimeStart
	Msg.ChangeMapDone *snipped*
	Msg.ResumeInviteChecks
Map changed to "PreGame" in 5818 ms.
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
	Msg.GameStateChanged *snipped*
	Msg.Resume *snipped*
	Msg.LoadingScreenPreClose
	Msg.GameStateChangedNotify
*Select screen 1*
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
*Select screen 2*
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
*Select screen 3*
	Msg.GameStateChanged *snipped*
	Msg.Pause *snipped*
	Msg.GameStateChanged *snipped*
	Msg.GameStateChangedNotify
Changing map to "BlankBigTerraceCMix_15"
Msg.ChangeMap *snipped*
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
Msg.DoneMap
Msg.PostDoneMap
Reloading lua files
Msg.ReloadLua
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
	Msg.ShortcutsReloaded
	Msg.PreNewMap
	Msg.LightmodelNightChange *snipped*
	Msg.LightmodelRainChange *snipped*
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
	Msg.ConstValueChanged *snipped*
	Msg.NewMap
Msg.CameraTransitionEnd
<color 255 255 0>[RM] Default preset Polymers_VeryLow selected for Polymers</color>
<color 255 255 0>[RM] Failed to find places for all Metals deposits in a Small cluster (idx:9): 1/2</color>
	Msg.NewMapLoaded
	Msg.PostNewMapLoaded
	Msg.GameTimeStart
	Msg.LightmodelChange *snipped*
	Msg.AfterLightmodelChange *snipped*
Msg.NewDay *snipped*
Msg.SunChange
Msg.NewWorkshift *snipped*
starting sector selected: D1
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
	Msg.GameStateChanged *snipped*
	Msg.ChangeMapDone *snipped*
	Msg.ResumeInviteChecks
Map changed to "BlankBigTerraceCMix_15" in 12835 ms.
	Msg.GameStateChangedNotify
	Msg.GameStateChanged *snipped*
	Msg.GameStateChanged *snipped*
	Msg.Resume *snipped*
	Msg.LoadingScreenPreClose
	Msg.GameStateChangedNotify
Msg.SectorScanned *snipped*
	Msg.GameStateChanged *snipped*
	Msg.Pause *snipped*
	Msg.GameStateChangedNotify
*Game loaded on screen with "Welcome to Mars msgs"*
	Msg.GameStateChanged *snipped*
	Msg.Resume *snipped*
	Msg.GameStateChangedNotify

*Start of actual gameplay*
```