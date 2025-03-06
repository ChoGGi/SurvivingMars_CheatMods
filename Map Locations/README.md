#### Last updated: Prunariu/Martian Express hotfix 1 (1,011,166)

https://survivingmars.paradoxwikis.com/Patches#Version_history

# Each DLC that adds breakthroughs changes the breakthrough list; you'll need to pick the one that matches your DLC (Green Planet / Below & Beyond).

## Do not use Tech Variety or Chaos Theory game rules! (they change the breakthrough order)

## The same goes for using the No Below and Beyond/No Terraforming game rules!


Only shows first 13 breakthroughs: Anything higher than that isn't guaranteed (unless using paradox sponsor which gives an extra 2-4).

1-4 are planetary anomalies (the rest are surface anomalies), if you have B&B then you need to use my Fix Bugs mod on new games or ignore them.

#### Google Sheets:

No DLC: https://docs.google.com/spreadsheets/d/1cMMVSz5z7dbKgxC-jgZCmYzMbfIX7friTAtMYuiaFL8/

BB: https://docs.google.com/spreadsheets/d/18HhxcqDsTXNhpF67ZTBtrSiN7jfkRmavXTq7QxynnB8/

GP: https://docs.google.com/spreadsheets/d/1q17ArktnT5zZGO7BfkbeN8aFogml6CbED75-4Yk9KWU/

GP BB: https://docs.google.com/spreadsheets/d/1cYRqjVxmdYeTSii6jGUiNOOKhLxZ6ffmYPcDn9sOVHs/

##### Google Sheets (No Planetary Anomalies):

BB-No PA: https://docs.google.com/spreadsheets/d/1gZhmONS3L6qH61hOhVB9E_Ue15md7aNI18YXI3lk268/

GP BB-No PA: https://docs.google.com/spreadsheets/d/1JsRFTeraAUtGQ-KTurGfZTRoYZ6H7nYwfH9ECtyqU6w/

#### Tools that use this data:

https://www.survivingmaps.space/

https://surviving-maps.cc/

https://github.com/Ocelloid/surviving-maps-3d

https://github.com/Jeutnarg/survivingmars_map_filter

https://github.com/CasuallyCorporate/Surviving-Maps-CC

https://github.com/trickster-is-weak/Surviving-Maps

#### Mods:

Find Map Locations: https://steamcommunity.com/sharedfiles/filedetails/?id=2453011286

View Colony Map: https://steamcommunity.com/sharedfiles/filedetails/?id=1491973763

#### Generate your own csv files (with more than 13 if wanted) paste this into console:

```
ChoGGi_Funcs.Common.ExportMapDataToCSV(XAction:new{
    setting_breakthroughs = true,
    setting_limit_count = 17,
})
-- You need "ChoGGi's Library" mod for this func.
```

See also: https://forum.paradoxplaza.com/forum/threads/surviving-mars-maps-find-your-perfect-landinglocation.1107750/page-2#post-25465232
