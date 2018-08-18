### Example of a Init script to use

```
In metadata.lua use: "code", {"Script.lua"},

Find and replace these below
Your_Mod_Id
Some_Unique_Mod_Name

Make a new file MODFOLDER/Script.lua, and copy the script into it.
```

##### The actual script:
```
-- if we use global func more then once: make them local for that small bit o' speed
local select,tostring,type,pcall,table = select,tostring,type,pcall,table
local AsyncGetFileAttribute,Mods = AsyncGetFileAttribute,Mods

local TableConcat
-- just in case they remove oldTableConcat
pcall(function()
  TableConcat = oldTableConcat
end)
-- thanks for replacing concat... what's wrong with using table.concat2?
TableConcat = TableConcat or table.concat

local function FileExists(file)
  -- AsyncFileOpen may not work that well under linux?
  local err,_ = AsyncGetFileAttribute(file,"size")
  if not err then
    return true
  end
end

-- SM has a tendency to inf loop when you return a non-string value that they want to table.concat
-- so now if i accidentally return say a menu item with a function for a name, it'll just look ugly instead of freezing (cursor moves screen wasd doesn't)
-- this is also used instead of "str .. str"; anytime you do that lua will hash the new string, and store it till exit (which means this is faster, and uses less memory)
local concat_table = {}
local function Concat(...)
  -- i assume sm added a c func to clear tables, which does seem to be faster than a lua for loop
  table.iclear(concat_table)
  -- build table from args
  for i = 1, select("#",...) do
    local concat_value = select(i,...)
    -- no sense in calling a func more then we need to
    local concat_type = type(concat_value)
    if concat_type == "string" or concat_type == "number" then
      concat_table[i] = concat_value
    else
      concat_table[i] = tostring(concat_value)
    end
  end
  -- and done
  return TableConcat(concat_table)
end

-- Everything stored in one global table
Some_Unique_Mod_Name = {
  email = "email@example.com",
  id = "Your_Mod_Id",
  _VERSION = Mods.Your_Mod_Id.version,
  ModPath = CurrentModPath,

  ComFuncs = {
    FileExists = FileExists,
    TableConcat = TableConcat,
    Concat = Concat,
  },
}
local Some_Unique_Mod_Name = Some_Unique_Mod_Name

-- remove the translate section if you don't use my method of translating (See Locales.md)
do -- translate
  --load up translation strings
  local function LoadLocale(file)
    if not pcall(function()
      LoadTranslationTableFile(file)
    end) then
      local err = [[Problem loading locale: %s

        Please send me latest log file: %s]]
      DebugPrintNL(err:format(file,Some_Unique_Mod_Name.email))
    end
  end

  -- load locale translation
  local locale_file = Concat(Some_Unique_Mod_Name.ModPath,"Locales/",GetLanguage(),".csv")
  if Some_Unique_Mod_Name.ComFuncs.FileExists(locale_file) then
    LoadLocale(locale_file)
  else
    LoadLocale(Concat(Some_Unique_Mod_Name.ModPath,"Locales/","English.csv"))
  end
  Msg("TranslationChanged")
end

-- any .lua files in MODFOLDER/Code will now get executed
dofolder_files(Concat(Some_Unique_Mod_Name.ModPath,"Code/"))

--[[
At the top of the .lua files you can add
local FileExists = Some_Unique_Mod_Name.ComFuncs.FileExists
local TableConcat = Some_Unique_Mod_Name.ComFuncs.TableConcat
local Concat = Some_Unique_Mod_Name.ComFuncs.Concat

for easier/quicker access to them
--]]

```