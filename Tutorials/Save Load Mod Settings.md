### There are two separate functions one to save and one to load
#### It expects a table with your settings inside of it

##### Example table
```lua
settings = {
	value1 = "text"
	["value 2"] = 12345
	tableinatable = {
		[1] = true
		[2] = false
	}
}
```

### MOD_SETTINGS_TABLE, and MOD_DEFAULT_SETTINGS are used for saved settings/default settings

#### Write Mod Settings
```lua
-- local some globals
local TableToLuaCode = TableToLuaCode
local AsyncCompress = AsyncCompress
local WriteModPersistentData = WriteModPersistentData
local MaxModDataSize = const.MaxModDataSize

function WriteModSettings(settings)
	settings = settings or MOD_SETTINGS_TABLE or MOD_DEFAULT_SETTINGS

	-- lz4 is quicker, but less compressy
	local err, data = AsyncCompress(TableToLuaCode(settings), false, "lz4")
	if err then
		print(err)
		return
	end

	-- too large
	if #data > MaxModDataSize then
		-- see if it'll fit now
		err, data = AsyncCompress(TableToLuaCode(settings), false, "zstd")
		if err then
			print(err)
			return
		end

		if #data > MaxModDataSize then
			print("too much data sucker")
			return
		end
	end

	local err = WriteModPersistentData(data)
	if err then
		print(err)
		return
	end

	-- if we call it from ReadModSettings looking for defaults
	return data
end
```

#### Read Mod Settings
```lua
-- local some globals
local ReadModPersistentData = ReadModPersistentData
local AsyncDecompress = AsyncDecompress
local LuaCodeToTuple = LuaCodeToTuple
function ReadModSettings()
	local settings_table

	-- try to read saved settings
	local err,settings_data = ReadModPersistentData()

	if err or not settings_data or settings_data == "" then
		-- no settings found so write default settings (it returns the saved setting)
		settings_data = WriteModSettings(MOD_DEFAULT_SETTINGS)
	end

	err, settings_table = AsyncDecompress(settings_data)
	if err then
		print(err)
	end

	-- and convert it to lua / update in-game settings
	err, MOD_SETTINGS_TABLE = LuaCodeToTuple(settings_table)
	if err then
		print(err)
	end

	-- just in case
	if type(MOD_SETTINGS_TABLE) ~= "table" then
		-- i have a defaults table i load up with my mod, if somethings wrong then at least the mod will have some settings to use
		MOD_SETTINGS_TABLE = MOD_DEFAULT_SETTINGS
	end

end
```

#### Clear Mod Settings
```lua
-- you can't nil the settings, so this is the best you can do for now

function ClearModSettings()
	WriteModPersistentData("")
end
```

##### Benching
```lua
-- uncompressed TableToLuaCode(TranslationTable)
-- #786351

-- lz4 compressed to #407672
-- 50 loops of AsyncDecompress(lz4_data)
-- 155 ticks
-- 50 loops of AsyncCompress(lz4_data)
-- 1404 ticks
-- 50 loops of compress/decompress
-- 1512,1491,1491 ticks (did it three times)

-- zstd compressed to #251660
-- 50 loops of AsyncDecompress(zstd_data)
-- 205 ticks
-- 50 loops of AsyncCompress(zstd_data)
-- 1508 ticks
-- 50 loops of compress/decompress
-- 1650,1676,1691 ticks (did it three times)
```

See ECM/Code/Misc/Testing.lua for the script I used
