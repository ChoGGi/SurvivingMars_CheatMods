-- See LICENSE for terms

local mod_options = {
--~ 	PlaceObj("ModItemOptionToggle", {
--~ 		"name", "EnableMod",
--~ 		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
--~ 		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
--~ 		"DefaultValue", true,
--~ 	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "UseVacancies",
		"DisplayName", T(0000, "<color ChoGGi_yellow>Use Vacancies</color>"),
		"Help", T(0000, "Turn on to use vacancies instead of work slots."),
		"DefaultValue", false,
	}),
}
local c = #mod_options

local ColonistSpecializationList = ColonistSpecializationList
for i = 1, #ColonistSpecializationList do
	local spec = ColonistSpecializationList[i]
	c = c + 1
	mod_options[c] = PlaceObj("ModItemOptionToggle", {
		"name", spec,
		"DisplayName", table.concat(T(0000, "Exclude") .. " " .. const.ColonistSpecialization[spec].display_name),
		"Help", T(0000, "Exclude this spec from training when Use Vacancies is turned on."),
		"DefaultValue", false,
	})
end

-- Sort by display name
local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(mod_options, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return mod_options
