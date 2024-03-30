#### Last updated: Prunariu/Martian Express hotfix 1 (1,011,166)

https://survivingmars.paradoxwikis.com/Patches#Version_history

# Each DLC that adds breakthroughs changes the breakthrough list; you'll need to pick the one that matches your DLC (Green Planet / Below & Beyond).

## Do not use Tech Variety or Chaos Theory game rules! (they change the breakthrough order)


Only shows first 13 breakthroughs: Anything higher than that isn't guaranteed.

The first 4 are planetary anomalies (the rest are on the ground), if you have BB then you need to use my Fix Bugs mod on new games or ignore them.

#### Google Sheets:


No DLC: https://docs.google.com/spreadsheets/d/1cMMVSz5z7dbKgxC-jgZCmYzMbfIX7friTAtMYuiaFL8/

BB: https://docs.google.com/spreadsheets/d/18HhxcqDsTXNhpF67ZTBtrSiN7jfkRmavXTq7QxynnB8/

GP: https://docs.google.com/spreadsheets/d/1q17ArktnT5zZGO7BfkbeN8aFogml6CbED75-4Yk9KWU/

GP BB: https://docs.google.com/spreadsheets/d/1cYRqjVxmdYeTSii6jGUiNOOKhLxZ6ffmYPcDn9sOVHs/

#### Tools that use this data:

https://github.com/Jeutnarg/survivingmars_map_filter

https://github.com/trickster-is-weak/Surviving-Maps

#### Mods:

Find Map Locations: https://steamcommunity.com/sharedfiles/filedetails/?id=2453011286

View Colony Map: https://steamcommunity.com/sharedfiles/filedetails/?id=1491973763

#### Generate your own csv files (with more than 13 if wanted) paste this into console:

```
ChoGGi.ComFuncs.ExportMapDataToCSV(XAction:new{
    setting_breakthroughs = true,
    setting_limit_count = 17,
})
-- You need "ChoGGi's Library" mod for this func.
```

See also: https://forum.paradoxplaza.com/forum/threads/surviving-mars-maps-find-your-perfect-landinglocation.1107750/page-2#post-25465232
