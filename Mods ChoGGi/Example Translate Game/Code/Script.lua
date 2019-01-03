-- You should only need to change these, the rest of translating is editing Game.csv
local lang_value = "Italian"
local locale = "it-IT"
local iso_639_1 = "it"
local pdx_locale = "it"
-- see Game.csv for other translated lang names
-- or if you use ECM put this in the console: ~AllLanguages
local lang_name = T(1000696,"Italian")
--  or just use a string:
-- local lang_name = "Italian"





-- You can ignore the rest of the code below





-- local some global funcs
local RegistryRead = RegistryRead
local LoadTranslationTableFile = LoadTranslationTableFile
local Msg = Msg

local modpath = CurrentModPath
local csv_str = "%sLocale/Game.csv"

function OnMsg.ModsReloaded()
	-- make it show up in Options>Gameplay>Language
	local langs = OptionsData.Options.Language
	-- no need to add it if it's already added
	if not table.find(langs,"value",lang_value) then
		langs[#langs+1] = {
			iso_639_1 = iso_639_1,
			pdx_locale = pdx_locale,
			locale = locale,
			text = lang_name,
			value = lang_value,
		}
	end

	-- load lang if option is set to our lang
	if RegistryRead("Language") == lang_value then
		LoadTranslationTableFile(csv_str:format(modpath))
		Msg("TranslationChanged",true)
	end
end

-- fires when lang is changed in game
function OnMsg.TranslationChanged(skip)
	if not skip and RegistryRead("Language") == lang_value then
		LoadTranslationTableFile(csv_str:format(modpath))
		-- we want it to update any other OnMsg.TranslationChanged, but skip this is one (or inf loop)
		Msg("TranslationChanged",true)
	end
end
