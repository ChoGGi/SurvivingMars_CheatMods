-- See LICENSE for terms

local properties = {}
local c = 0

local table = table
local T = T
local TraitPresets = TraitPresets

--~ local added_cats = {}
local function AddColonists(list)
	for i = 1, #list do
		local id = list[i]
		local trait = TraitPresets[id]
		local category = trait.category or trait.group
		-- backwards compat?
		if category then
			local category_str = category == "other" and T(10405, "Other")
				or category == "Age Group" and T(11607, "Age Group")
				or T(category)
				--or trait.category == "Negative" and T(0000, "Negative")

	--~ 				-- add categories
	--~ 				if not added_cats[trans(cat)] then
	--~ 					c = c + 1
	--~ 					properties[c] = PlaceObj("ModItemOptionToggle", {
	--~ 						"name", "cats" .. cat,
	--~ 						"DisplayName", table.concat(T(cat) .. T("  <yellow>-Category-</color>")),
	--~ 						"Help", T(302535920011751, "On/Off does nothing."),
	--~ 					})
	--~ 					added_cats[trans(cat)] = true
	--~ 				end

			c = c + 1
			properties[c] = PlaceObj("ModItemOptionToggle", {
				"name", "Trait_" .. id,
				"DisplayName", table.concat(category_str .. ": " .. T(trait.display_name)),
				"Help", table.concat(T(trait.description) .. "\n\n" .. id),
				"DefaultValue", false,
			})
		end
	end
end

local t = ChoGGi.Tables
AddColonists(t.ColonistAges)
AddColonists(t.NegativeTraits)
AddColonists(t.PositiveTraits)
AddColonists(t.OtherTraits)

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(properties, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

table.insert(properties, 1, PlaceObj("ModItemOptionToggle", {
	"name", "SkipTourists",
	"DisplayName", T(302535920011898, "Skip Tourists"),
	"Help", T(302535920011899, "Never remove tourists."),
	"DefaultValue", false,
}))
table.insert(properties, 2, PlaceObj("ModItemOptionToggle", {
	"name", "IgnoreDomes",
	"DisplayName", T(302535920011959, "Ignore Domes"),
	"Help", T(302535920011960, "Remove colonists inside domes/passages."),
	"DefaultValue", false,
}))

return properties
