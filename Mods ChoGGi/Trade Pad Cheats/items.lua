-- See LICENSE for terms

-- Remove log spam from TradePad when it's installed without space race.
if not g_AvailableDlc.gagarin then
	print(CurrentModDef.title, ": Space Race DLC not installed!")
	return {}
end

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MinAIExportAmount",
		"DisplayName", T(0000, "Min AI Export Amount"),
		"Help", T(0000, "Rivals will not trade a resource if they have under this amount of said resource."),
		"DefaultValue", TradePad.MinAIExportAmount or 100,
		"MinValue", 1,
		"MaxValue", 250,
	}),
}
