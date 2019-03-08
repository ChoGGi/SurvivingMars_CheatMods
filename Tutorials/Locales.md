### Add locale support to your mod (wtf is up with all this StringBase + 1 I see...)
```lua
If you're translating for XWindows, and you need to use a table value use:
T{123,"string",context_value = some_obj}
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


local locale_path = CurrentModPath .. "Locales/"
-- this checks if there's a csv for the current lang, if not it loads the English one.
if not LoadTranslationTableFile(locale_path .. GetLanguage() .. ".csv") then
	locale_path = locale_path .. "English.csv"
	LoadTranslationTableFile(locale_path)
else
	locale_path = locale_path .. GetLanguage() .. ".csv"
end
Msg("TranslationChanged")

-- if user changes lang reload strings
function OnMsg.TranslationChanged(skip)
	if skip ~= "skip_inf_loop" then
		LoadTranslationTableFile(locale_path)
		Msg("TranslationChanged","skip_inf_loop")
	end
end


Now you can use _InternalTranslate(T(11111111110001029--[[optionally showing a string for your %s.--]])):format("sanity")
All a translator needs to do is make a copy of English.csv, rename it to their lang: OpenExamine(AllLanguages),
start changing strings, and then send you the file.




I like to use this function for ease of use (and to make sure I always get a string back):

do -- Translate
	-- local some globals
	local T,_InternalTranslate,IsT,TGetID = T,_InternalTranslate,IsT,TGetID
	local type,select,pcall,tostring = type,select,pcall,tostring

	-- translate func that always returns a string
	function ChoGGi.ComFuncs.Translate(...)
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
			result,str = pcall(_InternalTranslate,str)
		end

		-- Missing text means the string id wasn't found (generally)
		if str == "Missing text" then
			return (IsT(...) and TGetID(...) or tostring(...)) .. " *bad string id?"
		-- just in case
		elseif not result or type(str) ~= "string" then
			str = select(2,...)
			if type(str) == "string" then
				return str
			end
			-- i'd rather know if something failed by having a bad string rather than a failed func
			return (IsT(...) and TGetID(...) or tostring(...)) .. " *bad string id?"
		end

		-- and done
		return str
	end
end -- do


Translate(11111111110001029--[[The text from the csv in a comment, so I know what it means--]])


or use:
local T = Translate
At the top of any new lua files. It'll work for both T() and T({})
```


### CSV import issue:
##### "[LUA ERROR] table index is nil, field ModsLoadLocTables"
##### "CommonLua/Core/localization.lua:559: table index is nil"
###### If you get one of those errors when trying to load your csv file, I have a func in Expanded Cheat Menu:

```lua
ChoGGi.ComFuncs.TestLocaleFile(filepath,test_csv)
It'll return a list of translated and failed strings, as well as some context to where the error is.

filepath is the path to the csv file
Mods.ChoGGi_ExampleTranslateGame.env.CurrentModPath .. "Locale/Game.csv"
or
"AppData/Mods/Some Mod/Locales/file.csv"

test_csv can be true to report columns above 5 (usual amount for translations).
It can also be a number for a custom amount of columns (if you get too many or not enough errors).

for something like
302535920000887,Example,
you should send 4
for something like
1000591,Error,Errore,
then 5 will work

test_csv requires you to install my HelperMod for ECM.
```
![Test Locale File](Locales.png?raw=true "Test Locale File")
