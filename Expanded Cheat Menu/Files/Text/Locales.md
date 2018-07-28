### Add easy locale support to your mod (wtf is up with all this StringBase + 1 I see...)
```
In your mod folder create a Locales folder, in that folder create English.csv (or whatever you use).

Mod folder\Locales\English.csv

In English.csv add text like so:
ID,Text
11111111110001001,Some text
11111111110001002,and More text.
11111111110001003,"and some ""quoted"" text"
11111111110001004,"some text with

new lines in them"
11111111110001005,"some text with commas, included"

CHANGE 11111111 to some random arsed number, or use whatever you already use in your mod.

At the tippy top of your ModItemCode file add this (or something like it)

local ModPath = Mods[YOUR_MOD_ID].path
local function FileExists(file)
  _,file = AsyncFileOpen(file)
  return file
end

--load up translation strings
local function LoadLocale(file)
  if not pcall(function()
    LoadTranslationTableFile(file)
  end) then
    DebugPrintNL(string.format([[Problem loading locale: %s

Please send me latest log file: %s]],file,"your@emailaddress.com"))
  end
end

-- load locale translation (if any, not likely with the amount of text, but maybe a partial one)
local locale_file = table.concat{ModPath,"Locales/",GetLanguage(),".csv"}
if FileExists(locale_file) then
  LoadLocale(locale_file)
else
  LoadLocale(table.concat{ModPath,"Locales/","English.csv"})
end
Msg("TranslationChanged")




Now you can use _InternalTranslate(T({11111111110001029--[[optionally showing a string for your %s.--]]})):format("sanity")
All a translator needs to do is make a copy of English.csv, rename it to their lang: OpenExamine(AllLanguages),
start changing strings, and then send you the file. All you need to do is put it in the Locales folder.




I like to use this function for ease of use (and to make sure I always get a string back):

Some_Unique_Name = {}

local local_T = T
function Some_Unique_Name.Translate(...)
  local trans
  local vararg = {...}
  -- just in case a
  pcall(function()
    if type(vararg[1]) == "userdata" then
      trans = _InternalTranslate(table.unpack(vararg))
    else
      trans = _InternalTranslate(local_T(vararg))
    end
  end)
  -- just in case b
  if type(trans) ~= "string" then
    if type(vararg[2]) == "string" then
      return vararg[2]
    end
    -- just in case c
    return table.concat{vararg[1]," < Missing locale string id"}
  end
  return trans
end

Translate(11111111110001029--[[The text from the csv, so I know what it means--]])


or use:
local T = Some_Unique_Name.Translate
At the top of any new lua files. It'll work for both T() and T({})
```


### If you get this totally and completely useful error msg when your locale doesn't load:
`CommonLua/Core/localization.lua:559: table index is nil`

##### This will give you *some* idea of where to start looking (helps when you've got 1000+ strings).
##### Search the log first for ERROR:, then if it's still happening you'll have to compare between your locale file and the log output
##### As this flushes the log every loop it will take some time to load if you have a large locale file (still quicker than a blind mouse).

##### Blind mouse = A badly formed csv will just leave the game "stuck" and no log that you can use.

```
--Well I hope you know what this is
local mod_id = "YOUR_MOD_ID"

--path to your csv file (assuming it's in MOD_FOLDER/Locales, and called LANG.csv)
local filename = table.concat({Mods[mod_id].path,"Locales/",GetLanguage(),".csv"})

--this is the LoadCSV func from CommonLua/Core/ParseCSV.lua with some DebugPrint added
DebugPrintNL("\r\nBegin: LoadCSV()")
local fields_remap = {
  "id",
  "text",
  "translated",
  "translated_new",
  "gender"
}
local data = {}
local omit_captions = "omit_captions"
local _, str = AsyncFileToString(filename)
local rows, pos = data, 1
local lpeg = require("lpeg")
local Q = lpeg.P("\"")
local quoted_value = Q * lpeg.Cs((1 - Q + Q * Q / "\"") ^ 0) * Q
local raw_value = lpeg.C((1 - lpeg.S(",\t\r\n\"")) ^ 0)
local field = (lpeg.P(" ") ^ 0 * quoted_value * lpeg.P(" ") ^ 0 + raw_value) * lpeg.Cp()
local space = string.byte(" ", 1)
local RemoveTrailingSpaces = RemoveTrailingSpaces
local DebugPrintNL = DebugPrintNL
local FlushLogFile = FlushLogFile
local table = table
--local debug_output = {}
--start of function LoadCSV(filename, data, fields_remap, omit_captions)
while pos < #str do
  local previous = ""
  local row, col = {}, 1
  local lf = str:sub(pos, pos) == "\n"
  local crlf = str:sub(pos, pos + 1) == "\r\n"
    while pos < #str and not lf and not crlf do
      -- because this game keeps the log in memory till exit/certain crashes.
      -- this certain crash won't leave you with a log file, so we flush.
      FlushLogFile()

      local value, next = field:match(str, pos)
      value = RemoveTrailingSpaces(value)
      if not fields_remap then
        row[col] = value
      elseif fields_remap[col] then
        row[fields_remap[col]] = value
      end
      col = col + 1
      lf = str:sub(next, next) == "\n"
      crlf = str:sub(next, next + 1) == "\r\n"
      pos = next + 1

      --only seems to happen on bad things
      if col > 4 then
        DebugPrintNL(table.concat{"\r\nERROR: \r\ncol: ",col," value: ",value," pos: ",pos})
      end

      local nextt = field:match(str, pos)
      if nextt ~= "" and previous ~= nextt then
        --outputs as STRING_ID,STRING,
        DebugPrintNL(table.concat{"\r\n",value,",",nextt,","})
        --shows col and position (not useful for comparing to csv file)
        --DebugPrintNL(table.concat({"\r\ncol: ",col," pos: ",pos,"\r\n",value,",",nextt,","}))
      end

      previous = nextt
    end

  if crlf then
    pos = pos + 1
  end
  if not omit_captions then
    table.insert(rows, row)
  end
  omit_captions = false
end

--DebugPrintNL(table.concat(debug_output))
DebugPrintNL("\r\nEnd: LoadCSV()")
```

##### you can use this AutoHotkey script to clear out the log a bit for easier side-by-side comparisons

```
FileRead, temptext, MarsSteam.exe-20180616-15.12.24-5b0fe520.log
Loop, parse, temptext, `n, `r
  {
  If A_LoopField !=
    {
    If !InStr(A_LoopField, "Lua time")
      output .= A_LoopField "`n"
    }
  }
FileDelete OUTPUT.csv
FileAppend %output%,OUTPUT.csv
```