### Order of msgs happening during a "Load Game"
##### last updated Cernan (245618), for current list use [OnMsg Print](https://steamcommunity.com/sharedfiles/filedetails/?id=1604230467)

##### {#} on the end means the msg has arguments (this list is for the order), to see args use OnMsg Print
##### Parts of the log are also included to get an idea of when the Msgs fire
```lua
[mod] Loading mod items...
Reloading lua files
Msg.ReloadLua { 0 }
*Mod starts loading (Code/Script.lua)*
Msg.BeforeClearEntityData { 0 }
Msg.ClassesGenerate { 1 }
Msg.ClassesPreprocess { 1 }
Msg.ClassesPostprocess { 0 }
Msg.GetCustomFXInheritActorRules { 1 }
Msg.RegisterTriggers { 1 }
Msg.ClassesBuilt { 0 }
Msg.ApplyAccountOptions { 0 }
Msg.ControlSchemeChanged { 0 }
Msg.OptionsApply { 0 }
Msg.ApplyAccountOptions { 0 }
Msg.ControlSchemeChanged { 0 }
Msg.ApplyAccountOptions { 0 }
Msg.ControlSchemeChanged { 0 }
Msg.OptionsApply { 0 }
Msg.ControlSchemeChanged { 0 }
Msg.Autorun { 0 }
Reloading done
[mod] Loading ChoGGi's Library Test(id ChoGGi_Library, version 10.02-102) items from AppData/Mods/ChoGGi's Library/
Msg.ShortcutsReloaded { 0 }
Msg.TranslationChanged { 0 }
[mod] Loading Expanded Cheat Menu Test (Warning)(id ChoGGi_CheatMenu, version 17.02-172) items from AppData/Mods/Expanded Cheat Menu/
[mod] Loading OnMsg Print(id ChoGGi_OnMsgPrint, version 0.07-007) items from AppData/Mods/OnMsg Print/
Msg.GetCustomFXInheritActorRules { 1 }
Msg.DevMenuVisible { 1 }
Msg.ModsReloaded { 0 }
Msg.TerrainTexturesChanged { 0 }
Msg.HexShapesRebuilt { 0 }
Msg.EntitiesLoaded { 0 }
Msg.ShortcutsReloaded { 0 }
Msg.BinAssetsLoaded { 0 }
Msg.ChangeMapDone { 1 }
Msg.ResumeInviteChecks { 0 }
Map changed to "" in 4233 ms.
Msg.PreLoadGame { 0 }
Msg.PersistPreLoad { 0 }
[mod] Savegame Mod ChoGGi's Library Test (id ChoGGi_Library, version 10.02-102)
[mod] Savegame Mod Expanded Cheat Menu Test (Warning) (id ChoGGi_CheatMenu, version 17.02-172)
[mod] Savegame references Mod Allow Buildings (id ChoGGi_AllowBuildings, version 0.01-001) which is not present
[mod] Savegame references Mod Unlock Overview Map (id ChoGGi_UnlockOverviewMap, version 0.01-001) which is not present
Msg.PersistPostLoad { 1 }
Msg.OnRealmLoad { 1 }
Msg.OnRealmLoad { 1 }
Msg.OnRealmLoad { 1 }
Msg.OnRealmLoad { 1 }
Msg.OnRealmLoad { 1 }
Msg.OnPassabilityChanged { 2 }
Msg.OnPassabilityChanged { 2 }
Msg.OnPassabilityChanged { 2 }
Msg.OnPassabilityChanged { 2 }
Msg.OnPassabilityChanged { 2 }
Msg.OnPassabilityChanged { 2 }
Game loaded on map BlankBigTerraceCMix_16
Msg.GameStateChanged { 1 }
<color 200 200 200> ECM </color>: Startup ticks : 8968
Msg.LoadGame { 2 }
Msg.LightmodelChange { 4 }
Msg.AfterLightmodelChange { 4 }
game_settings:
    save_game_id: N2mLkFXcfxu4Y3Sy
    sponsor: SpaceY
    profile: inventor
    mystery: none
    mystery_random:
    coordinates: 18S147E
    landing_spot:
    logo: SpaceY
map_conditions:
    altitude: 2418
    temperature: -15
    cold_wave: 36
    dust_devils: 92
    dust_storm: 36
    meteors: 79
map_resources:
    concrete: 109
    metals: 79
    precious_metals: 79
    water: 109
Msg.PostLoadGame { 2 }
Msg.GameStateChangedNotify { 0 }
Msg.UIModeChange { 1 }
Msg.InGameInterfaceCreated { 1 }
Msg.GameStateChanged { 1 }
Msg.Resume { 1 }
Msg.LoadingScreenPreClose { 0 }
Msg.GameStateChangedNotify { 0 }

*****Game loaded and playable*****
```