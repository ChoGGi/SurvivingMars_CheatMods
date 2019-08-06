### No warranty implied or otherwise!
```
(Ugly) AutohotKey script to decompile the LUA files
Needs a copy of unluac_2015_06_13.jar in same folder as DecompileLUA.ahk (or change the path in the ini)
Edit DecompileLUA.ini before starting it
```

[AutohotKey](https://autohotkey.com/download/)

[Java](https://java.com/download)

[unluac](https://sourceforge.net/projects/unluac/files/Unstable/)

Use [hpk](https://github.com/nickelc/hpk/releases) to extract LUA files from hpk archives (make sure to use the --fix-lua-files flag when you extract)

##### Stick this in a .bat file to unpack any .hpk archives in the same folder as the .bat
```
for %%g in (*.hpk) do mkdir %%~ng
for %%g in (*.hpk) do hpk.exe extract --fix-lua-files "%%g" "%%~ng"
```

##### unluac fails on CommonLua\Core\lib.lua, use hpk.exe to extract it without the --fix arg, then use [luadec](https://github.com/viruscamp/luadec) to decompile it.
