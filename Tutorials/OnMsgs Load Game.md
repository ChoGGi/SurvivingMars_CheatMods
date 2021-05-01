### Order of msgs happening during a "Load Game"
##### last updated Cernan (245618), for current list use [OnMsg Print](https://steamcommunity.com/sharedfiles/filedetails/?id=1604230467)

##### Tabs denote repetition of Msg. They could also be repeated later on in the game, but this list is during loading.
##### () on the end means the msg has arguments (this list is for the order), to see args use OnMsg Print
##### Parts of the log are also included to get an idea of when the Msgs fire
```lua
[mod] Loading mod items...
Reloading lua files

*****Mod starts loading (Code/Script.lua)*****
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
Msg.ApplyAccountOptions
	Msg.ControlSchemeChanged
Msg.ApplyAccountOptions
	Msg.ControlSchemeChanged
	Msg.OptionsApply
	Msg.ControlSchemeChanged
Msg.Autorun
Reloading done
[mod] Loading OnMsg Print(id ChoGGi_OnMsgPrint, version 0.05-005) items from AppData/Mods/OnMsg Print/

Msg.ModsReloaded
Msg.TerrainTexturesChanged
Msg.HexShapesRebuilt
Msg.EntitiesLoaded
	Msg.ShortcutsReloaded
Msg.BinAssetsLoaded
Msg.ChangeMapDone
Msg.ResumeInviteChecks
Map changed to "" in 4104 ms.
Msg.PreLoadGame
Msg.PersistPreLoad
Msg.PersistPostLoad ()
Msg.OnPassabilityChanged ()
Game loaded on map
	Msg.GameStateChanged ()
Msg.ApplyHeaters ()
	Msg.GameStateChanged ()
	Msg.LightmodelNightChange ()
	Msg.LightmodelChange ()
	Msg.AfterLightmodelChange ()
game_settings:
    save_game_id: M57Cxc4D6rb/S+OQ
    sponsor: IMM
    profile: rocketscientist
    mystery: random
    mystery_random: LightsMystery
    coordinates: 1,-110
    landing_spot:
    logo: MarsExpress
map_conditions:
    altitude: 5764
    temperature: -1
    cold_wave: 0
    dust_devils: 121
    dust_storm: 219
    meteors: 36
map_resources:
    concrete: 73
    metals: 73
    precious_metals: 73
    water: 176
Msg.LoadGame ()
	Msg.ShortcutsReloaded
	Msg.GameStateChangedNotify
Msg.UIModeChange selection
Msg.InGameInterfaceCreated ()
	Msg.GameStateChanged ()
	Msg.LightmodelNightChange ()
	Msg.LightmodelChange ()
	Msg.AfterLightmodelChange ()
	Msg.GameStateChangedNotify
	Msg.GameStateChanged ()
Msg.Resume ()
Msg.LoadingScreenPreClose
	Msg.GameStateChangedNotify
	Msg.NewMinute ()
	Msg.GameStateChanged ()
Msg.Pause ()
	Msg.GameStateChangedNotify
	Msg.NewMinute ()

*****Game loaded and playable*****
```