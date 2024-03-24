-- See LICENSE for terms

local table = table
local PlaceObj = PlaceObj
local T = T

local mod_options = {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
}
local c = #mod_options

local info = T(0000, [[0: Don't change trait
1: Add Trait
2: Remove Trait]])

local function AddTrait(item)
	c = c + 1
	mod_options[c] = PlaceObj("ModItemOptionNumber", {
		"name", item.id,
		"DisplayName", table.concat(T(item.category) .. " " .. T(item.display_name)),
		"Help", table.concat(T(item.description) .. "\n\n" .. info),
		"DefaultValue", 0,
		"MinValue", 0,
		"MaxValue", 2,
	})
end

local traits = Presets.TraitPreset
for i = 1, #traits.Negative do
	AddTrait(traits.Negative[i])
end
for i = 1, #traits.Positive do
	AddTrait(traits.Positive[i])
end
AddTrait(TraitPresets.Vegan)

-- Sort by display name
local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(mod_options, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return mod_options
