-- See LICENSE for terms

-- i translate all the strings at startup, so it's a table lookup instead of a func call
-- ~ ChoGGi.Strings[27]

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
local Translate = ChoGGi.ComFuncs.Translate

function ChoGGi.ComFuncs.UpdateStringsList()
	local ChoGGi = ChoGGi

	ChoGGi.lang = GetLanguage()
	-- devs didn't bother changing droid font to one that supports unicode, so we do this when it isn't eng
	if ChoGGi.lang ~= "English" then
		-- first get the unicode font name

		local f = Translate(997--[[*font*, 15, aa--]])
		-- index of first , then crop out the rest
		f = f:sub(1,f:find(",")-1)
		ChoGGi.font = f

		-- these four don't get to use non-eng fonts, cause screw you is why
		-- ok it's these aren't expected to be exposed to end users, but console is in mod editor so...
		local TextStyles = TextStyles
		TextStyles.Console.TextFont = f .. ", 18, bold, aa"
		TextStyles.ConsoleLog.TextFont = f .. ", 13, bold, aa"
		TextStyles.DevMenuBar.TextFont = f .. ", 18, aa"
		TextStyles.GizmoText.TextFont = f .. ", 32, bold, aa"

	end

	-- one big table of all in-game strings and mine (i make a copy since we edit some strings below, and i want to make sure tag icons show up)
	local strings = ChoGGi.Strings or {}

	-- build a list of tags with .tga
	local tags = {}
	local TagLookupTable = const.TagLookupTable
	for key,value in pairs(TagLookupTable) do
		if type(value) == "string" and value:find(".tga") then
			tags[key] = value
		end
	end
	-- any strings we want to manually translate, stuff with <em> and so on
	local translate = {
		[11] = true,
		[12] = true,
		[13] = true,
		[14] = true,
	}

	local TranslationTable = TranslationTable
	for key,value in pairs(TranslationTable) do
		local tag_match = tags[value:match("<+([%a_]+)>+")]
		-- translate strings with an image tag (<left_click> to <image UI/Infopanel/left_click.tga>)
		if tag_match or translate[key] then
			strings[key] = Translate(key)
		-- the rest don't matter
		else
			strings[key] = value
		end
	end

	strings[4356] = strings[4356]:gsub("<right><Gender>","")
	strings[4357] = strings[4357]:gsub("<right><UIBirthplace>","")
	strings[774720837511] = strings[774720837511]:gsub("<percent%(DifficultyBonus%)>","")

	-- for string.format ease of use
	strings[1000012] = strings[1000012]:gsub("<ModLabel>","%%s")
	strings[1000013] = strings[1000013]:gsub("<ModLabel>","%%s"):gsub("<err>","%%s")
	strings[1000014] = strings[1000014]:gsub("<ModLabel>","%%s")
	strings[1000771] = strings[1000771]:gsub("<ModLabel>","%%s")
	strings[4031] = strings[4031]:gsub("<day>","%%s")
	strings[5647] = strings[5647]:gsub("<count>","%%s")

	strings[293] = strings[293]:gsub("<right>",": %%s")
	strings[294] = strings[294]:gsub("<right>",": %%s")
	strings[295] = strings[295]:gsub("<right>",": %%s")
	strings[434] = strings[434]:gsub("<right><lifetime>",": %%s")
	strings[4273] = strings[4273]:gsub("<save_date>",": %%s")
	strings[4274] = strings[4274]:gsub("<playtime>",": %%s")
	strings[4439] = strings[4439]:gsub("<right><h SelectTarget InfopanelSelect><Target></h>",": %%s")
	strings[6729] = strings[6729]:gsub("<n>",": %%s")
	strings[584248706535] = strings[584248706535]:gsub("<right><ResourceAmount>",": %%s")

	-- and update my global ref
	ChoGGi.Strings = strings
end
-- always fire on startup
--~ ChoGGi.ComFuncs.TickStart("TestTableIterate.1.Tick")
ChoGGi.ComFuncs.UpdateStringsList()
--~ ChoGGi.ComFuncs.TickEnd("TestTableIterate.1.Tick")
