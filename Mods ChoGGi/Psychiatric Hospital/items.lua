-- See LICENSE for terms

local mod_options = {}
local c = 0

-- g_SanatoriumTraits isn't built till game loads
-- Enable them by default
local enabled_traits = {
	Alcoholic = true,
	Gambler = true,
	Glutton = true,
	Lazy = true,
	ChronicCondition = true,
	Melancholic = true,
	Coward = true,
	-- cause
	Idiot = true,
}
local function AddTraitsToOptions(traits, cat)
	for i = 1, #traits do
		local item = traits[i]
		c = c + 1
		mod_options[c] = PlaceObj("ModItemOptionToggle", {
			"name", "Trait_" .. item.id,
			"DisplayName", table.concat(cat .. " " .. T(item.display_name)),
			"Help", T(item.description),
			"DefaultValue", enabled_traits[item.id] and true or false,
		})
	end
end
local traits = Presets.TraitPreset
AddTraitsToOptions(traits.Positive, T(3934, "Perks"))
AddTraitsToOptions(traits.Negative, T(3936, "Flaws"))
-- We're cheating right?
AddTraitsToOptions(traits.other, T(3938, "Quirks"))

-- Sort by display name
local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(mod_options, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return mod_options
