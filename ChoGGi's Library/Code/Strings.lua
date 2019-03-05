-- See LICENSE for terms

-- i translate all the strings at startup, so it's a table lookup instead of a func call
-- ~ ChoGGi.Strings[27]

-- amount of entries in the CSV file
local string_limit = 1600

local _InternalTranslate = _InternalTranslate

do -- Translate
	-- local some globals
	local T,IsT,TGetID,count_params = T,IsT,TGetID,count_params
	local type,select,pcall,tostring = type,select,pcall,tostring

	-- translate func that always returns a string
	function ChoGGi.ComFuncs.Translate(...)
		local count = count_params(...) > 0
		local str = count and T(...) or T{...}

		-- not a translatable obj
		if not IsT(str) then
			return "Missing text"
		end

		local result
		-- certain stuff will fail without this obj, so just pass it off to pcall and let it error out
		if UICity then
			result,str = true,_InternalTranslate(str)
		else
			result,str = pcall(_InternalTranslate,str)
		end

		-- Missing text means the string id wasn't found (generally)
		if str == "Missing text" then
			return (IsT(str) and TGetID(str) or tostring(...)) .. " *bad string id?"
		-- just in case
		elseif not result or type(str) ~= "string" then
			-- if count over 1 then use the second arg (which might be a string)
			str = not count and select(2,...)
			if type(str) == "string" then
				return str
			end
			-- i'd rather know if something failed by having a bad string rather than a failed func
			return (IsT(str) and TGetID(str) or tostring(...)) .. " *bad string id?"
		end

		-- and done
		return str
	end
end -- do


-- we need to pad some zeros
local tonumber = tonumber
local locId_sig = shift(255, 56)
local LightUserData = LightUserData
local bor = bor
--~ local missing_strs = {}
local function TransZero(pad,first,last,strings)
	for i = first, last do
		if i > string_limit then
			break
		end
		local num = tonumber("30253592000" .. pad .. i)

--~ 		-- toggle to check for missing strings
--~ 		local str = _InternalTranslate(LightUserData(bor(num, locId_sig)))
--~ 		if str == "Missing text" or #str > 16 and str:sub(-16) == " *bad string id?" then
--~ 			c = c + 1
--~ 			missing_strs[#missing_strs+1] = num
--~ 		else
--~ 			strings[num] = str
			strings[num] = _InternalTranslate(LightUserData(bor(num, locId_sig)))
--~ 		end

	end
end

function ChoGGi.ComFuncs.UpdateStringsList()
	local lang = GetLanguage()
	ChoGGi.lang = lang

	-- devs didn't bother changing droid font to one that supports unicode, so we do this when it isn't eng
	if lang ~= "English" then
			-- first get the unicode font name
		local f = Trans(997--[[*font*, 15, aa--]])
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

	-- a table of translated strings (includes <> stuff unlike TranslationTable)
	local strings = ChoGGi.Strings

	-- 0000 = 0 if we try to pass as a number (as well as 001 to 1)
	TransZero("000",0,9,strings)
	TransZero("00",10,99,strings)
	TransZero(0,100,999,strings)
	TransZero("",1000,9999,strings)

	-- and update my global ref
	ChoGGi.Strings = strings
end
-- always fire on startup
ChoGGi.ComFuncs.UpdateStringsList()
