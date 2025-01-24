-- See LICENSE for terms

if not g_AvailableDlc.picard then
	print(CurrentModDef.title, ": Below & Beyond DLC not installed! Abort!")
	return
end

local mod_options = {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "LightTripodRadius",
		"DisplayName", T(0000, "Light Tripod Radius"),
		"DefaultValue", BuildingTemplates.LightTripod.reveal_range,
		"Help", T(0000, "How far the light reveals darkness."),
		"MinValue", 1,
		"MaxValue", 1000,
--~ 		"StepSize", 10,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "SupportStrutRadius",
		"DisplayName", T(0000, "Support Strut Radius"),
		"DefaultValue", SupportStruts.work_radius,
		"Help", T(0000, "How far the strut blocks cave-ins."),
		"MinValue", 1,
		"MaxValue", 500,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "PinRockets",
		"DisplayName", T(0000, "Pin Rockets"),
		"Help", T(0000, "When changing to underground, pin any rockets from surface (might have to toggle maps twice)."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "NoSanityLoss",
		"DisplayName", T(0000, "No Sanity Loss"),
		"Help", T(0000, "Colonists don't lose sanity when there's no light."),
		"DefaultValue", false,
	}),
}

local c = #mod_options

local wonder_desc = T(0000, "Turn on to let this wonder spawn underground.")

local bt = BuildingTemplates
local wonders = const.BuriedWonders
for i = 1, #wonders do
	c = c + 1
	local id = wonders[i]
	mod_options[c] = PlaceObj("ModItemOptionToggle", {
		"name", id,
		"DisplayName", table.concat(T(142--[[Wonder]]) .. ": " .. T(bt[id].display_name)),
		"Help", table.concat(wonder_desc .. "\n\n" .. T(bt[id].description)),
		"DefaultValue", true,
	})
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(mod_options, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return mod_options
