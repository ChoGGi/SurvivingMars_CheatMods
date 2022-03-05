-- See LICENSE for terms

-- what _InternalTranslate returns on failure
local missing_text = ChoGGi.Temp.missing_text

-- local some globals
local type, tostring = type, tostring
local _InternalTranslate, T, IsT = _InternalTranslate, T, IsT
local pcall = pcall

-- translate func that always returns a string (string id, {id,value}, nil)
local function Translate(t, context, ...)
	if not t then
		return missing_text
	elseif t == "" then
		return t
	end

--~ 	local str = _InternalTranslate(
--~ 		context and T(t, context, ...) or T{t, context, ...}
--~ 	)
	local result, str = pcall(
		_InternalTranslate, context and T(t, context, ...) or T{t, context, ...}
	)
	if result then
		-- "Missing text" means the string id wasn't found
		if str == missing_text or type(str) ~= "string" then
			-- try to return the string id (if we can)
			return tostring(IsT(t) or missing_text)
		end

		-- and done
		return str
	end
	-- false result means _InternalTranslate failed
	result, str = pcall(_InternalTranslate, t, context, ...)
	return result and str or tostring(str)
end
ChoGGi.ComFuncs.Translate = Translate

do -- fix missing tech defs/tourist description in main menu/new game (expectations of UICity)

	local ChoOrig_TFormat_has_researched = TFormat.has_researched
	function TFormat.has_researched(...)
		if not UICity then
			return false
		end
		return ChoOrig_TFormat_has_researched(...)
	end

	local fake_city = {
		construction_cost = {GetConstructionCost = empty_func},
		label_modifiers = {},
	}

	local ChoOrig_BuildingInfoLine = BuildingInfoLine

	function BuildingInfoLine(...)
		-- add fake city so BuildingInfoLine doesn't fail
		if not UICity then
			UICity = fake_city
			UIColony = fake_city
		end

		-- just to on the safe side (procall)
		local _, ret = pcall(ChoOrig_BuildingInfoLine, ...)

		if UICity == fake_city then
			UICity = false
			UIColony = false
		end

		return ret
	end

	-- we don't need to fake them after UICity is created
	local function ResetFunc()
		BuildingInfoLine = ChoOrig_BuildingInfoLine
		TFormat.has_researched = ChoOrig_TFormat_has_researched
	end
	OnMsg.CityStart = ResetFunc
	OnMsg.LoadGame = ResetFunc
end -- do

do -- when examine examines TranslationTable
	local ChoOrig_FormatScale = FormatScale
	function FormatScale(value, scale, round, ...)
		-- used in TFormat, errors out when calling a blank value/scale
		if not value or not round then
			return 0
		end
		return ChoOrig_FormatScale(value, scale, round, ...)
	end
	--
	local ChoOrig_TFormat_Stat = TFormat.Stat
	function TFormat.Stat(context_obj, value, ...)
		if not value then
			return 0
		end
		return ChoOrig_TFormat_Stat(context_obj, value, ...)
	end

end -- do

function ChoGGi.ComFuncs.UpdateStringsList()
  local lang = GetLanguage()
  ChoGGi.lang = lang

  -- devs didn't bother changing droid font to one that supports unicode, so we do this when it isn't eng
  if lang ~= "English" then
    -- first get the unicode font name
    local f = TranslationTable[997--[[*fontname*, 15, aa]]]
    -- Index of first , then crop out the rest
    f = f:sub(1, f:find(", ")-1)
    -- might use it for something else?
    ChoGGi.font = f

    -- these four don't get to use non-eng fonts, cause screw you is why
    -- ok it's these aren't expected to be exposed to end users, but console is in mod editor so...?
    local TextStyles = TextStyles
    TextStyles.Console.TextFont = f .. ", 18, bold, aa"
    TextStyles.ConsoleLog.TextFont = f .. ", 13, bold, aa"
    TextStyles.DevMenuBar.TextFont = f .. ", 18, aa"
    TextStyles.GizmoText.TextFont = f .. ", 32, bold, aa"

  end

end

-- always fire on startup
ChoGGi.ComFuncs.UpdateStringsList()
