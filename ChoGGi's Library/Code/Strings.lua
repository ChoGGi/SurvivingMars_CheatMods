-- See LICENSE for terms

-- i translate all the strings at startup, so it's a table lookup instead of a func call
-- ~ ChoGGi.Strings[27]

-- amount of entries in the CSV file
local string_limit = 1650


-- the string _InternalTranslate returns on failure
local missing_text = ChoGGi.Temp.missing_text

-- local some globals
local _InternalTranslate = _InternalTranslate
local type, select, tostring = type, select, tostring
local T, IsT, count_params = T, IsT, count_params

-- translate func that always returns a string (string id, {id,value}, nil)
local function Translate(...)
	local str = _InternalTranslate(T(...) or "")

	-- Missing text means the string id wasn't found (generally)
	if str == "" or str == missing_text or type(str) ~= "string" then
		-- if count over 1 then use the second arg (which might be a string)
		str = count_params(...) > 1 and select(2, ...)
		if type(str) == "string" then
			return str
		end
		-- i'd rather know if something failed by having a missing string rather than a failed func
		return (IsT(...) or tostring(...)) .. " *bad string id?"
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
	local procall = procall

	function BuildingInfoLine(...)
		-- add fake city so BuildingInfoLine doesn't fail
		if not UICity then
			UICity = fake_city
		end

		-- just to on the safe side (procall)
		local _, ret = procall(orig_BuildingInfoLine, ...)

		if UICity == fake_city then
			UICity = false
		end

		return ret
	end

	-- we don't need to fake it once UICity exists
	local function ResetFunc()
		BuildingInfoLine = orig_BuildingInfoLine
	end
	OnMsg.CityStart = ResetFunc
	OnMsg.LoadGame = ResetFunc
end -- do

-- we need to pad some zeros
local locId_sig = shift(255, 56)
local LightUserData = LightUserData
local bor = bor
local GetLanguage = GetLanguage
local setmetatable, next = setmetatable, next
function ChoGGi.ComFuncs.UpdateStringsList()
	local lang = GetLanguage()
	ChoGGi.lang = lang
	-- a table of translated strings (includes <> stuff unlike TranslationTable)
	local strings = ChoGGi.Strings

	-- if there's a missing id print/return a warning
	if not next(strings) then
		local print = print
		setmetatable(strings, {
			__index = function(_, id)
				id = "ECM Sez: *bad string id? " .. id
				print(id)
				return id
			end,
		})
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
		local f = Translate(997--[[*font*, 15, aa]])
		-- index of first , then crop out the rest
		f = f:sub(1, f:find(", ")-1)
		-- might use it?
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
