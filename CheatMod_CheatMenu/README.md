### No warranty implied or otherwise!

##### Info
```
Contains pretty much all of mine and FLiNGs mods, as well a few more (none of the new/modified building mods though)

F2: Toggle the cheats menu.
F4: Open object examiner for selected object
F5: Dump info for selected object to file (AppData/DumpedText.txt)
Ctrl+F: Fill resource of selected object

There's a cheats section in most info panels on the right side of the screen.
Menu>Toggles>Infopanel Cheats

Many of the cheat commands have keyboard shortcuts and these will function even when the menu is hidden.
Hover over menu items for a description

Thanks to chippydip (for the original mod) and therealshibe (for mentioning it)
http://steamcommunity.com/sharedfiles/filedetails/?id=1336604230
```

##### Console
```
Can now open with tilde as well (but it adds a `)
Added option to toggle showing history on-screen
Added option clear history
Added restart cmd
Added dump cmd: dump(obj,type,filename,ext)

If you want to dump something without quitting to check log
copy n paste this into the console
dump("test") < append to file
dump("test","w") < overwrite file
then open AppData/DumpedText.txt

you can paste chunks of scripts to test out:
local temp
for _,building in ipairs(DataInstances.BuildingTemplate) do
	temp = temp .. tostring(building.name) .. tostring(building.wonder)
end
dump(temp)
```

##### List of some stuff added (not up to date)
```
Add100PrefabsDrone
Add10PrefabsArcology
Add10PrefabsCloningVats
Add10PrefabsDroneHub
Add10PrefabsElectronicsFactory
Add10PrefabsFuelFactory
Add10PrefabsHangingGardens
Add10PrefabsMachinePartsFactory
Add10PrefabsMedicalCenter
Add10PrefabsMoistureVaporator
Add10PrefabsNetworkNode
Add10PrefabsPolymerPlant
Add10PrefabsSanatorium
Add10PrefabsStirlingGenerator
Add10PrefabsWaterReclamationSystem
AvoidWorkplaceFalse
BlockCheatEmpty
BombardmentAtCursor
BombardmentAtCursorMass
Building_hide_from_build_menu
Building_wonder
BuildingDamageCrimeNever
CablesAndPipesInstant
ChanceOfSanityDamageNever
ChangeMap
ColonistsAddSpecializationToAll
ColonistsChanceOfNegativeTraitNever
ColonistsChanceOfSuicideNever
ColonistsMoraleMaxAlways
ColonistsPerRocketIncrease
ColonistsSetAgesToAdult
ColonistsSetAgesToChild
ColonistsSetAgesToMiddleAged
ColonistsSetAgesToRetiree
ColonistsSetAgesToSenior
ColonistsSetAgesToYouth
ColonistsSetComfort100
ColonistsSetComfortMax
ColonistsSetHealth100
ColonistsSetHealthMax
ColonistsSetMorale100
ColonistsSetSanity100
ColonistsSetSanityMax
ColonistsSetSexAndroid
ColonistsSetSexClone
ColonistsSetSexFemale
ColonistsSetSexMale
ColonistsSetSexOther
ColonistsWillStarve
ColonistsWillSuffocate
ColonistsWontStarve
ColonistsWontSuffocate
CommandCenterRadiusIncrease
Console
ConsoleClearDisplay
ConsoleToggleHistory
ConstructionForFree
DeeperScanEnable
DeepScanDisable
DeepScanEnable
DestroySelectedObject
DroneBatteryInfinite
DroneBuildSpeedInstant
DroneCarryAmountIncrease
DroneMeteorMalfunctionDisable
DroneRechargeTimeFast
DroneRepairSupplyLeakFast
DronesPerDroneHubIncrease
DronesPerRCRoverIncrease
DumpCurrentObj
ExamineCurrentObj
FillSelectedResource
FoodPerRocketPassengerIncrease
FoodPerRocketPassengerIncrease1000
FundsAdded10000M
FundsAdded1000M
FundsAdded25M
GameSpeedDefault,Double,Triple,Quad
HexBuildGridToggle
MaintenanceBuildingsFree
MeteorHealthDamageZero
MinComfortBirthZero
MoistureVaporatorPenaltyRemove
NegativeTraitsAddAll
NegativeTraitsRemoveAll
OutsideWorkplaceRadiusLarge
OutsourcePoints1000000
OutsourcingFree
PerformancePenaltyNonSpecialistNever
PositivePlayground100
PositiveTraitsAddAll
PositiveTraitsRemoveAll
ProjectMorpheusPositiveTrait100
RCRoverDroneRechargeFree
RCRoverRadiusIncrease
RCTransportResourceFast
RCTransportStorageIncrease
RenegadeCreationStop
ResearchEveryBreakthrough
ResearchEveryMystery
ResearchQueueLarger
RocketCargoCapacityLarge
RocketTravelInstant
ScannerQueueLarger
SpacingPipesPillarsMax
StorageDepotHold1000
ToggleBorderScrolling
ToggleCameraZoom
ToggleCameraZoomSpeed
ToggleCheatsMenu
ToggleDeveloperMode
ToggleInfopanelCheats
ToggleTerrainDepositGrid
TriboelectricScrubberRadiusIncrease
UnlockEveryBreakthrough
VisitFailPenaltyZero

Also includes default menuitems for all toggleable settings

Settings are saved at %APPDATA%\Surviving Mars\CheatMenuModSettings.lua
^ delete to reset to default settings (unless it's something like changing capacity of RC Transports, that's kept in savegame)
```