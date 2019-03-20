This is needed for certain blacklisted functions in Da Vinci update and beyond.
Most people will not need to use this, modders may find it useful for testing.


Find and rename LocalStorage.lua to LocalStorage_Settings.lua
It's located in
%AppData%\Surviving Mars\
C:\Users\USERNAME\AppData\Roaming\Surviving Mars (AppData is a hidden folder)

Then you can move "LocalStorage.lua" and "BinAssets" to the profile folder


(See Install Help.png)



Symlinking:
If you symlink the BinAssets folder, you won't need to update HelperMod manually.
Though HelperMod shouldn't be updated too often.

Other OS locations:
macOS (OS X):
~/Library/Application Support/Surviving Mars/
Linux:
$XDG_DATA_HOME/Surviving Mars/

For those previously using the HelperMod:
Move the BinAssets folder to the appdata folder to keep any mods/settings.
