-- See LICENSE for terms

local properties = {}
local c = 0

local table_concat = table.concat
local TraitPresets = TraitPresets
local function AddColonists(list)
	for i = 1, #list do
		local id = list[i]
		local trait = TraitPresets[id]
		local cat = trait.category == "other" and T(10405, "Other")
			or trait.category == "Age Group" and T(11607,"Age Group")
			or T(trait.category)
--~ 			or trait.category == "Negative" and T(0, "Negative")

		c = c + 1
		properties[c] = PlaceObj("ModItemOptionToggle", {
			"name", id,
			"DisplayName", table_concat(cat .. ": " .. T(trait.display_name)),
			"Help", table_concat(T(trait.description) .. "\n\n" .. id),
			"DefaultValue", false,
		})
	end
end

local t = ChoGGi.Tables
AddColonists(t.ColonistAges)
AddColonists(t.NegativeTraits)
--~ AddColonists(t.PositiveTraits)
AddColonists(t.OtherTraits)

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(properties, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return properties
