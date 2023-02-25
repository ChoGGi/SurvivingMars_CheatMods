-
Last tested: Prunariu/Martian Express hotfix 1 (1,011,166)
-
Each DLC that adds breakthroughs changes the breakthrough list; you'll need to pick the one that matches your DLC (Green Planet / Below & Beyond).

Do not use Tech Variety or Chaos Theory game rules! (they change the breakthrough order)
-


Only shows first 12 breakthroughs: Anything higher than that isn't guaranteed.

The first 4 are planetary anomalies, if you have BB then you need to use my Fix Bugs mod on a new game or ignore them.

Tools that use this data:

https://github.com/Jeutnarg/survivingmars_map_filter

https://github.com/trickster-is-weak/Surviving-Maps

```

Generate your own csv files (with more than 12 if wanted) paste this into console:

ChoGGi.ComFuncs.ExportMapDataToCSV(XAction:new{
    setting_breakthroughs = true,
    setting_limit_count = 12,
})


You need my Library mod for this func.
```
