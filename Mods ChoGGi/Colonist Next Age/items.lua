-- See LICENSE for terms

local PlaceObj = PlaceObj
local T = T
local table = table

local properties = {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ChangeDeathAge",
		"DisplayName", T(302535920011980, "Change Death Age"),
		"Help", T(302535920011981, "Changes each colonist age to a random number between min/max ages."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MinDeathAge",
		"DisplayName", T(302535920011982, "Min Death Age"),
		"Help", T(302535920011983, [[Set the min age for death.

To reset death ages:
Set this and max to 0 to revert all colonist death ages to game default random values (this will use the modified senior age).]]),
		"DefaultValue", Colonist:GetProperty("MinAge_Senior") + 5,
		"MinValue", 0,
		"MaxValue", 500,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MaxDeathAge",
		"DisplayName", T(302535920011984, "Max Death Age"),
		"Help", T(302535920011985, [[Set the max age for death.

To reset death ages:
Set this and min to 0 to revert all colonist death ages to game default random values (this will use the modified senior age).]]),
		"DefaultValue", 110,
		"MinValue", 0,
		"MaxValue", 500,
	}),
}

local c = 4

local Colonist = Colonist
local ColonistAgeGroups = const.ColonistAgeGroups
for id, item in pairs(ColonistAgeGroups) do
		c = c + 1
		properties[c] = PlaceObj("ModItemOptionNumber", {
			"name", id,
			"DisplayName", table.concat(T(3929, "Age Group") .. " " .. T(item.display_name)),
			"Help", T(item.description),
			"DefaultValue", Colonist:GetProperty("MinAge_" .. id),
			"MinValue", 0,
			"MaxValue", 500,
		})
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(properties, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return properties
