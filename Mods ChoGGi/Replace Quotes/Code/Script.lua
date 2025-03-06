-- See LICENSE for terms

local TGetID = TGetID

local mod_ElonMusk
local mod_VladimirPutin
local mod_RemoveQuotes

local quotes_list = {
	[7933] = [[<grey>"I plan to live forever, of course, but barring that I'd settle for a couple thousand years. Even five hundred would be pretty nice."
<right>Nwabudike Morgan</grey><left>]],
	[6356] = [[<grey>"Some civilian workers got in among the research patients today and became so hysterical I felt compelled to have them nerve stapled. The consequence, of course, will be another public relations nightmare, but I was severely shaken by the extent of their revulsion towards a project so vital to our survival."
<right>Nwabudike Morgan</grey><left>]],
	[6497] = [[<grey>"Planet's Primary, Alpha Centauri A, blasts unimaginable quantities of energy into space each instant, and virtually every joule of it is wasted entirely. Incomprehensible riches can be ours if we can but stretch our arms wide enough to dip from this eternal river of wealth."
<right>Nwabudike Morgan</grey><left>]],
	[825589330974] = [[<grey>"Resources exist to be consumed. And consumed they will be, if not by this generation then by some future. By what right does this forgotten future seek to deny us our birthright? None I say! Let us take what is ours, chew and eat our fill."
<right>Nwabudike Morgan</grey><left>]],
	[11782] = [[Nwabudike]],
	[10515] = [[<grey>"Today the dreams of the best sons of mankind have come true. The assault on space has begun."
<right>Sergei Korolev</grey><left>]],
}

local function ReplaceQuote(tt, string_idx, replace_text, search_text)
	if not search_text then
		search_text = "<grey>"
	end

	-- Find returns start/end of found string
	local str = tt[string_idx]
	local idx = str:find(search_text)
	if not idx then
		return
	end

	if replace_text then
		tt[string_idx] = str:sub(1, idx - 1) .. replace_text
	else
		tt[string_idx] = str:sub(1, idx - 1)
	end
end

local function ChangeStrings()
	local tt = TranslationTable

	if mod_RemoveQuotes then
		-- local var for a hair of speed
		local TechDef = TechDef
		for _, def in pairs(TechDef) do
			ReplaceQuote(tt, TGetID(def.description))
		end
	else
		-- No point in replacing quotes if we're removing them anyways
		if mod_ElonMusk then
			ReplaceQuote(tt, 7933, quotes_list[7933])
			ReplaceQuote(tt, 6356, quotes_list[6356])
			ReplaceQuote(tt, 6497, quotes_list[6497])
			ReplaceQuote(tt, 825589330974, quotes_list[825589330974])
			-- Single word, no search just replace
			tt[11782] = quotes_list[11782]
		end

		if mod_VladimirPutin then
			ReplaceQuote(tt, 10515, quotes_list[10515])
		end
	end

	-- Probably don't need this
	Msg("TranslationChanged", "ChoGGi_skip_msg")
end

-- Override strings whenever TranslationChanged fires
function OnMsg.TranslationChanged(skip)
	if skip == "ChoGGi_skip_msg" then
		return
	end

	ChangeStrings()
end

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_RemoveQuotes = CurrentModOptions:GetProperty("RemoveQuotes")
	mod_ElonMusk = CurrentModOptions:GetProperty("ElonMusk")
	mod_VladimirPutin = CurrentModOptions:GetProperty("VladimirPutin")

	ChangeStrings()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
