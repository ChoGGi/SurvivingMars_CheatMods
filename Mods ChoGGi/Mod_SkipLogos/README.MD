### This needs to be placed in the game folder for Surviving Mars
### NOT in AppData\Surviving Mars

```
Surviving Mars\BinAssets\AssetsRevision.lua

This'll skip both logos at startup, and skips two of the mod manager warning msgs.

I also included an option (commented out) to skip straight to the load menu.
You can still get back to the main menu.


Turns out starting a new game gives a blank map
You need to pass a somewhat correct revision
It's stored in Packs\BinAssets.hpk, or just check the log
It'll say Assets revision: 17650 (17000 works fine for now, I assume when it goes over 18000...)
```