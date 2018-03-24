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

##### Menus
```
Added icons to some menuitems

Toggles menu:
Infopanel Cheats
Block CheatEmpty (stop CheatEmpty from emptying resources)
Storage Depot|Waste Rock Hold 1000
Building_wonder (allow multi wonders)
Building_hide_from_build_menu (show hidden stuff)

Debug menu:
Debug\Destroy Selected Object
Debug\Asteroid attack (single or bombardment)
Debug\Examine selected object
Debug\Dump info for selected object to file (AppData/DumpedText.txt)
Debug\Toggle Hex Build Grid Visibility (works now)
```

##### List of some stuff added (not up to date)
```
ResearchAllBreakthroughs
UnlockAllBreakthroughs
ResearchAllMysteries
FoodPerRocketPassengerIncrease
Add100PrefabsDrone + 10 of each kind of prefab/spire
FundsAdded25M,1000M,10000M
ResearchQueueLarger 25
OutsourcingFree
OutsourcePoints1000000
Double,Triple,Quad
RCTransportStorageIncrease
DroneBatteryInfinite
DroneCarryAmountIncrease
DroneBuildSpeedInstant
DronesPerDroneHubIncrease
DronesPerRCRoverIncrease
RCRoverDroneRechargeFree
RCTransportResourceFast
DroneMeteorMalfunctionDisable
DroneRechargeTimeFast
DroneRepairSupplyLeakFast
EnableDeepScan + exploitable
EnableDeeperScan
ScannerQueueLarger 100
ColonistsMaxMoraleAlways
ColonistsAddSpecializationToAll
ColonistsSetMoraleHigh
ColonistsSetSanityHigh
ColonistsSetComfortHigh
ColonistsSetHealthHigh
ColonistsSetAgesToChild,Youth,Adult,Middle Aged,Senior,Retiree
ColonistsSetSexOther,Android,Clone,Male,Female
ChanceOfSanityDamageNever
MeteorHealthDamageZero
ColonistsChanceOfNegativeTraitNever
ColonistsChanceOfSuicideNever
ColonistsWontSuffocate
ColonistsWontStarve
AvoidWorkplaceFalse
PositivePlayground100
ProjectMorpheusPositiveTrait100
PerformancePenaltyNonSpecialistNever
OutsideWorkplaceRadiusLarge
ColonistsPerRocketIncrease
RocketCargoCapacityLarge
RocketTravelInstant
MaintenanceBuildingsFree
MoistureVaporatorPenaltyRemove
ConstructionForFree
SpacingPipesPillarsMax
BuildingDamageCrimeNever
InstantCablesAndPipes
PositiveTraitsAddAll,PositiveTraitsRemoveAll,NegativeTraitsRemoveAll,NegativeTraitsAddAll


Also includes default menuitems for all toggleable settings

Settings are saved at %APPDATA%\Surviving Mars\CheatMenuModSettings.lua
^ delete to reset to default settings (unless it's something like changing capacity of RC Transports, that's kept in savegame)
```