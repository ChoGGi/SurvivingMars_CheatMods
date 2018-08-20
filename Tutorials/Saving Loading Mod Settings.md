### There are two separate functions one to save and one to load
#### It expects a table with your settings inside of it

##### Example table
```
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
```
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
```
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
  if MOD_SETTINGS_TABLE == empty_table or type(MOD_SETTINGS_TABLE) ~= "table" then
    -- i have a defaults table i load up with my mod, if somethings wrong then at at the mod will have some settings to use
    MOD_SETTINGS_TABLE = MOD_DEFAULT_SETTINGS
  end

end
```