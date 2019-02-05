### Add easy locale support to your mod (wtf is up with all this StringBase + 1 I see...)
```lua
If you're translating for XWindows, and you need to use a table value use:
T{123,"string",table_value = something}
Otherwise you can skip the table creation and just use:
T(123,"string")
```

```lua
In your mod folder create a Locales folder, in that folder create English.csv (or whatever you use).

Mod folder\Locales\English.csv

In English.csv add text like so (you only really need: ID,Text though Translation isn't bad)
ID,Text,Translation,Old Translation,Gender
11111111110001001,Some text
11111111110001002,and More text.
11111111110001003,"and some ""quoted"" text"
11111111110001004,"some text with

new lines in them"
11111111110001005,"some text with commas, included"

CHANGE 11111111 to some random arsed number, or use whatever you already use in your mod.

At the tippy top of your ModItemCode file add this (or something like it)


local locale_path = Concat(CurrentModPath,"Locales/%s.csv")
-- this checks if there's a csv for the current lang, if not it loads the English one.
if not LoadTranslationTableFile(locale_path:format(GetLanguage())) then
	LoadTranslationTableFile(locale_path:format("English"))
end
Msg("TranslationChanged")



Now you can use _InternalTranslate(T(11111111110001029--[[optionally showing a string for your %s.--]])):format("sanity")
All a translator needs to do is make a copy of English.csv, rename it to their lang: OpenExamine(AllLanguages),
start changing strings, and then send you the file.




I like to use this function for ease of use (and to make sure I always get a string back):

do -- Translate
	local T,_InternalTranslate,procall = T,_InternalTranslate,procall
	local type,select = type,select

	-- some userdata'll ref UICity, which will fail if being used in main menu
	local function SafeTrans(str)
		return _InternalTranslate(str)
	end

	-- translate func that always returns a string
	function Translate(...)
		local str,result
		local stype = type(select(1,...))
		if stype == "userdata" or stype == "number" then
			str = T{...}
		else
			str = ...
		end

		-- certain stuff will fail without this obj, so just pass it off to pcall and let it error out
		if UICity then
			result,str = true,_InternalTranslate(str)
		else
			-- procall is pretty much pcall, but with logging
			result,str = procall(SafeTrans,str)
		end

		-- just in case
		if not result or type(str) ~= "string" then
			local arg2 = select(2,...)
			if type(arg2) == "string" then
				return arg2
			end
			-- i'd rather know if something failed by having a bad string rather than a failed func
			return tostring(...) .. " *bad string id?"
		end

		-- and done
		return str
	end
end -- do


Translate(11111111110001029--[[The text from the csv, so I know what it means--]])


or use:
local T = Translate
At the top of any new lua files. It'll work for both T() and T({})
```


### If you get this totally and completely useful error msg when your locale doesn't load:
`CommonLua/Core/localization.lua:559: table index is nil`

##### This will give you *some* idea of where to start looking (helps when you've got 1000+ strings).
##### Search the log first for ERROR:, then if it's still happening you'll have to compare between your locale file and the log output
##### As this flushes the log every loop it will take some time to load if you have a large locale file (still quicker than a blind mouse).

##### Blind mouse = A badly formed csv will just leave the game "stuck" and no log that you can use.

```lua
--Well I hope you know what this is
local mod_id = "YOUR_MOD_ID"

--path to your csv file (assuming it's in MOD_FOLDER/Locales, and called LANG.csv)
local filename = table.concat({Mods[mod_id].path,"Locales/",GetLanguage(),".csv"})

--this is the LoadCSV func from CommonLua/Core/ParseCSV.lua with some DebugPrint added
print("\r\nBegin: LoadCSV()")
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
local print = print
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
				print(table.concat{"\r\nERROR: \r\ncol: ",col," value: ",value," pos: ",pos})
			end

			local nextt = field:match(str, pos)
			if nextt ~= "" and previous ~= nextt then
				--outputs as STRING_ID,STRING,
				print(table.concat{"\r\n",value,",",nextt,","})
				--shows col and position (not useful for comparing to csv file)
				--print(table.concat({"\r\ncol: ",col," pos: ",pos,"\r\n",value,",",nextt,","}))
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

--print(table.concat(debug_output))
print("\r\nEnd: LoadCSV()")
```

##### you can use this AutoHotkey script to clear out the log a bit for easier side-by-side comparisons

```ahk
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