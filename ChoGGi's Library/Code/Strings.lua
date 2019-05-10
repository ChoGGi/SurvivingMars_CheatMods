-- See LICENSE for terms

-- i translate all the strings at startup, so it's a table lookup instead of a func call
-- ~ ChoGGi.Strings[27]

-- amount of entries in the CSV file
local string_limit = 1650


-- the string _InternalTranslate returns on failure
local missing_text = ChoGGi.Temp.missing_text

-- local some globals
local _InternalTranslate = _InternalTranslate
local type,select,tostring,next = type,select,tostring,next
local T,IsT,TGetID,count_params = T,IsT,TGetID,count_params

-- translate func that always returns a string
local function Translate(...)
	local count = count_params(...) > 1
	local str = count and T(...) or T{...}

	-- not a translatable obj
	if not IsT(str) then
		return missing_text
	end

	local result
	result,str = true,_InternalTranslate(str)

	-- Missing text means the string id wasn't found (generally)
	if str == missing_text then
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
ChoGGi.ComFuncs.Translate = Translate

do -- fix missing tech defs description in main menu/new game
	local fake_city = {
		GetConstructionCost = empty_func,
		label_modifiers = {},
	}

	local orig_BuildingInfoLine = BuildingInfoLine
	local pcall = pcall

	local function ResetFunc()
		BuildingInfoLine = orig_BuildingInfoLine
	end
	-- we don't need to check once UICity exists
	OnMsg.CityStart = ResetFunc
	OnMsg.LoadGame = ResetFunc

	function BuildingInfoLine(...)
		-- add fake city so BuildingInfoLine doesn't fail
		if not UICity then
			UICity = fake_city
		end

		-- just to on the safe side (don't want to leave UICity as fake_city)
		local _,ret = pcall(orig_BuildingInfoLine,...)

		if UICity == fake_city then
			UICity = false
		end

		return ret
	end
end -- do

-- we need to pad some zeros
local locId_sig = shift(255, 56)
local LightUserData = LightUserData
local bor = bor
local GetLanguage = GetLanguage
function ChoGGi.ComFuncs.UpdateStringsList()
	local lang = GetLanguage()
	ChoGGi.lang = lang
	-- a table of translated strings (includes <> stuff unlike TranslationTable)
	local strings = ChoGGi.Strings

	-- if there's a missing id print/return a warning
	if not next(strings) then
		local meta = {}
		setmetatable(strings,meta)
		meta.__index = function(_,id)
			if type(id) == "number" then
				id = "ECM Sez: bad string id? " .. id
				print(id)
				return id
			end
		end
	end

	-- translate all my strings
	local iter = 302535920000000+string_limit
	for i = 302535920000000, iter do
		local str = _InternalTranslate(LightUserData(bor(i, locId_sig)))
		-- if the missing text is within the last 50 then we can safely break
		if (iter - 50) < i and str == missing_text then
			break
		end
		strings[i] = str
	end

	-- and update my global ref
	ChoGGi.Strings = strings

	-- devs didn't bother changing droid font to one that supports unicode, so we do this when it isn't eng
	if lang ~= "English" then
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
end
-- always fire on startup
ChoGGi.ComFuncs.UpdateStringsList()
