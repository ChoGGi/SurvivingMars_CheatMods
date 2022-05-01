-- See LICENSE for terms

if g_AvailableDlc.shepard then
	return {
		PlaceObj("ModItemOptionNumber", {
			"name", "StockMax",
			"DisplayName", T(302535920011690, "Max Storage Amount"),
			"Help", T(302535920011691, "Game default is 300."),
			"DefaultValue", 600,
			"MinValue", 0,
			"MaxValue", 5000,
			"StepSize", 10,
		}),
	}
end

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "Nadda",
		"DisplayName", T(302535920011692, "DLC is missing!"),
		"Help", T(302535920011693, "My Mods! The Goggles Do Nothing!"),
		"DefaultValue", true,
	}),
}
