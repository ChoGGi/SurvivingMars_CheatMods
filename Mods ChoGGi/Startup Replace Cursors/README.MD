### Blacklist bypass mod for Surviving Mars mods

```
Find and rename LocalStorage.lua to LocalStorage_Settings.lua
It's located in
%AppData%\Surviving Mars\
C:\Users\USERNAME\AppData\Roaming\Surviving Mars (AppData is a hidden folder)

Then you can move "LocalStorage.lua" and "BinAssets" to the profile folder


This will allow ECM to bypass the blacklist added in the Da Vinci update (reverts to Curiosity and below permissions).
```

##### Modders:
```
If you add a file with your steam id to the Mod Ids, then it will also work for yours.
A warning will be added to the mod manager to any mods without the blacklist active.
```

##### Other OS locations
```
macOS (OS X):
~/Library/Application Support/Surviving Mars/
Linux:
$XDG_DATA_HOME/Surviving Mars/
```

##### For those previously using the HelperMod
Move the BinAssets folder to the appdata folder to keep any mods/settings.
