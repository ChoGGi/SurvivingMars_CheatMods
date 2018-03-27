### No warranty implied or otherwise!

##### Info
```
Contains pretty much all of mine and FLiNGs mods, as well a few more (none of the new/modified building mods though)

F2: Toggle the cheats menu.
F4: Open object examiner for selected object
F5: Dump info for selected object to file (AppData/DumpedText.txt)
Ctrl+F: Fill resource of selected object
Enter or Tilde to show the console
F9 to clear the console

There's a cheats section in most info panels on the right side of the screen.
Menu>Toggles>Infopanel Cheats (on by default, as well as the empty cheat being disabled)

Hover over menu items for a description
If a menu has "+ num" then it'll increase it by that number each time

Thanks to chippydip (for the original mod) and therealshibe (for mentioning it)
http://steamcommunity.com/sharedfiles/filedetails/?id=1336604230
```

##### Console
```
Can open with tilde as well (but it adds a `)
Toggle showing history/results on-screen (Menu>Toggle)
restart
dumpl(TdlgConsole) --TupleToLuaCode
dumpo(SelectedObj) --object
dumpt(Consts) --table
dump() --anything
if you want to overwrite instead of append text: DumpObject(TechTree,"w")
if you want to dump functions as well: DumpTable(TechTree,nil,true)

ChoGGi.PrintIds(TechTree): Dumps table names+number (access with TechTree[6][46])
TechTree[6][46] = Breakthroughs>PrefabCompression

you can paste chunks of scripts to test out:
local temp
for _,building in ipairs(DataInstances.BuildingTemplate) do
	temp = temp .. tostring(building.name) .. tostring(building.wonder)
end
dump(temp)

ChoGGi.ReturnTechAmount(Tech,Prop)
returns number from TechTree (so you know how much it changes)

ChoGGi.ReturnTechAmount("CompactPassengerModule","MaxColonistsPerRocket").a
^returns 10
ChoGGi.ReturnTechAmount("HullPolarization","BuildingMaintenancePointsModifier").p
^ returns 0.25

it returns percentages in decimal for ease of mathing
ie: BuildingMaintenancePointsModifier is -25 this returns it as 0.25
it also returns negative amounts as positive (I prefer doing num - a not num + a)
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
AddMysteryBreakthroughBuildings
AvoidWorkplaceToggle
BirthThresholdToggle
BlockCheatEmpty
BombardmentAtCursor
BombardmentAtCursorMass
BorderScrollingToggle
BreakThroughTechsPerGameToggle
Building_hide_from_build_menu
Building_wonder
BuildingDamageCrimeToggle
CablesAndPipesToggle
CameraZoomToggle
CameraZoomToggleSpeed
ChanceOfNegativeTraitToggle
ChanceOfSanityDamageToggle
ColonistsAddSpecializationToAll
ColonistsChanceOfSuicideToggle
ColonistsMoraleMaxToggle
ColonistsPerRocketDefault
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
ColonistsStarveToggle
ColonistsSuffocateToggle
CommandCenterRadiusDefault
CommandCenterRadiusIncrease
ConsoleClearDisplay
ConsoleToggleHistory
ConstructionForFreeToggle
DeeperScanEnable
DeepScanToggle
DestroySelectedObject
DeveloperModeToggle
DroneBatteryInfiniteToggle
DroneBuildSpeedToggle
DroneCarryAmountDefault
DroneCarryAmountIncrease
DroneMeteorMalfunctionToggle
DroneRechargeTimeToggle
DroneRepairSupplyLeakToggle
DronesPerDroneHubDefault
DronesPerDroneHubIncrease
DronesPerRCRoverDefault
DronesPerRCRoverIncrease
DumpCurrentObj
ExamineCurrentObj
FillSelectedResource
FoodPerRocketPassengerDefault
FoodPerRocketPassengerIncrease
FoodPerRocketPassengerIncrease1000
FullyAutomatedBuildingsToggle
FundsAdded10000M
FundsAdded1000M
FundsAdded25M
GameSpeedDefault
GameSpeedDouble
GameSpeedQuad
GameSpeedTriple
HexBuildGridToggle
MaintenanceBuildingsFreeToggle
MeteorHealthDamageToggle
MinComfortBirthToggle
MoistureVaporatorPenaltyToggle
NegativeTraitsAddAll
NegativeTraitsRemoveAll
NewColonistAgeAdult
NewColonistAgeChild
NewColonistAgeDefault
NewColonistAgeMiddleAged
NewColonistAgeRetiree
NewColonistAgeSenior
NewColonistAgeYouth
NewColonistSexAndroid
NewColonistSexClone
NewColonistSexDefault
NewColonistSexFemale
NewColonistSexMale
NewColonistSexOther
OutsideWorkplaceRadiusDefault
OutsideWorkplaceRadiusIncrease
OutsourcePoints1000000
OutsourcingFreeToggle
PerformancePenaltyNonSpecialistToggle
PositivePlaygroundToggle
PositiveTraitsAddAll
PositiveTraitsRemoveAll
ProjectMorpheusPositiveTraitToggle
RCRoverDroneRechargeFreeToggle
RCRoverRadiusDefault
RCRoverRadiusIncrease
RCTransportResourceToggle
RCTransportStorageDefault
RCTransportStorageIncrease
RenegadeCreationToggle
ResearchEveryBreakthrough
ResearchEveryMystery
ResearchQueueLargerToggle
RocketCargoCapacityToggle
RocketTravelInstantToggle
SanatoriumCureAllToggle
SanatoriumSchoolShowAll
ScannerQueueLargerToggle
SchoolTrainAllToggle
ShowAllTraitsToggle
SpacingPipesPillarsToggle
StorageDepotHold1000
ToggleInfopanelCheats
ToggleTerrainDepositGrid
TriboelectricScrubberRadiusDefault
TriboelectricScrubberRadiusIncrease
UnlockEveryBreakthrough
VisitFailPenaltyToggle
WriteDebugLogs

Also includes default menuitems for all toggleable settings

Settings are saved at %APPDATA%\Surviving Mars\CheatMenuModSettings.lua
^ delete to reset to default settings (unless it's something like changing capacity of RC Transports, that's kept in savegame)
```