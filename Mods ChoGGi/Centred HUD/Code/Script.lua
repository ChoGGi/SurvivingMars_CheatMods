-- See LICENSE for terms

local IsBox = IsBox

-- res collection
local hud_lookup_table = {
	["38401080"] = box(960, 0, 960, 0),
	["57601080"] = box(2560, 0, 2560, 0),
	["76801440"] = box(1802, 0, 1802, 0),
	["76801378"] = box(1600, 0, 1600, 0),
	["76801411"] = box(1600, 0, 1600, 0),
}

local mod_CustomMargin

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_CustomMargin = tonumber(CurrentModOptions:GetProperty("CustomMargin"))

	-- mod option set
	if mod_CustomMargin and mod_CustomMargin > 0 then
		mod_CustomMargin = box(mod_CustomMargin, 0, mod_CustomMargin, 0)
	-- no number set, try lookup table
	elseif mod_CustomMargin == 0 then
		local ss = UIL.GetScreenSize()
		mod_CustomMargin = hud_lookup_table[ss:x() .. ss:y()]
	end

	-- update hud margins
	Msg("SafeAreaMarginsChanged")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- update based on lookup (only if mod option not set, add another option to always override?)
function OnMsg.SystemSize(pt)
	-- already set so don't check lookup
	if IsBox(mod_CustomMargin) then
		return
	end

	mod_CustomMargin = hud_lookup_table[pt:x() .. pt:y()]
end

-- other mods can toggle it with this
function OnMsg.ChoGGi_CentredHUD_SetMargin(toggle)
	if toggle then
		ModOptions()
	else
		mod_CustomMargin = nil
	end

	Msg("SafeAreaMarginsChanged")
end

-- what the hud elements use to position
local ChoOrig_GetSafeMargins = GetSafeMargins
function GetSafeMargins(win_box, ...)
	if win_box then
		return ChoOrig_GetSafeMargins(win_box, ...)
	end

	if IsBox(mod_CustomMargin) then
		return mod_CustomMargin
	end

	return ChoOrig_GetSafeMargins(win_box, ...)
end
