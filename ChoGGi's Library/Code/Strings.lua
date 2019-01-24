-- See LICENSE for terms

-- i translate all the strings at startup, so it's a table lookup instead of a func call
-- ~ ChoGGi.Strings[27]

local tonumber = tonumber
local StringFormat = string.format

local TranslationTable = TranslationTable

do -- Translate
	local T,_InternalTranslate,pack_params,procall = T,_InternalTranslate,pack_params,procall
	local type,select = type,select

	-- some userdata'll ref UICity, which will fail if being used in main menu
	local function SafeTrans(str)
		return _InternalTranslate(str)
	end
	local missing_str = "%s *bad string id?"

	-- translate func that always returns a string
	function ChoGGi.ComFuncs.Translate(...)
		local str,result
		local stype = type(select(1,...))
		if stype == "userdata" or stype == "number" then
			str = T(pack_params(...))
		else
			str = ...
		end

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
			-- i'd rather know if something failed by having a string rather than a func fail
			return missing_str:format(...)
		end

		-- and done
		return str
	end
end -- do
local Trans = ChoGGi.ComFuncs.Translate

-- devs didn't bother changing droid font to one that supports unicode, so we do this for not eng
-- pretty sure anything using droid is just for dev work so...
if ChoGGi.lang ~= "English" then
	-- first get the unicode font name

	local f = TranslationTable[997--[[*font*, 15, aa--]]]
	-- index of first , then crop out the rest
	f = f:sub(1,f:find(",")-1)
	ChoGGi.font = f

	-- these four don't get to use non-eng fonts, cause screw you is why
	-- ok it's these aren't expected to be exposed to end users, but console is in mod editor so...
	local TextStyles = TextStyles
	TextStyles.Console.TextFont = StringFormat("%s, 18, bold, aa",f)
	TextStyles.ConsoleLog.TextFont = StringFormat("%s, 13, bold, aa",f)
	TextStyles.DevMenuBar.TextFont = StringFormat("%s, 18, aa",f)
	TextStyles.GizmoText.TextFont = StringFormat("%s, 32, bold, aa",f)

end

-- one big table of all in-game strings and mine (i make a copy since we edit some strings below, and i want to make sure tag icons show up)
local strings = {}

-- build a list of tags with .tga
local tags = {}
local TagLookupTable = const.TagLookupTable
for key,value in pairs(TagLookupTable) do
	if type(value) == "string" and value:find(".tga") then
		tags[key] = value
	end
end

local TranslationTable = TranslationTable
for key,value in pairs(TranslationTable) do
	local tag_match = tags[value:match("<+([%a_]+)>+")]
	-- translate strings with an image tag (<left_click> to <image UI/Infopanel/left_click.tga>)
	if tag_match then
		strings[key] = Trans(key)
	-- the rest don't matter
	else
		strings[key] = value
	end
end

strings[4356] = strings[4356]:gsub("<right><Gender>","")
strings[4357] = strings[4357]:gsub("<right><UIBirthplace>","")

-- for string.format ease of use
strings[1000012] = strings[1000012]:gsub("<ModLabel>","%%s")
strings[1000013] = strings[1000013]:gsub("<ModLabel>","%%s"):gsub("<err>","%%s")
strings[1000014] = strings[1000014]:gsub("<ModLabel>","%%s")
strings[1000771] = strings[1000771]:gsub("<ModLabel>","%%s")

strings[293] = strings[293]:gsub("<right>",": %%s")
strings[294] = strings[294]:gsub("<right>",": %%s")
strings[295] = strings[295]:gsub("<right>",": %%s")
strings[434] = strings[434]:gsub("<right><lifetime>",": %%s")
strings[4273] = strings[4273]:gsub("<save_date>",": %%s")
strings[4274] = strings[4274]:gsub("<playtime>",": %%s")
strings[4439] = strings[4439]:gsub("<right><h SelectTarget InfopanelSelect><Target></h>",": %%s")
strings[5647] = strings[5647]:gsub("<count>","%%s")
strings[6729] = strings[6729]:gsub("<n>",": %%s")
strings[584248706535] = strings[584248706535]:gsub("<right><ResourceAmount>",": %%s")

-- and update my global ref
ChoGGi.Strings = strings
