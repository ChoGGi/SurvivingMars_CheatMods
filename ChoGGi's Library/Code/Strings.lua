-- See LICENSE for terms

-- I translate all the strings at startup, so it's a table lookup instead of a func call (okay it wasn't worth it)
-- ~ ChoGGi.Strings[27]

-- amount of entries in the CSV file
local string_limit = 1700

local testing = ChoGGi.testing

-- what _InternalTranslate returns on failure
local missing_text = ChoGGi.Temp.missing_text

-- local some globals
local type, tostring, print = type, tostring, print
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
		if str == missing_text then
			-- try to return the string id (if we can)
			return tostring(IsT(t) or missing_text)
		-- something didn't work
		elseif type(str) ~= "string" then
			-- try to return the string id, if we can
			print("ChoGGi Lib Sez: Translate Failed:", t, context, ...)
			return tostring(IsT(t) or missing_text)
		end

		-- and done
		return str
	end

	return tostring(str)
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
	local procall = procall

	function BuildingInfoLine(...)
		-- add fake city so BuildingInfoLine doesn't fail
		if not UICity then
			UICity = fake_city
			UIColony = fake_city
		end

		-- just to on the safe side (procall)
		local _, ret = procall(ChoOrig_BuildingInfoLine, ...)

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

do -- UpdateStringsList (fired below, and whenever lang is changed)
	-- we need to pad some zeros
	local locId_sig = shift(255, 56)
	local LightUserData = LightUserData
	local bor = bor
	local GetLanguage = GetLanguage
	local setmetatable, next = setmetatable, next

	function ChoGGi.ComFuncs.UpdateStringsList()
		local lang = GetLanguage()
		ChoGGi.lang = lang

		-- devs didn't bother changing droid font to one that supports unicode, so we do this when it isn't eng
		if lang ~= "English" then
			-- first get the unicode font name
			local f = Translate(997--[[*fontname*, 15, aa]])
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




		-- a table of translated strings (includes <> stuff unlike TranslationTable)
		local strings = ChoGGi.Strings
		-- blank table from modload
		if not next(strings) then
			-- If there's a missing id print/return a warning
			setmetatable(strings, {
				__index = function(errorsout, id)
					-- we only want numbers, so if anything else is requested then ignore
					if type(id) == "number" then
						print("ChoGGi Lib: *bad string id?", id)
						if testing then
							-- this will error out, but I'll know where it comes from at least.
							print(errorsout)
						end
						return missing_text
					end
				end,
			})
		end

		-- translate all my strings
		local iter = 302535920000000 + string_limit
		for i = 302535920000000, iter do
			local str = _InternalTranslate(LightUserData(bor(i, locId_sig)))
			-- If the missing text is within the last 50 then we can safely break
			if (iter - 50) < i and str == missing_text then
				break
			end
			strings[i] = str
		end

		-- and update my global ref
		ChoGGi.Strings = strings

	end
end -- do

-- always fire on startup
ChoGGi.ComFuncs.UpdateStringsList()
