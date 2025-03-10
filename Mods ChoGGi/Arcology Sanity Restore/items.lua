-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "SanityAmount",
		"DisplayName", T(0000, "Sanity Amount"),
		"Help", T(0000, "Amount of sanity added by Arcology."),
		"DefaultValue", BuildingTemplates.SmartHome.sanity_change / const.Scale.Stat,
		"MinValue", 0,
		"MaxValue", 100,
	}),
}
