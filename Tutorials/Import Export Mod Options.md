##### This requires both my Library mod and either ECM or Enable Console (doesn't matter which).


```lua
-- Export mod options (run this on old machine)
local options = TableToLuaCode(AccountStorage.ModOptions)
local err, data = AsyncCompress(options, false, "lz4")
err = AsyncStringToFile("AppData/mod_options.lua", data)
if err then
	print(err, "Export failed")
end```


```lua
-- Import mod options (run this on new machine)
local size = io.getsize("AppData/mod_options.lua")
local str = select(2,
AsyncFileToString("AppData/mod_options.lua", size, 0, "string", "raw")
)
local err, data = AsyncDecompress(str)
if err then
	print(err, "Import failed 1")
end
local err, settings = LuaCodeToTuple(data)
if err then
	print(err, "Import failed 2")
end

AccountStorage.ModOptions = settings
SaveAccountStorage(1000)
```
