### If you get this totally and completely useful error msg when your locale doesn't load:
`CommonLua/Core/localization.lua:559: table index is nil`

##### This will give you *some* idea of where to start looking (helps when you've got 1000+ strings).
##### Search the log first for ERROR:, then if it's still happening you'll have to compare between your locale file and the log output

```
--Well I hope you know what this is
local mod_id = "MOD_ID"
--path to your csv file (assuming it's in MOD_FOLDER/Locales, and called LANG.csv)
local filename = table.concat({Mods[mod_id].path,"Locales/",GetLanguage(),".csv"})

--this is the LoadCSV func from CommonLua/Core/ParseCSV.lua with some DebugPrint added
DebugPrintNL("\r\nBegin: LoadCSV()")
local fields_remap = {
  [1] = "id",
  [2] = "text",
  [5] = "translated",
  [3] = "translated_new",
  [7] = "gender"
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
--local debug_output = {}
--start of function LoadCSV(filename, data, fields_remap, omit_captions)
while pos < #str do
  local previous = ""
  local row, col = {}, 1
  local lf = str:sub(pos, pos) == "\n"
  local crlf = str:sub(pos, pos + 1) == "\r\n"
    while pos < #str and not lf and not crlf do
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

      --[[
      --DebugPrint seems to have a 2048 limit, so no doing this with just the one table
      if col > 4 then
        debug_output[#debug_output+1] = "\r\nERROR: \r\ncol: "
        debug_output[#debug_output+1] = col or "NO COL"
        debug_output[#debug_output+1] = " value: "
        debug_output[#debug_output+1] = value or "NO VALUE"
        debug_output[#debug_output+1] = " pos: "
        debug_output[#debug_output+1] = pos or "NO POS"
        debug_output[#debug_output+1] = "\r\n"
      end
      local nextt = field:match(str, pos)
      if nextt ~= "" and previous ~= nextt then
        debug_output[#debug_output+1] = "\r\n"
        debug_output[#debug_output+1] = value or "NO VALUE"
        debug_output[#debug_output+1] = ","
        debug_output[#debug_output+1] = nextt or "NO NEXT"
        debug_output[#debug_output+1] = ","
      end
      --]]

      --only seems to happen on bad things
      if col > 4 then
        DebugPrintNL(table.concat({"\r\nERROR: \r\ncol: ",col," value: ",value," pos: ",pos}))
      end

      local nextt = field:match(str, pos)
      if nextt ~= "" and previous ~= nextt then
        --outputs as STRING_ID,STRING,
        DebugPrint(table.concat({"\r\n",value,",",nextt,","}))
        --shows col and position (not useful for comparing to csv file)
        --DebugPrint(table.concat({"\r\ncol: ",col," pos: ",pos,"\r\n",value,",",nextt,","}))
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
