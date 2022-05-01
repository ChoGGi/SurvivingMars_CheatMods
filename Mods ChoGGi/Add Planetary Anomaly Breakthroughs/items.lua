-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "AddPlanetaryAnomalyBreakthroughs",
		"DisplayName", T(302535920011933, "Add Planetary Anomaly Breakthroughs"),
		"Help", T(302535920011934, [[Add this many breakthroughs to the anomaly breakthrough list the game grabs from (<color 255 110 110>press "Apply" to add</color>).]]),
		"DefaultValue", 4,
		"MinValue", 0,
		"MaxValue", 50,
	}),
}
